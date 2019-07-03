import 'package:monkey_lang/evaluator/evaluator.dart';
import 'package:monkey_lang/monkey/monkey.dart';
import 'package:monkey_lang/object/object.dart';

final Map<String, Builtin> builtins = {
  'len': Builtin((List<MonkeyObject> args) {
    if (args.length != 1) {
      throw MonkeyError(
          'wrong number of arguments. got=${args.length}, want=1');
    }

    MonkeyObject arg = args.first;
    if (arg is MonkeyString) {
      return MonkeyInteger(arg.value.length);
    } else if (arg is MonkeyArray) {
      return MonkeyInteger(arg.elements.length);
    }

    throw MonkeyError('argument to `len` not supported, got ${arg.type}');
  }),
  'first': Builtin((List<MonkeyObject> args) {
    if (args.length != 1) {
      throw MonkeyError(
          'wrong number of arguments. got=${args.length}, want=1');
    }

    MonkeyObject arg = args.first;
    if (arg.type != ARRAY_OBJ) {
      throw MonkeyError('argument to `first` must be ARRAY, got ${arg.type}');
    }

    MonkeyArray array = arg;
    if (array.elements.isNotEmpty) {
      return array.elements.first;
    }

    return NULL;
  }),
  'last': Builtin((List<MonkeyObject> args) {
    if (args.length != 1) {
      throw MonkeyError(
          'wrong number of arguments. got=${args.length}, want=1');
    }

    MonkeyObject arg = args.first;
    if (arg.type != ARRAY_OBJ) {
      throw MonkeyError('argument to `last` must be ARRAY, got ${arg.type}');
    }

    MonkeyArray array = arg;
    if (array.elements.isNotEmpty) {
      return array.elements.last;
    }

    return NULL;
  }),
  'rest': Builtin((List<MonkeyObject> args) {
    if (args.length != 1) {
      throw MonkeyError(
          'wrong number of arguments. got=${args.length}, want=1');
    }

    MonkeyObject arg = args.first;
    if (arg.type != ARRAY_OBJ) {
      throw MonkeyError('argument to `rest` must be ARRAY, got ${arg.type}');
    }

    MonkeyArray array = arg;
    if (array.elements.isNotEmpty) {
      return MonkeyArray(array.elements.sublist(1));
    }

    return NULL;
  }),
  'push': Builtin((List<MonkeyObject> args) {
    if (args.length != 2) {
      throw MonkeyError(
          'wrong number of arguments. got=${args.length}, want=2');
    }

    if (args.first.type != ARRAY_OBJ) {
      throw MonkeyError(
          'argument to `push` must be ARRAY, got ${args.first.type}');
    }

    MonkeyArray array = args.first;
    return MonkeyArray(List<MonkeyObject>.from(array.elements)..add(args[1]));
  }),
  'puts': Builtin((List<MonkeyObject> args) {
    args.forEach((MonkeyObject arg) {
      Monkey.monkeyPrint(arg.inspect());
    });
    return NULL;
  })
};
