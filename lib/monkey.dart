library monkeylang;

int sameNumber(int i) {
  return i;
}

void printHello(int i) {
  print('hello ${sameNumber(i + 1)}');
}

void main() {
  for (int i = 0; i < 5; i++) {
    printHello(i);
  }
}
