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
    return statements.isEmpty ? '' : statements.first.tokenLiteral;
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
  String toString() => '${tokenLiteral()} $name = ${value ?? ''};';
}

class ReturnStatement extends Statement {
  Expression returnValue;

  ReturnStatement(Token token) : super(token);

  @override
  String toString() => '${tokenLiteral()} ${returnValue ?? ''};';
}

class ExpressionStatement extends Statement {
  Expression expression;

  ExpressionStatement(Token token) : super(token);

  @override
  String toString() => '${expression ?? ''}';
}

class IntegerLiteral extends Expression {
  int value;

  IntegerLiteral(Token token) : super(token);

  @override
  String toString() => token.literal;
}

class PrefixExpression extends Expression {
  String operator;
  Expression right;

  PrefixExpression(Token token, this.operator) : super(token);

  @override
  String toString() => '($operator$right)';
}

class InfixExpression extends Expression {
  Expression left;
  String operator;
  Expression right;

  InfixExpression(Token token, this.operator, this.left) : super(token);

  @override
  String toString() => '($left $operator $right)';
}

class BooleanLiteral extends Expression {
  bool value;

  BooleanLiteral(Token token, this.value) : super(token);

  @override
  String toString() => token.literal;
}

class IfExpression extends Expression {
  Expression condition;
  BlockStatement consequence;
  BlockStatement alternative;

  IfExpression(Token token) : super(token);

  @override
  String toString() => 'if$condition $consequence ${alternative == null
      ? ''
      : 'else $alternative'}';
}

class BlockStatement extends Statement {
  List<Statement> statements = [];

  BlockStatement(Token token) : super(token);

  @override
  String toString() => statements.join();
}

class FunctionLiteral extends Expression {
  List<Identifier> parameters = [];
  BlockStatement body;

  FunctionLiteral(Token token) : super(token);

  @override
  String toString() => '${tokenLiteral()}(${parameters.join(', ')})$body';
}

class CallExpression extends Expression {
  Expression function;
  List<Expression> arguments = [];

  CallExpression(Token token, this.function) : super(token);

  @override
  String toString() => '$function(${arguments.join(', ')})';
}

class StringLiteral extends Expression {
  final String value;

  StringLiteral(Token token, this.value) : super(token);

  @override
  String toString() => token.literal;
}

class ArrayLiteral extends Expression {
  List<Expression> elements;

  ArrayLiteral(Token token, this.elements) : super(token);

  @override
  String toString() => '[${elements.join(', ')}]';
}
