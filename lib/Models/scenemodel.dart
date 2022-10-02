// To parse this JSON data, do
//
//     final sceneModel = sceneModelFromJson(jsonString);

import 'dart:convert';

List<SceneModel> sceneModelFromJson(String str) => List<SceneModel>.from(json.decode(str).map((x) => SceneModel.fromJson(x)));

String sceneModelToJson(List<SceneModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SceneModel {
  SceneModel({
    this.sceneId,
    this.sceneType,
    this.user,
  });

  String? sceneId;
  String ?sceneType;
  int ?user;

  factory SceneModel.fromJson(Map<String, dynamic> json) => SceneModel(
    sceneId: json["scene_id"],
    sceneType: json["scene_type"],
    user: json["user"],
  );

  Map<String, dynamic> toJson() => {
    "scene_id": sceneId,
    "scene_type": sceneType,
    "user": user,
  };
}
