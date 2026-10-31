import 'package:collab_tasker/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('email validation accepts a valid address', () {
    expect(Validators.emailValidator('person@example.com'), isNull);
  });

  test('email validation rejects an invalid address', () {
    expect(Validators.emailValidator('invalid-email'), isNotNull);
  });
}