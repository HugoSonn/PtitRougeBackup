import 'package:ptitrouge/metier/cave/produit/type.spiritueux.dart';

import '../bouteille.dart';

class Spiritueux extends Bouteille {
  late TypeSpiritueux _typeSpiritueux;

  Spiritueux(
      String nom,
      String commentaire,
      double tauxAlcool,
      double volume,
      int quantite,
      TypeSpiritueux typeSpiritueux,
      ) : super.avecQuantite(
    nom,
    commentaire,
    tauxAlcool,
    volume,
    quantite,
  ) {
    this.typeSpiritueux = typeSpiritueux;
  }

  factory Spiritueux.fromJson(Map<String, dynamic> json) {
    return Spiritueux(
      json['nom'],
      json['commentaire'] ?? '',
      (json['tauxAlcool'] as num).toDouble(),
      (json['volume'] as num).toDouble(),
      (json['quantite'] as num).toInt(),
      TypeSpiritueux.values.byName(
        json['typeSpiritueux'],
      ),
    );
  }

  set typeSpiritueux(TypeSpiritueux typeSpiritueux) {
    _typeSpiritueux = typeSpiritueux;
  }

  TypeSpiritueux get typeSpiritueux => _typeSpiritueux;

  @override
  int get hashCode {
    return Object.hash(
      super.hashCode,
      _typeSpiritueux,
    );
  }
}