library repl;

import 'dart:io';

import 'package:monkey_dart/lexer/lexer.dart';
import 'package:monkey_dart/token/token.dart';

void start() {
  const String prompt = ">> ";
  while (true) {
    stdout.write(prompt);

    String inputText = stdin.readLineSync();
    if (inputText == null) {
      return;
    }

    Lexer lexer = new Lexer(inputText);
    for (Token token = lexer.nextToken();
        token.type != Token.EOF;
        token = lexer.nextToken()) {
      print(token);
    }
  }
}

void main() {
  print("Hello! This is the Monkey programming language!");
  print("Feel free to type in commands");
  start();
}
