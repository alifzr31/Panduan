import 'package:panduan/app/utils/app_strings.dart';
import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiomStorage {
  final _localAuthentication = LocalAuthentication();

  Future<bool> checkBiometricHardware() async {
    try {
      return await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      if (kDebugMode) print(e.message);
      return false;
    }
  }

  Future<List<BiometricType>> checkAvailableBiometrics() async {
    try {
      return await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      if (kDebugMode) print(e.message);
      return const [];
    }
  }

  Future<BiometricStorageFile?> _getAuthFile() async {
    try {
      final response = await BiometricStorage().canAuthenticate();

      if (response != CanAuthenticateResponse.success) {
        if (kDebugMode) {
          print('Biometrik tidak didukung atau belum diatur: $response');
        }

        return null;
      }

      return await BiometricStorage().getStorage(
        AppStrings.appToken,
        options: StorageFileInitOptions(authenticationRequired: true),
        promptInfo: const PromptInfo(
          androidPromptInfo: AndroidPromptInfo(
            title: 'Panduan',
            subtitle: 'Masuk dengan biometrik',
            description: 'Silahkan pindai sidik jari anda untuk melanjutkan',
            negativeButton: 'Batal',
          ),
          iosPromptInfo: IosPromptInfo(
            accessTitle: 'Panduan',
            saveTitle: 'Simpan',
          ),
        ),
      );
    } catch (e) {
      if (kDebugMode) print('Gagal menginisialisasi Biometric Storage: $e');
      return null;
    }
  }

  Future<bool> write({required String value}) async {
    final hasHardware = await checkBiometricHardware();
    final availableBiometrics = await checkAvailableBiometrics();

    if (!hasHardware || availableBiometrics.isEmpty) return false;

    final authFile = await _getAuthFile();
    if (authFile == null) return false;

    try {
      await authFile.write(value);
      return true;
    } on PlatformException catch (e) {
      if (e.message?.contains('UnrecoverableKeyException') == true ||
          e.message?.contains('Failed to obtain information about key') ==
              true) {
        if (kDebugMode) {
          print(
            'CRITICAL: Keystore tidak bisa diakses. Kemungkinan Lock Screen dinonaktifkan (None/Swipe) atau kunci telah dihanguskan OS.',
          );
        }

        await BiometricStorage()
            .getStorage(AppStrings.refreshToken)
            .then((v) => v.delete())
            .catchError((_) {});

        return false;
      }

      if (kDebugMode) {
        print('PlatformException lain: ${e.message}');
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Gagal menyimpan token: $e');
      }

      return false;
    }
  }

  Future<String?> read() async {
    final hasHardware = await checkBiometricHardware();
    final availableBiometrics = await checkAvailableBiometrics();

    if (!hasHardware || availableBiometrics.isEmpty) return null;

    final authFile = await _getAuthFile();
    if (authFile == null) return null;

    try {
      final token = await authFile.read();
      return token;
    } on AuthException catch (e) {
      if (kDebugMode) {
        print('User membatalkan autentikasi: ${e.message}');
      }

      return null;
    } on PlatformException catch (e) {
      if (e.message?.contains('KeyPermanentlyInvalidated') == true ||
          e.code == 'auth_error') {
        if (kDebugMode) {
          print('Peringatan: Biometrik perangkat telah berubah. Kunci hangus.');
        }

        await delete();
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Terjadi kesalahan saat membaca token: $e');
      }

      return null;
    }
  }

  Future<bool> delete() async {
    final hasHardware = await checkBiometricHardware();
    final availableBiometrics = await checkAvailableBiometrics();

    if (!hasHardware || availableBiometrics.isEmpty) return false;

    final authFile = await _getAuthFile();
    if (authFile == null) return false;

    try {
      await authFile.delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
