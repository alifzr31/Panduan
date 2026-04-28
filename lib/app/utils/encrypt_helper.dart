import 'package:encrypt/encrypt.dart' as encrypt_pkg;

class CryptoHelper {
  static String generateMasterKey() {
    final secureRandom = encrypt_pkg.SecureRandom(32);
    return secureRandom.base64;
  }

  static String encryptData(String rawData, String base64MasterKey) {
    final key = encrypt_pkg.Key.fromBase64(base64MasterKey);
    final iv = encrypt_pkg.IV.fromLength(16);
    final encrypter = encrypt_pkg.Encrypter(encrypt_pkg.AES(key));

    final encrypted = encrypter.encrypt(rawData, iv: iv);

    return '${iv.base64}:${encrypted.base64}';
  }

  static String decryptData(String encryptedData, String base64MasterKey) {
    final parts = encryptedData.split(':');
    final iv = encrypt_pkg.IV.fromBase64(parts[0]);
    final cipherText = parts[1];

    final key = encrypt_pkg.Key.fromBase64(base64MasterKey);
    final encrypter = encrypt_pkg.Encrypter(encrypt_pkg.AES(key));

    return encrypter.decrypt64(cipherText, iv: iv);
  }
}
