import 'package:flutter/material.dart';
import '../models/account.dart';
import '../services/storage_service.dart';
import 'add_edit_account_screen.dart';
import 'account_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  List<Account> accounts = [];
  bool isLoading = true;
  String? _filterCountry;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    final data = await _storageService.loadAccounts();
    setState(() {
      accounts = data;
      isLoading = false;
    });
  }

  List<Account> get filteredAccounts {
    if (_filterCountry == null) return accounts;
    return accounts.where((a) => a.country == _filterCountry).toList();
  }

  void _showFilterDialog() {
    final Set<String> countries = accounts.map((a) => a.country).toSet();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text('Filtrer par pays'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Tous les pays'),
                onTap: () {
                  setState(() => _filterCountry = null);
                  Navigator.pop(ctx);
                },
              ),
              ...countries.map((c) => ListTile(
                title: Text(c),
                onTap: () {
                  setState(() => _filterCountry = c);
                  Navigator.pop(ctx);
                },
              ))
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = filteredAccounts;
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Mes Comptes'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_filterCountry == null ? Icons.filter_list : Icons.filter_list_off, color: Colors.blueAccent),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : list.isEmpty
          ? const Center(
              child: Text(
                'Aucun compte enregistré.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: list.length,
              itemBuilder: (ctx, i) {
                final acc = list[i];
                return Card(
                  color: const Color(0xFF1E1E1E),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent.withOpacity(0.2),
                      child: const Icon(Icons.email, color: Colors.blueAccent),
                    ),
                    title: Text(acc.email, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    subtitle: Text(acc.country, style: const TextStyle(color: Colors.grey)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
                    onTap: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (_) => AccountDetailScreen(account: acc)));
                      _loadData(); // Recharger au retour pour mettre à jour
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditAccountScreen()));
          if (result == true) {
            _loadData();
          }
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
