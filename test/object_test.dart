import 'package:monkey_lang/object/object.dart';
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
    MonkeyBoolean true1 = new MonkeyBoolean(true);
    MonkeyBoolean true2 = new MonkeyBoolean(true);
    MonkeyBoolean false1 = new MonkeyBoolean(false);
    MonkeyBoolean false2 = new MonkeyBoolean(false);
    expect(true1.hashKey(), equals(true2.hashKey()));
    expect(false1.hashKey(), equals(false2.hashKey()));
    expect(true1.hashKey(), isNot(equals(false1.hashKey())));
  });

  test('test integer hashkey', () {
    MonkeyInteger one1 = new MonkeyInteger(1);
    MonkeyInteger one2 = new MonkeyInteger(1);
    MonkeyInteger two1 = new MonkeyInteger(2);
    MonkeyInteger two2 = new MonkeyInteger(2);
    expect(one1.hashKey(), equals(one2.hashKey()));
    expect(two1.hashKey(), equals(two2.hashKey()));
    expect(one1.hashKey(), isNot(equals(two1.hashKey())));
  });
}
