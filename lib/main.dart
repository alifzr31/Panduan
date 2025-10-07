import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:panduan/app/configs/firebase/firebase_notif.dart';
import 'package:panduan/app/configs/firebase/firebase_options.dart';
import 'package:panduan/app/configs/get_it/service_locator.dart' as di;
import 'package:panduan/app/configs/local_notification/local_notif.dart';
import 'package:panduan/app/configs/router/app_router.dart';
import 'package:panduan/app/cubits/asset/asset_cubit.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/utils/app_strings.dart';
import 'package:panduan/app/views/splash/splash_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await LocalNotif().showNotifications(
    id: message.notification.hashCode,
    title: message.notification?.title,
    body: message.notification?.body,
    payload: message.data.toString(),
    imageUrl: message.notification?.android?.imageUrl,
  );

  if (kDebugMode) print('BACKGROUND FIREBASE NOTIF : $message');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseNotif firebaseNotif = FirebaseNotif();
  LocalNotif localNotif = LocalNotif();

  await firebaseNotif.requestNotificationPermission();
  firebaseNotif.firebaseInit();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await localNotif.init();

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<AuthCubit>()),
        BlocProvider(create: (context) => di.sl<AssetCubit>()),
      ],
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
                '${AppStrings.assetsLotties}/panduan-logo-loader.json',
                width: 80,
              ),
            ),
          );
        },
        child: MaterialApp(
          title: 'Panduan',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blueColor),
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
