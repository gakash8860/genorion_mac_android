// To parse this JSON data, do
//
//     final subAccessDevice = subAccessDeviceFromJson(jsonString);

import 'dart:convert';

List<SubAccessDevice> subAccessDeviceFromJson(String str) => List<SubAccessDevice>.from(json.decode(str).map((x) => SubAccessDevice.fromJson(x)));

String subAccessDeviceToJson(List<SubAccessDevice> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubAccessDevice {
    SubAccessDevice({
      required  this.id,
      required  this.dateInstalled,
      required  this.user,
      required  this.rId,
      required  this.dId,
    });

    int id;
    DateTime dateInstalled;
    int user;
    String rId;
    String dId;

    factory SubAccessDevice.fromJson(Map<String, dynamic> json) => SubAccessDevice(
        id: json["id"],
        dateInstalled: DateTime.parse(json["date_installed"]),
        user: json["user"],
        rId: json["r_id"].toString(),
        dId: json["d_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date_installed": "${dateInstalled.year.toString().padLeft(4, '0')}-${dateInstalled.month.toString().padLeft(2, '0')}-${dateInstalled.day.toString().padLeft(2, '0')}",
        "user": user,
        "r_id": rId,
        "d_id": dId,
    };
}
