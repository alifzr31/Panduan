// To parse this JSON data, do
//
//     final opd = opdFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

Opd opdFromJson(dynamic data) => Opd.fromJson(data);

String opdToJson(Opd data) => json.encode(data.toJson());

List<Opd> listOpdFromJson(dynamic data) =>
    data.map<Opd>((x) => Opd.fromJson(x)).toList();

String listOpdToJson(List<Opd> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Opd extends Equatable {
  final String? uuid;
  final String? name;
  final String? description;
  final String? phone;
  final String? email;
  final String? address;
  final String? code;
  final bool? isActive;
  final DateTime? createdAt;

  const Opd({
    this.uuid,
    this.name,
    this.description,
    this.phone,
    this.email,
    this.address,
    this.code,
    this.isActive,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    uuid,
    name,
    description,
    phone,
    email,
    address,
    code,
    isActive,
    createdAt,
  ];

  factory Opd.fromJson(Map<String, dynamic> json) => Opd(
    uuid: json["uuid"],
    name: json["name"],
    description: json["description"],
    phone: json["phone"],
    email: json["email"],
    address: json["address"],
    code: json["code"],
    isActive: json["is_active"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "description": description,
    "phone": phone,
    "email": email,
    "address": address,
    "code": code,
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
  };
}
