// To parse this JSON data, do
//
//     final spm = spmFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:panduan/app/models/attachment.dart';
import 'package:panduan/app/models/district.dart';
import 'package:panduan/app/models/opd.dart';
import 'package:panduan/app/models/subdistrict.dart';

Spm spmFromJson(dynamic data) => Spm.fromJson(data);

String spmToJson(Spm data) => json.encode(data.toJson());

List<Spm> listSpmFromJson(dynamic data) =>
    data.map<Spm>((x) => Spm.fromJson(x)).toList();

String listSpmToJson(List<Spm> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Spm extends Equatable {
  final String? uuid;
  final DateTime? createdAt;
  final DateTime? date;
  final String? description;
  final String? type;
  final String? latitude;
  final String? longitude;
  final String? receiptNumber;
  final String? status;
  final User? user;
  final ActionBy? healthPost;
  final Opd? opd;
  final District? district;
  final District? subDistrict;
  final ActionBy? spmField;
  final ActionBy? serviceCategory;
  final ActionBy? createdBy;
  final List<Activity>? activity;
  final List<Attachment>? attachments;

  const Spm({
    this.uuid,
    this.createdAt,
    this.date,
    this.description,
    this.type,
    this.latitude,
    this.longitude,
    this.receiptNumber,
    this.status,
    this.user,
    this.healthPost,
    this.opd,
    this.district,
    this.subDistrict,
    this.spmField,
    this.serviceCategory,
    this.createdBy,
    this.activity,
    this.attachments,
  });

  @override
  List<Object?> get props => [
    uuid,
    createdAt,
    date,
    description,
    type,
    latitude,
    longitude,
    receiptNumber,
    status,
    user,
    healthPost,
    opd,
    district,
    subDistrict,
    spmField,
    serviceCategory,
    createdBy,
    activity,
    attachments,
  ];

  factory Spm.fromJson(Map<String, dynamic> json) => Spm(
    uuid: json["uuid"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    description: json["description"],
    type: json["type"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    receiptNumber: json["receipt_number"],
    status: json["status"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    healthPost: json["health_post"] == null
        ? null
        : ActionBy.fromJson(json["health_post"]),
    opd: json["opd"] == null ? null : Opd.fromJson(json["opd"]),
    district: json["district"] == null
        ? null
        : District.fromJson(json["district"]),
    subDistrict: json["sub_district"] == null
        ? null
        : District.fromJson(json["sub_district"]),
    spmField: json["spm_field"] == null
        ? null
        : ActionBy.fromJson(json["spm_field"]),
    serviceCategory: json["service_category"] == null
        ? null
        : ActionBy.fromJson(json["service_category"]),
    createdBy: json["created_by"] == null
        ? null
        : ActionBy.fromJson(json["created_by"]),
    activity: json["activity"] == null
        ? []
        : List<Activity>.from(
            json["activity"]!.map((x) => Activity.fromJson(x)),
          ),
    attachments: json["attachments"] == null
        ? []
        : List<Attachment>.from(
            json["attachments"]!.map((x) => Attachment.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "created_at": createdAt?.toIso8601String(),
    "date": date?.toIso8601String(),
    "description": description,
    "type": type,
    "latitude": latitude,
    "longitude": longitude,
    "receipt_number": receiptNumber,
    "status": status,
    "user": user?.toJson(),
    "health_post": healthPost?.toJson(),
    "opd": opd?.toJson(),
    "district": district?.toJson(),
    "sub_district": subDistrict?.toJson(),
    "spm_field": spmField?.toJson(),
    "service_category": serviceCategory?.toJson(),
    "created_by": createdBy?.toJson(),
    "activity": activity == null
        ? []
        : List<dynamic>.from(activity!.map((x) => x.toJson())),
    "attachments": attachments == null
        ? []
        : List<dynamic>.from(attachments!.map((x) => x.toJson())),
  };
}

class Activity extends Equatable {
  final String? uuid;
  final DateTime? createdAt;
  final String? title;
  final DateTime? date;
  final String? description;
  final String? latitude;
  final String? longitude;
  final String? status;
  final ActionBy? healthPost;
  final ActionBy? opd;
  final District? district;
  final District? subDistrict;
  final ActionBy? createdBy;
  final List<Attachment>? attachments;

  const Activity({
    this.uuid,
    this.createdAt,
    this.title,
    this.date,
    this.description,
    this.latitude,
    this.longitude,
    this.status,
    this.healthPost,
    this.opd,
    this.district,
    this.subDistrict,
    this.createdBy,
    this.attachments,
  });

  @override
  List<Object?> get props => [
    uuid,
    createdAt,
    title,
    date,
    description,
    latitude,
    longitude,
    status,
    healthPost,
    opd,
    district,
    subDistrict,
    createdBy,
    attachments,
  ];

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    uuid: json["uuid"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    title: json["title"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    description: json["description"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    status: json["status"],
    healthPost: json["health_post"] == null
        ? null
        : ActionBy.fromJson(json["health_post"]),
    opd: json["opd"] == null ? null : ActionBy.fromJson(json["opd"]),
    district: json["district"] == null
        ? null
        : District.fromJson(json["district"]),
    subDistrict: json["sub_district"] == null
        ? null
        : District.fromJson(json["sub_district"]),
    createdBy: json["created_by"] == null
        ? null
        : ActionBy.fromJson(json["created_by"]),
    attachments: json["attachments"] == null
        ? []
        : List<Attachment>.from(
            json["attachments"]!.map((x) => Attachment.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "created_at": createdAt?.toIso8601String(),
    "title": title,
    "date": date?.toIso8601String(),
    "description": description,
    "latitude": latitude,
    "longitude": longitude,
    "status": status,
    "health_post": healthPost?.toJson(),
    "opd": opd?.toJson(),
    "district": district?.toJson(),
    "sub_district": subDistrict?.toJson(),
    "created_by": createdBy?.toJson(),
    "attachments": attachments == null
        ? []
        : List<dynamic>.from(attachments!.map((x) => x)),
  };
}

class ActionBy extends Equatable {
  final String? uuid;
  final String? name;
  final int? type;

  const ActionBy({this.uuid, this.name, this.type});

  @override
  List<Object?> get props => [uuid, name, type];

  factory ActionBy.fromJson(Map<String, dynamic> json) =>
      ActionBy(uuid: json["uuid"], name: json["name"], type: json["type"]);

  Map<String, dynamic> toJson() => {"uuid": uuid, "name": name, "type": type};
}

class User extends Equatable {
  final String? nik;
  final String? fullName;
  final String? address;
  final String? phone;
  final String? rt;
  final String? rw;
  final District? district;
  final SubDistrict? subDistrict;

  const User({
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

  factory User.fromJson(Map<String, dynamic> json) => User(
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
