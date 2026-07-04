import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/account.dart';
import 'add_edit_account_screen.dart';

class AccountDetailScreen extends StatelessWidget {
  final Account account;
  const AccountDetailScreen({super.key, required this.account});

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label copié !', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.green),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(isPassword ? '••••••••' : value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          if (value.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.copy, color: Colors.blueAccent, size: 20),
              onPressed: () => _copyToClipboard(context, value, label),
            )
        ],
      ),
    );
  }

  Widget _buildSocialSection(BuildContext context, String title, SocialMedia sm) {
    // On ne montre pas la carte si l'utilisateur n'a rien saisi
    if (sm.username.isEmpty && sm.password.isEmpty) return const SizedBox.shrink();
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
            const Divider(color: Colors.white24),
            _buildDetailRow(context, 'Identifiant', sm.username),
            _buildDetailRow(context, 'Mot de passe', sm.password, isPassword: true),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(account.email),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blueAccent),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditAccountScreen(account: account)));
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Informations Principales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          Card(
            color: const Color(0xFF1E1E1E),
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _buildDetailRow(context, 'E-mail', account.email),
                  _buildDetailRow(context, 'Mot de passe', account.password, isPassword: true),
                  _buildDetailRow(context, 'Pays', account.country),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Réseaux Sociaux Associés', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          const SizedBox(height: 10),
          _buildSocialSection(context, 'X (Twitter)', account.xTwitter),
          _buildSocialSection(context, 'Facebook', account.facebook),
          _buildSocialSection(context, 'Instagram', account.instagram),
          _buildSocialSection(context, 'LinkedIn', account.linkedin),
          _buildSocialSection(context, 'TikTok', account.tiktok),
        ],
      ),
    );
  }
}
