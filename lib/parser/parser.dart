library parser;

import 'package:monkey_dart/ast/ast.dart';
import 'package:monkey_dart/lexer/lexer.dart';
import 'package:monkey_dart/token/token.dart';

enum Precedence {
  _,
  LOWEST,
  // ==
  EQUALS,
  // > or <
  LESSGREATER,
  // +
  SUM,
  // *
  PRODUCT,
  // -x or !x
  PREFIX,
  // myFunction(x)
  CALL
}

class Parser {
  Lexer lexer;
  Token currentToken;
  Token peekToken;
  List<String> errors = [];
  Map<String, Function> prefixParseFns = {};
  Map<String, Function> infixParseFns = {};

  Parser(this.lexer) {
    nextToken();
    nextToken();
    registerPrefix(Token.IDENT, parseIdentifier);
  }

  void nextToken() {
    currentToken = peekToken;
    peekToken = lexer.nextToken();
  }

  Program parseProgram() {
    Program program = new Program();
    program.statements = new List();
    while (!currentTokenIs(Token.EOF)) {
      Statement statement = parseStatement();
      if (statement != null) {
        program.statements.add(statement);
      }
      nextToken();
    }

    return program;
  }

  Statement parseStatement() {
    switch (currentToken.type) {
      case Token.LET:
        return parseLetStatement();
      case Token.RETURN:
        return parseReturnStatement();
      default:
        return parseExpressionStatement();
    }
  }

  ReturnStatement parseReturnStatement() {
    ReturnStatement statement = new ReturnStatement(currentToken);
    nextToken();

    // TODO: We're skipping the expressions until we encounter a semicolon
    while (!currentTokenIs(Token.SEMICOLON)) {
      nextToken();
    }

    return statement;
  }

  LetStatement parseLetStatement() {
    LetStatement statement = new LetStatement(currentToken);

    if (!expectPeek(Token.IDENT)) {
      return null;
    }

    statement.name = new Identifier(currentToken, currentToken.literal);

    if (!expectPeek(Token.ASSIGN)) {
      return null;
    }

    // TODO: We're skipping the expressions until we encounter a semicolon
    while (!currentTokenIs(Token.SEMICOLON)) {
      nextToken();
    }

    return statement;
  }

  ExpressionStatement parseExpressionStatement() {
    ExpressionStatement statement = new ExpressionStatement(currentToken);
    statement.expression = parseExpression(Precedence.LOWEST);
    if (peekTokenIs(Token.SEMICOLON)) {
      nextToken();
    }
    return statement;
  }

  Expression parseExpression(Precedence precedence) {
    Function prefix = prefixParseFns[currentToken.type];
    if (prefix == null) {
      return null;
    }
    return prefix();
  }

  bool currentTokenIs(String tokenType) {
    return currentToken.type == tokenType;
  }

  bool peekTokenIs(String tokenType) {
    return peekToken.type == tokenType;
  }

  bool expectPeek(String tokenType) {
    if (peekToken.type == tokenType) {
      nextToken();
      return true;
    }
    peekError(tokenType);
    return false;
  }

  void peekError(String tokenType) {
    errors.add("expected next token to be $tokenType, but got ${currentToken
        .type} instead");
  }

  void registerPrefix(String tokenType, Function prefixParseFn) {
    prefixParseFns[tokenType] = prefixParseFn;
  }

  void registerInfix(String tokenType, Function infixParseFn) {
    infixParseFns[tokenType] = infixParseFn;
  }

  Expression parseIdentifier() =>
      new Identifier(currentToken, currentToken.literal);
}
