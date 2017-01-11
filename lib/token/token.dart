library token;

class Token {
  static const ILLEGAL = "ILLEGAL",
      EOF = "EOF",

// Identifiers + literals
      IDENT = "IDENT", // add, foobar, x, y, ...
      INT = "INT", // 1343456

// Operators
      ASSIGN = "=",
      PLUS = "+",
      MINUS = "-",
      BANG = "!",
      ASTERISK = "*",
      SLASH = "/",
      LT = "<",
      GT = ">",
      EQ = "==",
      NOT_EQ = "!=",

// Delimiters
      COMMA = ",",
      SEMICOLON = ";",
      LPAREN = "(",
      RPAREN = ")",
      LBRACE = "{",
      RBRACE = "}",

// Keywords
      FUNCTION = "FUNCTION",
      LET = "LET",
      TRUE = "TRUE",
      FALSE = "FALSE",
      IF = "IF",
      ELSE = "ELSE",
      RETURN = "RETURN";

  static const Map<String, String> keywords = const {
    "fn": Token.FUNCTION,
    "let": Token.LET,
    "true": Token.TRUE,
    "false": Token.FALSE,
    "if": Token.IF,
    "else": Token.ELSE,
    "return": Token.RETURN
  };

  String type;
  String literal;

  Token(this.type, this.literal);

  bool operator ==(o) => o is Token && o.type == type && o.literal == literal;

  static String lookupIdent(String ident) {
    String value = keywords[ident];
    return value == null ? Token.IDENT : value;
  }

  @override
  String toString() {
    return 'Token{type: $type, literal: $literal}';
  }
}
