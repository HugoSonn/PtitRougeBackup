import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../metier/cave/bouteille.dart';
import '../metier/cave/produit/spiritueux.dart';
import '../metier/cave/produit/vin.dart';
import '../metier/utilisateur/utilisateur.dart';

class Client {
  final Socket _socket;
  late final StreamIterator<String> _reponsesServeur;

  String? _bouteilleEnAttenteDoublon;

  Client._(this._socket) {
    final lignes = utf8.decoder
        .bind(_socket)
        .transform(const LineSplitter());

    _reponsesServeur = StreamIterator<String>(lignes);
  }

  static Future<Client> connecter(
      String ipServeur,
      int port,
      ) async {
    Socket socket = await Socket.connect(
      ipServeur,
      port,
    );

    return Client._(socket);
  }

  void envoyerMessageAuServeur(String message) {
    _socket.writeln(message);
  }

  Future<String?> recevoirMessageDuServeur() async {
    if (await _reponsesServeur.moveNext()) {
      return _reponsesServeur.current;
    }

    return null;
  }

  Object? traiterReponseServeur(String? reponseServeur) {
    if (reponseServeur == null) {
      return null;
    }

    String reponse = reponseServeur.trim();

    RegExpMatch? separation =
    RegExp(r'\s+').firstMatch(reponse);

    late String partieCommandeReponseServeur;
    String partieContenuReponseServeur = '';

    if (separation == null) {
      partieCommandeReponseServeur = reponse;
    } else {
      partieCommandeReponseServeur =
          reponse.substring(0, separation.start);

      partieContenuReponseServeur =
          reponse.substring(separation.end);
    }

    switch (partieCommandeReponseServeur) {
      case '@REPONSE_SERVEUR_DOUBLON':
        return int.parse(
          partieContenuReponseServeur,
        );

      case '@REPONSE_SERVEUR_GETCAVE':
        return recupererReponseServeurGetCaveApp(
          partieContenuReponseServeur,
        );

      case '@REPONSE_SERVEUR_GETCAVEUTILISATEUR':
        return recupererReponseServeurGetCaveApp(
          partieContenuReponseServeur,
        );

      case '@REPONSE_SERVEUR_RECHERCHEBOUTEILLE':
        return recupererReponseServeurRechercherBouteille(
          partieContenuReponseServeur,
        );

      case '@REPONSE_SERVEUR_GETPROFIL':
        return recupererReponseServeurGetProfilApp(
          partieContenuReponseServeur,
        );

      case '@REPONSE_SERVEUR_GETPROFILUTILISATEUR':
        return recupererReponseServeurGetProfilUtilisateurApp(
          partieContenuReponseServeur,
        );

      case '@REPONSE_SERVEUR_GETAMIS':
        return recupererReponseServeurGetAmisApp(
          partieContenuReponseServeur,
        );

      case '@REPONSE_SERVEUR_GETDEMANDEAMIS':
        return recupererReponseServeurGetAmisApp(
          partieContenuReponseServeur,
        );

      default:
        return reponseServeur;
    }
  }

  void envoyerLogin(
      String email,
      String mdp,
      ) {
    envoyerMessageAuServeur(
      '@LOGIN $email $mdp',
    );
  }

  void envoyerLogout() {
    envoyerMessageAuServeur(
      '@LOGOUT',
    );
  }

  void envoyerRegister(
      String pseudo,
      String email,
      String mdp,
      ) {
    envoyerMessageAuServeur(
      '@REGISTER $pseudo $email $mdp',
    );
  }

  void envoyerGetCave() {
    envoyerMessageAuServeur(
      '@GETCAVE',
    );
  }

  void envoyerGetCaveUtilisateur(
      int uidUtilisateur,
      ) {
    envoyerMessageAuServeur(
      '@GETCAVEUTILISATEUR $uidUtilisateur',
    );
  }

  void envoyerRechercherBouteille(String recherche) {
    envoyerMessageAuServeur(
        '@RECHERCHEBOUTEILLE $recherche'
    );
  }

  void envoyerAddBouteille(
      String bouteille,
      ) {
    _bouteilleEnAttenteDoublon = bouteille;

    envoyerMessageAuServeur(
      '@ADDBOUTEILLE $bouteille',
    );
  }

  void envoyerAddBouteilleForce(
      String bouteille,
      ) {
    envoyerMessageAuServeur(
      '@ADDBOUTEILLEFORCE $bouteille',
    );
  }

  void envoyerSuppBouteille(
      int idBouteille,
      ) {
    envoyerMessageAuServeur(
      '@SUPPBOUTEILLE $idBouteille',
    );
  }

  void envoyerAugmenterQte(
      int idBouteille,
      ) {
    envoyerMessageAuServeur(
      '@AUGMENTERQTE $idBouteille',
    );
  }

