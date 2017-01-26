import 'package:monkey_lang/evaluator/evaluator.dart';
import 'package:monkey_lang/object/object.dart';

final Map<String, Builtin> builtins = {
  'len': new Builtin((List<MonkeyObject> args) {
    if (args.length != 1) {
      throw new MonkeyError(
          'wrong number of arguments. got=${args.length}, want=1');
    }

    MonkeyObject arg = args.first;
    if (arg is MonkeyString) {
      return new MonkeyInteger(arg.value.length);
    } else if (arg is MonkeyArray) {
      return new MonkeyInteger(arg.elements.length);
    }

    throw new MonkeyError('argument to `len` not supported, got ${arg.type}');
  }),
  'first': new Builtin((List<MonkeyObject> args) {
    if (args.length != 1) {
      throw new MonkeyError(
          'wrong number of arguments. got=${args.length}, want=1');
    }

    MonkeyObject arg = args.first;
    if (arg.type != ARRAY_OBJ) {
      throw new MonkeyError(
          'argument to `first` must be ARRAY, got ${arg.type}');
    }

    MonkeyArray array = arg;
    if (array.elements.isNotEmpty) {
      return array.elements.first;
    }

    return NULL;
  }),
  'last': new Builtin((List<MonkeyObject> args) {
    if (args.length != 1) {
      throw new MonkeyError(
          'wrong number of arguments. got=${args.length}, want=1');
    }

    MonkeyObject arg = args.first;
    if (arg.type != ARRAY_OBJ) {
      throw new MonkeyError(
          'argument to `last` must be ARRAY, got ${arg.type}');
    }

    MonkeyArray array = arg;
    if (array.elements.isNotEmpty) {
      return array.elements.last;
    }

    return NULL;
  }),
  'rest': new Builtin((List<MonkeyObject> args) {
    if (args.length != 1) {
      throw new MonkeyError(
          'wrong number of arguments. got=${args.length}, want=1');
    }

    MonkeyObject arg = args.first;
    if (arg.type != ARRAY_OBJ) {
      throw new MonkeyError(
          'argument to `rest` must be ARRAY, got ${arg.type}');
    }

    MonkeyArray array = arg;
    if (array.elements.isNotEmpty) {
      return new MonkeyArray(array.elements.sublist(1));
    }

    return NULL;
  }),
  'push': new Builtin((List<MonkeyObject> args) {
    if (args.length != 2) {
      throw new MonkeyError(
          'wrong number of arguments. got=${args.length}, want=2');
    }

    if (args.first.type != ARRAY_OBJ) {
      throw new MonkeyError(
          'argument to `push` must be ARRAY, got ${args.first.type}');
    }

    MonkeyArray array = args.first;
    return new MonkeyArray(
        new List<MonkeyObject>.from(array.elements)..add(args[1]));
  }),
  'puts': new Builtin((List<MonkeyObject> args) {
    args.forEach((MonkeyObject arg) {
      print(arg.inspect());
    });
    return NULL;
  })
};
