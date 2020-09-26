import 'package:monkey_lang/ast/ast.dart';
import 'package:monkey_lang/lexer/lexer.dart';
import 'package:monkey_lang/monkey/monkey.dart';
import 'package:monkey_lang/token/token.dart';

enum Precedence {
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
  CALL,

  /// array[index]
  INDEX
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
    Token.ASTERISK: Precedence.PRODUCT,
    Token.LPAREN: Precedence.CALL,
    Token.LBRACKET: Precedence.INDEX
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
    registerPrefix(Token.IF, parseIfExpression);
    registerPrefix(Token.FUNCTION, parseFunctionLiteral);
    registerPrefix(Token.STRING, parseStringLiteral);
    registerPrefix(Token.LBRACKET, parseArrayLiteral);
    registerPrefix(Token.LBRACE, parseHashLiteral);

    registerInfix(Token.PLUS, parseInfixExpression);
    registerInfix(Token.MINUS, parseInfixExpression);
    registerInfix(Token.SLASH, parseInfixExpression);
    registerInfix(Token.ASTERISK, parseInfixExpression);
    registerInfix(Token.EQ, parseInfixExpression);
    registerInfix(Token.NOT_EQ, parseInfixExpression);
    registerInfix(Token.LT, parseInfixExpression);
    registerInfix(Token.GT, parseInfixExpression);
    registerInfix(Token.LPAREN, parseCallExpression);
    registerInfix(Token.LBRACKET, parseIndexExpression);
  }

  void nextToken() {
    currentToken = peekToken;
    peekToken = lexer.nextToken();
  }

  Program parseProgram() {
    Program program = Program();
    program.statements = [];
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
    ReturnStatement statement = ReturnStatement(currentToken);

    nextToken();

    statement.returnValue = parseExpression(Precedence.LOWEST);

    if (peekTokenIs(Token.SEMICOLON)) {
      nextToken();
    }

    return statement;
  }

  LetStatement parseLetStatement() {
    LetStatement statement = LetStatement(currentToken);

    if (!expectPeek(Token.IDENT)) {
      return null;
    }

    statement.name = Identifier(currentToken, currentToken.literal);

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
    ExpressionStatement statement = ExpressionStatement(currentToken);
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
    errors.add('expected next token to be $tokenType, but got '
        '${peekToken.type} instead');
  }

  void noPrefixParseFnError(String tokenType) {
    errors.add('no prefix parse function for $tokenType found');
  }

  void registerPrefix(String tokenType, Function prefixParseFn) {
    prefixParseFns[tokenType] = prefixParseFn;
  }

  void registerInfix(String tokenType, Function infixParseFn) {
    infixParseFns[tokenType] = infixParseFn;
  }

  Expression parseIdentifier() =>
      Identifier(currentToken, currentToken.literal);

  Expression parseIntegerLiteral() {
    IntegerLiteral literal = IntegerLiteral(currentToken);
    try {
      int value = int.parse(currentToken.literal);
      literal.value = value;
      return literal;
    } catch (e) {
      errors.add('could not parse ${currentToken.literal} as integer');
      return null;
    }
  }

  PrefixExpression parsePrefixExpression() {
    PrefixExpression expression =
        PrefixExpression(currentToken, currentToken.literal);
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
        InfixExpression(currentToken, currentToken.literal, left);
    Precedence precedence = currentPrecendence();
    nextToken();
    expression.right = parseExpression(precedence);
    return expression;
  }

  BooleanLiteral parseBoolean() =>
      BooleanLiteral(currentToken, currentTokenIs(Token.TRUE));

  Expression parseGroupedExpression() {
    nextToken();
    Expression expression = parseExpression(Precedence.LOWEST);
    if (!expectPeek(Token.RPAREN)) {
      return null;
    }
    return expression;
  }

  IfExpression parseIfExpression() {
    IfExpression expression = IfExpression(currentToken);
    if (!expectPeek(Token.LPAREN)) {
      return null;
    }

    nextToken();
    expression.condition = parseExpression(Precedence.LOWEST);

    if (!expectPeek(Token.RPAREN)) {
      return null;
    }
    if (!expectPeek(Token.LBRACE)) {
      return null;
    }

    expression.consequence = parseBlockStatement();

    if (peekTokenIs(Token.ELSE)) {
      nextToken();

      if (!expectPeek(Token.LBRACE)) {
        return null;
      }

      expression.alternative = parseBlockStatement();
    }

    return expression;
  }

  BlockStatement parseBlockStatement() {
    BlockStatement block = BlockStatement(currentToken);
    nextToken();
    while (!currentTokenIs(Token.RBRACE) && !currentTokenIs(Token.EOF)) {
      Statement statement = parseStatement();
      if (statement != null) {
        block.statements.add(statement);
      }
      nextToken();
    }
    return block;
  }

  FunctionLiteral parseFunctionLiteral() {
    FunctionLiteral function = FunctionLiteral(currentToken);
    if (!expectPeek(Token.LPAREN)) {
      return null;
    }
    function.parameters = parseFunctionParameters();
    if (!expectPeek(Token.LBRACE)) {
      return null;
    }
    function.body = parseBlockStatement();
    return function;
  }

  List<Identifier> parseFunctionParameters() {
    List<Identifier> parameters = [];

    if (peekTokenIs(Token.RPAREN)) {
      nextToken();
      return parameters;
    }

    nextToken();

    parameters.add(Identifier(currentToken, currentToken.literal));

    while (peekTokenIs(Token.COMMA)) {
      nextToken();
      nextToken();
      parameters.add(Identifier(currentToken, currentToken.literal));
    }

    if (!expectPeek(Token.RPAREN)) {
      return null;
    }

    return parameters;
  }

  CallExpression parseCallExpression(Expression function) {
    CallExpression call = CallExpression(currentToken, function);
    call.arguments = parseExpressionList(Token.RPAREN);
    return call;
  }

  StringLiteral parseStringLiteral() =>
      StringLiteral(currentToken, currentToken.literal);

  ArrayLiteral parseArrayLiteral() =>
      ArrayLiteral(currentToken, parseExpressionList(Token.RBRACKET));

  List<Expression> parseExpressionList(String endTokenType) {
    List<Expression> list = [];

    if (peekTokenIs(endTokenType)) {
      nextToken();
      return list;
    }

    nextToken();
    list.add(parseExpression(Precedence.LOWEST));

    while (peekTokenIs(Token.COMMA)) {
      nextToken();
      nextToken();
      list.add(parseExpression(Precedence.LOWEST));
    }

    if (!expectPeek(endTokenType)) {
      return null;
    }

    return list;
  }

  IndexExpression parseIndexExpression(Expression left) {
    IndexExpression expression = IndexExpression(currentToken)..left = left;
    nextToken();
    expression.index = parseExpression(Precedence.LOWEST);
    if (!expectPeek(Token.RBRACKET)) {
      return null;
    }
    return expression;
  }

  HashLiteral parseHashLiteral() {
    HashLiteral hash = HashLiteral(currentToken);
    while (!peekTokenIs(Token.RBRACE)) {
      nextToken();
      Expression key = parseExpression(Precedence.LOWEST);
      if (!expectPeek(Token.COLON)) {
        return null;
      }
      nextToken();
      Expression value = parseExpression(Precedence.LOWEST);
      hash.pairs[key] = value;

      if (!peekTokenIs(Token.RBRACE) && !expectPeek(Token.COMMA)) {
        return null;
      }
    }

    if (!expectPeek(Token.RBRACE)) {
      return null;
    }

    return hash;
  }

  bool hasErrors() => errors.isNotEmpty;

  String getErrorsAsString() {
    return '${Monkey.FACE}\n'
            'Woops! We ran into some monkey business here!\n'
            ' parser errors:\n' +
        errors.fold('',
            (prev, element) => prev == '' ? '\t$element' : '$prev\n\t$element');
  }
}
