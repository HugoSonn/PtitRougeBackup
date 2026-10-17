import 'package:ptitrouge/metier/cave/produit/spiritueux.dart';
import 'package:ptitrouge/metier/cave/produit/type.spiritueux.dart';
import 'package:ptitrouge/metier/cave/produit/type_vin.dart';
import 'package:ptitrouge/metier/cave/produit/vin.dart';
import 'package:ptitrouge/metier/cave/type_bouteille.dart';

import '../utilisateur/utilisateur.dart';
import 'bouteille.dart';

class Cave {
  Utilisateur _proprietaire;

  final List<Bouteille> _bouteilles = [];

  Cave(this._proprietaire);

  void enregistrerBouteille(
      String nom,
      String commentaire,
      double tauxAlcool,
      double volume,
      int quantite,
      TypeSpiritueux typeSpiritueux,
      int millesime,
      TypeVin typeVin,
      TypeBouteille typeBouteille,
      ) {
    if (typeBouteille == TypeBouteille.VIN) {
      Vin vin = Vin(
        nom,
        commentaire,
        tauxAlcool,
        volume,
        millesime,
        quantite,
        typeVin,
      );

      ajouterBouteille(vin as Bouteille);
    }

    if (typeBouteille == TypeBouteille.SPIRITUEUX) {
      Spiritueux spiritueux = Spiritueux(
        nom,
        commentaire,
        tauxAlcool,
        volume,
        quantite,
        typeSpiritueux,
      );

      ajouterBouteille(spiritueux as Bouteille);
    }
  }

  void ajouterBouteille(Bouteille bouteille) {
    for (Bouteille bouteilleCourante in _bouteilles) {
      if (bouteilleCourante == bouteille) {
        bouteilleCourante.augmenterQuantite();
        return;
      }
    }

    _bouteilles.add(bouteille);
  }

  set proprietaire(Utilisateur proprietaire) {
    _proprietaire = proprietaire;
  }

  Utilisateur get proprietaire => _proprietaire;

  int get nombreVins {
    int nombreVins = 0;

    for (Bouteille bouteilleCourante in _bouteilles) {
      if (bouteilleCourante is Vin) {
        nombreVins += bouteilleCourante.quantite;
      }
    }

    return nombreVins;
  }

  int? get nombreSpiritueux {
    int? nombreSpiritueux = 0;

    for (Bouteille bouteilleCourante in _bouteilles) {
      if (bouteilleCourante is Spiritueux) {
        nombreSpiritueux = (nombreSpiritueux! + bouteilleCourante.quantite)!;
      }
    }

    return nombreSpiritueux;
  }

  int get nombreBouteilles {
    return nombreVins + nombreSpiritueux!;
  }

  List<Bouteille> get bouteilles => List.unmodifiable(_bouteilles);
}