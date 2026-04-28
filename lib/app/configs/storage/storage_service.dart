import 'package:flutter/foundation.dart';
import 'package:panduan/app/configs/get_it/service_locator.dart';
import 'package:panduan/app/configs/storage/biom_storage/biom_storage.dart';
import 'package:panduan/app/configs/storage/secure_storage/secure_storage.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/utils/app_strings.dart';
import 'package:panduan/app/utils/encrypt_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _flagKey = 'biometrics_enabled';

  static String? _masterKey;

  static Future<bool> setupBiometric(bool enabledBiometric) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    try {
      if (enabledBiometric) {
        final newMasterKey = CryptoHelper.generateMasterKey();

        final isSaved = await BiomStorage().write(value: newMasterKey);

        if (!isSaved) return false;

        final appToken = await SecureStorage.readStorage(
          key: AppStrings.appToken,
        );

        if (appToken == null) return false;

        final encryptedToken = CryptoHelper.encryptData(appToken, newMasterKey);
        await SecureStorage.writeStorage(
          key: AppStrings.appToken,
          value: encryptedToken,
        );

        _masterKey = newMasterKey;
        await sharedPreferences.setBool(_flagKey, true);
        await sharedPreferences.reload();

        return true;
      } else {
        final savedMasterKey = await BiomStorage().read();

        if (savedMasterKey == null) return false;

        final appToken = await SecureStorage.readStorage(
          key: AppStrings.appToken,
        );

        if (appToken == null) return false;

        final decryptedToken = CryptoHelper.decryptData(
          appToken,
          savedMasterKey,
        );
        await SecureStorage.writeStorage(
          key: AppStrings.appToken,
          value: decryptedToken,
        );
        await BiomStorage().delete();
        _masterKey = null;

        await sharedPreferences.setBool(_flagKey, false);
        await sharedPreferences.reload();

        return true;
      }
    } catch (e) {
      if (kDebugMode) print('ERROR: $e');
      return false;
    }
  }

  static Future<String?> readAppToken() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    //
    final isBiometricOn = sharedPreferences.getBool(_flagKey) ?? false;

    try {
      if (isBiometricOn) {
        final savedMasterKey = await BiomStorage().read();

        if (savedMasterKey == null) return null;

        _masterKey = savedMasterKey;

        final encryptedToken = await SecureStorage.readStorage(
          key: AppStrings.appToken,
        );
        if (encryptedToken == null) return null;

        return CryptoHelper.decryptData(encryptedToken, savedMasterKey);
      } else {
        return await SecureStorage.readStorage(key: AppStrings.appToken);
      }
    } catch (e) {
      if (kDebugMode) print('ERROR getInitialToken: $e');
      sl<AuthCubit>().clearTokens();

      return null;
    }
  }

  static Future<bool> writeAppToken({required String newAppToken}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    //
    final enabledBiometric = sharedPreferences.getBool(_flagKey) ?? false;

    try {
      if (enabledBiometric) {
        if (_masterKey == null) {
          if (kDebugMode) print('ERROR: Master Key hilang dari RAM!');
          return false;
        }

        final encryptedToken = CryptoHelper.encryptData(
          newAppToken,
          _masterKey ?? '',
        );

        await SecureStorage.writeStorage(
          key: AppStrings.appToken,
          value: encryptedToken,
        );

        return true;
      } else {
        await SecureStorage.writeStorage(
          key: AppStrings.appToken,
          value: newAppToken,
        );

        return true;
      }
    } catch (e) {
      if (kDebugMode) print('ERROR writeAppToken: $e');
      return false;
    }
  }
}
