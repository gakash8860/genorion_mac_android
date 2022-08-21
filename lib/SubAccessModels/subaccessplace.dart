// To parse this JSON data, do
//
//     final subAccessPlace = subAccessPlaceFromJson(jsonString);

import 'dart:convert';

List<SubAccessPlace> subAccessPlaceFromJson(String str) => List<SubAccessPlace>.from(json.decode(str).map((x) => SubAccessPlace.fromJson(x)));

String subAccessPlaceToJson(List<SubAccessPlace> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubAccessPlace {
    SubAccessPlace({
       required this.pType,
       required this.pId,
    });

    String pType;
    dynamic pId;

    factory SubAccessPlace.fromJson(Map<String, dynamic> json) => SubAccessPlace(
        pType: json["p_type"],
        pId: json["p_id"],
    );

    Map<String, dynamic> toJson() => {
        "p_type": pType,
        "p_id": pId,
    };
}
