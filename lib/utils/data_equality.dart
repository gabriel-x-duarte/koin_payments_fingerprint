import 'dart:convert' as converter;

import 'package:equatable/equatable.dart';

abstract class DataEquality extends Equatable with AdditionalOperations {
  const DataEquality();
}

mixin AdditionalOperations on Equatable {
  dynamic copyWith();

  Map<String, dynamic> toMap();

  String toJson() {
    return converter.jsonEncode(
      toMap(),
    );
  }

  @override
  String toString() {
    return toJson();
  }
}
