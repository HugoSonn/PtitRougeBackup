class Bouteille {
  int _id = 0;
  late String _nom;
  late String _commentaire;
  late double _tauxAlcool;
  late double _volume;
  int _quantite = 0;

  Bouteille(
      String nom,
      String commentaire,
      double tauxAlcool,
      double volume, {
        int id = 0,
      }) : _id = id {
    this.nom = nom;
    this.commentaire = commentaire;
    this.tauxAlcool = tauxAlcool;
    this.volume = volume;

    augmenterQuantite();
  }

  Bouteille.avecId(
      String nom,
      String commentaire,
      double tauxAlcool,
      double volume,
      int id,
      ) : this(
    nom,
    commentaire,
    tauxAlcool,
    volume,
    id: id,
  );

  Bouteille.avecQuantite(
      String nom,
      String commentaire,
      double tauxAlcool,
      double volume,
      int quantite,
      ) {
    this.nom = nom;
    this.commentaire = commentaire;
    this.tauxAlcool = tauxAlcool;
    this.volume = volume;
    this.quantite = quantite;
  }

  void augmenterQuantite() {
    _quantite = _quantite + 1;
  }

  void retirerQuantite() {
    if (_quantite <= 0) {
      throw Exception("Quantite deja a 0");
    }

    _quantite--;
  }

  set nom(String nom) {
    if (nom.trim().isEmpty) {
      throw Exception("Nom NULL ou VIDE");
    }

    _nom = nom;
  }

  set commentaire(String commentaire) {
    _commentaire = commentaire;
  }

  set tauxAlcool(double tauxAlcool) {
    if (tauxAlcool < 0) {
      throw Exception("TauxAlcool INFERIEUR a 0");
    }

    _tauxAlcool = tauxAlcool;
  }

  set volume(double volume) {
    if (volume < 0) {
      throw Exception("Volume INFERIEUR a 0");
    }

    _volume = volume;
  }

  set quantite(int quantite) {
    if (quantite < 0) {
      throw ArgumentError("Quantite invalide");
    }

    _quantite = quantite;
  }

  String get nom => _nom;

  String get commentaire => _commentaire;

  double get tauxAlcool => _tauxAlcool;

  double get volume => _volume;

  int get id => _id;

  int get quantite => _quantite;

  @override
  int get hashCode =>
      Object.hash(_nom, _commentaire, _tauxAlcool, _volume);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other.runtimeType == runtimeType &&
        other is Bouteille &&
        other.nom == _nom &&
        other.commentaire == _commentaire &&
        other.tauxAlcool == _tauxAlcool &&
        other.volume == _volume;
  }
}