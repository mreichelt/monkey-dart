library repl;

import 'dart:io';

import 'package:monkey_dart/ast/ast.dart';
import 'package:monkey_dart/lexer/lexer.dart';
import 'package:monkey_dart/parser/parser.dart';

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

    print(program);
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
