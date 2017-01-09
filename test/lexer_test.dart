import 'package:monkey_dart/token/token.dart';
import 'package:monkey_dart/lexer/lexer.dart';
import 'package:test/test.dart';

void main() {
  test("test lexer with input =+(){},;", () {
    String input = "=+(){},;";
    List<Token> expected = [
      new Token(Token.ASSIGN, "="),
      new Token(Token.PLUS, "+"),
      new Token(Token.LPAREN, "("),
      new Token(Token.RPAREN, ")"),
      new Token(Token.LBRACE, "{"),
      new Token(Token.RBRACE, "}"),
      new Token(Token.COMMA, ","),
      new Token(Token.SEMICOLON, ";"),
      new Token(Token.EOF, "")
    ];

    Lexer lexer = new Lexer(input);
    for (int i = 0; i < expected.length; i++) {
      Token expectedToken = expected[i];
      Token actualToken = lexer.nextToken();
      expect(actualToken.tokenType, expectedToken.tokenType,
          reason: "tests[$i] - tokentype wrong");
      expect(actualToken.literal, expectedToken.literal,
          reason: "tests[$i] - literal wrong");
    }
  });
}
