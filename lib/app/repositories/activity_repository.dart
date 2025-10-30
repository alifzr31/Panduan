import 'package:dio/dio.dart';
import 'package:panduan/app/models/opd.dart';
import 'package:panduan/app/services/activity_service.dart';

abstract class ActivityRepository {
  Future<Response> createActivity({
    String? spmUuid,
    String? status,
    String? description,
    List<String>? opdUuids,
    double? latitude,
    double? longitude,
    List<String>? attachmentKeys,
    List<String>? attachmentPaths,
  });
  Future<List<Opd>> fetchOpd();
}

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityService _service;

  ActivityRepositoryImpl(this._service);

  @override
  Future<Response> createActivity({
    String? spmUuid,
    String? status,
    String? description,
    List<String>? opdUuids,
    double? latitude,
    double? longitude,
    List<String>? attachmentKeys,
    List<String>? attachmentPaths,
  }) async {
    return await _service.createActivity(
      spmUuid: spmUuid,
      status: status,
      description: description,
      opdUuids: opdUuids,
      latitude: latitude,
      longitude: longitude,
      attachmentKeys: attachmentKeys,
      attachmentPaths: attachmentPaths,
    );
  }

  @override
  Future<List<Opd>> fetchOpd() async {
    return await _service.fetchOpd();
  }
}
