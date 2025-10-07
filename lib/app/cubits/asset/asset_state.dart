part of 'asset_cubit.dart';

enum DownloadStatus { initial, loading, success, error }

class AssetState extends Equatable {
  final DownloadStatus downloadStatus;
  final int downloadProgress;
  final String? savePath;
  final String? downloadError;

  const AssetState({
    this.downloadStatus = DownloadStatus.initial,
    this.downloadProgress = 0,
    this.savePath,
    this.downloadError,
  });

  AssetState copyWith({
    DownloadStatus? downloadStatus,
    int? downloadProgress,
    String? savePath,
    String? downloadError,
  }) {
    return AssetState(
      downloadStatus: downloadStatus ?? this.downloadStatus,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      savePath: savePath,
      downloadError: downloadError,
    );
  }

  @override
  List<Object?> get props => [
    downloadStatus,
    downloadProgress,
    savePath,
    downloadError,
  ];
}
