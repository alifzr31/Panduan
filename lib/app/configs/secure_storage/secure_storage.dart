import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const FlutterSecureStorage storage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    storageCipherAlgorithm: StorageCipherAlgorithm.AES_CBC_PKCS7Padding,
  ),
  iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
);

class SecureStorage {
  static Future<void> writeStorage({
    required String key,
    required String value,
  }) async {
    return await storage.write(key: key, value: value);
  }

  static Future<String?> readStorage({required String key}) async {
    return await storage.read(key: key);
  }

  static Future<void> deleteStorage({required String key}) async {
    return await storage.delete(key: key);
  }

  static Future<void> deleteAllStorage() async {
    return await storage.deleteAll();
  }
}
