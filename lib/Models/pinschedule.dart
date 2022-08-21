// To parse this JSON data, do
//
//     final scheduledPin = scheduledPinFromJson(jsonString);

// ignore_for_file: prefer_if_null_operators

import 'dart:convert';

List<ScheduledPin> scheduledPinFromJson(String str) => List<ScheduledPin>.from(json.decode(str).map((x) => ScheduledPin.fromJson(x)));

String scheduledPinToJson(List<ScheduledPin> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ScheduledPin {
    ScheduledPin({
      required  this.id,
      required  this.date1,
      required  this.timing1,
      required  this.pin1Status,
      required  this.pin2Status,
      required  this.pin3Status,
      required  this.pin4Status,
      required  this.pin5Status,
      required  this.pin6Status,
      required  this.pin7Status,
      required  this.pin8Status,
      required  this.pin9Status,
      required  this.pin10Status,
      required  this.pin11Status,
      required  this.pin12Status,
      required  this.pin13Status,
      required  this.pin14Status,
      required  this.pin15Status,
      required  this.pin16Status,
      required  this.pin17Status,
      required  this.pin18Status,
      required  this.pin19Status,
      required  this.pin20Status,
      required  this.user,
      required  this.dId,
    });

    int id;
    DateTime date1;
    String timing1;
    int ?pin1Status;
    int ?pin2Status;
    int ?pin3Status;
    int ?pin4Status;
    int ?pin5Status;
    int ?pin6Status;
    int ?pin7Status;
    int ?pin8Status;
    int ?pin9Status;
    int ?pin10Status;
    int ?pin11Status;
    int ?pin12Status;
    int ?pin13Status;
    int ?pin14Status;
    int ?pin15Status;
    int ?pin16Status;
    int ?pin17Status;
    int ?pin18Status;
    dynamic pin19Status;
    dynamic pin20Status;
    int user;
    String dId;

    factory ScheduledPin.fromJson(Map<String, dynamic> json) => ScheduledPin(
        id: json["id"],
        date1: DateTime.parse(json["date1"]),
        timing1: json["timing1"],
        pin1Status: json["pin1Status"] == null ? null : json["pin1Status"],
        pin2Status: json["pin2Status"] == null ? null : json["pin2Status"],
        pin3Status: json["pin3Status"] == null ? null : json["pin3Status"],
        pin4Status: json["pin4Status"] == null ? null : json["pin4Status"],
        pin5Status: json["pin5Status"] == null ? null : json["pin5Status"],
        pin6Status: json["pin6Status"] == null ? null : json["pin6Status"],
        pin7Status: json["pin7Status"] == null ? null : json["pin7Status"],
        pin8Status: json["pin8Status"] == null ? null : json["pin8Status"],
        pin9Status: json["pin9Status"] == null ? null : json["pin9Status"],
        pin10Status: json["pin10Status"] == null ? null : json["pin10Status"],
        pin11Status: json["pin11Status"] == null ? null : json["pin11Status"],
        pin12Status: json["pin12Status"] == null ? null : json["pin12Status"],
        pin13Status: json["pin13Status"] == null ? null : json["pin13Status"],
        pin14Status: json["pin14Status"] == null ? null : json["pin14Status"],
        pin15Status: json["pin15Status"] == null ? null : json["pin15Status"],
        pin16Status: json["pin16Status"] == null ? null : json["pin16Status"],
        pin17Status: json["pin17Status"] == null ? null : json["pin17Status"],
        pin18Status: json["pin18Status"] == null ? null : json["pin18Status"],
        pin19Status: json["pin19Status"],
        pin20Status: json["pin20Status"],
        user: json["user"],
        dId: json["d_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date1": "${date1.year.toString().padLeft(4, '0')}-${date1.month.toString().padLeft(2, '0')}-${date1.day.toString().padLeft(2, '0')}",
        "timing1": timing1,
        "pin1Status": pin1Status == null ? null : pin1Status,
        "pin2Status": pin2Status == null ? null : pin2Status,
        "pin3Status": pin3Status == null ? null : pin3Status,
        "pin4Status": pin4Status == null ? null : pin4Status,
        "pin5Status": pin5Status == null ? null : pin5Status,
        "pin6Status": pin6Status == null ? null : pin6Status,
        "pin7Status": pin7Status == null ? null : pin7Status,
        "pin8Status": pin8Status == null ? null : pin8Status,
        "pin9Status": pin9Status == null ? null : pin9Status,
        "pin10Status": pin10Status == null ? null : pin10Status,
        "pin11Status": pin11Status == null ? null : pin11Status,
        "pin12Status": pin12Status == null ? null : pin12Status,
        "pin13Status": pin13Status == null ? null : pin13Status,
        "pin14Status": pin14Status == null ? null : pin14Status,
        "pin15Status": pin15Status == null ? null : pin15Status,
        "pin16Status": pin16Status == null ? null : pin16Status,
        "pin17Status": pin17Status == null ? null : pin17Status,
        "pin18Status": pin18Status == null ? null : pin18Status,
        "pin19Status": pin19Status,
        "pin20Status": pin20Status,
        "user": user,
        "d_id": dId,
    };
}
