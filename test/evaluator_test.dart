import 'package:monkey_dart/evaluator/evaluator.dart';
import 'package:monkey_dart/lexer/lexer.dart';
import 'package:monkey_dart/object/object.dart';
import 'package:monkey_dart/parser/parser.dart';
import 'package:test/test.dart';

void main() {
  test('test eval integer expression', () {
    testEvalInteger('5', 5);
    testEvalInteger('10', 10);
    testEvalInteger('-5', -5);
    testEvalInteger('-10', -10);
    testEvalInteger('5 + 5 + 5 + 5 - 10', 10);
    testEvalInteger('2 * 2 * 2 * 2 * 2', 32);
    testEvalInteger('-50 + 100 + -50', 0);
    testEvalInteger('5 * 2 + 10', 20);
    testEvalInteger('5 + 2 * 10', 25);
    testEvalInteger('20 + 2 * -10', 0);
    testEvalInteger('50 / 2 * 2 + 10', 60);
    testEvalInteger('2 * (5 + 10)', 30);
    testEvalInteger('3 * 3 * 3 + 10', 37);
    testEvalInteger('3 * (3 * 3) + 10', 37);
    testEvalInteger('(5 + 10 * 2 + 15 / 3) * 2 + -10', 50);
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
