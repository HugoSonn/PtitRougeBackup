import 'package:ptitrouge/metier/cave/produit/type_vin.dart';

import '../bouteille.dart';

class Vin extends Bouteille {
  late int _millesime;
  late TypeVin _typeVin;

  Vin(
      String nom,
      String commentaire,
      double tauxAlcool,
      double volume,
      int quantite,
      int millesime,
      TypeVin typeVin,
      ) : super.avecQuantite(
    nom,
    commentaire,
    tauxAlcool,
    volume,
    quantite,
  ) {
    this.millesime = millesime;
    this.typeVin = typeVin;
  }

  factory Vin.fromJson(Map<String, dynamic> json) {
    return Vin(
      json['nom'],
      json['commentaire'] ?? '',
      (json['tauxAlcool'] as num).toDouble(),
      (json['volume'] as num).toDouble(),
      (json['quantite'] as num).toInt(),
      (json['millesime'] as num).toInt(),
      TypeVin.values.byName(json['typeVin']),
    );
  }

  set millesime(int millesime) {
    if (millesime < 0) {
      throw Exception("Millesime INFERIEUR a 0");
    }

    _millesime = millesime;
  }

  set typeVin(TypeVin typeVin) {
    _typeVin = typeVin;
  }

  int get millesime => _millesime;

  TypeVin get typeVin => _typeVin;

  @override
  int get hashCode {
    return Object.hash(
      super.hashCode,
      _millesime,
      _typeVin,
    );
  }
}