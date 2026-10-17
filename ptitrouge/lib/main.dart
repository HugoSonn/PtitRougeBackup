import 'package:flutter/material.dart';
import 'package:ptitrouge/screens/bibliotheque_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PtitRougeApp());
}

class PtitRougeApp extends StatelessWidget {
  const PtitRougeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PtitRouge',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
      ),

      //home: HomeScreen(client: null),
      //home: BibliothequeScreen(client: null,),
      home: LoginScreen(),
    );
  }
}