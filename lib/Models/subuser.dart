// To parse this JSON data, do
//
//     final subUserDetails = subUserDetailsFromJson(jsonString);

import 'dart:convert';

List<SubUserDetails> subUserDetailsFromJson(String str) => List<SubUserDetails>.from(json.decode(str).map((x) => SubUserDetails.fromJson(x)));

String subUserDetailsToJson(List<SubUserDetails> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubUserDetails {
    SubUserDetails({
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
    String pId;

    factory SubUserDetails.fromJson(Map<String, dynamic> json) => SubUserDetails(
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
