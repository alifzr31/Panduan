// To parse this JSON data, do
//
//     final notification = notificationFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:panduan/app/models/spm.dart';

Notification notificationFromJson(dynamic data) => Notification.fromJson(data);

String notificationToJson(Notification data) => json.encode(data.toJson());

List<Notification> listNotificationFromJson(dynamic data) =>
    data.map<Notification>((x) => Notification.fromJson(x)).toList();

String listNotificationToJson(List<Notification> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Notification extends Equatable {
  final String? id;
  final int? ownerId;
  final NotificationData? data;
  final String? notifiableType;
  final int? notifiableId;
  final String? notifiableUuid;
  final String? type;
  final dynamic deletedAt;
  final DateTime? readAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? numbering;

  const Notification({
    this.id,
    this.ownerId,
    this.data,
    this.notifiableType,
    this.notifiableId,
    this.notifiableUuid,
    this.type,
    this.deletedAt,
    this.readAt,
    this.createdAt,
    this.updatedAt,
    this.numbering,
  });

  @override
  List<Object?> get props => [
    id,
    ownerId,
    data,
    notifiableType,
    notifiableId,
    notifiableUuid,
    type,
    deletedAt,
    readAt,
    createdAt,
    updatedAt,
    numbering,
  ];

  Notification copyWith({
    String? id,
    int? ownerId,
    NotificationData? data,
    String? notifiableType,
    int? notifiableId,
    String? notifiableUuid,
    String? type,
    dynamic deletedAt,
    DateTime? readAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? numbering,
  }) {
    return Notification(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      data: data ?? this.data,
      notifiableType: notifiableType ?? this.notifiableType,
      notifiableId: notifiableId ?? this.notifiableId,
      notifiableUuid: notifiableUuid ?? this.notifiableUuid,
      type: type ?? this.type,
      deletedAt: deletedAt ?? this.deletedAt,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      numbering: numbering ?? this.numbering,
    );
  }

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    id: json["id"],
    ownerId: json["owner_id"],
    data: json["data"] == null ? null : NotificationData.fromJson(json["data"]),
    notifiableType: json["notifiable_type"],
    notifiableId: json["notifiable_id"],
    notifiableUuid: json["notifiable_uuid"],
    type: json["type"],
    deletedAt: json["deleted_at"],
    readAt: json["read_at"] == null ? null : DateTime.parse(json["read_at"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    numbering: json["numbering"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "owner_id": ownerId,
    "data": data?.toJson(),
    "notifiable_type": notifiableType,
    "notifiable_id": notifiableId,
    "notifiable_uuid": notifiableUuid,
    "type": type,
    "deleted_at": deletedAt,
    "read_at": readAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "numbering": numbering,
  };
}

class NotificationData extends Equatable {
  final String? title;
  final String? body;
  final String? androidChannelId;
  final String? featureableType;
  final int? featureableId;
  final String? featureableUuid;
  final int? ownerId;
  final String? type;
  final DataData? data;

  const NotificationData({
    this.title,
    this.body,
    this.androidChannelId,
    this.featureableType,
    this.featureableId,
    this.featureableUuid,
    this.ownerId,
    this.type,
    this.data,
  });

  @override
  List<Object?> get props => [
    title,
    body,
    androidChannelId,
    featureableType,
    featureableId,
    featureableUuid,
    ownerId,
    type,
    data,
  ];

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        title: json["title"],
        body: json["body"],
        androidChannelId: json["android_channel_id"],
        featureableType: json["featureable_type"],
        featureableId: json["featureable_id"],
        featureableUuid: json["featureable_uuid"],
        ownerId: json["owner_id"],
        type: json["type"],
        data: json["data"] == null ? null : DataData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "body": body,
    "android_channel_id": androidChannelId,
    "featureable_type": featureableType,
    "featureable_id": featureableId,
    "featureable_uuid": featureableUuid,
    "owner_id": ownerId,
    "type": type,
    "data": data?.toJson(),
  };
}

class DataData extends Equatable {
  final String? uuid;
  final int? userId;
  final User? user;
  final int? spmFieldId;
  final int? serviceCategoryId;
  final int? healthPostId;
  final dynamic opdId;
  final String? subDistrictCode;
  final String? districtCode;
  final String? receiptNumber;
  final String? description;
  final String? type;
  final DateTime? date;
  final String? status;
  final dynamic latitude;
  final dynamic longitude;
  final int? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DataData({
    this.uuid,
    this.userId,
    this.user,
    this.spmFieldId,
    this.serviceCategoryId,
    this.healthPostId,
    this.opdId,
    this.subDistrictCode,
    this.districtCode,
    this.receiptNumber,
    this.description,
    this.type,
    this.date,
    this.status,
    this.latitude,
    this.longitude,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    uuid,
    userId,
    user,
    spmFieldId,
    serviceCategoryId,
    healthPostId,
    opdId,
    subDistrictCode,
    districtCode,
    receiptNumber,
    description,
    type,
    date,
    status,
    latitude,
    longitude,
    createdBy,
    createdAt,
    updatedAt,
  ];

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
    uuid: json["uuid"],
    userId: json["user_id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    spmFieldId: json["spm_field_id"],
    serviceCategoryId: json["service_category_id"],
    healthPostId: json["health_post_id"],
    opdId: json["opd_id"],
    subDistrictCode: json["sub_district_code"],
    districtCode: json["district_code"],
    receiptNumber: json["receipt_number"],
    description: json["description"],
    type: json["type"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    status: json["status"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    createdBy: json["created_by"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "user_id": userId,
    "user": user?.toJson(),
    "spm_field_id": spmFieldId,
    "service_category_id": serviceCategoryId,
    "health_post_id": healthPostId,
    "opd_id": opdId,
    "sub_district_code": subDistrictCode,
    "district_code": districtCode,
    "receipt_number": receiptNumber,
    "description": description,
    "type": type,
    "date": date?.toIso8601String(),
    "status": status,
    "latitude": latitude,
    "longitude": longitude,
    "created_by": createdBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
