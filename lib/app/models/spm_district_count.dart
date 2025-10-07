// To parse this JSON data, do
//
//     final spmDistrictCount = spmDistrictCountFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

SpmDistrictCount spmDistrictCountFromJson(dynamic data) =>
    SpmDistrictCount.fromJson(data);

String spmDistrictCountToJson(SpmDistrictCount data) =>
    json.encode(data.toJson());

List<SpmDistrictCount> listSpmDistrictCountFromJson(dynamic data) =>
    data.map<SpmDistrictCount>((x) => SpmDistrictCount.fromJson(x)).toList();

String listSpmDistrictCountToJson(List<SpmDistrictCount> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SpmDistrictCount extends Equatable {
  final String? district;
  final String? code;
  final int? pendidikan;
  final int? kesehatan;
  final int? pekerjaanUmum;
  final int? perumahanRakyat;
  final int? trantibumLinmas;
  final int? sosial;
  final int? total;

  const SpmDistrictCount({
    this.district,
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
    district,
    code,
    pendidikan,
    kesehatan,
    pekerjaanUmum,
    perumahanRakyat,
    trantibumLinmas,
    sosial,
    total,
  ];

  factory SpmDistrictCount.fromJson(Map<String, dynamic> json) =>
      SpmDistrictCount(
        district: json["district"],
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
    "district": district,
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
