library ast;

import 'package:monkey_dart/token/token.dart';

abstract class Node {
  String tokenLiteral();
}

abstract class Statement extends Node {}

abstract class Expression extends Node {}

class Program extends Node {
  List<Statement> statements;

  String tokenLiteral() {
    return statements.isEmpty ? "" : statements.first.tokenLiteral;
  }
}

class Identifier extends Expression {
  // the IDENT token
  Token token;
  String value;

  Identifier(this.token, this.value);

  @override
  String tokenLiteral() {
    return token.literal;
  }
}

class LetStatement extends Statement {
  // the LET token
  Token token;
  Identifier name;
  Expression value;

  LetStatement(this.token);

  @override
  String tokenLiteral() {
    return token.literal;
  }
}

class ReturnStatement extends Statement {
  // the 'return' token
  Token token;
  Expression returnValue;

  ReturnStatement(this.token);

  @override
  String tokenLiteral() {
    return token.literal;
  }
}
