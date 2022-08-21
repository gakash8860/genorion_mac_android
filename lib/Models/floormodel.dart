// To parse this JSON data, do
//
//     final floorType = floorTypeFromJson(jsonString);

import 'dart:convert';

List<FloorType> floorTypeFromJson(String str) => List<FloorType>.from(json.decode(str).map((x) => FloorType.fromJson(x)));

String floorTypeToJson(List<FloorType> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FloorType {
    FloorType({
      required this.fId,
      required this.fName,
      required this.user,
      required this.pId,
    });

    String fId;
    String fName;
    int user;
    String pId;

    factory FloorType.fromJson(Map<String, dynamic> json) => FloorType(
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
