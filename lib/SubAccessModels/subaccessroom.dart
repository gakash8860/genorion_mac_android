// To parse this JSON data, do
//
//     final subAccessRoom = subAccessRoomFromJson(jsonString);

import 'dart:convert';

List<SubAccessRoom> subAccessRoomFromJson(String str) => List<SubAccessRoom>.from(json.decode(str).map((x) => SubAccessRoom.fromJson(x)));

String subAccessRoomToJson(List<SubAccessRoom> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubAccessRoom {
    SubAccessRoom({
      required  this.rId,
      required  this.rName,
      required  this.user,
      required  this.fltId,
    });

    String rId;
    String rName;
    int user;
    String fltId;

    factory SubAccessRoom.fromJson(Map<String, dynamic> json) => SubAccessRoom(
        rId: json["r_id"].toString(),
        rName: json["r_name"],
        user: json["user"],
        fltId: json["flt_id"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "r_id": rId,
        "r_name": rName,
        "user": user,
        "flt_id": fltId,
    };
}
