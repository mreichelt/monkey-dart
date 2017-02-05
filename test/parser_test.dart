import 'package:monkey_lang/ast/ast.dart';
import 'package:monkey_lang/lexer/lexer.dart';
import 'package:monkey_lang/parser/parser.dart';
import 'package:test/test.dart';

void main() {
  test('test let statements', () {
    testLetStatementParsing('let x = 5;', 'x', 5);
    testLetStatementParsing('let y = true;', 'y', true);
    testLetStatementParsing('let foobar = y;', 'foobar', 'y');
  });

  test('test return statements', () {
    testReturnStatementParsing('return 5;', 5);
    testReturnStatementParsing('return true;', true);
    testReturnStatementParsing('return foobar;', 'foobar');
  });

  test('test identifier expression', () {
    ExpressionStatement statement = parseExpressionStatement('foobar;');

    expect(statement.expression, new isInstanceOf<Identifier>());
    Identifier ident = statement.expression;

    expect(ident.value, equals('foobar'));
    expect(ident.tokenLiteral(), equals('foobar'));
  });

  test('test literal integer expression', () {
    ExpressionStatement statement = parseExpressionStatement('5;');
    testIntegerLiteral(statement.expression, 5);
  });

  test('test boolean expression', () {
    testBooleanParsing('true;', true);
    testBooleanParsing('false;', false);
  });

  test('test parsing prefix expressions', () {
    testPrefix('!5;', '!', 5);
    testPrefix('-15;', '-', 15);
    testPrefix('!foobar;', '!', 'foobar');
    testPrefix('-foobar;', '-', 'foobar');
    testPrefix('!true;', '!', true);
    testPrefix('!false;', '!', false);
  });

  test('test parsing infix expressions', () {
    testInfix('5 + 5;', 5, '+', 5);
    testInfix('5 - 5;', 5, '-', 5);
    testInfix('5 * 5;', 5, '*', 5);
    testInfix('5 / 5;', 5, '/', 5);
    testInfix('5 > 5;', 5, '>', 5);
    testInfix('5 < 5;', 5, '<', 5);
    testInfix('5 == 5;', 5, '==', 5);
    testInfix('5 != 5;', 5, '!=', 5);
    testInfix('foobar + barfoo;', 'foobar', '+', 'barfoo');
    testInfix('foobar - barfoo;', 'foobar', '-', 'barfoo');
    testInfix('foobar * barfoo;', 'foobar', '*', 'barfoo');
    testInfix('foobar / barfoo;', 'foobar', '/', 'barfoo');
    testInfix('foobar > barfoo;', 'foobar', '>', 'barfoo');
    testInfix('foobar < barfoo;', 'foobar', '<', 'barfoo');
    testInfix('foobar == barfoo;', 'foobar', '==', 'barfoo');
    testInfix('foobar != barfoo;', 'foobar', '!=', 'barfoo');
    testInfix('true == true', true, '==', true);
    testInfix('true != false', true, '!=', false);
    testInfix('false == false', false, '==', false);
  });

  test('test operator precedence parsing', () {
    testPrecedence('-a * b', '((-a) * b)');
    testPrecedence('!-a', '(!(-a))');
    testPrecedence('a + b + c', '((a + b) + c)');
    testPrecedence('a + b - c', '((a + b) - c)');
    testPrecedence('a * b * c', '((a * b) * c)');
    testPrecedence('a * b / c', '((a * b) / c)');
    testPrecedence('a + b / c', '(a + (b / c))');
    testPrecedence('a + b * c + d / e - f', '(((a + (b * c)) + (d / e)) - f)');
    testPrecedence('3 + 4; -5 * 5', '(3 + 4)((-5) * 5)');
    testPrecedence('5 > 4 == 3 < 4', '((5 > 4) == (3 < 4))');
    testPrecedence('5 < 4 != 3 > 4', '((5 < 4) != (3 > 4))');
    testPrecedence(
        '3 + 4 * 5 == 3 * 1 + 4 * 5', '((3 + (4 * 5)) == ((3 * 1) + (4 * 5)))');
    testPrecedence(
        '3 + 4 * 5 == 3 * 1 + 4 * 5', '((3 + (4 * 5)) == ((3 * 1) + (4 * 5)))');
    testPrecedence('true', 'true');
    testPrecedence('false', 'false');
    testPrecedence('3 > 5 == false', '((3 > 5) == false)');
    testPrecedence('3 < 5 == true', '((3 < 5) == true)');
    testPrecedence('1 + (2 + 3) + 4', '((1 + (2 + 3)) + 4)');
    testPrecedence('(5 + 5) * 2', '((5 + 5) * 2)');
    testPrecedence('2 / (5 + 5)', '(2 / (5 + 5))');
    testPrecedence('(5 + 5) * 2 * (5 + 5)', '(((5 + 5) * 2) * (5 + 5))');
    testPrecedence('-(5 + 5)', '(-(5 + 5))');
    testPrecedence('!(true == true)', '(!(true == true))');
    testPrecedence('a + add(b * c) + d', '((a + add((b * c))) + d)');
    testPrecedence('add(a, b, 1, 2 * 3, 4 + 5, add(6, 7 * 8))',
        'add(a, b, 1, (2 * 3), (4 + 5), add(6, (7 * 8)))');
    testPrecedence(
        'add(a + b + c * d / f + g)', 'add((((a + b) + ((c * d) / f)) + g))');
    testPrecedence(
        'a * [1, 2, 3, 4][b * c] * d', '((a * ([1, 2, 3, 4][(b * c)])) * d)');
    testPrecedence('add(a * b[2], b[1], 2 * [1, 2][1])',
        'add((a * (b[2])), (b[1]), (2 * ([1, 2][1])))');
  });

  test('test if expression', () {
    ExpressionStatement statement =
        parseExpressionStatement('if (x < y) { x }');
    expect(statement.expression, new isInstanceOf<IfExpression>());
    IfExpression expression = statement.expression;
    testInfixExpression(expression.condition, 'x', '<', 'y');
    expect(expression.consequence.statements, hasLength(1));
    ExpressionStatement consequence = expression.consequence.statements.first;
    testIdentifier(consequence.expression, 'x');
    expect(expression.alternative, isNull);
  });

  test('test if/else expression', () {
    ExpressionStatement statement =
        parseExpressionStatement('if (x < y) { x } else { y }');
    expect(statement.expression, new isInstanceOf<IfExpression>());
    IfExpression expression = statement.expression;
    testInfixExpression(expression.condition, 'x', '<', 'y');

    expect(expression.consequence.statements, hasLength(1));
    ExpressionStatement consequence = expression.consequence.statements.first;
    testIdentifier(consequence.expression, 'x');

    expect(expression.alternative.statements, hasLength(1));
    ExpressionStatement alternative = expression.alternative.statements.first;
    testIdentifier(alternative.expression, 'y');
  });

  test('test function literal parsing', () {
    ExpressionStatement statement =
        parseExpressionStatement('fn(x, y) { x + y; }');
    expect(statement.expression, new isInstanceOf<FunctionLiteral>());
    FunctionLiteral function = statement.expression;

    expect(function.parameters, hasLength(2));
    testLiteralExpression(function.parameters[0], 'x');
    testLiteralExpression(function.parameters[1], 'y');

    expect(function.body.statements, hasLength(1));
    expect(function.body.statements.first,
        new isInstanceOf<ExpressionStatement>());
    ExpressionStatement body = function.body.statements.first;
    testInfixExpression(body.expression, 'x', '+', 'y');
  });

  test('test function parameter parsing', () {
    testFunctionParameters('fn() {};', []);
    testFunctionParameters('fn(x) {};', ['x']);
    testFunctionParameters('fn(x, y, z) {};', ['x', 'y', 'z']);
  });

  test('test call expression parsing', () {
    ExpressionStatement statement =
        parseExpressionStatement('add(1, 2 * 3, 4 + 5);');
    expect(statement.expression, new isInstanceOf<CallExpression>());
    CallExpression call = statement.expression;
    testIdentifier(call.function, 'add');
    expect(call.arguments, hasLength(3));
    testLiteralExpression(call.arguments[0], 1);
    testInfixExpression(call.arguments[1], 2, '*', 3);
    testInfixExpression(call.arguments[2], 4, '+', 5);
  });

  test('test string literal expression parsing', () {
    ExpressionStatement statement = parseExpressionStatement('"hello world"');
    expect(statement.expression, new isInstanceOf<StringLiteral>());
    StringLiteral literal = statement.expression;
    expect(literal.value, equals('hello world'));
  });

  test('test array literals parsing', () {
    ExpressionStatement statement =
        parseExpressionStatement('[1, 2 * 2, 3 + 3]');
    expect(statement.expression, new isInstanceOf<ArrayLiteral>());
    ArrayLiteral array = statement.expression;
    expect(array.elements, hasLength(3));
    testIntegerLiteral(array.elements[0], 1);
    testInfixExpression(array.elements[1], 2, '*', 2);
    testInfixExpression(array.elements[2], 3, '+', 3);
  });

  test('test parsing index expressions', () {
    ExpressionStatement statement = parseExpressionStatement('myArray[1 + 1]');
    expect(statement.expression, new isInstanceOf<IndexExpression>());
    IndexExpression indexExpression = statement.expression;
    testIdentifier(indexExpression.left, 'myArray');
    testInfixExpression(indexExpression.index, 1, '+', 1);
  });

  test('test parsing hash literal string keys', () {
    ExpressionStatement statement =
        parseExpressionStatement('{"one": 1, "two": 2, "three": 3}');
    Map<String, int> expected = {"one": 1, "two": 2, "three": 3};
    expect(statement.expression, new isInstanceOf<HashLiteral>());
    HashLiteral hash = statement.expression;
    expect(hash.pairs, hasLength(3));

    hash.pairs.forEach((key, value) {
      expect(key, new isInstanceOf<StringLiteral>());
      StringLiteral literal = key;
      int expectedValue = expected[literal.toString()];
      testIntegerLiteral(value, expectedValue);
    });
  });

  test('test parsing empty hash literal', () {
    ExpressionStatement statement = parseExpressionStatement('{}');
    expect(statement.expression, new isInstanceOf<HashLiteral>());
    HashLiteral hash = statement.expression;
    expect(hash.pairs, isEmpty);
  });

  test('test parsing hash literal with expressions', () {
    ExpressionStatement statement = parseExpressionStatement(
        '{"one": 0 + 1, "two": 10 - 8, "three": 15 / 5}');
    expect(statement.expression, new isInstanceOf<HashLiteral>());
    HashLiteral hash = statement.expression;
    expect(hash.pairs, hasLength(3));

    Map<String, Function> testFunctions = {
      'one': (Expression e) {
        testInfixExpression(e, 0, '+', 1);
      },
      'two': (e) {
        testInfixExpression(e, 10, '-', 8);
      },
      'three': (e) {
        testInfixExpression(e, 15, '/', 5);
      },
    };

    hash.pairs.forEach((key, value) {
      expect(key, new isInstanceOf<StringLiteral>());
      StringLiteral literal = key;
      testFunctions[literal.toString()](value);
    });
  });

  test('test parser errors for unclosed statements', () {
    testParserError('{');
    testParserError('(');
    testParserError('fn(');
    testParserError('if(');
  });
}

