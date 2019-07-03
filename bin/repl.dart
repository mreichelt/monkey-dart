import 'dart:io';

import 'package:monkey_lang/ast/ast.dart';
import 'package:monkey_lang/evaluator/evaluator.dart';
import 'package:monkey_lang/lexer/lexer.dart';
import 'package:monkey_lang/monkey/monkey.dart';
import 'package:monkey_lang/object/environment.dart';
import 'package:monkey_lang/object/object.dart';
import 'package:monkey_lang/parser/parser.dart';

void start() {
  const String prompt = '>> ';
  final Environment env = Environment.freshEnvironment();

  while (true) {
    stdout.write(prompt);

    String inputText = stdin.readLineSync();
    if (inputText == null) {
      return;
    }

    Parser parser = Parser(Lexer(inputText));
    Program program = parser.parseProgram();
    if (parser.hasErrors()) {
      print(parser.getErrorsAsString());
      continue;
    }

    try {
      MonkeyObject evaluated = eval(program, env);
      if (evaluated != null) {
        print(evaluated.inspect());
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

void main() {
  print(Monkey.WELCOME);
  start();
}
