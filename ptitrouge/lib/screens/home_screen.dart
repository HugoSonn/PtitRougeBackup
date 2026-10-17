import 'dart:convert';
import 'dart:convert';
import 'package:flutter/material.dart';

import '../client/client.dart';
import 'bibliotheque_screen.dart';

class HomeScreen extends StatefulWidget {
  final Client? _client;
  const HomeScreen({super.key, required this._client});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color _backgroundColor = Color(0xFF181818);
  static const Color _primaryColor = Color(0xFF710627);
  static const Color _cardColor = Color(0xFF242424);

  final PageController _pageController = PageController(
    viewportFraction: 0.86,
  );

  @override
  void dispose() {
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

                      child: _bouteilleDuJour(),
                    ),

                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),

                      child: _cave(),
                    ),

                    const SizedBox(height: 30),

                    _titreSection(
                      "Raccourcis",
                    ),

                    const SizedBox(height: 15),

                    _raccourcis(),

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
            "P'tit Rouge",

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
  // BOUTEILLE DU JOUR
  // --------------------------------------------------

  Widget _bouteilleDuJour() {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: () {
          print("Bouteille du jour");
        },

        borderRadius: BorderRadius.circular(24),

        child: Ink(
          height: 380,

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

          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  "Ravi de vous revoir Hugo !",

                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: Colors.white,
                  ),
                ),

                const Spacer(),

                const Text(
                  "VOTRE BOUTEILLE DU JOUR",

                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Château Margaux",

                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Rouge • 2018",

                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,

                  children: const [
                    Text(
                      "Voir la bouteille",

                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(width: 5),

                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // CAVE
  // --------------------------------------------------

  Widget _cave() {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: () {
          print("Votre cave");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BibliothequeScreen(
                client: widget._client,
              ),
            ),
          );
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
                width: 55,
                height: 55,

                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),

                child: const Icon(
                  Icons.wine_bar_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 18),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Votre cave",

                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      "Découvrez toutes vos bouteilles",

                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                size: 30,
                color: Colors.white54,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // RACCOURCIS
  // --------------------------------------------------

  Widget _raccourcis() {
    return SizedBox(
      height: 180,

      child: PageView(
        controller: _pageController,

        children: [
          _carteRaccourci(
            titre: "Ajouter une bouteille",
            sousTitre: "Enrichir votre cave",
            icone: Icons.add_rounded,
          ),

          _carteRaccourci(
            titre: "Mes statistiques",
            sousTitre: "Analysez votre collection",
            icone: Icons.bar_chart_rounded,
          ),

          _carteRaccourci(
            titre: "Mes amis",
            sousTitre: "Découvrez leurs caves",
            icone: Icons.people_alt_rounded,
          ),

          _carteRaccourci(
            titre: "Demander à P'titBouchon",
            sousTitre: "Il répondre à toutes vos questions !",
            icone: Icons.help_center,
          )
        ],
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

  // --------------------------------------------------
  // ACTIONS
  // --------------------------------------------------

  Future<void> _boutonMenuHeader() async {
    print("Menu");
  }

  Future<void> _boutonAmisHeader() async {
    print("Profil");
  }
}