void testParserError(String input) {
  Parser parser = new Parser(new Lexer(input));
  parser.parseProgram();
  expect(parser.errors, isNotEmpty);
}

void testFunctionParameters(String input, List<String> expectedParameters) {
  ExpressionStatement statement = parseExpressionStatement(input);
  expect(statement.expression, new isInstanceOf<FunctionLiteral>());
  FunctionLiteral function = statement.expression;

  expect(function.parameters, hasLength(expectedParameters.length));
  for (int i = 0; i < expectedParameters.length; i++) {
    testIdentifier(function.parameters[i], expectedParameters[i]);
  }
}

void testBooleanParsing(String input, bool expected) {
  ExpressionStatement statement = parseExpressionStatement(input);
  testBooleanLiteral(statement.expression, expected);
}

void testLetStatementParsing(
    String input, String expectedIdentifier, Object expectedValue) {
  Statement statement = parseSingleStatement(input);
  testLetStatement(statement, expectedIdentifier);
  testLiteralExpression((statement as LetStatement).value, expectedValue);
}

void testLetStatement(Statement statement, String name) {
  expect(statement.tokenLiteral(), equals('let'));
  expect(statement, new isInstanceOf<LetStatement>());
  LetStatement letStatement = statement;
  expect(letStatement.name.value, equals(name));
  expect(letStatement.name.tokenLiteral(), equals(name));
}

