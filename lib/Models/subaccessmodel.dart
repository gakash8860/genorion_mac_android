// To parse this JSON data, do
//
//     final subAccessModel = subAccessModelFromJson(jsonString);

import 'dart:convert';

List<SubAccessModel> subAccessModelFromJson(String str) => List<SubAccessModel>.from(json.decode(str).map((x) => SubAccessModel.fromJson(x)));

String subAccessModelToJson(List<SubAccessModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubAccessModel {
    SubAccessModel({
       required this.id,
       required this.ownerName,
       required this.name,
       required this.user,
       required this.email,
       required this.pId,
    });

    int id;
    String ownerName;
    String name;
    int user;
    String email;
    dynamic pId;

    factory SubAccessModel.fromJson(Map<String, dynamic> json) => SubAccessModel(
        id: json["id"],
        ownerName: json["owner_name"],
        name: json["name"],
        user: json["user"],
        email: json["email"],
        pId: json["p_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "owner_name": ownerName,
        "name": name,
        "user": user,
        "email": email,
        "p_id": pId,
    };
}
