// To parse this JSON data, do
//
//     final subDistrict = subDistrictFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

SubDistrict subDistrictFromJson(dynamic data) => SubDistrict.fromJson(data);

String subDistrictToJson(SubDistrict data) => json.encode(data.toJson());

List<SubDistrict> listSubDistrictFromJson(dynamic data) =>
    data.map<SubDistrict>((x) => SubDistrict.fromJson(x)).toList();

String listSubDistrictToJson(List<SubDistrict> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubDistrict extends Equatable {
  final String? code;
  final String? provinceCode;
  final String? cityCode;
  final String? districtCode;
  final String? subDistrictCode;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SubDistrict({
    this.code,
    this.provinceCode,
    this.cityCode,
    this.districtCode,
    this.subDistrictCode,
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
    subDistrictCode,
    name,
    createdAt,
    updatedAt,
  ];

  factory SubDistrict.fromJson(Map<String, dynamic> json) => SubDistrict(
    code: json["code"],
    provinceCode: json["province_code"],
    cityCode: json["city_code"],
    districtCode: json["district_code"],
    subDistrictCode: json["sub_district_code"],
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
    "sub_district_code": subDistrictCode,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
