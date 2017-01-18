library object;

const String INTEGER_OBJ = 'INTEGER',
    BOOLEAN_OBJ = 'BOOLEAN',
    NULL_OBJ = 'NULL',
    RETURN_VALUE_OBJ = 'RETURN_VALUE';

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
