import 'package:flutter/material.dart';
import '../models/account.dart';
import '../services/storage_service.dart';

class AddEditAccountScreen extends StatefulWidget {
  final Account? account;
  const AddEditAccountScreen({super.key, this.account});

  @override
  State<AddEditAccountScreen> createState() => _AddEditAccountScreenState();
}

class _AddEditAccountScreenState extends State<AddEditAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;
  
  String _selectedCountry = '🇫🇷 France';
  final List<String> _countries = [
    '🇫🇷 France',
    '🇺🇸 États-Unis',
    '🇬🇧 Royaume-Uni',
    '🇨🇦 Canada',
    '🇨🇭 Suisse',
    '🇧🇪 Belgique',
    '🇲🇦 Maroc',
    '🇩🇿 Algérie',
    '🇹🇳 Tunisie',
    '🌍 Autre'
  ];

  late TextEditingController _xUserCtrl, _xPassCtrl;
  late TextEditingController _fbUserCtrl, _fbPassCtrl;
  late TextEditingController _igUserCtrl, _igPassCtrl;
  late TextEditingController _inUserCtrl, _inPassCtrl;
  late TextEditingController _tkUserCtrl, _tkPassCtrl;

  @override
  void initState() {
    super.initState();
    final acc = widget.account;
    _emailCtrl = TextEditingController(text: acc?.email ?? '');
    _passwordCtrl = TextEditingController(text: acc?.password ?? '');
    if (acc != null && _countries.contains(acc.country)) {
      _selectedCountry = acc.country;
    }

    _xUserCtrl = TextEditingController(text: acc?.xTwitter.username ?? '');
    _xPassCtrl = TextEditingController(text: acc?.xTwitter.password ?? '');
    
    _fbUserCtrl = TextEditingController(text: acc?.facebook.username ?? '');
    _fbPassCtrl = TextEditingController(text: acc?.facebook.password ?? '');
    
    _igUserCtrl = TextEditingController(text: acc?.instagram.username ?? '');
    _igPassCtrl = TextEditingController(text: acc?.instagram.password ?? '');
    
    _inUserCtrl = TextEditingController(text: acc?.linkedin.username ?? '');
    _inPassCtrl = TextEditingController(text: acc?.linkedin.password ?? '');
    
    _tkUserCtrl = TextEditingController(text: acc?.tiktok.username ?? '');
    _tkPassCtrl = TextEditingController(text: acc?.tiktok.password ?? '');
  }

  @override
  void dispose() {
    _emailCtrl.dispose(); _passwordCtrl.dispose();
    _xUserCtrl.dispose(); _xPassCtrl.dispose();
    _fbUserCtrl.dispose(); _fbPassCtrl.dispose();
    _igUserCtrl.dispose(); _igPassCtrl.dispose();
    _inUserCtrl.dispose(); _inPassCtrl.dispose();
    _tkUserCtrl.dispose(); _tkPassCtrl.dispose();
    super.dispose();
  }

  void _saveAccount() async {
    if (_formKey.currentState!.validate()) {
      final acc = Account(
        id: widget.account?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        email: _emailCtrl.text,
        password: _passwordCtrl.text,
        country: _selectedCountry,
        xTwitter: SocialMedia(username: _xUserCtrl.text, password: _xPassCtrl.text),
        facebook: SocialMedia(username: _fbUserCtrl.text, password: _fbPassCtrl.text),
        instagram: SocialMedia(username: _igUserCtrl.text, password: _igPassCtrl.text),
        linkedin: SocialMedia(username: _inUserCtrl.text, password: _inPassCtrl.text),
        tiktok: SocialMedia(username: _tkUserCtrl.text, password: _tkPassCtrl.text),
      );

      final storage = StorageService();
      final list = await storage.loadAccounts();
      
      if (widget.account != null) {
        final idx = list.indexWhere((a) => a.id == acc.id);
        if (idx != -1) list[idx] = acc;
      } else {
        list.add(acc);
      }
      
      await storage.saveAccounts(list);
      
      if (mounted) Navigator.pop(context, true);
    }
  }

  Widget _buildSocialFields(String title, IconData icon, TextEditingController userCtrl, TextEditingController passCtrl) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.cyanAccent),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: userCtrl,
              decoration: InputDecoration(
                labelText: 'Identifiant / Username', 
                filled: true, 
                fillColor: Colors.black12,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: passCtrl,
              decoration: InputDecoration(
                labelText: 'Mot de passe', 
                filled: true, 
                fillColor: Colors.black12,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.account == null ? 'Nouveau Compte' : 'Modifier Compte'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.blueAccent),
            onPressed: _saveAccount,
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Informations de l\'E-mail', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            const SizedBox(height: 15),
            TextFormField(
              controller: _emailCtrl,
              decoration: InputDecoration(labelText: 'Adresse E-mail', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
              validator: (v) => v!.isEmpty ? 'Ce champ est requis' : null,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _passwordCtrl,
              decoration: InputDecoration(labelText: 'Mot de passe de l\'e-mail', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
              obscureText: true,
              validator: (v) => v!.isEmpty ? 'Ce champ est requis' : null,
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _selectedCountry,
              items: _countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _selectedCountry = v!),
              decoration: InputDecoration(labelText: 'Pays de création', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 30),
            const Text('Réseaux Sociaux Associés', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            const SizedBox(height: 15),
            _buildSocialFields('X (Twitter)', Icons.close, _xUserCtrl, _xPassCtrl),
            _buildSocialFields('Facebook', Icons.facebook, _fbUserCtrl, _fbPassCtrl),
            _buildSocialFields('Instagram', Icons.camera_alt, _igUserCtrl, _igPassCtrl),
            _buildSocialFields('LinkedIn', Icons.work, _inUserCtrl, _inPassCtrl),
            _buildSocialFields('TikTok', Icons.music_note, _tkUserCtrl, _tkPassCtrl),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Enregistrer le compte', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}
