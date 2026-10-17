import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptitrouge/client/client.dart';
import 'package:ptitrouge/screens/register_screen.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mdpController = TextEditingController();
  Client? _client;
  bool _connexionEnCours = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: Image.asset('lib/medias/imageTitreConnexion.jpg', fit:BoxFit.cover)
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 300,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Color(0xFF181818),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Center(
                        child: const Text(
                          "P'tit Rouge",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 12,
                                offset: Offset(0, 3),
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                    )
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 4,
              child: Container(
                color: Color(0xFF181818),
                width: double.infinity,

                child: Padding (
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [

                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Adresse mail",
                          hintText: "exemple@mail.com",

                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),

                          prefixIcon: const Icon(Icons.email),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        controller: _mdpController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Mot de passe",

                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),

                          prefixIcon: const Icon(Icons.password),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _sEnregistrer,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFF710627),
                          backgroundColor: const Color(0xFF181818)
                        ),
                        child: Text(
                            "Vous n'avez pas de compte ?"
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _connexionEnCours ? null : _seConnecter,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF710627),
                          foregroundColor: Colors.white,

                          disabledBackgroundColor: Colors.grey,
                          disabledForegroundColor: Colors.white,

                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        child: Text(
                          _connexionEnCours
                              ? "Connexion..."
                              : "Connexion",
                        ),
                      ),
                    ],
                  ),
                ),

              ),
            ),
          ],
        )
    );
  }
  Future<void> _sEnregistrer() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  }
  Future<void> _seConnecter() async {
    print("DEBUT connexion");

    if (_connexionEnCours) {
      print("Déjà en cours");
      return;
    }

    setState(() {
      _connexionEnCours = true;
    });

    try {
      print("Connexion socket");

      _client ??= await Client.connecter(
        '192.168.1.90',
        4567,
      );

      print("Socket OK");

      _client!.envoyerLogin(
        _emailController.text.trim(),
        _mdpController.text,
      );

      print("LOGIN envoyé");

      String? reponse =
      await _client!.recevoirMessageDuServeur();

      print("Réponse brute >>>$reponse<<<");

      if (reponse?.trim() == "[SERVEUR] Connexion reussie !") {
        print("LOGIN RECONNU COMME OK");

        if (!mounted) return;

        print("NAVIGATION VERS HOME");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              client: _client!,
            ),
          ),
        );
      } else {
        print("LOGIN PAS RECONNU");
      }

    } catch (e) {
      print("ERREUR : $e");
      _client = null;

    } finally {
      print("FIN connexion");

      if (mounted) {
        setState(() {
          _connexionEnCours = false;
        });
      }
    }
  }
}
