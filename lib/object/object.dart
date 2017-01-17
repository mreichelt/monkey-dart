library object;

const String INTEGER_OBJ = 'INTEGER',
    BOOLEAN_OBJ = 'BOOLEAN',
    NULL_OBJ = 'NULL';

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
