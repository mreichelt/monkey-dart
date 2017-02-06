import 'dart:io';

import 'package:monkey_lang/ast/ast.dart';
import 'package:monkey_lang/evaluator/evaluator.dart';
import 'package:monkey_lang/lexer/lexer.dart';
import 'package:monkey_lang/object/environment.dart';
import 'package:monkey_lang/object/object.dart';
import 'package:monkey_lang/parser/parser.dart';

const MONKEY_FACE = r"""            __,__
   .--.  .-"     "-.  .--.
  / .. \/  .-. .-.  \/ .. \
 | |  '|  /   Y   \  |'  | |
 | \   \  \ 0 | 0 /  /   / |
  \ '- ,\.-"""
    '"""""""'
    """-./, -' /
   ''-' /_   ^ ^   _\\ '-''
       |  \\._   _./  |
       \\   \\ '~' /   /
        '._ '-=-' _.'
           '-----'""";

void start() {
  const String prompt = '>> ';
  final Environment env = new Environment.freshEnvironment();
  while (true) {
    stdout.write(prompt);

    String inputText = stdin.readLineSync();
    if (inputText == null) {
      return;
    }

    Parser parser = new Parser(new Lexer(inputText));
    Program program = parser.parseProgram();
    if (parser.errors.isNotEmpty) {
      printParserErrors(parser.errors);
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

void printParserErrors(List<String> errors) {
  print(MONKEY_FACE);
  print('Woops! We ran into some monkey business here!');
  print(' parser errors:');
  errors.forEach((error) {
    print('\t$error');
  });
}

void main() {
  print('Hello! This is the Monkey programming language!');
  print('Feel free to type in commands');
  start();
}
