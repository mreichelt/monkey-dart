class Token {
  static const ILLEGAL = 'ILLEGAL',
      EOF = 'EOF',

// Identifiers + literals
      IDENT = 'IDENT', // add, foobar, x, y, ...
      INT = 'INT', // 1343456
      STRING = 'STRING',

// Operators
      ASSIGN = '=',
      PLUS = '+',
      MINUS = '-',
      BANG = '!',
      ASTERISK = '*',
      SLASH = '/',
      LT = '<',
      GT = '>',
      EQ = '==',
      NOT_EQ = '!=',

// Delimiters
      COMMA = ',',
      SEMICOLON = ';',
      LPAREN = '(',
      RPAREN = ')',
      LBRACE = '{',
      RBRACE = '}',
      LBRACKET = '[',
      RBRACKET = ']',
      COLON = ':',

// Keywords
      FUNCTION = 'FUNCTION',
      LET = 'LET',
      TRUE = 'TRUE',
      FALSE = 'FALSE',
      IF = 'IF',
      ELSE = 'ELSE',
      RETURN = 'RETURN';

  static const Map<String, String> keywords = {
    'fn': Token.FUNCTION,
    'let': Token.LET,
    'true': Token.TRUE,
    'false': Token.FALSE,
    'if': Token.IF,
    'else': Token.ELSE,
    'return': Token.RETURN
  };

  String type;
  String literal;

  Token(this.type, this.literal);

  @override
  bool operator ==(o) => o is Token && o.type == type && o.literal == literal;

  static String lookupIdent(String ident) {
    String value = keywords[ident];
    return value ?? Token.IDENT;
  }

  @override
  String toString() {
    return 'Token{type: $type, literal: $literal}';
  }
}
