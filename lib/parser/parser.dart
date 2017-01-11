library parser;

import 'package:monkey_dart/ast/ast.dart';
import 'package:monkey_dart/lexer/lexer.dart';
import 'package:monkey_dart/token/token.dart';

class Parser {
  Lexer lexer;
  Token currentToken;
  Token peekToken;
  List<String> errors = [];

  Parser(this.lexer) {
    nextToken();
    nextToken();
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
        return null;
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
}
