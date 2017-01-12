library ast;

import 'package:monkey_dart/token/token.dart';

abstract class Node {
  String tokenLiteral();
}

abstract class Statement extends Node {
  Token token;

  Statement(this.token);

  @override
  String tokenLiteral() => token.literal;
}

abstract class Expression extends Node {
  Token token;

  Expression(this.token);

  @override
  String tokenLiteral() => token.literal;
}

class Program extends Node {
  List<Statement> statements;

  String tokenLiteral() {
    return statements.isEmpty ? "" : statements.first.tokenLiteral;
  }

  @override
  String toString() {
    StringBuffer sb = new StringBuffer();
    statements.forEach((statement) => sb.write(statement));
    return sb.toString();
  }
}

class Identifier extends Expression {
  String value;

  Identifier(Token token, this.value) : super(token);

  @override
  String toString() => value;
}

class LetStatement extends Statement {
  Identifier name;
  Expression value;

  LetStatement(Token token) : super(token);

  @override
  String toString() => "${tokenLiteral()} $name = ${value ?? ''};";
}

class ReturnStatement extends Statement {
  Expression returnValue;

  ReturnStatement(Token token) : super(token);

  @override
  String toString() => "${tokenLiteral()} ${returnValue ?? ''};";
}

class ExpressionStatement extends Statement {
  Expression expression;

  ExpressionStatement(Token token) : super(token);

  @override
  String toString() => "${expression ?? ''}";
}

class IntegerLiteral extends Expression {
  int value;

  IntegerLiteral(Token token) : super(token);

  @override
  String toString() => token.literal;
}
