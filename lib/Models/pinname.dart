// To parse this JSON data, do
//
//     final devicePinName = devicePinNameFromJson(jsonString);

import 'dart:convert';

DevicePinName devicePinNameFromJson(String str) => DevicePinName.fromJson(json.decode(str));

String devicePinNameToJson(DevicePinName data) => json.encode(data.toJson());

class DevicePinName {
    DevicePinName({
      required this.dId,
      required this.pin1Name,
      required this.pin2Name,
      required this.pin3Name,
      required this.pin4Name,
      required this.pin5Name,
      required this.pin6Name,
      required this.pin7Name,
      required this.pin8Name,
      required this.pin9Name,
      required this.pin10Name,
      required this.pin11Name,
      required this.pin12Name,
        this.pin13Name,
        this.pin14Name,
        this.pin15Name,
        this.pin16Name,
        this.pin17Name,
        this.pin18Name,
        this.pin19Name,
        this.pin20Name, id,
    });

    String dId;
    String pin1Name;
    String pin2Name;
    String pin3Name;
    String pin4Name;
    String pin5Name;
    String pin6Name;
    String pin7Name;
    String pin8Name;
    String pin9Name;
    String pin10Name;
    String pin11Name;
    String pin12Name;
    dynamic pin13Name;
    dynamic pin14Name;
    dynamic pin15Name;
    dynamic pin16Name;
    dynamic pin17Name;
    dynamic pin18Name;
    dynamic pin19Name;
    dynamic pin20Name;

    factory DevicePinName.fromJson(Map<String, dynamic> json) => DevicePinName(
        dId: json["d_id"],
        pin1Name: json["pin1Name"],
        pin2Name: json["pin2Name"],
        pin3Name: json["pin3Name"],
        pin4Name: json["pin4Name"],
        pin5Name: json["pin5Name"],
        pin6Name: json["pin6Name"],
        pin7Name: json["pin7Name"],
        pin8Name: json["pin8Name"],
        pin9Name: json["pin9Name"],
        pin10Name: json["pin10Name"],
        pin11Name: json["pin11Name"],
        pin12Name: json["pin12Name"],
        pin13Name: json["pin13Name"],
        pin14Name: json["pin14Name"],
        pin15Name: json["pin15Name"],
        pin16Name: json["pin16Name"],
        pin17Name: json["pin17Name"],
        pin18Name: json["pin18Name"],
        pin19Name: json["pin19Name"],
        pin20Name: json["pin20Name"],
    );

    Map<String, dynamic> toJson() => {
        "d_id": dId,
        "pin1Name": pin1Name,
        "pin2Name": pin2Name,
        "pin3Name": pin3Name,
        "pin4Name": pin4Name,
        "pin5Name": pin5Name,
        "pin6Name": pin6Name,
        "pin7Name": pin7Name,
        "pin8Name": pin8Name,
        "pin9Name": pin9Name,
        "pin10Name": pin10Name,
        "pin11Name": pin11Name,
        "pin12Name": pin12Name,
        "pin13Name": pin13Name,
        "pin14Name": pin14Name,
        "pin15Name": pin15Name,
        "pin16Name": pin16Name,
        "pin17Name": pin17Name,
        "pin18Name": pin18Name,
        "pin19Name": pin19Name,
        "pin20Name": pin20Name,
    };
}
