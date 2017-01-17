library evaluator;

import 'package:monkey_dart/ast/ast.dart';
import 'package:monkey_dart/object/object.dart';

MonkeyObject eval(Node node) {
  if (node is Program) {
    return evalStatements(node.statements);
  } else if (node is ExpressionStatement) {
    return eval(node.expression);
  } else if (node is IntegerLiteral) {
    return new Integer(node.value);
  } else if (node is BooleanLiteral) {
    return new Boolean(node.value);
  }
  return null;
}

MonkeyObject evalStatements(List<Statement> statements) {
  MonkeyObject result;
  statements.forEach((statement) {
    result = eval(statement);
  });
  return result;
}
