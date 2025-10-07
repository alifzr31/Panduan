// To parse this JSON data, do
//
//     final district = districtFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

District districtFromJson(dynamic data) => District.fromJson(data);

String districtToJson(District data) => json.encode(data.toJson());

List<District> listDistrictFromJson(dynamic data) =>
    data.map<District>((x) => District.fromJson(x)).toList();

String listDistrictToJson(List<District> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class District extends Equatable {
  final String? code;
  final String? provinceCode;
  final String? cityCode;
  final String? districtCode;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const District({
    this.code,
    this.provinceCode,
    this.cityCode,
    this.districtCode,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    code,
    provinceCode,
    cityCode,
    districtCode,
    name,
    createdAt,
    updatedAt,
  ];

  factory District.fromJson(Map<String, dynamic> json) => District(
    code: json["code"],
    provinceCode: json["province_code"],
    cityCode: json["city_code"],
    districtCode: json["district_code"],
    name: json["name"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "province_code": provinceCode,
    "city_code": cityCode,
    "district_code": districtCode,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
