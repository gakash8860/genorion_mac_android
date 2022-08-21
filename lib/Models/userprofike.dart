// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) => UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
    UserProfile({
       required this.email,
       required this.firstName,
       required this.lastName,
    });

    String email;
    String firstName;
    String lastName;

    factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
    };
}
