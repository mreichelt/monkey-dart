import 'package:monkey_lang/ast/ast.dart';
import 'package:monkey_lang/token/token.dart';
import 'package:test/test.dart';

void main() {
  test('test program.toString()', () {
    Program program = new Program()
      ..statements = [
        new LetStatement(new Token(Token.LET, 'let'))
          ..name = ident('myVar')
          ..value = ident('anotherVar')
      ];

    expect(program.toString(), equals('let myVar = anotherVar;'));
  });
}

Identifier ident(String name) =>
    new Identifier(new Token(Token.IDENT, name), name);
