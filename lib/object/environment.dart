library environment;

import 'package:monkey_dart/object/object.dart';

class Environment {
  final Map<String, MonkeyObject> store = {};

  MonkeyObject get(String name) {
    return store[name];
  }

  MonkeyObject set(String name, MonkeyObject object) {
    store[name] = object;
    return object;
  }
}
