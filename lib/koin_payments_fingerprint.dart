library koin_payments_fingerprint;

import 'utils/data_equality.dart';

part "./models/fingerprint.dart";

/// Abstract helper class
abstract class KoinPaymentsFingerprint {
  /// Returns sandbox URL
  static const String sandboxUrl =
      "https://api-sandbox.koin.com.br/fingerprint/session/mobile";

  /// Returns production URL
  static const String productionUrl = ""; // TODO:

  /// Returns device fingerprint
  static Fingerprint fingerprint({
    required String organizationId,
    required String sessionId,
    required MobileApplication mobileApplication,
  }) =>
      Fingerprint(
        organizationId: organizationId,
        sessionId: sessionId,
        mobileApplication: mobileApplication,
      );
}
