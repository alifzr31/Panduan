// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:panduan/app/models/district.dart';
import 'package:panduan/app/models/opd.dart';
import 'package:panduan/app/models/subdistrict.dart';

Profile profileFromJson(dynamic data) => Profile.fromJson(data);

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile extends Equatable {
  final String? name;
  final String? email;
  final String? username;
  final bool? isActive;
  final DateTime? lastLogin;
  final DateTime? createdAt;
  final String? districtCode;
  final String? subDistrictCode;
  final District? district;
  final SubDistrict? subDistrict;
  final HealthFacility? healthFacility;
  final HealthPost? healthPost;
  final Opd? opd;
  final bool? isNeedResetPassword;
  final String? descriptionResetPassword;
  final String? roleName;
  final List<Permission>? permissions;
  final List<dynamic>? healthFacilitySubDistricts;
  final List<dynamic>? healthFacilityDistricts;

  const Profile({
    this.name,
    this.email,
    this.username,
    this.isActive,
    this.lastLogin,
    this.createdAt,
    this.districtCode,
    this.subDistrictCode,
    this.district,
    this.subDistrict,
    this.healthFacility,
    this.healthPost,
    this.opd,
    this.isNeedResetPassword,
    this.descriptionResetPassword,
    this.roleName,
    this.permissions,
    this.healthFacilitySubDistricts,
    this.healthFacilityDistricts,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    username,
    isActive,
    lastLogin,
    createdAt,
    districtCode,
    subDistrictCode,
    district,
    subDistrict,
    healthFacility,
    healthPost,
    opd,
    isNeedResetPassword,
    descriptionResetPassword,
    roleName,
    permissions,
    healthFacilitySubDistricts,
    healthFacilityDistricts,
  ];

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    name: json["name"],
    email: json["email"],
    username: json["username"],
    isActive: json["is_active"],
    lastLogin: json["last_login"] == null
        ? null
        : DateTime.parse(json["last_login"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    districtCode: json["district_code"],
    subDistrictCode: json["sub_district_code"],
    district: json["district"] == null
        ? null
        : District.fromJson(json["district"]),
    subDistrict: json["sub_district"] == null
        ? null
        : SubDistrict.fromJson(json["sub_district"]),
    healthFacility: json["health_facility"] == null
        ? null
        : HealthFacility.fromJson(json["health_facility"]),
    healthPost: json["health_post"] == null
        ? null
        : HealthPost.fromJson(json["health_post"]),
    opd: json["opd"] == null ? null : Opd.fromJson(json["opd"]),
    isNeedResetPassword: json["is_need_reset_password"],
    descriptionResetPassword: json["description_reset_password"],
    roleName: json["role_name"],
    permissions: json["permissions"] == null
        ? []
        : List<Permission>.from(
            json["permissions"]!.map((x) => Permission.fromJson(x)),
          ),
    healthFacilitySubDistricts: json["health_facility_sub_districts"] == null
        ? []
        : List<dynamic>.from(
            json["health_facility_sub_districts"]!.map((x) => x),
          ),
    healthFacilityDistricts: json["health_facility_districts"] == null
        ? []
        : List<dynamic>.from(json["health_facility_districts"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "username": username,
    "is_active": isActive,
    "last_login": lastLogin?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "district_code": districtCode,
    "sub_district_code": subDistrictCode,
    "district": district?.toJson(),
    "sub_district": subDistrict?.toJson(),
    "health_facility": healthFacility?.toJson(),
    "health_post": healthPost?.toJson(),
    "opd": opd?.toJson(),
    "is_need_reset_password": isNeedResetPassword,
    "description_reset_password": descriptionResetPassword,
    "role_name": roleName,
    "permissions": permissions == null
        ? []
        : List<dynamic>.from(permissions!.map((x) => x.toJson())),
    "health_facility_sub_districts": healthFacilitySubDistricts == null
        ? []
        : List<dynamic>.from(healthFacilitySubDistricts!.map((x) => x)),
    "health_facility_districts": healthFacilityDistricts == null
        ? []
        : List<dynamic>.from(healthFacilityDistricts!.map((x) => x)),
  };
}

class HealthFacility extends Equatable {
  final String? uuid;
  final String? name;

  const HealthFacility({this.uuid, this.name});

  @override
  List<Object?> get props => [uuid, name];

  factory HealthFacility.fromJson(Map<String, dynamic> json) =>
      HealthFacility(uuid: json["uuid"], name: json["name"]);

  Map<String, dynamic> toJson() => {"uuid": uuid, "name": name};
}

class HealthPost extends Equatable {
  final String? uuid;
  final String? name;

  const HealthPost({this.uuid, this.name});

  @override
  List<Object?> get props => [uuid, name];

  factory HealthPost.fromJson(Map<String, dynamic> json) =>
      HealthPost(uuid: json["uuid"], name: json["name"]);

  Map<String, dynamic> toJson() => {"uuid": uuid, "name": name};
}

class Permission extends Equatable {
  final int? id;
  final String? name;
  final String? guardName;
  final bool? isDefault;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Permission({
    this.id,
    this.name,
    this.guardName,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    guardName,
    isDefault,
    createdAt,
    updatedAt,
  ];

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
    id: json["id"],
    name: json["name"],
    guardName: json["guard_name"],
    isDefault: json["is_default"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "guard_name": guardName,
    "is_default": isDefault,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
