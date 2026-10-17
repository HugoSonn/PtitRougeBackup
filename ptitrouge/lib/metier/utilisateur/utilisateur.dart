import 'package:ptitrouge/metier/utilisateur/utilisateur.dart' as prefix0;

import '../cave/cave.dart';

class Utilisateur {
  int _uid;
  late String _pseudo;
  late String _email;
  String? _mdp;

  late Cave _cave;

  final List<Utilisateur> _amis = [];

  Utilisateur({
    int uid = 0,
    required String pseudo,
    required String email,
    String? mdp,
  }) : _uid = uid {
    this.pseudo = pseudo;
    this.email = email;

    if (mdp != null) {
      this.mdp = mdp;
    }

    _cave = Cave(this as prefix0.Utilisateur);
  }

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur.profil(
      uid: (json['uid'] as num).toInt(),
      pseudo: json['pseudo'],
      email: json['email'],
    );
  }

  // Équivalent de ton constructeur Java sans UID
  Utilisateur.nouveau({
    required String pseudo,
    required String email,
    required String mdp,
  }) : this(
    pseudo: pseudo,
    email: email,
    mdp: mdp,
  );

  // Équivalent du constructeur profil sans mot de passe
  Utilisateur.profil({
    required int uid,
    required String pseudo,
    required String email,
  }) : this(
    uid: uid,
    pseudo: pseudo,
    email: email,
  );

  void ajouterAmis(Utilisateur utilisateur) {
    _amis.add(utilisateur);
  }

  void retirerAmis(Utilisateur utilisateur) {
    _amis.remove(utilisateur);
  }

  bool estAmisAvec(Utilisateur utilisateur) {
    return _amis.contains(utilisateur);
  }

  set pseudo(String pseudo) {
    if (pseudo.isEmpty) {
      throw ArgumentError("Pseudo NULL ou VIDE");
    }

    _pseudo = pseudo;
  }

  set email(String email) {
    if (email.isEmpty) {
      throw ArgumentError("Email NULL ou VIDE");
    }

    _email = email;
  }

  set mdp(String mdp) {
    if (mdp.isEmpty) {
      throw ArgumentError("Mdp NULL ou VIDE");
    }

    if (mdp.length < 6) {
      throw ArgumentError("Mdp est INFERIEUR a 6 caracteres");
    }

    if (!RegExp(r'\d').hasMatch(mdp)) {
      throw ArgumentError("Il faut au moins un chiffre");
    }

    _mdp = mdp;
  }

  int get uid => _uid;

  String get pseudo => _pseudo;

  String get email => _email;

  String? get mdp => _mdp;

  Cave get cave => _cave;

  List<Utilisateur> get amis => List.unmodifiable(_amis);

  int get nombreAmis => _amis.length;

  @override
  int get hashCode => _email.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Utilisateur &&
        other.email == _email;
  }
}