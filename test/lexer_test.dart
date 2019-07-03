import 'package:monkey_lang/lexer/lexer.dart';
import 'package:monkey_lang/token/token.dart';
import 'package:test/test.dart';

Token t(String tokenType, String literal) {
  return Token(tokenType, literal);
}

void testLexer(List<Token> expected, String input) {
  Lexer lexer = Lexer(input);
  for (int i = 0; i < expected.length; i++) {
    Token expectedToken = expected[i];
    Token actualToken = lexer.nextToken();
    print('${actualToken.literal} ');
    expect(actualToken.type, expectedToken.type,
        reason: 'tests[$i] - tokentype wrong');
    expect(actualToken.literal, expectedToken.literal,
        reason: 'tests[$i] - literal wrong');
  }
}

void main() {
  test('test lexer with input =+(){},;', () {
    String input = '=+(){},;';
    List<Token> expected = [
      t(Token.ASSIGN, '='),
      t(Token.PLUS, '+'),
      t(Token.LPAREN, '('),
      t(Token.RPAREN, ')'),
      t(Token.LBRACE, '{'),
      t(Token.RBRACE, '}'),
      t(Token.COMMA, ','),
      t(Token.SEMICOLON, ';'),
      t(Token.EOF, '')
    ];

    testLexer(expected, input);
  });

  test('test monkey language tokens', () {
    String input = """
      let five = 5;
      let ten = 10;

      let add = fn(x, y) {
        x + y;
      };

      let result = add(five, ten);
      !-/*5;
      5 < 10 > 5;

      if (5 < 10) {
        return true;
      } else {
        return false;
      }

      10 == 10;
      10 != 9;
      "foobar"
      "foo bar"
      [1, 2];
      {"foo": "bar"}
    """;
    List<Token> expected = [
      t(Token.LET, 'let'),
      t(Token.IDENT, 'five'),
      t(Token.ASSIGN, '='),
      t(Token.INT, '5'),
      t(Token.SEMICOLON, ';'),
      t(Token.LET, 'let'),
      t(Token.IDENT, 'ten'),
      t(Token.ASSIGN, '='),
      t(Token.INT, '10'),
      t(Token.SEMICOLON, ';'),
      t(Token.LET, 'let'),
      t(Token.IDENT, 'add'),
      t(Token.ASSIGN, '='),
      t(Token.FUNCTION, 'fn'),
      t(Token.LPAREN, '('),
      t(Token.IDENT, 'x'),
      t(Token.COMMA, ','),
      t(Token.IDENT, 'y'),
      t(Token.RPAREN, ')'),
      t(Token.LBRACE, '{'),
      t(Token.IDENT, 'x'),
      t(Token.PLUS, '+'),
      t(Token.IDENT, 'y'),
      t(Token.SEMICOLON, ';'),
      t(Token.RBRACE, '}'),
      t(Token.SEMICOLON, ';'),
      t(Token.LET, 'let'),
      t(Token.IDENT, 'result'),
      t(Token.ASSIGN, '='),
      t(Token.IDENT, 'add'),
      t(Token.LPAREN, '('),
      t(Token.IDENT, 'five'),
      t(Token.COMMA, ','),
      t(Token.IDENT, 'ten'),
      t(Token.RPAREN, ')'),
      t(Token.SEMICOLON, ';'),
      t(Token.BANG, '!'),
      t(Token.MINUS, '-'),
      t(Token.SLASH, '/'),
      t(Token.ASTERISK, '*'),
      t(Token.INT, '5'),
      t(Token.SEMICOLON, ';'),
      t(Token.INT, '5'),
      t(Token.LT, '<'),
      t(Token.INT, '10'),
      t(Token.GT, '>'),
      t(Token.INT, '5'),
      t(Token.SEMICOLON, ';'),
      t(Token.IF, 'if'),
      t(Token.LPAREN, '('),
      t(Token.INT, '5'),
      t(Token.LT, '<'),
      t(Token.INT, '10'),
      t(Token.RPAREN, ')'),
      t(Token.LBRACE, '{'),
      t(Token.RETURN, 'return'),
      t(Token.TRUE, 'true'),
      t(Token.SEMICOLON, ';'),
      t(Token.RBRACE, '}'),
      t(Token.ELSE, 'else'),
      t(Token.LBRACE, '{'),
      t(Token.RETURN, 'return'),
      t(Token.FALSE, 'false'),
      t(Token.SEMICOLON, ';'),
      t(Token.RBRACE, '}'),
      t(Token.INT, '10'),
      t(Token.EQ, '=='),
      t(Token.INT, '10'),
      t(Token.SEMICOLON, ';'),
      t(Token.INT, '10'),
      t(Token.NOT_EQ, '!='),
      t(Token.INT, '9'),
      t(Token.SEMICOLON, ';'),
      t(Token.STRING, 'foobar'),
      t(Token.STRING, 'foo bar'),
      t(Token.LBRACKET, '['),
      t(Token.INT, '1'),
      t(Token.COMMA, ','),
      t(Token.INT, '2'),
      t(Token.RBRACKET, ']'),
      t(Token.SEMICOLON, ';'),
      t(Token.LBRACE, '{'),
      t(Token.STRING, 'foo'),
      t(Token.COLON, ':'),
      t(Token.STRING, 'bar'),
      t(Token.RBRACE, '}'),
      t(Token.EOF, '')
    ];

    testLexer(expected, input);
  });
}
