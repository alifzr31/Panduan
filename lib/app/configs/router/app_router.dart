import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/configs/get_it/service_locator.dart';
import 'package:panduan/app/configs/router/custompageroute_builder.dart';
import 'package:panduan/app/cubits/create_spm/createspm_cubit.dart';
import 'package:panduan/app/cubits/dashboard/dashboard_cubit.dart';
import 'package:panduan/app/cubits/detail_spm/detailspm_cubit.dart';
import 'package:panduan/app/cubits/edit_spm/editspm_cubit.dart';
import 'package:panduan/app/cubits/location/location_cubit.dart';
import 'package:panduan/app/cubits/notification/notification_cubit.dart';
import 'package:panduan/app/cubits/spm/spm_cubit.dart';
import 'package:panduan/app/views/create_spm/createspm_page.dart';
import 'package:panduan/app/views/dashboard/dashboard_page.dart';
import 'package:panduan/app/views/detail_spm/detailspm_page.dart';
import 'package:panduan/app/views/edit_spm/editspm_page.dart';
import 'package:panduan/app/views/login/login_page.dart';
import 'package:panduan/app/views/map_coordinate/mapcoordinate_page.dart';
import 'package:panduan/app/views/notification/notification_page.dart';
import 'package:panduan/app/views/splash/splash_page.dart';
import 'package:panduan/app/views/spm/spm_page.dart';
import 'package:panduan/app/views/spm_field/spmfield_page.dart';
import 'package:panduan/app/views/update/update_page.dart';
import 'package:panduan/app/views/webview/webview_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashPage.routeName:
        return customPageRouteBuilder(
          settings,
          bottomSafeArea: false,
          child: const SplashPage(),
        );
      case UpdatePage.routeName:
        final args = settings.arguments as Map<String, dynamic>;

        return customPageRouteBuilder(
          settings,
          child: UpdatePage(
            isLoggedIn: args['isLoggedIn'],
            packageName: args['packageName'],
            currentVersion: args['currentVersion'],
            currentBuildNumber: args['currentBuildNumber'],
            latestVersion: args['latestVersion'],
            latestBuildNumber: args['latestBuildNumber'],
            updateDescription: args['updateDescription'],
            mandatoryUpdate: args['mandatoryUpdate'],
          ),
        );
      case LoginPage.routeName:
        return customPageRouteBuilder(
          settings,
          bottomSafeArea: false,
          child: const LoginPage(),
        );
      case DashboardPage.routeName:
        return customPageRouteBuilder(
          settings,
          bottomSafeArea: false,
          child: BlocProvider(
            create: (context) => sl<DashboardCubit>(),
            child: const DashboardPage(),
          ),
        );
      case NotificationPage.routeName:
        return customPageRouteBuilder(
          settings,
          bottomSafeArea: false,
          child: BlocProvider(
            create: (context) => sl<NotificationCubit>(),
            child: const NotificationPage(),
          ),
        );
      case SpmPage.routeName:
        final status = settings.arguments as String?;

        return customPageRouteBuilder(
          settings,
          bottomSafeArea: false,
          child: BlocProvider(
            create: (context) => sl<SpmCubit>(),
            child: SpmPage(status: status),
          ),
        );
      case DetailSpmPage.routeName:
        final spmUuid = settings.arguments as String;

        return customPageRouteBuilder(
          settings,
          bottomSafeArea: false,
          child: BlocProvider(
            create: (context) => sl<DetailSpmCubit>(),
            child: DetailSpmPage(spmUuid: spmUuid),
          ),
        );
      case SpmFieldPage.routeName:
        return customPageRouteBuilder(
          settings,
          bottomSafeArea: false,
          child: BlocProvider(
            create: (context) => sl<SpmCubit>(),
            child: const SpmFieldPage(),
          ),
        );
      case CreateSpmPage.routeName:
        final args = settings.arguments as Map<String, dynamic>?;

        return customPageRouteBuilder(
          settings,
          bottomSafeArea: false,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<LocationCubit>()),
              BlocProvider(create: (context) => sl<CreateSpmCubit>()),
            ],
            child: CreateSpmPage(
              spmFieldUuid: args?['spmFieldUuid'],
              spmFieldName: args?['spmFieldName'],
            ),
          ),
        );
      case EditSpmPage.routeName:
        final args = settings.arguments as Map<String, dynamic>?;

        return customPageRouteBuilder(
          settings,
          bottomSafeArea: false,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<LocationCubit>()),
              BlocProvider(create: (context) => sl<EditSpmCubit>()),
            ],
            child: EditSpmPage(
              spmFieldUuid: args?['spmFieldUuid'],
              spmFieldName: args?['spmFieldName'],
              detailSpm: args?['detailSpm'],
            ),
          ),
        );
      case MapCoordinatePage.routeName:
        final args = settings.arguments as Map<String, dynamic>?;

        return customPageRouteBuilder(
          settings,
          bottomSafeArea: false,
          child: MapCoordinatePage(
            latitude: args?['latitude'],
            longitude: args?['longitude'],
            viewOnly: args?['viewOnly'] ?? false,
          ),
        );
      case WebviewPage.routeName:
        final args = settings.arguments as Map<String, dynamic>?;

        return customPageRouteBuilder(
          settings,
          bottomSafeArea: false,
          child: WebviewPage(
            fileName: args?['fileName'],
            filePath: args?['filePath'],
          ),
        );
      default:
        return customPageRouteBuilder(settings, child: const Placeholder());
    }
  }
}
