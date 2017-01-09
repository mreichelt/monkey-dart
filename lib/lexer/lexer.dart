library lexer;

import 'package:monkey_dart/token/token.dart';

class Lexer {

  String input;

  /** current position in input (points to current char) */
  int position = 0;

  /** current reading position in input (after current char) */
  int readPosition = 0;

  /** current char under examination */
  String ch;

  Lexer(this.input) {
    readChar();
  }

  void readChar() {
    if (readPosition >= input.length) {
      ch = '\0';
    } else {
      ch = input[readPosition];
    }
    position = readPosition;
    readPosition += 1;
  }

  Token nextToken() {
    Token token;

    switch (ch) {
      case '=':
        token = new Token(Token.ASSIGN, ch);
        break;
      case ';':
        token = new Token(Token.SEMICOLON, ch);
        break;
      case '(':
        token = new Token(Token.LPAREN, ch);
        break;
      case ')':
        token = new Token(Token.RPAREN, ch);
        break;
      case ',':
        token = new Token(Token.COMMA, ch);
        break;
      case '+':
        token = new Token(Token.PLUS, ch);
        break;
      case '{':
        token = new Token(Token.LBRACE, ch);
        break;
      case '}':
        token = new Token(Token.RBRACE, ch);
        break;
      case '\0':
        token = new Token(Token.EOF, '');
        break;
    }

    readChar();
    return token;
  }

}
