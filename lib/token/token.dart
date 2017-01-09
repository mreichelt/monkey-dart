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

// Delimiters
      COMMA = ",",
      SEMICOLON = ";",
      LPAREN = "(",
      RPAREN = ")",
      LBRACE = "{",
      RBRACE = "}",

// Keywords
      FUNCTION = "FUNCTION",
      LET = "LET";

  static const Map<String, String> keywords = const {
    "fn": Token.FUNCTION,
    "let": Token.LET
  };

  String tokenType;
  String literal;

  Token(this.tokenType, this.literal);

  bool operator ==(o) =>
      o is Token && o.tokenType == tokenType && o.literal == literal;

  static String lookupIdent(String ident) {
    String value = keywords[ident];
    return value == null ? Token.IDENT : value;
  }
}
