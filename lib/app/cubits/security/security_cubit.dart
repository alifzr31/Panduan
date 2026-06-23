import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:freerasp/freerasp.dart' show TalsecException;
import 'package:panduan/app/repositories/security_repository.dart';

part 'security_state.dart';

class SecurityCubit extends Cubit<SecurityState> {
  SecurityCubit(this._repository) : super(const SecurityState());

  final SecurityRepository _repository;

  Future<void> startRasp() async {
    try {
      await _repository.startRasp(
        onThreatDetected: (threatMessage) {
          emit(
            state.copyWith(status: Status.compromised, message: threatMessage),
          );
        },
      );

      emit(state.copyWith(status: Status.safe));
    } on TalsecException catch (e) {
      emit(state.copyWith(status: Status.compromised, message: e.message));
    } on PlatformException catch (e) {
      emit(state.copyWith(status: Status.compromised, message: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.compromised,
          message:
              'Ups sepertinya terjadi kesalahan, silahkan buka ulang aplikasi.',
        ),
      );
    }
  }
}
