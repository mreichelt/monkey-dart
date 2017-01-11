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

    Parser parser = new Parser(new Lexer(input));
    Program program = parser.parseProgram();
    checkParserErrors(parser);

    expect(program, isNotNull, reason: "parseProgram() returned null");

    expectNumStatements(program, 3);

    List<String> identifiers = ['x', 'y', 'foobar'];
    for (int i = 0; i < identifiers.length; i++) {
      Statement statement = program.statements[i];
      testLetStatement(statement, identifiers[i]);
    }
  });

  test("test return statements", () {
    String input = """
      return 5;
      return 10;
      return 993322;
   """;

    Parser parser = new Parser(new Lexer(input));
    Program program = parser.parseProgram();
    checkParserErrors(parser);

    expectNumStatements(program, 3);

    program.statements.forEach((statement) {
      expect(statement, new isInstanceOf<ReturnStatement>());
      expect(statement.tokenLiteral(), equals('return'));
    });
  });
}

void expectNumStatements(Program program, int expectedStatements) {
  expect(program.statements.length, equals(expectedStatements),
      reason:
          "program.statements does not contain $expectedStatements statements. got=${program
          .statements.length}");
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
