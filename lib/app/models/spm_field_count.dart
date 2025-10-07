// To parse this JSON data, do
//
//     final district = districtFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

SpmFieldCount spmFieldCountFromJson(dynamic data) =>
    SpmFieldCount.fromJson(data);

String spmFieldCountToJson(SpmFieldCount data) => json.encode(data.toJson());

class SpmFieldCount extends Equatable {
  final DateTime? date;
  final int? pendidikan;
  final int? kesehatan;
  final int? pekerjaanUmum;
  final int? perumahanRakyat;
  final int? trantibumLinmas;
  final int? sosial;
  final int? total;

  const SpmFieldCount({
    this.date,
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
    date,
    pendidikan,
    kesehatan,
    pekerjaanUmum,
    perumahanRakyat,
    trantibumLinmas,
    sosial,
    total,
  ];

  factory SpmFieldCount.fromJson(Map<String, dynamic> json) => SpmFieldCount(
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    pendidikan: json["pendidikan"],
    kesehatan: json["kesehatan"],
    pekerjaanUmum: json["pekerjaan_umum"],
    perumahanRakyat: json["perumahan_rakyat"],
    trantibumLinmas: json["trantibum_linmas"],
    sosial: json["sosial"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "date": date?.toIso8601String(),
    "pendidikan": pendidikan,
    "kesehatan": kesehatan,
    "pekerjaan_umum": pekerjaanUmum,
    "perumahan_rakyat": perumahanRakyat,
    "trantibmum_linmas": trantibumLinmas,
    "sosial": sosial,
    "total": total,
  };
}
