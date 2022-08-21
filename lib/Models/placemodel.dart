// To parse this JSON data, do
//
//     final placeType = placeTypeFromJson(jsonString);

import 'dart:convert';

List<PlaceType> placeTypeFromJson(String str) => List<PlaceType>.from(json.decode(str).map((x) => PlaceType.fromJson(x)));

String placeTypeToJson(List<PlaceType> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlaceType {
    PlaceType({
       required this.pId,
       required this.pType,
       required this.user,
    });

    String pId;
    String pType;
    int user;

    factory PlaceType.fromJson(Map<String, dynamic> json) => PlaceType(
        pId: json["p_id"].toString(),
        pType: json["p_type"],
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "p_id": pId,
        "p_type": pType,
        "user": user,
    };
}
