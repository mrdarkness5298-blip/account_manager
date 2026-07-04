import 'package:encrypt/encrypt.dart' as encrypt_pkg;
import 'dart:convert';
import 'secure_storage_service.dart';

class EncryptionService {
  final SecureStorageService _secureStorage = SecureStorageService();

  Future<encrypt_pkg.Encrypter> _getEncrypter() async {
    final keyString = await _secureStorage.getEncryptionKey();
    final keyBytes = base64Url.decode(keyString);
    final key = encrypt_pkg.Key(keyBytes);
    // Utilisation de AES en mode CBC (Cipher Block Chaining)
    return encrypt_pkg.Encrypter(encrypt_pkg.AES(key, mode: encrypt_pkg.AESMode.cbc));
  }

  /// Chiffre le texte clair et retourne une chaîne contenant [IV:TexteChiffré]
  Future<String> encrypt(String plainText) async {
    if (plainText.isEmpty) return '';
    final encrypter = await _getEncrypter();
    
    // Génération d'un Vecteur d'Initialisation (IV) aléatoire pour chaque chiffrement
    final iv = encrypt_pkg.IV.fromSecureRandom(16);
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    
    // Le stockage concatène l'IV et le texte chiffré
    return '${base64Url.encode(iv.bytes)}:${encrypted.base64}';
  }

  /// Déchiffre une chaîne au format [IV:TexteChiffré]
  Future<String> decrypt(String encryptedData) async {
    if (encryptedData.isEmpty || !encryptedData.contains(':')) return '';
    
    try {
      final parts = encryptedData.split(':');
      final iv = encrypt_pkg.IV(base64Url.decode(parts[0]));
      final cipherText = encrypt_pkg.Encrypted.fromBase64(parts[1]);
      
      final encrypter = await _getEncrypter();
      return encrypter.decrypt(cipherText, iv: iv);
    } catch (e) {
      print("Erreur de déchiffrement : $e");
      return 'Erreur';
    }
  }
}
