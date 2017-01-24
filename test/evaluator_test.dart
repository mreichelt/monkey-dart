import 'package:monkey_dart/evaluator/evaluator.dart';
import 'package:monkey_dart/lexer/lexer.dart';
import 'package:monkey_dart/object/environment.dart';
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
    testEvalBoolean('1 < 2', true);
    testEvalBoolean('1 > 2', false);
    testEvalBoolean('1 < 1', false);
    testEvalBoolean('1 > 1', false);
    testEvalBoolean('1 == 1', true);
    testEvalBoolean('1 != 1', false);
    testEvalBoolean('1 == 2', false);
    testEvalBoolean('1 != 2', true);
    testEvalBoolean('true == true', true);
    testEvalBoolean('false == false', true);
    testEvalBoolean('true == false', false);
    testEvalBoolean('true != false', true);
    testEvalBoolean('false != true', true);
    testEvalBoolean('(1 < 2) == true', true);
    testEvalBoolean('(1 < 2) == false', false);
    testEvalBoolean('(1 > 2) == true', false);
    testEvalBoolean('(1 > 2) == false', true);
  });

  test('test bang operator', () {
    testBangOperator('!true', false);
    testBangOperator('!false', true);
    testBangOperator('!5', false);
    testBangOperator('!!true', true);
    testBangOperator('!!false', false);
    testBangOperator('!!5', true);
  });

  test('test if/else expressions', () {
    testIfElse('if (true) { 10 }', 10);
    testIfElse('if (false) { 10 }', null);
    testIfElse('if (1) { 10 }', 10);
    testIfElse('if (1 < 2) { 10 }', 10);
    testIfElse('if (1 > 2) { 10 }', null);
    testIfElse('if (1 > 2) { 10 } else { 20 }', 20);
    testIfElse('if (1 < 2) { 10 } else { 20 }', 10);
  });

  test('test return statements', () {
    testReturnStatement('return 10;', 10);
    testReturnStatement('return 10; 9;', 10);
    testReturnStatement('return 2 * 5; 9;', 10);
    testReturnStatement('9; return 2 * 5; 9;', 10);
    testReturnStatement(
        '''
      if (10 > 1) {
        if (10 > 1) {
          return 10;
        }
        return 1;
      }
    ''',
        10);
  });

  test('test error handling', () {
    testErrorHandling('5 + true;', 'type mismatch: INTEGER + BOOLEAN');
    testErrorHandling('5 + true; 5;', 'type mismatch: INTEGER + BOOLEAN');
    testErrorHandling('-true', 'unknown operator: -BOOLEAN');
    testErrorHandling('true + false;', 'unknown operator: BOOLEAN + BOOLEAN');
    testErrorHandling(
        'if (10 > 1) { true + false; }', 'unknown operator: BOOLEAN + BOOLEAN');
    testErrorHandling(
        '''if (10 > 1) {
      if (10 > 1) {
        return true + false;
       }
       return 1;
      }
    ''',
        'unknown operator: BOOLEAN + BOOLEAN');
    testErrorHandling('foobar', 'identifier not found: foobar');
    testErrorHandling('"Hello" - "World"', 'unknown operator: STRING - STRING');
    testErrorHandling(
        '{"name": "Monkey"}[fn(x) { x }];', 'unusable as hash key: FUNCTION');
  });

  test('test let statements', () {
    testEvalInteger('let a = 5; a;', 5);
    testEvalInteger('let a = 5 * 5; a;', 25);
    testEvalInteger('let a = 5; let b = a; b;', 5);
    testEvalInteger('let a = 5; let b = a; let c = a + b + 5; c;', 15);
  });

  test('test function object', () {
    MonkeyObject evaluated = testEval('fn(x) { x + 2; };');
    expect(evaluated, new isInstanceOf<MonkeyFunction>());
    MonkeyFunction function = evaluated;

    expect(function.parameters.length, equals(1));
    expect(function.parameters.first.toString(), equals('x'));
    expect(function.body.toString(), equals('(x + 2)'));
  });

  test('test function application', () {
    testEvalInteger('let identity = fn(x) { x; }; identity(5);', 5);
    testEvalInteger('let identity = fn(x) { return x; }; identity(5);', 5);
    testEvalInteger('let double = fn(x) { x * 2; }; double(5);', 10);
    testEvalInteger('let add = fn(x, y) { x + y; }; add(5, 5);', 10);
    testEvalInteger(
        'let add = fn(x, y) { x + y; }; add(5 + 5, add(5, 5));', 20);
    testEvalInteger('fn(x) { x; }(5)', 5);
  });

  test('test closures', () {
    testEvalInteger(
        '''
    let newAdder = fn(x) {
      fn(y) { x + y };
    };
    let addTwo = newAdder(2);
    addTwo(2);
   ''',
        4);
  });

  test('test string literal', () {
    MonkeyObject evaluated = testEval('"Hello World!"');
    expect(evaluated, new isInstanceOf<MonkeyString>());
    MonkeyString string = evaluated;
    expect(string.value, equals('Hello World!'));
  });

  test('test string concatenation', () {
    MonkeyObject evaluated = testEval('"Hello" + " " + "World!"');
    expect(evaluated, new isInstanceOf<MonkeyString>());
    MonkeyString string = evaluated;
    expect(string.value, equals('Hello World!'));
  });

  test('test builtin functions', () {
    testBuiltin('len("")', 0);
    testBuiltin('len("four")', 4);
    testBuiltin('len("hello world")', 11);
    testBuiltin('len(1)', 'argument to `len` not supported, got INTEGER');
    testBuiltin(
        'len("one", "two")', "wrong number of arguments. got=2, want=1");
    testBuiltin('len([1, 2, 3])', 3);
    testBuiltin('len([])', 0);
    //testBuiltin('puts("hello", "world!")', null);
    testBuiltin('first([1, 2, 3])', 1);
    testBuiltin('first([])', null);
    testBuiltin('first(1)', 'argument to `first` must be ARRAY, got INTEGER');
    testBuiltin('last([1, 2, 3])', 3);
    testBuiltin('last([])', null);
    testBuiltin('last(1)', 'argument to `last` must be ARRAY, got INTEGER');
    testBuiltin('rest([1, 2, 3])', [2, 3]);
    testBuiltin('rest([])', null);
    testBuiltin('push([], 1)', [1]);
    testBuiltin('push(1, 1)', 'argument to `push` must be ARRAY, got INTEGER');
  });

  test('test array literals', () {
    MonkeyObject evaluated = testEval('[1, 2 * 2, 3 + 3]');
    expect(evaluated, new isInstanceOf<MonkeyArray>());
    MonkeyArray array = evaluated;
    expect(array.elements.length, equals(3));
    testIntegerObject(array.elements[0], 1);
    testIntegerObject(array.elements[1], 4);
    testIntegerObject(array.elements[2], 6);
  });

  test('test array index expressions', () {
    testArrayIndex('[1, 2, 3][0]', 1);
    testArrayIndex('[1, 2, 3][1]', 2);
    testArrayIndex('[1, 2, 3][2]', 3);
    testArrayIndex('let i = 0; [1][i];', 1);
    testArrayIndex('[1, 2, 3][1 + 1];', 3);
    testArrayIndex('let myArray = [1, 2, 3]; myArray[2];', 3);
    testArrayIndex(
        'let myArray = [1, 2, 3]; myArray[0] + myArray[1] + myArray[2];', 6);
    testArrayIndex(
        'let myArray = [1, 2, 3]; let i = myArray[0]; myArray[i]', 2);
    testArrayIndex('[1, 2, 3][3]', null);
    testArrayIndex('[1, 2, 3][-1]', null);
  });

  test('test hash literals', () {
    MonkeyObject evaluated = testEval("""
      let two = "two";
      {
        "one": 10 - 9,
        two: 1 + 1,
        "thr" + "ee": 6 / 2,
        4: 4,
        true: 5,
        false: 6
      }
    """);
    expect(evaluated, new isInstanceOf<Hash>());
    Hash hash = evaluated;
    Map<HashKey, int> expected = {
      new MonkeyString('one').hashKey(): 1,
      new MonkeyString('two').hashKey(): 2,
      new MonkeyString('three').hashKey(): 3,
      new MonkeyInteger(4).hashKey(): 4,
      TRUE.hashKey(): 5,
      FALSE.hashKey(): 6,
    };
    expect(hash.pairs, hasLength(expected.length));
    expected.forEach((HashKey expectedKey, int expectedValue) {
      HashPair pair = hash.pairs[expectedKey];
      expect(pair, isNotNull);
      testIntegerObject(pair.value, expectedValue);
    });
  });

  test('test hash index expressions', () {
    testHashIndex('{"foo": 5}["foo"]', 5);
    testHashIndex('{"foo": 5}["bar"]', null);
    testHashIndex('let key = "foo"; {"foo": 5}[key]', 5);
    testHashIndex('{}["foo"]', null);
    testHashIndex('{5: 5}[5]', 5);
    testHashIndex('{true: 5}[true]', 5);
    testHashIndex('{false: 5}[false]', 5);
  });
}

