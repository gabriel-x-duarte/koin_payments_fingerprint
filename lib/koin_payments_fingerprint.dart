library koin_payments_fingerprint;

import 'utils/data_equality.dart';

part "./models/fingerprint.dart";

abstract class KoinPaymentsFingerprint {
  static Future<Fingerprint> getDeviceFingerprint() async =>
      await _gatherDeviceFingerprintInformation();

  static Future<Fingerprint> _gatherDeviceFingerprintInformation() async {
    return Fingerprint(
      organizationId: "organizationId",
      sessionId: "sessionId",
      mobileApplication: MobileApplication.fromMap(const {}),
    );
  }
}
