class Monkey {
  static const FACE = r"""            __,__
   .--.  .-"     "-.  .--.
  / .. \/  .-. .-.  \/ .. \
 | |  '|  /   Y   \  |'  | |
 | \   \  \ 0 | 0 /  /   / |
  \ '- ,\.-"""
      '"""""""'
      """-./, -' /
   ''-' /_   ^ ^   _\\ '-''
       |  \\._   _./  |
       \\   \\ '~' /   /
        '._ '-=-' _.'
           '-----'""";
  static const WELCOME = 'Hello! This is the Monkey programming language!\n'
      'Feel free to type in commands';

  static Function monkeyPrint = (Object object) {
    print(object);
  };
}
