const numberOfTries = 8;
Future<void> timeoutDelay(int i) async {
  await Future.delayed(Duration(milliseconds: _timeout[i]));
}

const _timeout = [
  200,
  400,
  800,
  1600,
  3200,
  6400,
  12800,
  25600,
  51200,
];
