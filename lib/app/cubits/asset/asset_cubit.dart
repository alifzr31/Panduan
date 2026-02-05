import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:panduan/app/repositories/asset_repository.dart';
import 'package:panduan/app/utils/app_helpers.dart';

part 'asset_state.dart';

class AssetCubit extends Cubit<AssetState> {
  AssetCubit(this._repository) : super(const AssetState());

  final AssetRepository _repository;

  void resetDownloadAttachmentState() async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      emit(
        state.copyWith(
          downloadStatus: DownloadStatus.initial,
          downloadProgress: null,
          savePath: null,
          downloadError: null,
        ),
      );
    });
  }

  void downloadAttachment({String? path, String? fileName}) async {
    emit(state.copyWith(downloadStatus: DownloadStatus.loading));

    try {
      final savePath = await _repository.downloadAttachment(
        path: path,
        fileName: fileName,
        onReceiveProgress: (received, total) {
          if (total != 1) {
            emit(
              state.copyWith(
                downloadProgress: ((received / total) * 100).ceil(),
              ),
            );
          }
        },
      );

      emit(
        state.copyWith(
          downloadStatus: DownloadStatus.success,
          savePath: savePath,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          downloadStatus: DownloadStatus.error,
          downloadError: AppHelpers.errorHandlingApiMessage(e),
        ),
      );
    }
  }
}
