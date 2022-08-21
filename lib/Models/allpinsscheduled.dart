// To parse this JSON data, do
//
//     final allPinScheduled = allPinScheduledFromJson(jsonString);

import 'dart:convert';

List<AllPinScheduled> allPinScheduledFromJson(String str) => List<AllPinScheduled>.from(json.decode(str).map((x) => AllPinScheduled.fromJson(x)));

String allPinScheduledToJson(List<AllPinScheduled> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllPinScheduled {
    AllPinScheduled({
        this.id,
        this.date1,
        this.timing1,
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
        this.user,
        this.dId,
    });

    int ?id;
    DateTime? date1;
    String? timing1;
    dynamic pin1Status;
    dynamic pin2Status;
    dynamic pin3Status;
    dynamic pin4Status;
    dynamic pin5Status;
    dynamic pin6Status;
    dynamic pin7Status;
    dynamic pin8Status;
    dynamic pin9Status;
    dynamic pin10Status;
    dynamic pin11Status;
    dynamic pin12Status;
    dynamic pin13Status;
    dynamic pin14Status;
    dynamic pin15Status;
    dynamic pin16Status;
    dynamic pin17Status;
    dynamic pin18Status;
    dynamic pin19Status;
    dynamic pin20Status;
    int? user;
    String ?dId;

    factory AllPinScheduled.fromJson(Map<String, dynamic> json) => AllPinScheduled(
        id: json["id"],
        date1: DateTime.parse(json["date1"]),
        timing1: json["timing1"],
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
        user: json["user"],
        dId: json["d_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date1": "${date1!.year.toString().padLeft(4, '0')}-${date1!.month.toString().padLeft(2, '0')}-${date1!.day.toString().padLeft(2, '0')}",
        "timing1": timing1,
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
        "user": user,
        "d_id": dId,
    };
}
