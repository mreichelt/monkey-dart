import 'package:monkey_lang/ast/ast.dart';
import 'package:monkey_lang/object/environment.dart';

const String INTEGER_OBJ = 'INTEGER',
    BOOLEAN_OBJ = 'BOOLEAN',
    NULL_OBJ = 'NULL',
    RETURN_VALUE_OBJ = 'RETURN_VALUE',
    ERROR_OBJ = 'ERROR',
    FUNCTION_OBJ = 'FUNCTION',
    STRING_OBJ = 'STRING',
    BUILTIN_OBJ = 'BUILTIN',
    ARRAY_OBJ = 'ARRAY',
    HASH_OBJ = 'HASH';

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
    return other is HashKey && type == other.type && value == other.value;
  }

  @override
  int get hashCode {
    return type.hashCode ^ value.hashCode;
  }
}

abstract class Hashable {
  HashKey hashKey();
}

class HashPair {
  MonkeyObject key;
  MonkeyObject value;

  HashPair(this.key, this.value);
}

class Hash extends MonkeyObject {
  Map<HashKey, HashPair> pairs = {};

  Hash() : super(HASH_OBJ);

  @override
  String inspect() {
    String inspect = pairs.values
        .map((pair) => '${pair.key.inspect()}:${pair.value.inspect()}')
        .join(', ');
    return '{$inspect}';
  }
}

class MonkeyInteger extends MonkeyObject implements Hashable {
  int value;

  MonkeyInteger(this.value) : super(INTEGER_OBJ);

  @override
  String inspect() => '$value';

  @override
  HashKey hashKey() => HashKey(type, value);
}

class MonkeyBoolean extends MonkeyObject implements Hashable {
  final bool value;

  const MonkeyBoolean(this.value) : super(BOOLEAN_OBJ);

  @override
  String inspect() => '$value';

  @override
  HashKey hashKey() => HashKey(type, value ? 1 : 0);
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

class MonkeyFunction extends MonkeyObject {
  List<Identifier> parameters;
  Environment env;
  BlockStatement body;

  MonkeyFunction(this.parameters, this.env, this.body) : super(FUNCTION_OBJ);

  @override
  String inspect() => 'fn(${parameters.join(', ')}) {\n$body\n}';
}

class MonkeyString extends MonkeyObject implements Hashable {
  final String value;

  MonkeyString(this.value) : super(STRING_OBJ);

  @override
  String inspect() => value;

  @override
  HashKey hashKey() => HashKey(type, value.hashCode);
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

class MonkeyError extends Error {
  final String message;

  MonkeyError(this.message);

  @override
  String toString() => 'ERROR: $message';
}
