// To parse this JSON data, do
//
//     final customException = customExceptionFromJson(jsonString);

import 'dart:convert';

CustomException customExceptionFromJson(String str) => CustomException.fromJson(json.decode(str));

String customExceptionToJson(CustomException data) => json.encode(data.toJson());

class CustomException {
  CustomException({
    this.dId,
  });

  List<String>? dId;

  factory CustomException.fromJson(Map<String, dynamic> json) => CustomException(
    dId: List<String>.from(json["d_id"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "d_id": List<dynamic>.from(dId!.map((x) => x)),
  };
}