void testBuiltin(String input, Object expected) {
  MonkeyObject evaluated = testEval(input);
  if (expected is int) {
    testIntegerObject(evaluated, expected);
  } else if (expected is String) {
    expect(evaluated, new isInstanceOf<MonkeyError>());
    expect((evaluated as MonkeyError).message, equals(expected));
  } else if (expected == null) {
    testNullObject(evaluated);
  } else if (expected is List<int>) {
    expect(evaluated, new isInstanceOf<MonkeyArray>());
    MonkeyArray array = evaluated;
    expect(array.elements.length, equals(expected.length));
    for (int i = 0; i < expected.length; i++) {
      testIntegerObject(array.elements[i], expected[i]);
    }
  } else {
    fail('unsupported test type: ${expected.runtimeType}');
  }
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

void testIfElse(String input, Object expected) {
  MonkeyObject evaluated = testEval(input);
  if (expected is int) {
    testIntegerObject(evaluated, expected);
  } else {
    testNullObject(evaluated);
  }
}

void testReturnStatement(String input, int expected) {
  MonkeyObject evaluated = testEval(input);
  testIntegerObject(evaluated, expected);
}

void testErrorHandling(String input, String expectedMessage) {
  MonkeyObject evaluated = testEval(input);
  expect(evaluated, new isInstanceOf<MonkeyError>());
  MonkeyError error = evaluated;
  expect(error.message, equals(expectedMessage));
}

void testArrayIndex(String input, Object expected) {
  MonkeyObject evaluated = testEval(input);
  if (expected is int) {
    testIntegerObject(evaluated, expected);
  } else {
    testNullObject(evaluated);
  }
}

void testHashIndex(String input, Object expected) {
  MonkeyObject evaluated = testEval(input);
  if (expected is int) {
    testIntegerObject(evaluated, expected);
  } else {
    testNullObject(evaluated);
  }
}

void testNullObject(MonkeyObject object) {
  expect(object, equals(NULL));
}

void testIntegerObject(MonkeyObject object, int expected) {
  expect(object, new isInstanceOf<MonkeyInteger>());
  MonkeyInteger integer = object;
  expect(integer.value, equals(expected));
}

void testBooleanObject(MonkeyObject object, bool expected) {
  expect(object, new isInstanceOf<MonkeyBoolean>());
  MonkeyBoolean boolean = object;
  expect(boolean.value, equals(expected));
}

MonkeyObject testEval(String input) {
  Parser parser = new Parser(new Lexer(input));
  return eval(parser.parseProgram(), new Environment.freshEnvironment());
}
