library parser;

import 'package:monkey_dart/ast/ast.dart';
import 'package:monkey_dart/lexer/lexer.dart';
import 'package:monkey_dart/token/token.dart';

enum Precedence {
  _,
  LOWEST,

  /// ==
  EQUALS,

  /// > or <
  LESSGREATER,

  /// +
  SUM,

  /// *
  PRODUCT,

  /// -x or !x
  PREFIX,

  /// myFunction(x)
  CALL
}

class Parser {
  Lexer lexer;
  Token currentToken;
  Token peekToken;
  List<String> errors = [];
  Map<String, Function> prefixParseFns = {};
  Map<String, Function> infixParseFns = {};
  Map<String, Precedence> precedences = {
    Token.EQ: Precedence.EQUALS,
    Token.NOT_EQ: Precedence.EQUALS,
    Token.LT: Precedence.LESSGREATER,
    Token.GT: Precedence.LESSGREATER,
    Token.PLUS: Precedence.SUM,
    Token.MINUS: Precedence.SUM,
    Token.SLASH: Precedence.PRODUCT,
    Token.ASTERISK: Precedence.PRODUCT
  };

  Parser(this.lexer) {
    nextToken();
    nextToken();

    registerPrefix(Token.IDENT, parseIdentifier);
    registerPrefix(Token.INT, parseIntegerLiteral);
    registerPrefix(Token.BANG, parsePrefixExpression);
    registerPrefix(Token.MINUS, parsePrefixExpression);
    registerPrefix(Token.MINUS, parsePrefixExpression);
    registerPrefix(Token.TRUE, parseBoolean);
    registerPrefix(Token.FALSE, parseBoolean);
    registerPrefix(Token.LPAREN, parseGroupedExpression);

    registerInfix(Token.PLUS, parseInfixExpression);
    registerInfix(Token.MINUS, parseInfixExpression);
    registerInfix(Token.SLASH, parseInfixExpression);
    registerInfix(Token.ASTERISK, parseInfixExpression);
    registerInfix(Token.EQ, parseInfixExpression);
    registerInfix(Token.NOT_EQ, parseInfixExpression);
    registerInfix(Token.LT, parseInfixExpression);
    registerInfix(Token.GT, parseInfixExpression);
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

    statement.returnValue = parseExpression(Precedence.LOWEST);

    if (peekTokenIs(Token.SEMICOLON)) {
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

    nextToken();

    statement.value = parseExpression(Precedence.LOWEST);

    if (peekTokenIs(Token.SEMICOLON)) {
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
      noPrefixParseFnError(currentToken.type);
      return null;
    }
    Expression left = prefix();

    while (!peekTokenIs(Token.SEMICOLON) &&
        precedence.index < peekPrecendence().index) {
      Function infix = infixParseFns[peekToken.type];
      if (infix == null) {
        return left;
      }
      nextToken();
      left = infix(left);
    }

    return left;
  }

  bool currentTokenIs(String tokenType) => currentToken.type == tokenType;

  bool peekTokenIs(String tokenType) => peekToken.type == tokenType;

  bool expectPeek(String tokenType) {
    if (peekToken.type == tokenType) {
      nextToken();
      return true;
    }
    peekError(tokenType);
    return false;
  }

  void peekError(String tokenType) {
    errors.add("expected next token to be $tokenType, but got " +
        "${currentToken.type} instead");
  }

  void noPrefixParseFnError(String tokenType) {
    errors.add("no prefix parse function for $tokenType found");
  }

  void registerPrefix(String tokenType, Function prefixParseFn) {
    prefixParseFns[tokenType] = prefixParseFn;
  }

  void registerInfix(String tokenType, Function infixParseFn) {
    infixParseFns[tokenType] = infixParseFn;
  }

  Expression parseIdentifier() =>
      new Identifier(currentToken, currentToken.literal);

  Expression parseIntegerLiteral() {
    IntegerLiteral literal = new IntegerLiteral(currentToken);
    try {
      int value = int.parse(currentToken.literal);
      literal.value = value;
      return literal;
    } catch (e) {
      errors.add("could not parse ${currentToken.literal} as integer");
      return null;
    }
  }

  PrefixExpression parsePrefixExpression() {
    PrefixExpression expression =
        new PrefixExpression(currentToken, currentToken.literal);
    nextToken();
    expression.right = parseExpression(Precedence.PREFIX);
    return expression;
  }

  Precedence peekPrecendence() =>
      precedences[peekToken.type] ?? Precedence.LOWEST;

  Precedence currentPrecendence() =>
      precedences[currentToken.type] ?? Precedence.LOWEST;

  InfixExpression parseInfixExpression(Expression left) {
    InfixExpression expression =
        new InfixExpression(currentToken, currentToken.literal, left);
    Precedence precedence = currentPrecendence();
    nextToken();
    expression.right = parseExpression(precedence);
    return expression;
  }

  Boolean parseBoolean() =>
      new Boolean(currentToken, currentTokenIs(Token.TRUE));

  Expression parseGroupedExpression() {
    nextToken();
    Expression expression = parseExpression(Precedence.LOWEST);
    if (!expectPeek(Token.RPAREN)) {
      return null;
    }
    return expression;
  }
}
