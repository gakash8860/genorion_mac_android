// To parse this JSON data, do
//
//     final tempUserDetails = tempUserDetailsFromJson(jsonString);

import 'dart:convert';

List<TempUserDetails> tempUserDetailsFromJson(String str) => List<TempUserDetails>.from(json.decode(str).map((x) => TempUserDetails.fromJson(x)));

String tempUserDetailsToJson(List<TempUserDetails> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TempUserDetails {
    TempUserDetails({
       required this.id,
       required this.ownerName,
       required this.mobile,
       required this.email,
       required this.name,
       required this.date,
       required this.timing,
       required this.user,
       required this.pId,
       required this.fId,
       required this.fltId,
       required this.rId,
       required this.dId,
    });

    int id;
    String ownerName;
    String mobile;
    String email;
    String name;
    DateTime date;
    String timing;
    int user;
    dynamic pId;
    dynamic fId;
    dynamic fltId;
    dynamic rId;
    dynamic dId;

    factory TempUserDetails.fromJson(Map<String, dynamic> json) => TempUserDetails(
        id: json["id"],
        ownerName: json["owner_name"],
        mobile: json["mobile"].toString(),
        email: json["email"],
        name: json["name"],
        date: DateTime.parse(json["date"]),
        timing: json["timing"],
        user: json["user"],
        pId: json["p_id"],
        fId: json["f_id"],
        fltId: json["flt_id"],
        rId: json["r_id"],
        dId: json["d_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "owner_name": ownerName,
        "mobile": mobile,
        "email": email,
        "name": name,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "timing": timing,
        "user": user,
        "p_id": pId,
        "f_id": fId,
        "flt_id": fltId,
        "r_id": rId,
        "d_id": dId,
    };
}
