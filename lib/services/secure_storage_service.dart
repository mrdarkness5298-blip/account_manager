import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt_pkg;
import 'dart:convert';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();
  static const _encryptionKeyAlias = 'app_encryption_key';

  /// Récupère la clé de chiffrement existante, ou en génère une nouvelle
  /// qui sera stockée dans le Keystore Android / Keychain iOS.
  Future<String> getEncryptionKey() async {
    String? key = await _storage.read(key: _encryptionKeyAlias);
    if (key == null) {
      // Génération d'une clé AES 256-bit (32 bytes)
      final generatedKey = encrypt_pkg.Key.fromSecureRandom(32);
      key = base64Url.encode(generatedKey.bytes);
      await _storage.write(key: _encryptionKeyAlias, value: key);
    }
    return key;
  }
}
