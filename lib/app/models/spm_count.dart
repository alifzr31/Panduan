// To parse this JSON data, do
//
//     final district = districtFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

SpmCount spmCountFromJson(dynamic data) => SpmCount.fromJson(data);

String spmCountToJson(SpmCount data) => json.encode(data.toJson());

class SpmCount extends Equatable {
  final int? finish;
  final int? decline;
  final int? proses;
  final int? needVerification;
  final int? needVerificationSubDistrict;
  final int? needVerificationOpd;
  final int? needApprovalDistrict;
  final int? finishByOpd;
  final int? finishBySubDistrict;
  final int? declineBySubDistrict;
  final int? declineByOpd;
  final int? declineByDistrict;
  final int? processByOpd;
  final int? processBySubDistrict;
  final int? total;

  const SpmCount({
    this.finish,
    this.decline,
    this.proses,
    this.needVerification,
    this.needVerificationSubDistrict,
    this.needVerificationOpd,
    this.needApprovalDistrict,
    this.finishByOpd,
    this.finishBySubDistrict,
    this.declineBySubDistrict,
    this.declineByOpd,
    this.declineByDistrict,
    this.processByOpd,
    this.processBySubDistrict,
    this.total,
  });

  @override
  List<Object?> get props => [
    finish,
    decline,
    proses,
    needVerification,
    needVerificationSubDistrict,
    needVerificationOpd,
    needApprovalDistrict,
    finishByOpd,
    finishBySubDistrict,
    declineBySubDistrict,
    declineByOpd,
    declineByDistrict,
    processByOpd,
    processBySubDistrict,
    total,
  ];

  factory SpmCount.fromJson(Map<String, dynamic> json) => SpmCount(
    finish: json["finish"],
    decline: json["decline"],
    proses: json["proses"],
    needVerification: json["need_verification"],
    needVerificationSubDistrict: json["need_verification_sub_district"],
    needVerificationOpd: json["need_verification_opd"],
    needApprovalDistrict: json["need_approval_district"],
    finishByOpd: json["finish_by_opd"],
    finishBySubDistrict: json["finish_by_sub_district"],
    declineBySubDistrict: json["decline_by_sub_district"],
    declineByOpd: json["decline_by_opd"],
    declineByDistrict: json["decline_by_district"],
    processByOpd: json["process_by_opd"],
    processBySubDistrict: json["process_by_sub_district"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "finish": finish,
    "decline": decline,
    "proses": proses,
    "need_verification": needVerification,
    "need_verification_sub_district": needVerificationSubDistrict,
    "need_verification_opd": needVerificationOpd,
    "need_approval_district": needApprovalDistrict,
    "finish_by_opd": finishByOpd,
    "finish_by_sub_district": finishBySubDistrict,
    "decline_by_sub_district": declineBySubDistrict,
    "decline_by_opd": declineByOpd,
    "decline_by_district": declineByDistrict,
    "process_by_opd": processByOpd,
    "process_by_sub_district": processBySubDistrict,
    "total": total,
  };
}
