library builtins;

import 'package:monkey_dart/evaluator/evaluator.dart';
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
  }),
  'first': new Builtin((List<MonkeyObject> args) {
    if (args.length != 1) {
      return new MonkeyError(
          'wrong number of arguments. got=${args.length}, want=1');
    }

    MonkeyObject arg = args.first;
    if (arg.type != ARRAY_OBJ) {
      return new MonkeyError(
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
      return new MonkeyError(
          'wrong number of arguments. got=${args.length}, want=1');
    }

    MonkeyObject arg = args.first;
    if (arg.type != ARRAY_OBJ) {
      return new MonkeyError(
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
      return new MonkeyError(
          'wrong number of arguments. got=${args.length}, want=1');
    }

    MonkeyObject arg = args.first;
    if (arg.type != ARRAY_OBJ) {
      return new MonkeyError(
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
      return new MonkeyError(
          'wrong number of arguments. got=${args.length}, want=2');
    }

    if (args.first.type != ARRAY_OBJ) {
      return new MonkeyError(
          'argument to `push` must be ARRAY, got ${args.first.type}');
    }

    MonkeyArray array = args.first;
    return new MonkeyArray(
        new List<MonkeyObject>.from(array.elements)..add(args[1]));
  })
};
