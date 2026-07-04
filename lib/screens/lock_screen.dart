import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'home_screen.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
      });
      // Demande l'authentification (Empreinte, FaceID, ou Code PIN)
      authenticated = await auth.authenticate(
        localizedReason: 'Veuillez vous authentifier pour accéder à vos comptes',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (e) {
      debugPrint("Erreur d'authentification : $e");
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
        if (authenticated) {
          // Navigue vers l'écran d'accueil
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Mode Sombre par défaut
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield_moon_outlined, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 20),
            const Text(
              'Account Manager',
              style: TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.bold, 
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Verrouillage de sécurité actif',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 50),
            if (_isAuthenticating)
              const CircularProgressIndicator(color: Colors.blueAccent)
            else
              ElevatedButton.icon(
                onPressed: _authenticate,
                icon: const Icon(Icons.fingerprint),
                label: const Text('Déverrouiller'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.withOpacity(0.2),
                  foregroundColor: Colors.blueAccent,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
