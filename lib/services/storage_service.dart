import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/account.dart';
import 'encryption_service.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final EncryptionService _encryptionService = EncryptionService();
  static const String _fileName = 'accounts_secure_data.enc';

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<void> saveAccounts(List<Account> accounts) async {
    final file = await _getFile();
    // On convertit la liste en JSON
    final List<Map<String, dynamic>> jsonList = accounts.map((a) => a.toMap()).toList();
    final String jsonString = jsonEncode(jsonList);
    
    // On chiffre l'intégralité du fichier avec AES-256
    final encryptedData = await _encryptionService.encrypt(jsonString);
    
    // Sauvegarde physique
    await file.writeAsString(encryptedData);
  }

  Future<List<Account>> loadAccounts() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        return [];
      }
      
      final encryptedData = await file.readAsString();
      if (encryptedData.isEmpty) return [];

      // Déchiffrement
      final decryptedData = await _encryptionService.decrypt(encryptedData);
      if (decryptedData == 'Erreur' || decryptedData.isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(decryptedData);
      return jsonList.map((map) {
        final m = map as Map<String, dynamic>;
        return Account.fromMap(m, m['id'] ?? DateTime.now().millisecondsSinceEpoch.toString());
      }).toList();
    } catch (e) {
      print("Erreur de chargement des comptes : $e");
      return [];
    }
  }
}