void testReturnStatementParsing(String input, Object expectedValue) {
  Statement statement = parseSingleStatement(input);
  expect(statement.tokenLiteral(), equals('return'));
  expect(statement, new isInstanceOf<ReturnStatement>());
  ReturnStatement returnStatement = statement;
  testLiteralExpression(returnStatement.returnValue, expectedValue);
}

Program parseProgramChecked(String input) {
  Parser parser = new Parser(new Lexer(input));
  Program program = parser.parseProgram();
  checkParserErrors(parser);
  return program;
}

Statement parseSingleStatement(String input) {
  Program program = parseProgramChecked(input);
  expectNumStatements(program, 1);
  return program.statements.first;
}

ExpressionStatement parseExpressionStatement(String input) {
  Statement statement = parseSingleStatement(input);
  expect(statement, new isInstanceOf<ExpressionStatement>());
  ExpressionStatement expressionStatement = statement;
  return expressionStatement;
}

void testPrefix(String input, String operator, Object expectedValue) {
  ExpressionStatement statement = parseExpressionStatement(input);
  expect(statement.expression, new isInstanceOf<PrefixExpression>());
  PrefixExpression expression = statement.expression;
  expect(expression.operator, equals(operator));
  testLiteralExpression(expression.right, expectedValue);
}

