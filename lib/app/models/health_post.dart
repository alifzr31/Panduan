// To parse this JSON data, do
//
//     final healthPost = healthPostFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

HealthPost healthPostFromJson(dynamic data) => HealthPost.fromJson(data);

String healthPostToJson(HealthPost data) => json.encode(data.toJson());

List<HealthPost> listHealthPostFromJson(dynamic data) =>
    data.map<HealthPost>((x) => HealthPost.fromJson(x)).toList();

String listHealthPostToJson(List<HealthPost> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HealthPost extends Equatable {
  final int? id;
  final String? uuid;
  final String? name;
  final String? code;
  final String? districtCode;
  final String? districtName;
  final String? subDistrictCode;
  final String? subDistrictName;
  final String? address;
  final bool? isActive;
  final DateTime? createdAt;

  const HealthPost({
    this.id,
    this.uuid,
    this.name,
    this.code,
    this.districtCode,
    this.districtName,
    this.subDistrictCode,
    this.subDistrictName,
    this.address,
    this.isActive,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    uuid,
    name,
    code,
    districtCode,
    districtName,
    subDistrictCode,
    subDistrictName,
    address,
    isActive,
    createdAt,
  ];

  factory HealthPost.fromJson(Map<String, dynamic> json) => HealthPost(
    id: json["id"],
    uuid: json["uuid"],
    name: json["name"],
    code: json["code"],
    districtCode: json["district_code"],
    districtName: json["district_name"],
    subDistrictCode: json["sub_district_code"],
    subDistrictName: json["sub_district_name"],
    address: json["address"],
    isActive: json["is_active"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "name": name,
    "code": code,
    "district_code": districtCode,
    "sub_district_code": subDistrictCode,
    "address": address,
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
  };
}
