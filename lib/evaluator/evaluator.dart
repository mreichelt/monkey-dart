library evaluator;

import 'package:monkey_dart/ast/ast.dart';
import 'package:monkey_dart/object/object.dart';

const MonkeyNull NULL = const MonkeyNull();
const Boolean TRUE = const Boolean(true);
const Boolean FALSE = const Boolean(false);

MonkeyObject eval(Node node) {
  if (node is Program) {
    return evalStatements(node.statements);
  } else if (node is ExpressionStatement) {
    return eval(node.expression);
  } else if (node is IntegerLiteral) {
    return new Integer(node.value);
  } else if (node is BooleanLiteral) {
    return nativeBoolToBooleanObject(node.value);
  } else if (node is PrefixExpression) {
    return evalPrefixExpression(node.operator, eval(node.right));
  } else if (node is InfixExpression) {
    var left = eval(node.left);
    var right = eval(node.right);
    return evalInfixExpression(node.operator, left, right);
  } else if (node is BlockStatement) {
    return evalStatements(node.statements);
  } else if (node is IfExpression) {
    return evalIfExpression(node);
  }
  return null;
}

MonkeyObject evalIfExpression(IfExpression expression) {
  MonkeyObject condition = eval(expression.condition);
  if (isTruthy(condition)) {
    return eval(expression.consequence);
  } else if (expression.alternative != null) {
    return eval(expression.alternative);
  } else {
    return NULL;
  }
}

bool isTruthy(MonkeyObject condition) {
  if (condition == NULL) {
    return false;
  } else if (condition == TRUE) {
    return true;
  } else if (condition == FALSE) {
    return false;
  } else {
    return true;
  }
}

MonkeyObject evalInfixExpression(
    String operator, MonkeyObject left, MonkeyObject right) {
  if (left.type == INTEGER_OBJ && right.type == INTEGER_OBJ) {
    return evalIntegerInfixExpression(operator, left, right);
  } else if (operator == '==') {
    return nativeBoolToBooleanObject(left == right);
  } else if (operator == '!=') {
    return nativeBoolToBooleanObject(left != right);
  } else {
    return NULL;
  }
}

MonkeyObject evalIntegerInfixExpression(
    String operator, Integer left, Integer right) {
  switch (operator) {
    case '+':
      return new Integer(left.value + right.value);
    case '-':
      return new Integer(left.value - right.value);
    case '*':
      return new Integer(left.value * right.value);
    case '/':
      return new Integer(left.value ~/ right.value);
    case '<':
      return nativeBoolToBooleanObject(left.value < right.value);
    case '>':
      return nativeBoolToBooleanObject(left.value > right.value);
    case '==':
      return nativeBoolToBooleanObject(left.value == right.value);
    case '!=':
      return nativeBoolToBooleanObject(left.value != right.value);
    default:
      return NULL;
  }
}

MonkeyObject evalPrefixExpression(String operator, MonkeyObject right) {
  switch (operator) {
    case '!':
      return evalBangOperatorExpression(right);
    case '-':
      return evalMinusPrefixOperatorExpression(right);
    default:
      return NULL;
  }
}

MonkeyObject evalBangOperatorExpression(MonkeyObject right) {
  if (right == TRUE) {
    return FALSE;
  } else if (right == FALSE) {
    return TRUE;
  } else if (right == NULL) {
    return TRUE;
  } else {
    return FALSE;
  }
}

MonkeyObject evalMinusPrefixOperatorExpression(MonkeyObject right) {
  if (right.type != INTEGER_OBJ) {
    return NULL;
  }
  return new Integer(-(right as Integer).value);
}

Boolean nativeBoolToBooleanObject(bool value) => value ? TRUE : FALSE;

MonkeyObject evalStatements(List<Statement> statements) {
  MonkeyObject result;
  statements.forEach((statement) {
    result = eval(statement);
  });
  return result;
}
