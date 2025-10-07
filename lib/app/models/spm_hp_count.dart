// To parse this JSON data, do
//
//     final spmHpCount = spmHpCountFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

SpmHpCount spmHpCountFromJson(dynamic data) => SpmHpCount.fromJson(data);

String spmHpCountToJson(SpmHpCount data) => json.encode(data.toJson());

List<SpmHpCount> listSpmHpCountFromJson(dynamic data) =>
    data.map<SpmHpCount>((x) => SpmHpCount.fromJson(x)).toList();

String listSpmHpCountToJson(List<SpmHpCount> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SpmHpCount extends Equatable {
  final String? healthPost;
  final int? pendidikan;
  final int? kesehatan;
  final int? pekerjaanUmum;
  final int? perumahanRakyat;
  final int? trantibumLinmas;
  final int? sosial;
  final int? total;

  const SpmHpCount({
    this.healthPost,
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
    healthPost,
    pendidikan,
    kesehatan,
    pekerjaanUmum,
    perumahanRakyat,
    trantibumLinmas,
    sosial,
    total,
  ];

  factory SpmHpCount.fromJson(Map<String, dynamic> json) => SpmHpCount(
    healthPost: json["health_post"],
    pendidikan: json["pendidikan"],
    kesehatan: json["kesehatan"],
    pekerjaanUmum: json["pekerjaan_umum"],
    perumahanRakyat: json["perumahan_rakyat"],
    trantibumLinmas: json["trantibum_linmas"],
    sosial: json["sosial"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "health_post": healthPost,
    "pendidikan": pendidikan,
    "kesehatan": kesehatan,
    "pekerjaan_umum": pekerjaanUmum,
    "perumahan_rakyat": perumahanRakyat,
    "trantibum_linmas": trantibumLinmas,
    "sosial": sosial,
    "total": total,
  };
}
