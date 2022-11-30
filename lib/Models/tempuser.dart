// To parse this JSON data, do
//
//     final tempUserDetails = tempUserDetailsFromJson(jsonString);

import 'dart:convert';

List<TempUserDetails> tempUserDetailsFromJson(String str) => List<TempUserDetails>.from(json.decode(str).map((x) => TempUserDetails.fromJson(x)));

String tempUserDetailsToJson(List<TempUserDetails> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TempUserDetails {
  TempUserDetails({
    this.id,
    this.ownerName,
    this.mobile,
    this.email,
    this.name,
    this.date,
    this.timing,
    this.user,
    this.pId,
    this.fId,
    this.fltId,
    this.rId,
    this.dId,
  });

  int ?id;
  String? ownerName;
  String? mobile;
  String? email;
  String? name;
  DateTime? date;
  String? timing;
  int? user;
  String? pId;
  String? fId;
  String ?fltId;
  String ?rId;
  String ?dId;

  factory TempUserDetails.fromJson(Map<String, dynamic> json) => TempUserDetails(
    id: json["id"],
    ownerName: json["owner_name"],
    mobile: json["mobile"].toString(),
    email: json["email"],
    name: json["name"],
    date: DateTime.parse(json["date"]),
    timing: json["timing"],
    user: json["user"],
    pId: json["p_id"].toString(),
    fId: json["f_id"].toString(),
    fltId: json["flt_id"].toString(),
    rId: json["r_id"].toString(),
    dId: json["d_id"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "owner_name": ownerName,
    "mobile": mobile,
    "email": email,
    "name": name,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "timing": timing,
    "user": user,
    "p_id": pId,
    "f_id": fId,
    "flt_id": fltId,
    "r_id": rId,
    "d_id": dId,
  };
}
