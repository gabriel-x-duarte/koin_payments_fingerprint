import 'package:flutter_test/flutter_test.dart';

import 'package:koin_payments_fingerprint/koin_payments_fingerprint.dart';

void main() {
  test('Return device fingerprint', () async {
    final Fingerprint fingerprint =
        await KoinPaymentsFingerprint.getDeviceFingerprint();

    print(fingerprint.toString());
  });
}
