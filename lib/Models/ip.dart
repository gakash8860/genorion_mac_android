// To parse this JSON data, do
//
//     final ipAddress = ipAddressFromJson(jsonString);

import 'dart:convert';

IpAddress ipAddressFromJson(String str) => IpAddress.fromJson(json.decode(str));

String ipAddressToJson(IpAddress data) => json.encode(data.toJson());

class IpAddress {
    IpAddress({
       required this.dId,
       required this.ipaddress,
    });

    String dId;
    String ipaddress;

    factory IpAddress.fromJson(Map<String, dynamic> json) => IpAddress(
        dId: json["d_id"],
        ipaddress: json["ipaddress"],
    );

    Map<String, dynamic> toJson() => {
        "d_id": dId,
        "ipaddress": ipaddress,
    };
}
