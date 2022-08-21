// To parse this JSON data, do
//
//     final sensorData = sensorDataFromJson(jsonString);

import 'dart:convert';

SensorData sensorDataFromJson(String str) => SensorData.fromJson(json.decode(str));

String sensorDataToJson(SensorData data) => json.encode(data.toJson());

class SensorData {
    SensorData({
      required this.dId,
      required this.sensor1,
      required this.sensor2,
      required this.sensor3,
      required this.sensor4,
      required this.sensor5,
      required this.sensor6,
      required this.sensor7,
      required this.sensor8,
      required this.sensor9,
      required this.sensor10,
    });

    String dId;
    double sensor1;
    double sensor2;
    double sensor3;
    double sensor4;
    double sensor5;
    double sensor6;
    double sensor7;
    double sensor8;
    double sensor9;
    double sensor10;

    factory SensorData.fromJson(Map<String, dynamic> json) => SensorData(
        dId: json["d_id"],
        sensor1: json["sensor1"].toDouble(),
        sensor2: json["sensor2"].toDouble(),
        sensor3: json["sensor3"].toDouble(),
        sensor4: json["sensor4"].toDouble(),
        sensor5: json["sensor5"].toDouble(),
        sensor6: json["sensor6"].toDouble(),
        sensor7: json["sensor7"].toDouble(),
        sensor8: json["sensor8"].toDouble(),
        sensor9: json["sensor9"].toDouble(),
        sensor10: json["sensor10"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "d_id": dId,
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
