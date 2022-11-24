// To parse this JSON data, do
//
//     final devicePinStatus = devicePinStatusFromJson(jsonString);

import 'dart:convert';

DevicePinStatus devicePinStatusFromJson(String str) => DevicePinStatus.fromJson(json.decode(str));

String devicePinStatusToJson(DevicePinStatus data) => json.encode(data.toJson());

class DevicePinStatus {
  DevicePinStatus({
    this.dId,
    this.pin1Status,
    this.pin2Status,
    this.pin3Status,
    this.pin4Status,
    this.pin5Status,
    this.pin6Status,
    this.pin7Status,
    this.pin8Status,
    this.pin9Status,
    this.pin10Status,
    this.pin11Status,
    this.pin12Status,
    this.pin13Status,
    this.pin14Status,
    this.pin15Status,
    this.pin16Status,
    this.pin17Status,
    this.pin18Status,
    this.pin19Status,
    this.pin20Status,
    this.sensor1,
    this.sensor2,
    this.sensor3,
    this.sensor4,
    this.sensor5,
    this.sensor6,
    this.sensor7,
    this.sensor8,
    this.sensor9,
    this.sensor10,
  });

  String ?dId;
  int? pin1Status;
  int? pin2Status;
  int? pin3Status;
  int? pin4Status;
  int? pin5Status;
  int? pin6Status;
  int? pin7Status;
  int? pin8Status;
  int? pin9Status;
  int? pin10Status;
  int? pin11Status;
  int? pin12Status;
  int? pin13Status;
  int? pin14Status;
  int? pin15Status;
  int? pin16Status;
  int? pin17Status;
  int? pin18Status;
  int? pin19Status;
  int? pin20Status;
  double? sensor1;
  double? sensor2;
  double? sensor3;
  double? sensor4;
  double? sensor5;
  double? sensor6;
  double? sensor7;
  double? sensor8;
  double? sensor9;
  double? sensor10;

  factory DevicePinStatus.fromJson(Map<String, dynamic> json) => DevicePinStatus(
    dId: json["d_id"],
    pin1Status: json["pin1Status"],
    pin2Status: json["pin2Status"],
    pin3Status: json["pin3Status"],
    pin4Status: json["pin4Status"],
    pin5Status: json["pin5Status"],
    pin6Status: json["pin6Status"],
    pin7Status: json["pin7Status"],
    pin8Status: json["pin8Status"],
    pin9Status: json["pin9Status"],
    pin10Status: json["pin10Status"],
    pin11Status: json["pin11Status"],
    pin12Status: json["pin12Status"],
    pin13Status: json["pin13Status"],
    pin14Status: json["pin14Status"],
    pin15Status: json["pin15Status"],
    pin16Status: json["pin16Status"],
    pin17Status: json["pin17Status"],
    pin18Status: json["pin18Status"],
    pin19Status: json["pin19Status"],
    pin20Status: json["pin20Status"],
    sensor1: json["sensor1"],
    sensor2: json["sensor2"],
    sensor3: json["sensor3"],
    sensor4: json["sensor4"],
    sensor5: json["sensor5"],
    sensor6: json["sensor6"],
    sensor7: json["sensor7"],
    sensor8: json["sensor8"],
    sensor9: json["sensor9"],
    sensor10: json["sensor10"],
  );

  Map<String, dynamic> toJson() => {
    "d_id": dId,
    "pin1Status": pin1Status,
    "pin2Status": pin2Status,
    "pin3Status": pin3Status,
    "pin4Status": pin4Status,
    "pin5Status": pin5Status,
    "pin6Status": pin6Status,
    "pin7Status": pin7Status,
    "pin8Status": pin8Status,
    "pin9Status": pin9Status,
    "pin10Status": pin10Status,
    "pin11Status": pin11Status,
    "pin12Status": pin12Status,
    "pin13Status": pin13Status,
    "pin14Status": pin14Status,
    "pin15Status": pin15Status,
    "pin16Status": pin16Status,
    "pin17Status": pin17Status,
    "pin18Status": pin18Status,
    "pin19Status": pin19Status,
    "pin20Status": pin20Status,
    "sensor1": sensor1,
    "sensor2": sensor2,
    "sensor3": sensor3,
    "sensor4": sensor4,
    "sensor5": sensor5,
    "sensor6": sensor6,
    "sensor7": sensor7,
    "sensor8": sensor8,
    "sensor9": sensor9,
    "sensor10": sensor10,
  };
}
