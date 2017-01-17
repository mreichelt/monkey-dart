import 'package:monkey_dart/lexer/lexer.dart';
import 'package:monkey_dart/object/object.dart';
import 'package:monkey_dart/parser/parser.dart';
import 'package:monkey_dart/evaluator/evaluator.dart';
import 'package:test/test.dart';

void main() {
  test('test eval integer expression', () {
    testEvalInteger('5', 5);
    testEvalInteger('10', 10);
  });

  test('test eval boolean expression', () {
    testEvalBoolean('true', true);
    testEvalBoolean('false', false);
  });

  test('test bang operator', () {
    testBangOperator('!true', false);
    testBangOperator('!false', true);
    testBangOperator('!5', false);
    testBangOperator('!!true', true);
    testBangOperator('!!false', false);
    testBangOperator('!!5', true);
  });
}

void testEvalInteger(String input, int expected) {
  MonkeyObject evaluated = testEval(input);
  testIntegerObject(evaluated, expected);
}

void testEvalBoolean(String input, bool expected) {
  MonkeyObject evaluated = testEval(input);
  testBooleanObject(evaluated, expected);
}

void testBangOperator(String input, bool expected) {
  MonkeyObject evaluated = testEval(input);
  testBooleanObject(evaluated, expected);
}

void testIntegerObject(MonkeyObject object, int expected) {
  expect(object, new isInstanceOf<Integer>());
  Integer integer = object;
  expect(integer.value, equals(expected));
}

void testBooleanObject(MonkeyObject object, bool expected) {
  expect(object, new isInstanceOf<Boolean>());
  Boolean boolean = object;
  expect(boolean.value, equals(expected));
}

MonkeyObject testEval(String input) {
  Parser parser = new Parser(new Lexer(input));
  return eval(parser.parseProgram());
}
