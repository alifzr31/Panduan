import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:panduan/app/models/spm_field.dart';
import 'package:panduan/app/repositories/spm_repository.dart';
import 'package:panduan/app/utils/app_helpers.dart';

part 'spm_state.dart';

class SpmCubit extends Cubit<SpmState> {
  SpmCubit(this._repository) : super(const SpmState());

  final SpmRepository _repository;

  Future<void> fetchSpmFields() async {
    emit(state.copyWith(spmFieldStatus: SpmFieldStatus.loading));

    try {
      final spmFields = await _repository.fetchSpmFields();

      if (spmFields.isNotEmpty &&
          spmFields.any(
            (element) => element.name?.toLowerCase() == 'lainnya',
          )) {
        final updatedList = List.of(spmFields);
        final lainnyaField = updatedList.firstWhere(
          (element) => element.name?.toLowerCase() == 'lainnya',
        );

        updatedList
          ..remove(lainnyaField)
          ..add(lainnyaField);

        emit(
          state.copyWith(
            spmFieldStatus: SpmFieldStatus.success,
            spmFields: updatedList,
          ),
        );
      } else {
        emit(
          state.copyWith(
            spmFieldStatus: SpmFieldStatus.success,
            spmFields: spmFields,
          ),
        );
      }
    } on DioException catch (e) {
      emit(
        state.copyWith(
          spmFieldStatus: SpmFieldStatus.error,
          spmFieldError: AppHelpers.errorHandlingApiMessage(e),
        ),
      );
    }
  }

  void refetchSpmFields() async {
    emit(
      state.copyWith(
        spmFieldStatus: SpmFieldStatus.initial,
        spmFields: const [],
        spmFieldError: null,
      ),
    );

    await fetchSpmFields();
  }

  Future<void> refreshSpmFields() async {
    await Future.delayed(const Duration(milliseconds: 2500), () {
      refetchSpmFields();
    });
  }
}
