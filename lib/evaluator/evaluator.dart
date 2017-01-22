library evaluator;

import 'package:monkey_dart/ast/ast.dart';
import 'package:monkey_dart/evaluator/builtins.dart';
import 'package:monkey_dart/object/environment.dart';
import 'package:monkey_dart/object/object.dart';

const MonkeyNull NULL = const MonkeyNull();
const Boolean TRUE = const Boolean(true);
const Boolean FALSE = const Boolean(false);

MonkeyObject eval(Node node, Environment env) {
  if (node is Program) {
    return evalProgram(node, env);
  } else if (node is ExpressionStatement) {
    return eval(node.expression, env);
  } else if (node is IntegerLiteral) {
    return new Integer(node.value);
  } else if (node is BooleanLiteral) {
    return nativeBoolToBooleanObject(node.value);
  } else if (node is PrefixExpression) {
    var right = eval(node.right, env);
    return isError(right) ? right : evalPrefixExpression(node.operator, right);
  } else if (node is InfixExpression) {
    var left = eval(node.left, env);
    if (isError(left)) {
      return left;
    }

    var right = eval(node.right, env);
    if (isError(right)) {
      return right;
    }
    return evalInfixExpression(node.operator, left, right);
  } else if (node is BlockStatement) {
    return evalBlockStatement(node, env);
  } else if (node is IfExpression) {
    return evalIfExpression(node, env);
  } else if (node is ReturnStatement) {
    var value = eval(node.returnValue, env);
    return isError(value) ? value : new ReturnValue(value);
  } else if (node is LetStatement) {
    var value = eval(node.value, env);
    if (isError(value)) {
      return value;
    }
    env.set(node.name.value, value);
  } else if (node is Identifier) {
    return evalIdentifier(node, env);
  } else if (node is FunctionLiteral) {
    return new MonkeyFunction(node.parameters, env, node.body);
  } else if (node is CallExpression) {
    MonkeyObject function = eval(node.function, env);
    if (isError(function)) {
      return function;
    }
    List<MonkeyObject> args = evalExpressions(node.arguments, env);
    if (args.length == 1 && isError(args.first)) {
      return args.first;
    }
    return applyFunction(function, args);
  } else if (node is StringLiteral) {
    return new MonkeyString(node.value);
  } else if (node is ArrayLiteral) {
    List<MonkeyObject> elements = evalExpressions(node.elements, env);
    if (elements.length == 1 && elements.first is MonkeyError) {
      return elements.first;
    }
    return new MonkeyArray(elements);
  }
  return null;
}

MonkeyObject evalIdentifier(Identifier node, Environment env) {
  MonkeyObject value = env.get(node.value);
  if (value != null) {
    return value;
  }

  Builtin builtin = builtins[node.value];
  if (builtin != null) {
    return builtin;
  }

  return new MonkeyError('identifier not found: ${node.value}');
}

List<MonkeyObject> evalExpressions(
    List<Expression> expressions, Environment env) {
  List<MonkeyObject> result = [];
  for (int i = 0; i < expressions.length; i++) {
    MonkeyObject evaluated = eval(expressions[i], env);
    if (isError(evaluated)) {
      return [evaluated];
    }
    result.add(evaluated);
  }
  return result;
}

MonkeyObject evalProgram(Program program, Environment env) {
  MonkeyObject result;
  for (int i = 0; i < program.statements.length; i++) {
    result = eval(program.statements[i], env);
    if (result is ReturnValue) {
      return result.value;
    } else if (result is MonkeyError) {
      return result;
    }
  }
  return result;
}

MonkeyObject evalBlockStatement(BlockStatement block, Environment env) {
  MonkeyObject result;
  for (int i = 0; i < block.statements.length; i++) {
    result = eval(block.statements[i], env);
    if (result != null) {
      if (result.type == RETURN_VALUE_OBJ || result.type == ERROR_OBJ) {
        return result;
      }
    }
  }
  return result;
}

MonkeyObject evalIfExpression(IfExpression expression, Environment env) {
  MonkeyObject condition = eval(expression.condition, env);
  if (isError(condition)) {
    return condition;
  }

  if (isTruthy(condition)) {
    return eval(expression.consequence, env);
  } else if (expression.alternative != null) {
    return eval(expression.alternative, env);
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
  } else if (left.type == STRING_OBJ && right.type == STRING_OBJ) {
    return evalStringInfixExpression(operator, left, right);
  } else if (operator == '==') {
    return nativeBoolToBooleanObject(left == right);
  } else if (operator == '!=') {
    return nativeBoolToBooleanObject(left != right);
  } else if (left.type != right.type) {
    return new MonkeyError('type mismatch: ${left.type} '
        '$operator ${right.type}');
  } else {
    return new MonkeyError('unknown operator: ${left.type} '
        '$operator ${right.type}');
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
      return new MonkeyError('unknown operator: ${left.type} '
          '$operator ${right.type}');
  }
}

MonkeyObject evalStringInfixExpression(
    String operator, MonkeyString left, MonkeyString right) {
  switch (operator) {
    case '+':
      return new MonkeyString(left.value + right.value);
    default:
      return new MonkeyError('unknown operator: ${left.type} '
          '$operator ${right.type}');
  }
}

MonkeyObject evalPrefixExpression(String operator, MonkeyObject right) {
  switch (operator) {
    case '!':
      return evalBangOperatorExpression(right);
    case '-':
      return evalMinusPrefixOperatorExpression(right);
    default:
      return new MonkeyError('unknown operator: $operator${right.type}');
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
    return new MonkeyError('unknown operator: -${right.type}');
  }
  return new Integer(-(right as Integer).value);
}

Boolean nativeBoolToBooleanObject(bool value) => value ? TRUE : FALSE;

MonkeyObject evalStatements(List<Statement> statements, Environment env) {
  MonkeyObject result;
  for (int i = 0; i < statements.length; i++) {
    result = eval(statements[i], env);
    if (result is ReturnValue) {
      return result.value;
    }
  }
  return result;
}

bool isError(MonkeyObject object) {
  if (object != null) {
    return object.type == ERROR_OBJ;
  }
  return false;
}

MonkeyObject applyFunction(MonkeyObject function, List<MonkeyObject> args) {
  if (function is MonkeyFunction) {
    Environment extendedEnv = extendFunctionEnv(function, args);
    MonkeyObject evaluated = eval(function.body, extendedEnv);
    return unwrapReturnValue(evaluated);
  } else if (function is Builtin) {
    return function.fn(args);
  } else {
    return new MonkeyError('not a function: ${function.type}');
  }
}

Environment extendFunctionEnv(
    MonkeyFunction function, List<MonkeyObject> args) {
  Environment env = new Environment.enclosedEnvironment(function.env);
  for (int i = 0; i < function.parameters.length; i++) {
    env.set(function.parameters[i].value, args[i]);
  }
  return env;
}

MonkeyObject unwrapReturnValue(MonkeyObject object) {
  return object is ReturnValue ? object.value : object;
}
