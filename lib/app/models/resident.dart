// To parse this JSON data, do
//
//     final resident = residentFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:panduan/app/models/district.dart';
import 'package:panduan/app/models/subdistrict.dart';

Resident residentFromJson(dynamic data) => Resident.fromJson(data);

String residentToJson(Resident data) => json.encode(data.toJson());

class Resident extends Equatable {
  final String? nik;
  final String? fullName;
  final String? address;
  final String? phone;
  final String? rt;
  final String? rw;
  final District? district;
  final SubDistrict? subDistrict;

  const Resident({
    this.nik,
    this.fullName,
    this.address,
    this.phone,
    this.rt,
    this.rw,
    this.district,
    this.subDistrict,
  });

  @override
  List<Object?> get props => [
    nik,
    fullName,
    address,
    phone,
    rt,
    rw,
    district,
    subDistrict,
  ];

  factory Resident.fromJson(Map<String, dynamic> json) => Resident(
    nik: json["nik"],
    fullName: json["full_name"],
    address: json["address"],
    phone: json["phone"],
    rt: json["rt"],
    rw: json["rw"],
    district: json["district"] == null
        ? null
        : District.fromJson(json["district"]),
    subDistrict: json["sub_district"] == null
        ? null
        : SubDistrict.fromJson(json["sub_district"]),
  );

  Map<String, dynamic> toJson() => {
    "nik": nik,
    "full_name": fullName,
    "address": address,
    "phone": phone,
    "rt": rt,
    "rw": rw,
    "district": district?.toJson(),
    "sub_district": subDistrict?.toJson(),
  };
}
