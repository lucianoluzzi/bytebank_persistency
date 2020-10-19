import 'package:bytebank_persistency/models/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('When create transaction then should return the correct value', () {
    final transaction = Transaction(null, 200, null);
    expect(transaction.value, 200);
  });

  test('Given 0 value transaction, then should show error', () {
    expect(() => Transaction(null, 0, null), throwsAssertionError);
  });
}