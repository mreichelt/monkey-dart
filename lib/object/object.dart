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
    BUILTIN_OBJ = 'BUILTIN',
    ARRAY_OBJ = 'ARRAY';

abstract class MonkeyObject {
  final String type;

  const MonkeyObject(this.type);

  String inspect();
}

class HashKey {
  String type;
  int value;

  HashKey(this.type, this.value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is HashKey &&
        this.type == other.type &&
        this.value == other.value;
  }

  @override
  int get hashCode {
    return type.hashCode ^ value.hashCode;
  }
}

abstract class HasHashKey {
  HashKey hashKey();
}

class Integer extends MonkeyObject implements HasHashKey {
  int value;

  Integer(this.value) : super(INTEGER_OBJ);

  @override
  String inspect() => '$value';

  @override
  HashKey hashKey() => new HashKey(type, value);
}

class Boolean extends MonkeyObject implements HasHashKey {
  final bool value;

  const Boolean(this.value) : super(BOOLEAN_OBJ);

  @override
  String inspect() => '$value';

  @override
  HashKey hashKey() => new HashKey(type, value ? 1 : 0);
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

class MonkeyString extends MonkeyObject implements HasHashKey {
  final String value;

  MonkeyString(this.value) : super(STRING_OBJ);

  @override
  String inspect() => value;

  @override
  HashKey hashKey() => new HashKey(type, value.hashCode);
}

class Builtin extends MonkeyObject {
  final Function fn;

  const Builtin(this.fn) : super(BUILTIN_OBJ);

  @override
  String inspect() => 'builtin function';
}

class MonkeyArray extends MonkeyObject {
  final List<MonkeyObject> elements;

  const MonkeyArray(this.elements) : super(ARRAY_OBJ);

  @override
  String inspect() =>
      '[${elements.map((object) => object.inspect()).join(', ')}]';
}
