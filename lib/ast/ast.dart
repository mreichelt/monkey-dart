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

  @override
  String toString() {
    StringBuffer sb = new StringBuffer();
    statements.forEach((statement) => sb.write(statement));
    return sb.toString();
  }
}

class Identifier extends Expression {
  /** the IDENT token */
  Token token;
  String value;

  Identifier(this.token, this.value);

  @override
  String tokenLiteral() => token.literal;

  @override
  String toString() => value;
}

class LetStatement extends Statement {
  /** the LET token */
  Token token;
  Identifier name;
  Expression value;

  LetStatement(this.token);

  @override
  String tokenLiteral() => token.literal;

  @override
  String toString() => "$tokenLiteral $name = ${value ?? ''};";
}

class ReturnStatement extends Statement {
  /** the 'return' token */
  Token token;
  Expression returnValue;

  ReturnStatement(this.token);

  @override
  String tokenLiteral() => token.literal;

  @override
  String toString() => "$tokenLiteral ${returnValue ?? ''};";
}

class ExpressionStatement extends Statement {
  /** the first token of the expression */
  Token token;
  Expression expression;

  @override
  String tokenLiteral() => token.literal;

  @override
  String toString() => "${expression ?? ''}";
}
