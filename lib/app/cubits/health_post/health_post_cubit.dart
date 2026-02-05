import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:panduan/app/models/health_post.dart';
import 'package:panduan/app/repositories/healthpost_repository.dart';
import 'package:panduan/app/utils/app_helpers.dart';

part 'health_post_state.dart';

class HealthPostCubit extends Cubit<HealthPostState> {
  HealthPostCubit(this._repository) : super(const HealthPostState());

  final HealthPostRepository _repository;
  int _currentHealthPostPage = 1;

  Future<void> fetchHealthPosts({
    String? keyword,
    String? districtCode,
    String? subDistrictCode,
  }) async {
    if (_currentHealthPostPage == 1) {
      emit(state.copyWith(listStatus: ListStatus.loading));
    }

    try {
      final healthPosts = await _repository.fetchHealthPosts(
        page: _currentHealthPostPage,
        limit: 10,
        keyword: keyword,
        districtCode: districtCode,
        subDistrictCode: subDistrictCode,
      );

      if (healthPosts.length < 10) {
        emit(state.copyWith(hasMoreHealthPost: false));
      }

      emit(
        state.copyWith(
          listStatus: ListStatus.success,
          healthPosts: List.of(state.healthPosts)..addAll(healthPosts),
        ),
      );
      _currentHealthPostPage++;
    } on DioException catch (e) {
      emit(
        state.copyWith(
          listStatus: ListStatus.error,
          listError: AppHelpers.errorHandlingApiMessage(e),
        ),
      );
    }
  }

  void refetchHealthPosts({
    String? keyword,
    String? districtCode,
    String? subDistrictCode,
  }) async {
    _currentHealthPostPage = 1;
    emit(
      state.copyWith(
        listStatus: ListStatus.initial,
        hasMoreHealthPost: true,
        healthPosts: const [],
        listError: null,
      ),
    );

    await fetchHealthPosts(
      keyword: keyword,
      districtCode: districtCode,
      subDistrictCode: subDistrictCode,
    );
  }

  Future<void> fetchAllHealthPosts({
    String? districtCode,
    String? subDistrictCode,
  }) async {
    emit(state.copyWith(listStatus: ListStatus.loading));

    try {
      final healthPosts = await _repository.fetchHealthPosts(
        page: 1,
        limit: 200,
        districtCode: districtCode,
        subDistrictCode: subDistrictCode,
      );

      emit(
        state.copyWith(
          listStatus: ListStatus.success,
          healthPosts: healthPosts,
        ),
      );
    } on DioException catch (e) {
      emit(
        state.copyWith(
          listStatus: ListStatus.error,
          listError: AppHelpers.errorHandlingApiMessage(e),
        ),
      );
    }
  }
}
