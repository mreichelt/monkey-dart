library object;

import 'package:monkey_dart/ast/ast.dart';
import 'package:monkey_dart/object/environment.dart';

const String INTEGER_OBJ = 'INTEGER',
    BOOLEAN_OBJ = 'BOOLEAN',
    NULL_OBJ = 'NULL',
    RETURN_VALUE_OBJ = 'RETURN_VALUE',
    ERROR_OBJ = 'ERROR',
    FUNCTION_OBJ = 'FUNCTION',
    STRING_OBJ = 'STRING',
    BUILTIN_OBJ = 'BUILTIN';

abstract class MonkeyObject {
  final String type;

  const MonkeyObject(this.type);

  String inspect();
}

class Integer extends MonkeyObject {
  int value;

  Integer(this.value) : super(INTEGER_OBJ);

  @override
  String inspect() => '$value';
}

class Boolean extends MonkeyObject {
  final bool value;

  const Boolean(this.value) : super(BOOLEAN_OBJ);

  @override
  String inspect() => '$value';
}

class MonkeyNull extends MonkeyObject {
  const MonkeyNull() : super(NULL_OBJ);

  @override
  String inspect() => 'null';
}

class ReturnValue extends MonkeyObject {
  final MonkeyObject value;

  const ReturnValue(this.value) : super(RETURN_VALUE_OBJ);

  @override
  String inspect() => value.inspect();
}

class MonkeyError extends MonkeyObject {
  final String message;

  const MonkeyError(this.message) : super(ERROR_OBJ);

  @override
  String inspect() => 'ERROR: $message';
}

class MonkeyFunction extends MonkeyObject {
  List<Identifier> parameters;
  Environment env;
  BlockStatement body;

  MonkeyFunction(this.parameters, this.env, this.body) : super(FUNCTION_OBJ);

  @override
  String inspect() => 'fn(${parameters.join(', ')}) {\n$body\n}';
}

class MonkeyString extends MonkeyObject {
  String value;

  MonkeyString(this.value) : super(STRING_OBJ);

  @override
  String inspect() => value;
}

class Builtin extends MonkeyObject {
  final Function fn;

  const Builtin(this.fn) : super(BUILTIN_OBJ);

  @override
  String inspect() => 'builtin function';
}
