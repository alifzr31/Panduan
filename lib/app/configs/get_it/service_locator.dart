import 'package:get_it/get_it.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/repositories/auth_repository.dart';
import 'package:panduan/app/services/auth_service.dart';

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton(() => AuthService());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerFactory(() => AuthCubit(sl()));
}
