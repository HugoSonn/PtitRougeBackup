import 'package:flutter/material.dart';
import 'package:ptitrouge/client/client.dart';

import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mdpController = TextEditingController();
  final TextEditingController _pseudoController = TextEditingController();
  Client? _client;
  bool _enregistrementEnCours = false;
  @override
  void dispose() {
    _pseudoController.dispose();
    _emailController.dispose();
    _mdpController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 5,
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
              flex: 5,
              child: Container(
                color: Color(0xFF181818),
                width: double.infinity,

                child: Padding (
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Text("S'enregistrer",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                        fontSize: 24,
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
                      ),),
                      const SizedBox(height: 40),
                      TextField(
                        controller: _pseudoController,
                        decoration: InputDecoration(
                          labelText: "Pseudo",
                          hintText: "LeVigneron",

                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),

                          prefixIcon: const Icon(Icons.account_box),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
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
                      const SizedBox(height: 30),
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
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _enregistrementEnCours ? null : _sEnregistrer,

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
                          _enregistrementEnCours
                              ? "Enregistrement..."
                              : "S'enregistrer",
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
    print("DEBUT enregistrement");

    if (_enregistrementEnCours) {
      print("Déjà en cours");
      return;
    }

    setState(() {
      _enregistrementEnCours = true;
    });

    try {
      print("Connexion socket");

      _client ??= await Client.connecter(
        '192.168.1.90',
        4567,
      );

      print("Socket OK");

      _client!.envoyerRegister(
        _pseudoController.text.trim(),
        _emailController.text.trim(),
        _mdpController.text,
      );

      print("REGISTER envoyé");

      String? reponseRegister =
      await _client!.recevoirMessageDuServeur();

      print("REGISTER => $reponseRegister");

      if (reponseRegister == "[SERVEUR] Enregistrement reussi !") {
        _client!.envoyerLogin(
          _emailController.text.trim(),
          _mdpController.text,
        );

        String? reponseLogin =
        await _client!.recevoirMessageDuServeur();

        print("LOGIN => $reponseLogin");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(client: _client!),
          ),
        );
      }

    } catch (e) {
      print("ERREUR : $e");
      _client = null;

    } finally {
      print("FIN enregistrement");


      if (mounted) {
        setState(() {
          _enregistrementEnCours = false;
        });
      }
    }
  }
}
// COMPTE TEST :
// PSEUDO : jo
// EMAIL : jo@test.fr
// MDP : jojo57!