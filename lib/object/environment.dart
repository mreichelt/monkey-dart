import 'package:monkey_lang/object/object.dart';

class Environment {
  final Map<String, MonkeyObject> store = {};
  Environment outer;

  Environment.freshEnvironment();
  Environment.enclosedEnvironment(this.outer);

  MonkeyObject get(String name) {
    var value = store[name];
    if (value == null && outer != null) {
      return outer.get(name);
    }
    return value;
  }

  MonkeyObject set(String name, MonkeyObject object) {
    store[name] = object;
    return object;
  }
}
