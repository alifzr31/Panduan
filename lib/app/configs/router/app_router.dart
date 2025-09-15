import 'package:flutter/cupertino.dart';
import 'package:panduan/app/configs/router/custompageroute_builder.dart';
import 'package:panduan/app/views/dashboard/dashboard_page.dart';
import 'package:panduan/app/views/login/login_page.dart';
import 'package:panduan/app/views/splash/splash_page.dart';
import 'package:panduan/app/views/update/update_page.dart';

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
          child: const DashboardPage(),
        );
      default:
        return customPageRouteBuilder(settings, child: const Placeholder());
    }
  }
}