void testInfix(
    String input, Object leftValue, String operator, Object rightValue) {
  ExpressionStatement expressionStatement = parseExpressionStatement(input);
  expect(expressionStatement.expression, new isInstanceOf<InfixExpression>());
  InfixExpression expression = expressionStatement.expression;
  testLiteralExpression(expression.left, leftValue);
  expect(expression.operator, equals(operator));
  testLiteralExpression(expression.right, rightValue);
}

void testPrecedence(String input, String expected) {
  Program program = parseProgramChecked(input);
  expect(program.toString(), equals(expected));
}

void testIntegerLiteral(Expression expression, int integerValue) {
  expect(expression, new isInstanceOf<IntegerLiteral>());
  IntegerLiteral literal = expression;
  expect(literal.value, equals(integerValue));
  expect(literal.tokenLiteral(), equals('$integerValue'));
}

void testIdentifier(Expression expression, String value) {
  expect(expression, new isInstanceOf<Identifier>());
  Identifier identifier = expression;
  expect(identifier.value, equals(value));
  expect(identifier.tokenLiteral(), equals(value));
}

void testLiteralExpression(Expression expression, Object expected) {
  if (expected is int) {
    testIntegerLiteral(expression, expected);
  } else if (expected is String) {
    testIdentifier(expression, expected);
  } else if (expected is bool) {
    testBooleanLiteral(expression, expected);
  } else {
    fail('type of expression not handled: ${expected.runtimeType}');
  }
}

void testBooleanLiteral(Expression expression, bool expected) {
  expect(expression, new isInstanceOf<BooleanLiteral>());
  BooleanLiteral boolean = expression;
  expect(boolean.value, equals(expected));
  expect(boolean.tokenLiteral(), equals(expected.toString()));
}

void testInfixExpression(
    Expression expression, Object left, String operator, Object right) {
  expect(expression, new isInstanceOf<InfixExpression>());

  InfixExpression infixExpression = expression;
  testLiteralExpression(infixExpression.left, left);
  expect(infixExpression.operator, equals(operator));
  testLiteralExpression(infixExpression.right, right);
}

void expectNumStatements(Program program, int expectedStatements) {
  expect(program.statements, hasLength(expectedStatements));
}

void checkParserErrors(Parser parser) {
  if (parser.errors.isEmpty) {
    return;
  }

  print('parser has ${parser.errors.length} errors');
  parser.errors.forEach((error) {
    print('parser error: $error');
  });

  fail('');
}
