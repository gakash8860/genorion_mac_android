// To parse this JSON data, do
//
//     final photoModel = photoModelFromMap(jsonString);

import 'dart:convert';

PhotoModel photoModelFromMap(String str) => PhotoModel.fromMap(json.decode(str));

String photoModelToMap(PhotoModel data) => json.encode(data.toMap());

class PhotoModel {
    PhotoModel({
       required this.user,
        required this.file,
    });

    int user;
    String file;

    factory PhotoModel.fromMap(Map<String, dynamic> json) => PhotoModel(
        user: json["user"],
        file: json["file"],
    );

    Map<String, dynamic> toMap() => {
        "user": user,
        "file": file,
    };
}
