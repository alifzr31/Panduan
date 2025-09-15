import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:panduan/app/configs/firebase/firebase_options.dart';
import 'package:panduan/app/configs/get_it/service_locator.dart' as di;
import 'package:panduan/app/configs/router/app_router.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/views/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  initializeDateFormatting('id_ID');
  Intl.defaultLocale = 'id_ID';

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<AuthCubit>(),
      child: GlobalLoaderOverlay(
        overlayColor: Colors.black.withValues(alpha: 0.4),
        disableBackButton: true,
        overlayWholeScreen: true,
        overlayHeight: AppHelpers.getHeightDevice(context),
        overlayWidth: AppHelpers.getWidthDevice(context),
        overlayWidgetBuilder: (progress) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Lottie.asset(
                'assets/lotties/panduan-logo-loader.json',
                width: 80,
              ),
            ),
          );
        },
        child: MaterialApp(
          title: 'Panduan',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.amberColor),
            scaffoldBackgroundColor: AppColors.backgroundColor,
            fontFamily: 'Jost',
            useMaterial3: true,
            applyElevationOverlayColor: false,
          ),
          initialRoute: SplashPage.routeName,
          onGenerateRoute: (settings) {
            return AppRouter.onGenerateRoute(settings);
          },
        ),
      ),
    );
  }
}
