# Writing an Interpreter in Dart

[![Build Status](https://travis-ci.org/mreichelt/monkey-dart.svg?branch=master)](https://travis-ci.org/mreichelt/monkey-dart)

A fully working interpreter for the Monkey programming language as known from the book [Writing an Interpreter in Go](https://interpreterbook.com/), written in [Dart](https://www.dartlang.org/).

Before you start, get the dependencies:

```sh
$ pub get
Resolving dependencies...
[...]
```

### Go ahead and start the REPL

```
$ dart lib/repl/repl.dart
Hello! This is the Monkey programming language!
Feel free to type in commands
>> let answer = fn(){ 6*7; };
>> answer()
42
```

### Run the test suite

```sh
$ pub run test
[...]
00:00 +42: All tests passed! 
```

### Format + analyze the code

```sh
$ ./dartformat_analyze.sh
Formatting directory lib/:
[...]
Formatting directory test/:
[...]
Analyzing [.]...
No issues found
```

### TODOs

- Tell the world about how awesome the book is!
- Create Dart library so every Dart developer can import the Monkey language
- Surprise…