  void envoyerDiminuerQte(
      int idBouteille,
      ) {
    envoyerMessageAuServeur(
      '@DIMINUERQTE $idBouteille',
    );
  }

  void envoyerModifierBouteille(
      String bouteille,
      ) {
    envoyerMessageAuServeur(
      '@MODIFIERBOUTEILLE $bouteille',
    );
  }

  void envoyerGetProfil() {
    envoyerMessageAuServeur(
      '@GETPROFIL',
    );
  }

  void envoyerGetProfilUtilisateur(
      int uidUtilisateur,
      ) {
    envoyerMessageAuServeur(
      '@GETPROFILUTILISATEUR $uidUtilisateur',
    );
  }

  void envoyerAddAmis(
      int uidUtilisateur,
      ) {
    envoyerMessageAuServeur(
      '@ADDAMIS $uidUtilisateur',
    );
  }

  void envoyerAcceptAmis(
      int uidUtilisateur,
      ) {
    envoyerMessageAuServeur(
      '@ACCEPTAMIS $uidUtilisateur',
    );
  }

  void envoyerDelAmis(
      int uidUtilisateur,
      ) {
    envoyerMessageAuServeur(
      '@DELAMIS $uidUtilisateur',
    );
  }

  void envoyerGetAmis() {
    envoyerMessageAuServeur(
      '@GETAMIS',
    );
  }

  void envoyerGetDemandeAmis() {
    envoyerMessageAuServeur(
      '@GETDEMANDEAMIS',
    );
  }

  void choisirAugmenterDoublon(
      int idBouteille,
      ) {
    envoyerAugmenterQte(
      idBouteille,
    );

    _bouteilleEnAttenteDoublon = null;
  }

  void choisirAjouterDoublon() {
    if (_bouteilleEnAttenteDoublon == null) {
      throw StateError(
        "Aucune bouteille en attente de traitement",
      );
    }

    envoyerAddBouteilleForce(
      _bouteilleEnAttenteDoublon!,
    );

    _bouteilleEnAttenteDoublon = null;
  }

  List<Bouteille> recupererReponseServeurGetCaveApp(
      String reponseServeurJson,
      ) {
    List<dynamic> tableau =
    jsonDecode(reponseServeurJson);

    List<Bouteille> listeBouteilles = [];

    for (dynamic element in tableau) {
      Map<String, dynamic> objet =
      Map<String, dynamic>.from(element);

      if (objet.containsKey('typeVin')) {
        Vin vin = Vin.fromJson(objet);

        listeBouteilles.add(vin as Bouteille);
      } else if (objet.containsKey('typeSpiritueux')) {
        Spiritueux spiritueux =
        Spiritueux.fromJson(objet);

        listeBouteilles.add(spiritueux as Bouteille);
      }
    }

    return listeBouteilles;
  }

  List<Bouteille> recupererReponseServeurRechercherBouteille(
      String reponseServeurJson,
      ) {
    List<dynamic> tableau =
    jsonDecode(reponseServeurJson);

    List<Bouteille> listeBouteilles = [];

    for (dynamic element in tableau) {
      Map<String, dynamic> objet =
      Map<String, dynamic>.from(element);

      if (objet.containsKey('typeVin')) {
        Vin vin = Vin.fromJson(objet);

        listeBouteilles.add(vin as Bouteille);
      } else if (objet.containsKey('typeSpiritueux')) {
        Spiritueux spiritueux =
        Spiritueux.fromJson(objet);

        listeBouteilles.add(spiritueux as Bouteille);
      }
    }

    return listeBouteilles;
  }

  Utilisateur recupererReponseServeurGetProfilApp(
      String reponseServeurJson,
      ) {
    Map<String, dynamic> objet =
    jsonDecode(reponseServeurJson);

    return Utilisateur.fromJson(objet);
  }

  Utilisateur
  recupererReponseServeurGetProfilUtilisateurApp(
      String reponseServeurJson,
      ) {
    Map<String, dynamic> objet =
    jsonDecode(reponseServeurJson);

    return Utilisateur.fromJson(objet);
  }

  List<Utilisateur> recupererReponseServeurGetAmisApp(
      String reponseServeurJson,
      ) {
    List<dynamic> tableau =
    jsonDecode(reponseServeurJson);

    List<Utilisateur> listeAmis = [];

    for (dynamic element in tableau) {
      Map<String, dynamic> objet =
      Map<String, dynamic>.from(element);

      Utilisateur utilisateur =
      Utilisateur.fromJson(objet);

      listeAmis.add(utilisateur);
    }

    return listeAmis;
  }

  Future<void> fermerConnexion() async {
    await _reponsesServeur.cancel();
    await _socket.close();
  }
}