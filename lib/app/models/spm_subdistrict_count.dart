// To parse this JSON data, do
//
//     final spmDistrictCount = spmDistrictCountFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

SpmSubDistrictCount spmSubDistrictCountFromJson(dynamic data) =>
    SpmSubDistrictCount.fromJson(data);

String spmSubDistrictCountToJson(SpmSubDistrictCount data) =>
    json.encode(data.toJson());

List<SpmSubDistrictCount> listSpmSubDistrictCountFromJson(dynamic data) => data
    .map<SpmSubDistrictCount>((x) => SpmSubDistrictCount.fromJson(x))
    .toList();

String listSpmSubDistrictCountToJson(List<SpmSubDistrictCount> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SpmSubDistrictCount extends Equatable {
  final String? subDistrict;
  final String? code;
  final int? pendidikan;
  final int? kesehatan;
  final int? pekerjaanUmum;
  final int? perumahanRakyat;
  final int? trantibumLinmas;
  final int? sosial;
  final int? total;

  const SpmSubDistrictCount({
    this.subDistrict,
    this.code,
    this.pendidikan,
    this.kesehatan,
    this.pekerjaanUmum,
    this.perumahanRakyat,
    this.trantibumLinmas,
    this.sosial,
    this.total,
  });

  @override
  List<Object?> get props => [
    subDistrict,
    code,
    pendidikan,
    kesehatan,
    pekerjaanUmum,
    perumahanRakyat,
    trantibumLinmas,
    sosial,
    total,
  ];

  factory SpmSubDistrictCount.fromJson(Map<String, dynamic> json) =>
      SpmSubDistrictCount(
        subDistrict: json["sub_district"],
        code: json["code"],
        pendidikan: json["pendidikan"],
        kesehatan: json["kesehatan"],
        pekerjaanUmum: json["pekerjaan_umum"],
        perumahanRakyat: json["perumahan_rakyat"],
        trantibumLinmas: json["trantibum_linmas"],
        sosial: json["sosial"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
    "sub_district": subDistrict,
    "code": code,
    "pendidikan": pendidikan,
    "kesehatan": kesehatan,
    "pekerjaan_umum": pekerjaanUmum,
    "perumahan_rakyat": perumahanRakyat,
    "trantibum_linmas": trantibumLinmas,
    "sosial": sosial,
    "total": total,
  };
}
