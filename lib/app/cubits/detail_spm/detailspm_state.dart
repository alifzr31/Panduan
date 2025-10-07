part of 'detailspm_cubit.dart';

enum DetailStatus { initial, loading, success, error }

enum DeleteStatus { initial, loading, success, error }

class DetailSpmState extends Equatable {
  final DetailStatus detailStatus;
  final Spm? detailSpm;
  final String? detailError;
  final DeleteStatus deleteStatus;
  final Response? deleteResponse;
  final String? deleteError;

  const DetailSpmState({
    this.detailStatus = DetailStatus.initial,
    this.detailSpm,
    this.detailError,
    this.deleteStatus = DeleteStatus.initial,
    this.deleteResponse,
    this.deleteError,
  });

  DetailSpmState copyWith({
    DetailStatus? detailStatus,
    Spm? detailSpm,
    String? detailError,
    DeleteStatus? deleteStatus,
    Response? deleteResponse,
    String? deleteError,
  }) {
    return DetailSpmState(
      detailStatus: detailStatus ?? this.detailStatus,
      detailSpm: detailSpm,
      detailError: detailError,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      deleteResponse: deleteResponse,
      deleteError: deleteError,
    );
  }

  @override
  List<Object?> get props => [
    detailStatus,
    detailSpm,
    detailError,
    deleteStatus,
    deleteResponse,
    deleteError,
  ];
}
