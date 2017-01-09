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

  String tokenType;
  String literal;

  Token(this.tokenType, this.literal);

  bool operator ==(o) =>
      o is Token && o.tokenType == tokenType && o.literal == literal;
}
