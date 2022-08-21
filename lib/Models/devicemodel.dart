// To parse this JSON data, do
//
//     final deviceType = deviceTypeFromJson(jsonString);

import 'dart:convert';

List<DeviceType> deviceTypeFromJson(String str) => List<DeviceType>.from(json.decode(str).map((x) => DeviceType.fromJson(x)));

String deviceTypeToJson(List<DeviceType> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeviceType {
    DeviceType({
      required this.id,
      required this.dateInstalled,
      required this.user,
      required this.rId,
      required this.dId,
    });

    int id;
    DateTime dateInstalled;
    int user;
    String rId;
    String dId;

    factory DeviceType.fromJson(Map<String, dynamic> json) => DeviceType(
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
