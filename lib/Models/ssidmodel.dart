// To parse this JSON data, do
//
//     final ssidModel = ssidModelFromJson(jsonString);

import 'dart:convert';

SsidModel ssidModelFromJson(String str) => SsidModel.fromJson(json.decode(str));

String ssidModelToJson(SsidModel data) => json.encode(data.toJson());

class SsidModel {
    SsidModel({
        this.dId,
        this.ssid1,
        this.password1,
        this.ssid2,
        this.password2,
        this.ssid3,
        this.password3,
    });

    String? dId;
    String? ssid1;
    String? password1;
    String? ssid2;
    String? password2;
    String ?ssid3;
    String? password3;

    factory SsidModel.fromJson(Map<String, dynamic> json) => SsidModel(
        dId: json["d_id"],
        ssid1: json["ssid1"],
        password1: json["password1"],
        ssid2: json["ssid2"],
        password2: json["password2"],
        ssid3: json["ssid3"],
        password3: json["password3"],
    );

    Map<String, dynamic> toJson() => {
        "d_id": dId,
        "ssid1": ssid1,
        "password1": password1,
        "ssid2": ssid2,
        "password2": password2,
        "ssid3": ssid3,
        "password3": password3,
    };
}
