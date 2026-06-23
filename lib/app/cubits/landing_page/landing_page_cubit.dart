import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:panduan/app/repositories/landing_page_repository.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:url_launcher/url_launcher.dart';

part 'landing_page_state.dart';

class LandingPageCubit extends Cubit<LandingPageState> {
  LandingPageCubit(this._repository) : super(const LandingPageState());

  final LandingPageRepository _repository;
  final Map<String, CancelToken> _cancelTokens = {};

  void fetchUserManualUrl() async {
    final cancelToken = AppHelpers.createCancelToken(
      _cancelTokens,
      key: 'userManualUrl',
    );

    emit(state.copyWith(status: Status.loading));

    try {
      final userManualUrl = await _repository.fetchUserManualUrl(
        cancelToken: cancelToken,
      );

      emit(
        state.copyWith(status: Status.success, userManualUrl: userManualUrl),
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) return;

      emit(
        state.copyWith(
          status: Status.error,
          error: AppHelpers.errorHandlingApiMessage(e),
        ),
      );
    } finally {
      AppHelpers.removeCancelToken(_cancelTokens, key: 'userManualUrl');
    }
  }

  Future<void> openUserManualUrl(String url) async {
    final uri = Uri.parse(url);

    try {
      final canLaunch = await canLaunchUrl(uri);

      if (!canLaunch) return;

      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }
  }

  @override
  Future<void> close() {
    AppHelpers.removeAllCancelToken(_cancelTokens);
    return super.close();
  }
}
