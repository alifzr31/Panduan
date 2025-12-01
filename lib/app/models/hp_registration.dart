// To parse this JSON data, do
//
//     final hpRegistration = hpRegistrationFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

HpRegistration hpRegistrationFromJson(dynamic data) =>
    HpRegistration.fromJson(data);

String hpRegistrationToJson(HpRegistration data) => json.encode(data.toJson());

class HpRegistration extends Equatable {
  final int? id;
  final int? healthPostId;
  final String? name;
  final String? noReg;
  final DateTime? date;
  final String? strata;
  final List<Component>? components;

  const HpRegistration({
    this.id,
    this.healthPostId,
    this.name,
    this.noReg,
    this.date,
    this.strata,
    this.components,
  });

  @override
  List<Object?> get props => [
    id,
    healthPostId,
    name,
    noReg,
    date,
    strata,
    components,
  ];

  factory HpRegistration.fromJson(Map<String, dynamic> json) => HpRegistration(
    id: json["id"],
    healthPostId: json["health_post_id"],
    name: json["name"],
    noReg: json["no_reg"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    strata: json["strata"],
    components: json["components"] == null
        ? []
        : List<Component>.from(
            json["components"]!.map((x) => Component.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "health_post_id": healthPostId,
    "name": name,
    "no_reg": noReg,
    "date":
        "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "strata": strata,
    "components": components == null
        ? []
        : List<dynamic>.from(components!.map((x) => x.toJson())),
  };
}

class Component extends Equatable {
  final int? id;
  final String? name;
  final List<ComponentItem>? componentItems;

  const Component({this.id, this.name, this.componentItems});

  @override
  List<Object?> get props => [id, name, componentItems];

  factory Component.fromJson(Map<String, dynamic> json) => Component(
    id: json["id"],
    name: json["name"],
    componentItems: json["component_items"] == null
        ? []
        : List<ComponentItem>.from(
            json["component_items"]!.map((x) => ComponentItem.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "component_items": componentItems == null
        ? []
        : List<dynamic>.from(componentItems!.map((x) => x.toJson())),
  };
}

class ComponentItem extends Equatable {
  final int? id;
  final String? title;
  final bool? response;
  final dynamic description;
  final dynamic filePath;

  const ComponentItem({
    this.id,
    this.title,
    this.response,
    this.description,
    this.filePath,
  });

  @override
  List<Object?> get props => [id, title, response, description, filePath];

  factory ComponentItem.fromJson(Map<String, dynamic> json) => ComponentItem(
    id: json["id"],
    title: json["title"],
    response: json["response"],
    description: json["description"],
    filePath: json["file_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "response": response,
    "description": description,
    "file_path": filePath,
  };
}
