import 'package:panduan/app/services/asset_service.dart';
import 'package:path_provider/path_provider.dart';

abstract class AssetRepository {
  Future<String?> downloadAttachment({
    String? path,
    String? fileName,
    void Function(int, int)? onReceiveProgress,
  });
}

class AssetRepositoryImpl implements AssetRepository {
  final AssetService _service;

  AssetRepositoryImpl(this._service);

  @override
  Future<String?> downloadAttachment({
    String? path,
    String? fileName,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final directory = await getDownloadsDirectory();
    final savePath = '${directory?.path}/$fileName';

    await _service.downloadAttachment(
      path: path,
      savePath: savePath,
      onReceiveProgress: onReceiveProgress,
    );

    return savePath;
  }
}
