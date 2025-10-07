// To parse this JSON data, do
//
//     final spmField = spmFieldFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

SpmField spmFieldFromJson(dynamic data) => SpmField.fromJson(data);

String spmFieldToJson(SpmField data) => json.encode(data.toJson());

List<SpmField> listSpmFieldFromJson(dynamic data) =>
    data.map<SpmField>((x) => SpmField.fromJson(x)).toList();

String listSpmFieldToJson(List<SpmField> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SpmField extends Equatable {
  final String? uuid;
  final String? name;
  final String? code;
  final String? description;
  final int? type;
  final bool? isActive;
  final DateTime? createdAt;

  const SpmField({
    this.uuid,
    this.name,
    this.code,
    this.description,
    this.type,
    this.isActive,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    uuid,
    name,
    code,
    description,
    type,
    isActive,
    createdAt,
  ];

  factory SpmField.fromJson(Map<String, dynamic> json) => SpmField(
    uuid: json["uuid"],
    name: json["name"],
    code: json["code"],
    description: json["description"],
    type: json["type"],
    isActive: json["is_active"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "code": code,
    "description": description,
    "type": type,
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
  };
}
