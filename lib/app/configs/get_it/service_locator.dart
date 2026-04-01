import 'package:get_it/get_it.dart';
import 'package:panduan/app/cubits/activity/activity_cubit.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/cubits/create_spm/createspm_cubit.dart';
import 'package:panduan/app/cubits/asset/asset_cubit.dart';
import 'package:panduan/app/cubits/dashboard/dashboard_cubit.dart';
import 'package:panduan/app/cubits/detail_spm/detailspm_cubit.dart';
import 'package:panduan/app/cubits/edit_spm/editspm_cubit.dart';
import 'package:panduan/app/cubits/health_post/health_post_cubit.dart';
import 'package:panduan/app/cubits/hp_registration/hp_registration_cubit.dart';
import 'package:panduan/app/cubits/location/location_cubit.dart';
import 'package:panduan/app/cubits/region/region_cubit.dart';
import 'package:panduan/app/cubits/notification/notification_cubit.dart';
import 'package:panduan/app/cubits/spm/spm_cubit.dart';
import 'package:panduan/app/repositories/activity_repository.dart';
import 'package:panduan/app/repositories/asset_repository.dart';
import 'package:panduan/app/repositories/auth_repository.dart';
import 'package:panduan/app/repositories/createspm_repository.dart';
import 'package:panduan/app/repositories/dashboard_repository.dart';
import 'package:panduan/app/repositories/detailspm_repository.dart';
import 'package:panduan/app/repositories/editspm_repository.dart';
import 'package:panduan/app/repositories/healthpost_repository.dart';
import 'package:panduan/app/repositories/hpregistration_repository.dart';
import 'package:panduan/app/repositories/region_repository.dart';
import 'package:panduan/app/repositories/notification_repository.dart';
import 'package:panduan/app/repositories/spm_repository.dart';
import 'package:panduan/app/services/activity_service.dart';
import 'package:panduan/app/services/asset_service.dart';
import 'package:panduan/app/services/auth_service.dart';
import 'package:panduan/app/services/createspm_service.dart';
import 'package:panduan/app/services/dashboard_service.dart';
import 'package:panduan/app/services/detailspm_service.dart';
import 'package:panduan/app/services/editspm_service.dart';
import 'package:panduan/app/services/healthpost_service.dart';
import 'package:panduan/app/services/hpregistration_service.dart';
import 'package:panduan/app/services/region_service.dart';
import 'package:panduan/app/services/notification_service.dart';
import 'package:panduan/app/services/spm_service.dart';

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton(() => AuthService());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => AuthCubit(sl()));

  sl.registerLazySingleton(() => RegionService());
  sl.registerLazySingleton<RegionRepository>(() => RegionRepositoryImpl(sl()));
  sl.registerFactory(() => RegionCubit(sl()));

  sl.registerFactory(() => LocationCubit());

  sl.registerLazySingleton(() => DashboardService());
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(sl()),
  );
  sl.registerFactory(() => DashboardCubit(sl()));

  sl.registerLazySingleton(() => NotificationService());
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl()),
  );
  sl.registerFactory(() => NotificationCubit(sl()));

  sl.registerLazySingleton(() => HpRegistrationService());
  sl.registerLazySingleton<HpRegistrationRepository>(
    () => HpRegistrationRepositoryImpl(sl()),
  );
  sl.registerFactory(() => HpRegistrationCubit(sl()));

  sl.registerLazySingleton(() => SpmService());
  sl.registerLazySingleton<SpmRepository>(() => SpmRepositoryImpl(sl()));
  sl.registerFactory(() => SpmCubit(sl()));

  sl.registerLazySingleton(() => DetailSpmService());
  sl.registerLazySingleton<DetailSpmRepository>(
    () => DetailSpmRepositoryImpl(sl()),
  );
  sl.registerFactory(() => DetailSpmCubit(sl()));

  sl.registerLazySingleton(() => HealthPostService());
  sl.registerLazySingleton<HealthPostRepository>(
    () => HealthPostRepositoryImpl(sl()),
  );
  sl.registerFactory(() => HealthPostCubit(sl()));

  sl.registerLazySingleton(() => ActivityService());
  sl.registerLazySingleton<ActivityRepository>(
    () => ActivityRepositoryImpl(sl()),
  );
  sl.registerFactory(() => ActivityCubit(sl()));

  sl.registerLazySingleton(() => AssetService());
  sl.registerLazySingleton<AssetRepository>(() => AssetRepositoryImpl(sl()));
  sl.registerFactory(() => AssetCubit(sl()));

  sl.registerLazySingleton(() => CreateSpmService());
  sl.registerLazySingleton<CreateSpmRepository>(
    () => CreateSpmRepositoryImpl(sl()),
  );
  sl.registerFactory(() => CreateSpmCubit(sl()));

  sl.registerLazySingleton(() => EditSpmService());
  sl.registerLazySingleton<EditSpmRepository>(
    () => EditSpmRepositoryImpl(sl()),
  );
  sl.registerFactory(() => EditSpmCubit(sl()));
}
