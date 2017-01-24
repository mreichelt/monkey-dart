import 'package:monkey_dart/object/object.dart';
import 'package:test/test.dart';

void main() {
  test('test string hashkey', () {
    MonkeyString hello1 = new MonkeyString('Hello World');
    MonkeyString hello2 = new MonkeyString('Hello World');
    MonkeyString diff1 = new MonkeyString('My name is johnny');
    MonkeyString diff2 = new MonkeyString('My name is johnny');
    expect(hello1.hashKey(), equals(hello2.hashKey()));
    expect(diff1.hashKey(), equals(diff2.hashKey()));
    expect(hello1.hashKey(), isNot(equals(diff1.hashKey())));
  });

  test('test boolean hashkey', () {
    Boolean true1 = new Boolean(true);
    Boolean true2 = new Boolean(true);
    Boolean false1 = new Boolean(false);
    Boolean false2 = new Boolean(false);
    expect(true1.hashKey(), equals(true2.hashKey()));
    expect(false1.hashKey(), equals(false2.hashKey()));
    expect(true1.hashKey(), isNot(equals(false1.hashKey())));
  });

  test('test integer hashkey', () {
    Integer one1 = new Integer(1);
    Integer one2 = new Integer(1);
    Integer two1 = new Integer(2);
    Integer two2 = new Integer(2);
    expect(one1.hashKey(), equals(one2.hashKey()));
    expect(two1.hashKey(), equals(two2.hashKey()));
    expect(one1.hashKey(), isNot(equals(two1.hashKey())));
  });
}
