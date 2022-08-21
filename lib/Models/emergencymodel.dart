// To parse this JSON data, do
//
//     final emergencyNumberModel = emergencyNumberModelFromJson(jsonString);

import 'dart:convert';

EmergencyNumberModel emergencyNumberModelFromJson(String str) => EmergencyNumberModel.fromJson(json.decode(str));

String emergencyNumberModelToJson(EmergencyNumberModel data) => json.encode(data.toJson());

class EmergencyNumberModel {
    EmergencyNumberModel({
        this.dId,
        this.number1,
        this.number2,
        this.number3,
        this.number4,
        this.number5,
        this.user,
    });

    String? dId;
    String? number1;
    String? number2;
    String? number3;
    String? number4;
    String? number5;
    int? user;

    factory EmergencyNumberModel.fromJson(Map<String, dynamic> json) => EmergencyNumberModel(
        dId: json["d_id"],
        number1: json["number1"],
        number2: json["number2"],
        number3: json["number3"],
        number4: json["number4"],
        number5: json["number5"],
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "d_id": dId,
        "number1": number1,
        "number2": number2,
        "number3": number3,
        "number4": number4,
        "number5": number5,
        "user": user,
    };
}
