import 'package:monkey_dart/ast/ast.dart';
import 'package:monkey_dart/lexer/lexer.dart';
import 'package:monkey_dart/parser/parser.dart';
import 'package:test/test.dart';

void main() {
  test("test let statements", () {
    String input = """
      let x = 5;
      let y = 10;
      let foobar = 838383;
   """;

    Lexer lexer = new Lexer(input);
    Parser parser = new Parser(lexer);
    Program program = parser.parseProgram();
    checkParserErrors(parser);

    expect(program, isNotNull, reason: "parseProgram() returned null");

    var numStatements = program.statements.length;
    expect(numStatements, equals(3),
        reason:
            "program.statements does not contain 3 statements. got=$numStatements");

    List<String> identifiers = ['x', 'y', 'foobar'];
    for (int i = 0; i < identifiers.length; i++) {
      Statement statement = program.statements[i];
      testLetStatement(statement, identifiers[i]);
    }
  });
}

void checkParserErrors(Parser parser) {
  if (parser.errors.isEmpty) {
    return;
  }

  print("parser has ${parser.errors.length} errors");
  parser.errors.forEach((error) {
    print("parser error: $error");
  });

  fail('');
}

void testLetStatement(Statement statement, String expectedIdentifier) {
  expect(statement.tokenLiteral(), equals('let'));

  LetStatement letStatement = statement;
  expect(letStatement.name.value, equals(expectedIdentifier));
  expect(letStatement.name.tokenLiteral(), equals(expectedIdentifier));
}
