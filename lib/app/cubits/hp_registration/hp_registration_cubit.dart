import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:panduan/app/models/hp_registration.dart';
import 'package:panduan/app/repositories/hpregistration_repository.dart';
import 'package:panduan/app/utils/app_helpers.dart';

part 'hpregistration_state.dart';

class HpRegistrationCubit extends Cubit<HpRegistrationState> {
  HpRegistrationCubit(this._repository) : super(const HpRegistrationState());

  final HpRegistrationRepository _repository;

  Future<void> fetchHpRegistration({int? healthPostId}) async {
    emit(state.copyWith(registrationStatus: RegistrationStatus.loading));

    try {
      final hpRegistration = await _repository.fetchHpRegistration(
        healthPostId: healthPostId,
      );

      emit(
        state.copyWith(
          registrationStatus: RegistrationStatus.success,
          hpRegistration: hpRegistration,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          registrationStatus: RegistrationStatus.error,
          registrationError: AppHelpers.errorHandlingApiMessage(e),
        ),
      );
    }
  }

  void refetchHpRegistration({int? healthPostId}) async {
    emit(
      state.copyWith(
        registrationStatus: RegistrationStatus.initial,
        hpRegistration: null,
        registrationError: null,
      ),
    );

    await fetchHpRegistration(healthPostId: healthPostId);
  }
}
