library builtins;

import 'package:monkey_dart/object/object.dart';

final Map<String, Builtin> builtins = {
  'len': new Builtin((List<MonkeyObject> args) {
    if (args.length != 1) {
      return new MonkeyError(
          'wrong number of arguments. got=${args.length}, want=1');
    }

    MonkeyObject arg = args.first;
    if (arg is MonkeyString) {
      return new Integer(arg.value.length);
    } else if (arg is MonkeyArray) {
      return new Integer(arg.elements.length);
    }

    return new MonkeyError('argument to `len` not supported, got ${arg.type}');
  })
};
