import 'dart:convert' as converter;

abstract class DataEquality extends AdditionalOperations {
  const DataEquality();
}

abstract class AdditionalOperations {
  const AdditionalOperations();

  dynamic copyWith();

  Map<String, dynamic> toMap();

  String toJson() {
    return converter.jsonEncode(
      toMap(),
    );
  }

  @override
  int get hashCode => toJson().hashCode;

  @override
  bool operator ==(covariant Object other) {
    if (other.hashCode == hashCode) {
      return true;
    }

    return false;
  }

  @override
  String toString() {
    return toJson();
  }
}
