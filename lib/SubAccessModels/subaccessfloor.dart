// To parse this JSON data, do
//
//     final subAccessFloor = subAccessFloorFromJson(jsonString);

import 'dart:convert';

List<SubAccessFloor> subAccessFloorFromJson(String str) => List<SubAccessFloor>.from(json.decode(str).map((x) => SubAccessFloor.fromJson(x)));

String subAccessFloorToJson(List<SubAccessFloor> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubAccessFloor {
    SubAccessFloor({
       required this.fId,
       required this.fName,
       required this.user,
       required this.pId,
    });

    String fId;
    String fName;
    int user;
    String pId;

    factory SubAccessFloor.fromJson(Map<String, dynamic> json) => SubAccessFloor(
        fId: json["f_id"].toString(),
        fName: json["f_name"],
        user: json["user"],
        pId: json["p_id"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "f_id": fId,
        "f_name": fName,
        "user": user,
        "p_id": pId,
    };
}
