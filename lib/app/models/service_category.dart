// To parse this JSON data, do
//
//     final serviceCategory = serviceCategoryFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

ServiceCategory serviceCategoryFromJson(dynamic data) =>
    ServiceCategory.fromJson(data);

String serviceCategoryToJson(ServiceCategory data) =>
    json.encode(data.toJson());

List<ServiceCategory> listServiceCategoryFromJson(dynamic data) =>
    data.map<ServiceCategory>((x) => ServiceCategory.fromJson(x)).toList();

String listServiceCategoryToJson(List<ServiceCategory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServiceCategory extends Equatable {
  final String? name;
  final String? description;
  final String? uuid;
  final bool? isActive;
  final DateTime? createdAt;

  const ServiceCategory({
    this.name,
    this.description,
    this.uuid,
    this.isActive,
    this.createdAt,
  });

  @override
  List<Object?> get props => [name, description, uuid, isActive, createdAt];

  factory ServiceCategory.fromJson(Map<String, dynamic> json) =>
      ServiceCategory(
        name: json["name"],
        description: json["description"],
        uuid: json["uuid"],
        isActive: json["is_active"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "uuid": uuid,
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
  };
}
