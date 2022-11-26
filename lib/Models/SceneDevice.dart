// To parse this JSON data, do
//
//     final sceneDevice = sceneDeviceFromJson(jsonString);

import 'dart:convert';

List<SceneDevice> sceneDeviceFromJson(String str) => List<SceneDevice>.from(json.decode(str).map((x) => SceneDevice.fromJson(x)));

String sceneDeviceToJson(List<SceneDevice> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SceneDevice {
  SceneDevice({
    this.scenedevicesId,
    this.sceneName,
    this.status1,
    this.status2,
    this.status3,
    this.status4,
    this.status5,
    this.status6,
    this.status7,
    this.status8,
    this.status9,
    this.status10,
    this.status11,
    this.status12,
    this.status13,
    this.status14,
    this.status15,
    this.status16,
    this.status17,
    this.status18,
    this.status19,
    this.status20,
    this.date,
    this.timing,
    this.sceneId,
    this.dId,
  });

  String? scenedevicesId;
  String? sceneName;
  int? status1;
  int? status2;
  int? status3;
  int? status4;
  int? status5;
  int? status6;
  int? status7;
  int? status8;
  int? status9;
  int? status10;
  int? status11;
  int? status12;
  int? status13;
  int? status14;
  int? status15;
  int? status16;
  int? status17;
  int? status18;
  int? status19;
  int? status20;
  DateTime? date;
  String? timing;
  String? sceneId;
  String? dId;

  factory SceneDevice.fromJson(Map<String, dynamic> json) => SceneDevice(
    scenedevicesId: json["scenedevices_id"],
    sceneName: json["sceneName"],
    status1: json["status1"],
    status2: json["status2"],
    status3: json["status3"],
    status4: json["status4"],
    status5: json["status5"],
    status6: json["status6"],
    status7: json["status7"],
    status8: json["status8"],
    status9: json["status9"],
    status10: json["status10"],
    status11: json["status11"],
    status12: json["status12"],
    status13: json["status13"],
    status14: json["status14"],
    status15: json["status15"],
    status16: json["status16"],
    status17: json["status17"],
    status18: json["status18"],
    status19: json["status19"],
    status20: json["status20"],
    date: DateTime.parse(json["date"]),
    timing: json["timing"],
    sceneId: json["scene_id"],
    dId: json["d_id"],
  );

  Map<String, dynamic> toJson() => {
    "scenedevices_id": scenedevicesId,
    "sceneName": sceneName,
    "status1": status1,
    "status2": status2,
    "status3": status3,
    "status4": status4,
    "status5": status5,
    "status6": status6,
    "status7": status7,
    "status8": status8,
    "status9": status9,
    "status10": status10,
    "status11": status11,
    "status12": status12,
    "status13": status13,
    "status14": status14,
    "status15": status15,
    "status16": status16,
    "status17": status17,
    "status18": status18,
    "status19": status19,
    "status20": status20,
    "date": "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
    "timing": timing,
    "scene_id": sceneId,
    "d_id": dId,
  };
}
