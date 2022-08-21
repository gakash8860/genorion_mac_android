// To parse this JSON data, do
//
//     final subAccessFlat = subAccessFlatFromJson(jsonString);

import 'dart:convert';

List<SubAccessFlat> subAccessFlatFromJson(String str) => List<SubAccessFlat>.from(json.decode(str).map((x) => SubAccessFlat.fromJson(x)));

String subAccessFlatToJson(List<SubAccessFlat> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubAccessFlat {
    SubAccessFlat({
       required this.fltId,
       required this.fltName,
       required this.user,
       required this.fId,
    });

    String fltId;
    String fltName;
    int user;
    String fId;

    factory SubAccessFlat.fromJson(Map<String, dynamic> json) => SubAccessFlat(
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
