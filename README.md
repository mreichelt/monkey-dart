# Writing an Interpreter for the Monkey 🐒 Language in Dart

[![Build Status](https://travis-ci.org/mreichelt/monkey-dart.svg?branch=master)](https://travis-ci.org/mreichelt/monkey-dart)

A fully working interpreter for the Monkey programming language as known from the book [Writing an Interpreter in Go](https://interpreterbook.com/), written in [Dart](https://www.dartlang.org/).

### Install Monkey and start the REPL

With one command, you can install the `monkey` binary:
```sh
$ pub global activate monkey_lang
Downloading monkey_lang 0.9.1...
[...]
Installed executable monkey.
```

Now you can run `monkey` from anywhere you want!

```
$ monkey
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

Go ahead and have fun with Monkey!
