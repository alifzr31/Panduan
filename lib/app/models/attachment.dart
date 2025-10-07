import 'dart:convert';

import 'package:equatable/equatable.dart';

Attachment attachmentFromJson(dynamic data) => Attachment.fromJson(data);

String attachmentToJson(Attachment data) => json.encode(data.toJson());

List<Attachment> listAttachmentFromJson(dynamic data) =>
    data.map<Attachment>((x) => Attachment.fromJson(x)).toList();

String listAttachmentToJson(List<Attachment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Attachment extends Equatable {
  final String? uuid;
  final DateTime? createdAt;
  final String? title;
  final String? path;
  final String? nameFile;
  final bool? checklist;

  const Attachment({
    this.uuid,
    this.createdAt,
    this.title,
    this.path,
    this.nameFile,
    this.checklist,
  });

  @override
  List<Object?> get props => [
    uuid,
    createdAt,
    title,
    path,
    nameFile,
    checklist,
  ];

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    uuid: json["uuid"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    title: json["title"],
    path: json["path"],
    nameFile: json["name_file"],
    checklist: json["checklist"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "created_at": createdAt?.toIso8601String(),
    "title": title,
    "path": path,
    "name_file": nameFile,
  };
}
