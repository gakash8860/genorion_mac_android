// To parse this JSON data, do
//
//     final roomType = roomTypeFromJson(jsonString);

import 'dart:convert';

List<RoomType> roomTypeFromJson(String str) => List<RoomType>.from(json.decode(str).map((x) => RoomType.fromJson(x)));

String roomTypeToJson(List<RoomType> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RoomType {
    RoomType({
      required this.rId,
      required this.rName,
      required this.user,
      required this.fltId,
    });

    String rId;
    String rName;
    int user;
    String fltId;

    factory RoomType.fromJson(Map<String, dynamic> json) => RoomType(
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
