// To parse this JSON data, do
//
//     final flatType = flatTypeFromJson(jsonString);

import 'dart:convert';

List<FlatType> flatTypeFromJson(String str) => List<FlatType>.from(json.decode(str).map((x) => FlatType.fromJson(x)));

String flatTypeToJson(List<FlatType> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FlatType {
    FlatType({
      required this.fltId,
      required this.fltName,
      required this.user,
      required this.fId,
    });

    String fltId;
    String fltName;
    int user;
    String fId;

    factory FlatType.fromJson(Map<String, dynamic> json) => FlatType(
        fltId: json["flt_id"].toString(),
        fltName: json["flt_name"],
        user: json["user"],
        fId: json["f_id"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "flt_id": fltId,
        "flt_name": fltName,
        "user": user,
        "f_id": fId,
    };
}
