import 'package:flutter/foundation.dart';
import 'package:panduan/app/configs/dio/dio_client.dart';
import 'package:panduan/app/utils/app_env.dart';

class AssetService extends DioClient {
  @override
  String get baseUrl => AppEnv.basePublicUrl;

  Future<String?> downloadAttachment({
    String? path,
    String? savePath,
    void Function(int, int)? onReceiveProgress,
  }) async {
    dio.options.baseUrl = AppEnv.basePublicUrl;

    try {
      await download(
        '/assets/serve',
        savePath ?? '',
        queryParams: {'path': path},
        onReceiveProgress: onReceiveProgress,
      );

      return await compute((message) => message, savePath);
    } catch (e) {
      rethrow;
    }
  }
}
