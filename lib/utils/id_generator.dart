import 'dart:math';

String idGenerator() {
  final rnd = Random();
  final id = rnd.nextInt(899999) + 100000;
  return id.toString();
}