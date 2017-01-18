library repl;

import 'dart:io';

import 'package:monkey_dart/ast/ast.dart';
import 'package:monkey_dart/lexer/lexer.dart';
import 'package:monkey_dart/parser/parser.dart';
import 'package:monkey_dart/object/object.dart';
import 'package:monkey_dart/object/environment.dart';
import 'package:monkey_dart/evaluator/evaluator.dart';

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

    MonkeyObject evaluated = eval(program, env);
    if (evaluated != null) {
      print(evaluated.inspect());
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
