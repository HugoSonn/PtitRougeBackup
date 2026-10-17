import 'dart:convert';
import 'package:flutter/material.dart';

import '../client/client.dart';
import '../metier/cave/bouteille.dart';

class BibliothequeScreen extends StatefulWidget {
  final Client? _client;
  const BibliothequeScreen({super.key, required this._client});
  @override
  State<BibliothequeScreen> createState() => _BibliothequeScreenState();
}

class _BibliothequeScreenState extends State<BibliothequeScreen> {
  static const Color _backgroundColor = Color(0xFF181818);
  static const Color _primaryColor = Color(0xFF710627);
  static const Color _cardColor = Color(0xFF242424);

  final TextEditingController _rechercheController =
  TextEditingController();

  String _triSelection = "AGE";
  String _ordreSelection = "ASC";
  List<Bouteille> _resultatRecherche = [];

  final PageController _pageController = PageController(
    viewportFraction: 0.86,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _lancerRecherche();
    });
  }

  @override
  void dispose() {
    _rechercheController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,

      body: SafeArea(
        child: Column(
          children: [
            _header(),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),

                child: Column(
                  children: [
                    const SizedBox(height: 25),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _rechercheEtTri(),
                    ),

                    const SizedBox(height: 15),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _boutonsAjout(),
                    ),

                    const SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Mes bouteilles",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),

                            decoration: BoxDecoration(
                              color: _primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Text(
                              "${_resultatRecherche.length}",

                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _listeBouteilles(),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // HEADER
  // --------------------------------------------------

  Widget _header() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ),

      decoration: const BoxDecoration(
        color: _backgroundColor,

        border: Border(
          bottom: BorderSide(
            color: Colors.white10,
          ),
        ),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          IconButton(
            onPressed: _boutonMenuHeader,

            icon: const Icon(
              Icons.menu_rounded,
              size: 32,
              color: Colors.white,
            ),
          ),

          const Text(
            "Ma Cave",

            style: TextStyle(
              fontSize: 28,
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

          IconButton(
            onPressed: _boutonAmisHeader,

            icon: const Icon(
              Icons.account_circle_rounded,
              size: 34,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // RECHERCHE ET TRI
  // --------------------------------------------------

  Widget _rechercheEtTri() {
    return Container(
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),

        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8C0B35),
            Color(0xFF4B041B),
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Rechercher dans votre cave",

            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            "Trouvez rapidement une bouteille",

            style: TextStyle(
              fontSize: 14,
              color: Colors.white60,
            ),
          ),

          const SizedBox(height: 20),

          // RECHERCHE
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _rechercheController,

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(
                    hintText: "Nom d'une bouteille...",

                    hintStyle: const TextStyle(
                      color: Colors.white38,
                    ),

                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Colors.white70,
                    ),

                    filled: true,
                    fillColor: const Color(0xFF242424),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Colors.white10,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFF9E2349),
                        width: 2,
                      ),
                    ),
                  ),

                  onSubmitted: (_) {
                    _lancerRecherche();
                  },
                ),
              ),

              const SizedBox(width: 10),

              SizedBox(
                height: 56,
                width: 56,

                child: ElevatedButton(
                  onPressed: _lancerRecherche,

                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,

                    backgroundColor: const Color(0xFF710627),
                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: const Icon(
                    Icons.search_rounded,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              // TRI
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  initialValue: _triSelection,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF242424),

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),

                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white70,
                  ),

                  decoration: InputDecoration(
                    labelText: "Trier par",

                    labelStyle: const TextStyle(
                      color: Colors.white60,
                    ),

                    prefixIcon: const Icon(
                      Icons.sort_rounded,
                      color: Color(0xFF9E2349),
                    ),

                    filled: true,
                    fillColor: const Color(0xFF242424),

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Colors.white10,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFF9E2349),
                        width: 2,
                      ),
                    ),
                  ),

                  items: const [
                    DropdownMenuItem(
                      value: "AGE",
                      child: Text("Âge"),
                    ),
                    DropdownMenuItem(
                      value: "ALCOOL",
                      child: Text("Alcool"),
                    ),
                    DropdownMenuItem(
                      value: "VOLUME",
                      child: Text("Volume"),
                    ),
                  ],

                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _triSelection = value;
                      });

                      _lancerRecherche();
                    }
                  },
                ),
              ),

              const SizedBox(width: 10),

              // ORDRE
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  initialValue: _ordreSelection,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF242424),

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),

                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white70,
                  ),

                  decoration: InputDecoration(
                    labelText: "Ordre",

                    labelStyle: const TextStyle(
                      color: Colors.white60,
                    ),

                    filled: true,
                    fillColor: const Color(0xFF242424),

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Colors.white10,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFF9E2349),
                        width: 2,
                      ),
                    ),
                  ),

                  items: const [
                    DropdownMenuItem(
                      value: "ASC",
                      child: Text("Croissant"),
                    ),
                    DropdownMenuItem(
                      value: "DESC",
                      child: Text("Décroissant"),
                    ),
                  ],

                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _ordreSelection = value;
                      });

                      _lancerRecherche();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }




  Widget _boutonsAjout() {
    return Row(
      children: [
        Expanded(
          child: _petitBoutonAjout(
            titre: "Ajouter un vin",
            icone: Icons.wine_bar_rounded,
            onTap: _ouvrirPopupAjouterVin,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _petitBoutonAjout(
            titre: "Ajouter un spiritueux",
            icone: Icons.liquor_rounded,
            onTap: _ouvrirPopupAjouterSpiritueux,
          ),
        ),
      ],
    );
  }


  Widget _petitBoutonAjout({
    required String titre,
    required IconData icone,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),

        child: Ink(
          height: 75,

          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),

          decoration: BoxDecoration(
            color: _cardColor,

            borderRadius: BorderRadius.circular(16),

            border: Border.all(
              color: Colors.white10,
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.20),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,

                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Icon(
                  icone,
                  color: Colors.white,
                  size: 24,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  titre,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),

                  maxLines: 2,
                ),
              ),

              const Icon(
                Icons.add_rounded,
                color: Colors.white54,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _ouvrirPopupAjouterBouteille() async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: const Color(0xFF181818),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Ajouter une bouteille",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),

                    IconButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                const Text(
                  "Que souhaitez-vous ajouter à votre cave ?",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: _boutonTypeBouteille(
                        titre: "Vin",
                        icone: Icons.wine_bar_rounded,
                        onTap: () {
                          Navigator.pop(dialogContext);
                          _ouvrirPopupAjouterVin();
                        },
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: _boutonTypeBouteille(
                        titre: "Spiritueux",
                        icone: Icons.liquor_rounded,
                        onTap: () {
                          Navigator.pop(dialogContext);
                          _ouvrirPopupAjouterSpiritueux();
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _boutonTypeBouteille({
    required String titre,
    required IconData icone,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),

      child: Container(
        height: 140,

        decoration: BoxDecoration(
          color: const Color(0xFF242424),
          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: Colors.white10,
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 55,
              height: 55,

              decoration: BoxDecoration(
                color: const Color(0xFF710627),
                borderRadius: BorderRadius.circular(16),
              ),

              child: Icon(
                icone,
                color: Colors.white,
                size: 30,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              titre,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _champPopup({
    required TextEditingController controller,
    required String label,
    required IconData icone,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,

      style: const TextStyle(
        color: Colors.white,
      ),

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,

        labelStyle: const TextStyle(
          color: Colors.white60,
        ),

        hintStyle: const TextStyle(
          color: Colors.white30,
        ),

        prefixIcon: Icon(
          icone,
          color: const Color(0xFF9E2349),
        ),

        filled: true,
        fillColor: const Color(0xFF242424),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.white10,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF9E2349),
            width: 2,
          ),
        ),
      ),
    );
  }

  Future<void> _ouvrirPopupAjouterVin() async {
    final nomController = TextEditingController();
    final commentaireController = TextEditingController();
    final alcoolController = TextEditingController();
    final volumeController = TextEditingController();
    final quantiteController = TextEditingController();
    final millesimeController = TextEditingController();

    String typeVin = "ROUGE";

    final Map<String, dynamic>? bouteille = await showDialog(
      context: context,

      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: const Color(0xFF181818),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),

              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 450,
                ),

                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Text(
                            "Ajouter un vin",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      _champPopup(
                        controller: nomController,
                        label: "Nom",
                        hint: "Château Margaux",
                        icone: Icons.wine_bar_rounded,
                      ),

                      const SizedBox(height: 15),

                      _champPopup(
                        controller: commentaireController,
                        label: "Commentaire",
                        icone: Icons.notes_rounded,
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: _champPopup(
                              controller: alcoolController,
                              label: "Alcool %",
                              icone: Icons.percent_rounded,
                              keyboardType: TextInputType.number,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: _champPopup(
                              controller: volumeController,
                              label: "Volume (L)",
                              icone: Icons.local_drink_rounded,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: _champPopup(
                              controller: quantiteController,
                              label: "Quantité",
                              icone: Icons.numbers_rounded,
                              keyboardType: TextInputType.number,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: _champPopup(
                              controller: millesimeController,
                              label: "Millésime",
                              icone: Icons.calendar_month_rounded,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      DropdownButtonFormField<String>(
                        initialValue: typeVin,

                        dropdownColor: const Color(0xFF242424),

                        style: const TextStyle(
                          color: Colors.white,
                        ),

                        decoration: InputDecoration(
                          labelText: "Type de vin",
                          labelStyle: const TextStyle(
                            color: Colors.white60,
                          ),

                          prefixIcon: const Icon(
                            Icons.palette_rounded,
                            color: Color(0xFF9E2349),
                          ),

                          filled: true,
                          fillColor: const Color(0xFF242424),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),

                        items: const [
                          DropdownMenuItem(
                            value: "ROUGE",
                            child: Text("Rouge"),
                          ),
                          DropdownMenuItem(
                            value: "BLANC",
                            child: Text("Blanc"),
                          ),
                          DropdownMenuItem(
                            value: "ROSE",
                            child: Text("Rosé"),
                          ),
                        ],

                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              typeVin = value;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton.icon(
                          onPressed: () {
                            final alcool =
                            double.tryParse(alcoolController.text);

                            final volume =
                            double.tryParse(volumeController.text);

                            final quantite =
                            int.tryParse(quantiteController.text);

                            final millesime =
                            int.tryParse(millesimeController.text);

                            if (nomController.text.trim().isEmpty ||
                                alcool == null ||
                                volume == null ||
                                quantite == null ||
                                millesime == null) {
                              return;
                            }

                            Navigator.pop(
                              dialogContext,
                              {
                                "nom": nomController.text.trim(),
                                "commentaire":
                                commentaireController.text.trim(),
                                "tauxAlcool": alcool,
                                "volume": volume,
                                "quantite": quantite,
                                "millesime": millesime,
                                "typeVin": typeVin,
                              },
                            );
                          },

                          icon: const Icon(
                            Icons.add_rounded,
                          ),

                          label: const Text(
                            "Ajouter à ma cave",
                          ),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF710627),
                            foregroundColor: Colors.white,

                            padding: const EdgeInsets.symmetric(
                              vertical: 17,
                            ),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (bouteille != null) {
      final jsonBouteille = jsonEncode(bouteille);

      print(jsonBouteille);

      widget._client?.envoyerAddBouteille(
        jsonBouteille,
      );
    }
  }

  Future<void> _ouvrirPopupAjouterSpiritueux() async {
    final nomController = TextEditingController();
    final commentaireController = TextEditingController();
    final alcoolController = TextEditingController();
    final volumeController = TextEditingController();
    final quantiteController = TextEditingController();

    String typeSpiritueux = "WHISKY";

    final Map<String, dynamic>? bouteille = await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: const Color(0xFF181818),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 450,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Ajouter un spiritueux",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      _champPopup(
                        controller: nomController,
                        label: "Nom",
                        hint: "Rhum des îles",
                        icone: Icons.wine_bar_rounded,
                      ),

                      const SizedBox(height: 15),

                      _champPopup(
                        controller: commentaireController,
                        label: "Commentaire",
                        icone: Icons.notes_rounded,
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: _champPopup(
                              controller: alcoolController,
                              label: "Alcool %",
                              icone: Icons.percent_rounded,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _champPopup(
                              controller: volumeController,
                              label: "Volume (L)",
                              icone: Icons.local_drink_rounded,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      _champPopup(
                        controller: quantiteController,
                        label: "Quantité",
                        icone: Icons.numbers_rounded,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 15),

                      DropdownButtonFormField<String>(
                        initialValue: typeSpiritueux,
                        dropdownColor: const Color(0xFF242424),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          labelText: "Type de spiritueux",
                          labelStyle: const TextStyle(
                            color: Colors.white60,
                          ),
                          prefixIcon: const Icon(
                            Icons.palette_rounded,
                            color: Color(0xFF9E2349),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF242424),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "WHISKY",
                            child: Text("Whisky"),
                          ),
                          DropdownMenuItem(
                            value: "RHUM",
                            child: Text("Rhum"),
                          ),
                          DropdownMenuItem(
                            value: "COGNAC",
                            child: Text("Cognac"),
                          ),
                          DropdownMenuItem(
                            value: "ARMAGNAC",
                            child: Text("Armagnac"),
                          ),
                          DropdownMenuItem(
                            value: "VODKA",
                            child: Text("Vodka"),
                          ),
                          DropdownMenuItem(
                            value: "GIN",
                            child: Text("Gin"),
                          ),
                          DropdownMenuItem(
                            value: "TEQUILA",
                            child: Text("Tequila"),
                          ),
                          DropdownMenuItem(
                            value: "LIQUEUR",
                            child: Text("Liqueur"),
                          ),
                          DropdownMenuItem(
                            value: "AUTRE",
                            child: Text("Autre"),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              typeSpiritueux = value;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final alcool =
                            double.tryParse(alcoolController.text);

                            final volume =
                            double.tryParse(volumeController.text);

                            final quantite =
                            int.tryParse(quantiteController.text);

                            if (nomController.text.trim().isEmpty ||
                                alcool == null ||
                                volume == null ||
                                quantite == null) {
                              return;
                            }

                            Navigator.pop(
                              dialogContext,
                              {
                                "nom": nomController.text.trim(),
                                "commentaire":
                                commentaireController.text.trim(),
                                "tauxAlcool": alcool,
                                "volume": volume,
                                "quantite": quantite,
                                "typeSpiritueux": typeSpiritueux,
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.add_rounded,
                          ),
                          label: const Text(
                            "Ajouter à ma cave",
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF710627),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 17,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (bouteille != null) {
      final jsonBouteille = jsonEncode(bouteille);

      print(jsonBouteille);

      widget._client?.envoyerAddBouteille(
        jsonBouteille,
      );
    }
  }

  Widget _carteRaccourci({
    required String titre,
    required String sousTitre,
    required IconData icone,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          onTap: () {
            if (titre == "Ajouter une bouteille") {
              _ouvrirPopupAjouterBouteille();
            }
          },

          borderRadius: BorderRadius.circular(20),

          child: Ink(
            padding: const EdgeInsets.all(22),

            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(20),

              border: Border.all(
                color: Colors.white10,
              ),
            ),

            child: Row(
              children: [
                Container(
                  width: 65,
                  height: 65,

                  decoration: BoxDecoration(
                    color: _primaryColor,
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Icon(
                    icone,
                    size: 34,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        titre,

                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        sousTitre,

                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _titreSection(String titre) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),

      child: Align(
        alignment: Alignment.centerLeft,

        child: Text(
          titre,

          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _lancerRecherche() async {
    final recherche = _rechercheController.text.trim();
    final parametrePourRequete = '$recherche $_triSelection $_ordreSelection';
    print("Recherche : $parametrePourRequete");

    widget._client?.envoyerRechercherBouteille(parametrePourRequete);
    String? reponseServeur = await widget._client?.recevoirMessageDuServeur();
    print("Reponse serveur : $reponseServeur");

    Object? resultat = widget._client?.traiterReponseServeur(reponseServeur);

    if (!mounted) return;

    if (resultat is List<Bouteille>) {
      setState(() {
        _resultatRecherche = resultat;
      });

      print(
        "${_resultatRecherche.length} bouteille(s) trouvée(s)",
      );
    }

  }

  // --------------------------------------------------
  // ACTIONS
  // --------------------------------------------------

  Future<void> _boutonMenuHeader() async {
    print("Menu");
  }

  Future<void> _boutonAmisHeader() async {
    print("Profil");
  }

  Widget _listeBouteilles() {
    if (_resultatRecherche.isEmpty) {
      return Container(
        width: double.infinity,

        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 40,
        ),

        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: Colors.white10,
          ),
        ),

        child: const Column(
          children: [
            Icon(
              Icons.wine_bar_outlined,
              size: 55,
              color: Colors.white24,
            ),

            SizedBox(height: 15),

            Text(
              "Aucune bouteille trouvée",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 6),

            Text(
              "Essayez une autre recherche",
              style: TextStyle(
                color: Colors.white38,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,

      physics: const NeverScrollableScrollPhysics(),

      itemCount: _resultatRecherche.length,

      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },

      itemBuilder: (context, index) {
        final bouteille = _resultatRecherche[index];

        return _carteBouteille(bouteille);
      },
    );
  }

  Widget _carteBouteille(Bouteille bouteille) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: () {
          _ouvrirDetailBouteille(bouteille);
        },

        borderRadius: BorderRadius.circular(20),

        child: Ink(
          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: _cardColor,

            borderRadius: BorderRadius.circular(20),

            border: Border.all(
              color: Colors.white10,
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),

          child: Row(
            children: [
              // ICONE
              Container(
                width: 58,
                height: 58,

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,

                    colors: [
                      Color(0xFF8C0B35),
                      Color(0xFF4B041B),
                    ],
                  ),

                  borderRadius: BorderRadius.circular(16),
                ),

                child: const Icon(
                  Icons.wine_bar_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),

              const SizedBox(width: 16),

              // INFOS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      bouteille.nom,

                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        _infoBouteille(
                          Icons.percent_rounded,
                          "${bouteille.tauxAlcool}%",
                        ),

                        const SizedBox(width: 14),

                        _infoBouteille(
                          Icons.local_drink_rounded,
                          "${bouteille.volume} L",
                        ),
                      ],
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        _infoBouteille(
                          Icons.inventory_2_outlined,
                          "Qté : ${bouteille.quantite}",
                        ),
                      ],
                    ),

                    if (bouteille.commentaire.isNotEmpty) ...[
                      const SizedBox(height: 8),

                      Text(
                        bouteille.commentaire,

                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white38,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _ouvrirDetailBouteille(Bouteille bouteille) async {
    final PageController photoController = PageController();

    bool modeModification = false;
    int photoIndex = 0;
    String? erreurModification;

    // TEMPORAIRE : permet de tester le swipe du carousel tant que les
    // vraies photos ne sont pas encore stockees / renvoyees par le serveur.
    const int nombrePhotosDemo = 3;

    // Valeurs affichees dans la fiche. Elles permettent de voir immediatement
    // le resultat d'une modification, meme avant le branchement de la requete
    // de mise a jour cote serveur.
    String nomAffiche = bouteille.nom;
    double alcoolAffiche = bouteille.tauxAlcool;
    double volumeAffiche = bouteille.volume;
    int quantiteAffiche = bouteille.quantite;
    String commentaireAffiche = bouteille.commentaire;

    final nomController = TextEditingController(text: nomAffiche);
    final alcoolController = TextEditingController(
      text: alcoolAffiche.toString(),
    );
    final volumeController = TextEditingController(
      text: volumeAffiche.toString(),
    );
    final quantiteController = TextEditingController(
      text: quantiteAffiche.toString(),
    );
    final commentaireController = TextEditingController(
      text: commentaireAffiche,
    );

    void restaurerChamps() {
      nomController.text = nomAffiche;
      alcoolController.text = alcoolAffiche.toString();
      volumeController.text = volumeAffiche.toString();
      quantiteController.text = quantiteAffiche.toString();
      commentaireController.text = commentaireAffiche;
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return FractionallySizedBox(
              heightFactor: 0.92,
              child: Container(
                decoration: const BoxDecoration(
                  color: _backgroundColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // Petite barre de glissement de la bottom-sheet.
                    Container(
                      width: 45,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ------------------------------------------
                            // EN-TETE
                            // ------------------------------------------
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      AnimatedSwitcher(
                                        duration:
                                        const Duration(milliseconds: 180),
                                        child: modeModification
                                            ? TextField(
                                          key: const ValueKey(
                                            'nom-modification',
                                          ),
                                          controller: nomController,
                                          textCapitalization:
                                          TextCapitalization.words,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w800,
                                          ),
                                          decoration: InputDecoration(
                                            labelText: "Nom",
                                            labelStyle: const TextStyle(
                                              color: Colors.white54,
                                            ),
                                            filled: true,
                                            fillColor: _cardColor,
                                            contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 14,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                14,
                                              ),
                                              borderSide: BorderSide.none,
                                            ),
                                            enabledBorder:
                                            OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                14,
                                              ),
                                              borderSide:
                                              const BorderSide(
                                                color: Colors.white10,
                                              ),
                                            ),
                                            focusedBorder:
                                            OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                14,
                                              ),
                                              borderSide:
                                              const BorderSide(
                                                color: Color(0xFF9E2349),
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                        )
                                            : Text(
                                          nomAffiche,
                                          key: const ValueKey(
                                            'nom-lecture',
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 27,
                                            fontWeight: FontWeight.w900,
                                            height: 1.1,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _primaryColor.withValues(
                                            alpha: 0.22,
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(999),
                                          border: Border.all(
                                            color: const Color(0xFF9E2349)
                                                .withValues(alpha: 0.38),
                                          ),
                                        ),
                                        child: Text(
                                          bouteille.runtimeType.toString(),
                                          style: const TextStyle(
                                            color: Color(0xFFD16A8A),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 10),

                                IconButton(
                                  tooltip: "Fermer",
                                  onPressed: () {
                                    Navigator.pop(bottomSheetContext);
                                  },
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.white70,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 22),

                            // ------------------------------------------
                            // CAROUSEL PHOTOS
                            // ------------------------------------------
                            SizedBox(
                              height: 285,
                              child: PageView.builder(
                                controller: photoController,
                                itemCount: nombrePhotosDemo,
                                onPageChanged: (index) {
                                  setModalState(() {
                                    photoIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF363636),
                                            Color(0xFF202020),
                                          ],
                                        ),
                                        border: Border.all(
                                          color: Colors.white10,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.20,
                                            ),
                                            blurRadius: 14,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          const Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.add_a_photo_outlined,
                                                  color: Colors.white30,
                                                  size: 62,
                                                ),
                                                SizedBox(height: 12),
                                                Text(
                                                  "Photo à venir",
                                                  style: TextStyle(
                                                    color: Colors.white60,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  "Le carousel est déjà prêt",
                                                  style: TextStyle(
                                                    color: Colors.white30,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Positioned(
                                            top: 14,
                                            right: 14,
                                            child: Container(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.black45,
                                                borderRadius:
                                                BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                "${index + 1}/$nombrePhotosDemo",
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                nombrePhotosDemo,
                                    (index) {
                                  final bool actif = index == photoIndex;

                                  return AnimatedContainer(
                                    duration:
                                    const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    width: actif ? 22 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: actif
                                          ? _primaryColor
                                          : Colors.white24,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 28),

                            // ------------------------------------------
                            // INFORMATIONS
                            // ------------------------------------------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Informations",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                if (modeModification)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF9E2349)
                                          .withValues(alpha: 0.16),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.edit_rounded,
                                          color: Color(0xFFD16A8A),
                                          size: 14,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "Mode édition",
                                          style: TextStyle(
                                            color: Color(0xFFD16A8A),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: modeModification
                                      ? _champModification(
                                    controller: alcoolController,
                                    label: "Alcool %",
                                    icone: Icons.percent_rounded,
                                    keyboardType: const TextInputType
                                        .numberWithOptions(decimal: true),
                                  )
                                      : _detailBouteilleInfo(
                                    Icons.percent_rounded,
                                    "Alcool",
                                    "$alcoolAffiche%",
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: modeModification
                                      ? _champModification(
                                    controller: volumeController,
                                    label: "Volume (L)",
                                    icone: Icons.local_drink_rounded,
                                    keyboardType: const TextInputType
                                        .numberWithOptions(decimal: true),
                                  )
                                      : _detailBouteilleInfo(
                                    Icons.local_drink_rounded,
                                    "Volume",
                                    "$volumeAffiche L",
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: modeModification
                                      ? _champModification(
                                    controller: quantiteController,
                                    label: "Quantité",
                                    icone: Icons.inventory_2_outlined,
                                    keyboardType: TextInputType.number,
                                  )
                                      : _detailBouteilleInfo(
                                    Icons.inventory_2_outlined,
                                    "Quantité",
                                    "$quantiteAffiche",
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _detailBouteilleInfo(
                                    Icons.category_outlined,
                                    "Type",
                                    bouteille.runtimeType.toString(),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // ------------------------------------------
                            // COMMENTAIRE
                            // ------------------------------------------
                            const Row(
                              children: [
                                Icon(
                                  Icons.notes_rounded,
                                  color: Color(0xFFB83A61),
                                  size: 21,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Commentaire",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: double.infinity,
                              padding: EdgeInsets.all(
                                modeModification ? 4 : 16,
                              ),
                              decoration: BoxDecoration(
                                color: _cardColor,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: modeModification
                                      ? const Color(0xFF9E2349)
                                      .withValues(alpha: 0.55)
                                      : Colors.white10,
                                ),
                              ),
                              child: modeModification
                                  ? TextField(
                                controller: commentaireController,
                                minLines: 3,
                                maxLines: 6,
                                textCapitalization:
                                TextCapitalization.sentences,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.45,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(12),
                                  hintText:
                                  "Ajoutez une note sur cette bouteille...",
                                  hintStyle: TextStyle(
                                    color: Colors.white30,
                                  ),
                                ),
                              )
                                  : Text(
                                commentaireAffiche.trim().isEmpty
                                    ? "Aucun commentaire pour le moment."
                                    : commentaireAffiche,
                                style: TextStyle(
                                  color: commentaireAffiche.trim().isEmpty
                                      ? Colors.white38
                                      : Colors.white70,
                                  fontSize: 14,
                                  height: 1.45,
                                ),
                              ),
                            ),

                            if (erreurModification != null) ...[
                              const SizedBox(height: 14),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.redAccent.withValues(
                                      alpha: 0.30,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.error_outline_rounded,
                                      color: Colors.redAccent,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 9),
                                    Expanded(
                                      child: Text(
                                        erreurModification!,
                                        style: const TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            const SizedBox(height: 22),

                            // ------------------------------------------
                            // ACTIONS
                            // ------------------------------------------
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      if (modeModification) {
                                        setModalState(() {
                                          restaurerChamps();
                                          erreurModification = null;
                                          modeModification = false;
                                        });
                                        return;
                                      }

                                      print(
                                        "Ajout photo pour $nomAffiche",
                                      );
                                    },
                                    icon: Icon(
                                      modeModification
                                          ? Icons.close_rounded
                                          : Icons.add_a_photo_rounded,
                                      size: 19,
                                    ),
                                    label: Text(
                                      modeModification
                                          ? "Annuler"
                                          : "Ajouter une photo",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: const BorderSide(
                                        color: Color(0xFF9E2349),
                                        width: 1.2,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                        horizontal: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      backgroundColor: _cardColor,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      if (!modeModification) {
                                        setModalState(() {
                                          restaurerChamps();
                                          erreurModification = null;
                                          modeModification = true;
                                        });
                                        return;
                                      }

                                      final String nouveauNom =
                                      nomController.text.trim();
                                      final double? nouvelAlcool =
                                      double.tryParse(
                                        alcoolController.text
                                            .trim()
                                            .replaceAll(',', '.'),
                                      );
                                      final double? nouveauVolume =
                                      double.tryParse(
                                        volumeController.text
                                            .trim()
                                            .replaceAll(',', '.'),
                                      );
                                      final int? nouvelleQuantite =
                                      int.tryParse(
                                        quantiteController.text.trim(),
                                      );

                                      if (nouveauNom.isEmpty) {
                                        setModalState(() {
                                          erreurModification =
                                          "Le nom de la bouteille ne peut pas être vide.";
                                        });
                                        return;
                                      }

                                      if (nouvelAlcool == null ||
                                          nouvelAlcool < 0 ||
                                          nouvelAlcool > 100) {
                                        setModalState(() {
                                          erreurModification =
                                          "Le degré d'alcool doit être compris entre 0 et 100.";
                                        });
                                        return;
                                      }

                                      if (nouveauVolume == null ||
                                          nouveauVolume <= 0) {
                                        setModalState(() {
                                          erreurModification =
                                          "Le volume doit être supérieur à 0.";
                                        });
                                        return;
                                      }

                                      if (nouvelleQuantite == null ||
                                          nouvelleQuantite < 0) {
                                        setModalState(() {
                                          erreurModification =
                                          "La quantité doit être un nombre entier positif ou nul.";
                                        });
                                        return;
                                      }

                                      setModalState(() {
                                        nomAffiche = nouveauNom;
                                        alcoolAffiche = nouvelAlcool;
                                        volumeAffiche = nouveauVolume;
                                        quantiteAffiche = nouvelleQuantite;
                                        commentaireAffiche =
                                            commentaireController.text.trim();

                                        erreurModification = null;
                                        modeModification = false;
                                      });

                                      // TODO : brancher ici l'envoi de la
                                      // modification au serveur lorsque ton
                                      // protocole de mise a jour de bouteille
                                      // sera finalise.
                                      print(
                                        "Modification locale : "
                                            "$nomAffiche / $alcoolAffiche% / "
                                            "$volumeAffiche L / "
                                            "qte $quantiteAffiche / "
                                            "$commentaireAffiche",
                                      );
                                    },
                                    icon: Icon(
                                      modeModification
                                          ? Icons.save_rounded
                                          : Icons.edit_rounded,
                                      size: 19,
                                    ),
                                    label: Text(
                                      modeModification
                                          ? "Enregistrer"
                                          : "Modifier",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: _primaryColor,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                        horizontal: 10,
                                      ),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    photoController.dispose();
    nomController.dispose();
    alcoolController.dispose();
    volumeController.dispose();
    quantiteController.dispose();
    commentaireController.dispose();
  }

  Widget _champModification({
    required TextEditingController controller,
    required String label,
    required IconData icone,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white54,
          fontSize: 12,
        ),
        prefixIcon: Icon(
          icone,
          color: const Color(0xFFB83A61),
          size: 20,
        ),
        filled: true,
        fillColor: _cardColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.white10,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF9E2349),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _detailBouteilleInfo(
      IconData icone,
      String label,
      String valeur,
      ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _primaryColor.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icone,
              color: const Color(0xFFB83A61),
              size: 21,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  valeur,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBouteille(
      IconData icone,
      String texte,
      ) {
    return Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        Icon(
          icone,
          size: 15,
          color: const Color(0xFFB83A61),
        ),

        const SizedBox(width: 4),

        Text(
          texte,

          style: const TextStyle(
            color: Colors.white60,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
