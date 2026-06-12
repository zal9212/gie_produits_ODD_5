import 'package:flutter/material.dart';
import '../models/produit_transforme.dart';
import '../services/database_helper.dart';
import '../widgets/produit_card.dart';

enum FiltreStatut { tous, enStock, vendus }

class ListeProduitsScreen extends StatefulWidget {
  const ListeProduitsScreen({super.key});
  @override
  State<ListeProduitsScreen> createState() => _ListeProduitsScreenState();
}

class _ListeProduitsScreenState extends State<ListeProduitsScreen> {
  List<ProduitTransforme> _produits = [];
  bool _chargement = true;
  FiltreStatut _filtre = FiltreStatut.tous;

  @override
  void initState() {
    super.initState();
    _chargerProduits();
  }

  Future<void> _chargerProduits() async {
    final db = DatabaseHelper.instance;
    List<ProduitTransforme> liste = await db.getAll();
    if (liste.isEmpty) {
      await _insererDonneesInitiales();
      liste = await db.getAll();
    }
    setState(() {
      _produits = liste;
      _chargement = false;
    });
  }

  Future<void> _insererDonneesInitiales() async {
    final db = DatabaseHelper.instance;
    await db.insert(ProduitTransforme(id: '1', produit: 'Poudre de Nep-Nep',
        categorie: CategorieProduit.alimentaire, quantiteProduite: 25,
        prixUnitaire: 4500, dateProduction: DateTime(2026, 5, 8), vendu: false));
    await db.insert(ProduitTransforme(id: '2', produit: 'Thé Wass (kinkeliba)',
        categorie: CategorieProduit.boisson, quantiteProduite: 40,
        prixUnitaire: 3200, dateProduction: DateTime(2026, 5, 12), vendu: true));
    await db.insert(ProduitTransforme(id: '3', produit: 'Feuilles de Nguer',
        categorie: CategorieProduit.cosmetique, quantiteProduite: 20,
        prixUnitaire: 3900, dateProduction: DateTime(2026, 5, 20), vendu: false));
    await db.insert(ProduitTransforme(id: '4', produit: 'Poudre de Baobab',
        categorie: CategorieProduit.alimentaire, quantiteProduite: 35,
        prixUnitaire: 5000, dateProduction: DateTime(2026, 6, 1), vendu: true));
    await db.insert(ProduitTransforme(id: '5', produit: 'Huile de coco bio',
        categorie: CategorieProduit.cosmetique, quantiteProduite: 15,
        prixUnitaire: 6500, dateProduction: DateTime(2026, 6, 3), vendu: false));
  }

  int get _chiffreAffaires {
    return _produits
        .where((p) => p.vendu)
        .fold(0, (sum, p) => sum + p.valeurTotale());
  }

  int get _nbVendus => _produits.where((p) => p.vendu).length;

  List<ProduitTransforme> get _produitsFiltres {
    switch (_filtre) {
      case FiltreStatut.enStock:
        return _produits.where((p) => !p.vendu).toList();
      case FiltreStatut.vendus:
        return _produits.where((p) => p.vendu).toList();
      case FiltreStatut.tous:
        return _produits;
    }
  }

  void _confirmerSuppression(ProduitTransforme produit) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Supprimer le produit ?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        content: Text(
          'Voulez-vous supprimer « ${produit.produit} » ?',
          style: const TextStyle(fontSize: 14, color: Color(0xFF888780)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler',
                style: TextStyle(color: Color(0xFF888780))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await DatabaseHelper.instance.delete(produit.id);
              setState(() {
                _produits.removeWhere((p) => p.id == produit.id);
              });
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _ouvrirDetail(ProduitTransforme produit) async {
    final resultat = await Navigator.pushNamed(context, '/detail',
        arguments: produit);
    if (resultat == 'supprimer') {
      await DatabaseHelper.instance.delete(produit.id);
      setState(() {
        _produits.removeWhere((p) => p.id == produit.id);
      });
    } else if (resultat is ProduitTransforme) {
      await DatabaseHelper.instance.update(resultat);
      setState(() {
        final idx = _produits.indexWhere((p) => p.id == resultat.id);
        if (idx != -1) _produits[idx] = resultat;
      });
    }
  }

  void _ouvrirFormulaire() async {
    final nouveau = await Navigator.pushNamed(context, '/formulaire');
    if (nouveau is ProduitTransforme) {
      await DatabaseHelper.instance.insert(nouveau);
      setState(() {
        _produits.add(nouveau);
      });
    }
  }

  String _formatFcfa(int montant) {
    if (montant >= 1000000) {
      return '${(montant / 1000000).toStringAsFixed(1)} M FCFA';
    } else if (montant >= 1000) {
      final milliers = montant ~/ 1000;
      final reste = montant % 1000;
      return reste == 0
          ? '$milliers 000 FCFA'
          : '$milliers ${reste.toString().padLeft(3, '0')} FCFA';
    }
    return '$montant FCFA';
  }

  @override
  Widget build(BuildContext context) {
    if (_chargement) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F6F3),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F3),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/about'),
                          child: Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFFE8E8E8)),
                            ),
                            child: const Icon(Icons.info_outline,
                                size: 18, color: Color(0xFF888780)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 180, width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: const Color(0xFF2D5016),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset('assets/images/hero_bg.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const SizedBox()),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('GIE Produits',
                                      style: TextStyle(fontSize: 24,
                                          fontWeight: FontWeight.w700, color: Colors.white),
                                      textAlign: TextAlign.center),
                                  const SizedBox(height: 6),
                                  Text('Gestion des produits naturels',
                                      style: TextStyle(fontSize: 13,
                                          color: Colors.white.withValues(alpha: 0.85)),
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE8E8E8), width: 0.8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Chiffre d\'affaires',
                                    style: TextStyle(fontSize: 12, color: Color(0xFF888780))),
                                const SizedBox(height: 4),
                                Text(_formatFcfa(_chiffreAffaires),
                                    style: const TextStyle(fontSize: 22,
                                        fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                                const SizedBox(height: 2),
                                Text("$_nbVendus produit${_nbVendus > 1 ? 's' : ''} vendu${_nbVendus > 1 ? 's' : ''}",
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF888780))),
                              ],
                            ),
                          ),
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.bar_chart_rounded,
                                color: Color(0xFF888780), size: 22),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _ChipFiltre(label: 'Tous',
                            actif: _filtre == FiltreStatut.tous,
                            onTap: () => setState(() => _filtre = FiltreStatut.tous)),
                        const SizedBox(width: 8),
                        _ChipFiltre(label: 'En stock',
                            actif: _filtre == FiltreStatut.enStock,
                            onTap: () => setState(() => _filtre = FiltreStatut.enStock)),
                        const SizedBox(width: 8),
                        _ChipFiltre(label: 'Vendus',
                            actif: _filtre == FiltreStatut.vendus,
                            onTap: () => setState(() => _filtre = FiltreStatut.vendus)),
                      ],
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
            _produitsFiltres.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('\u{1f33f}', style: TextStyle(fontSize: 44)),
                          const SizedBox(height: 12),
                          Text(
                            _filtre == FiltreStatut.tous
                                ? 'Aucun produit.\nAppuie sur + pour commencer.'
                                : 'Aucun produit dans cette catégorie.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14, color: Color(0xFF888780)),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final produit = _produitsFiltres[index];
                          return ProduitCard(
                            produit: produit,
                            onTap: () => _ouvrirDetail(produit),
                            onDelete: () => _confirmerSuppression(produit),
                          );
                        },
                        childCount: _produitsFiltres.length,
                      ),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ouvrirFormulaire,
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ChipFiltre extends StatelessWidget {
  final String label;
  final bool actif;
  final VoidCallback onTap;
  const _ChipFiltre({
    required this.label,
    required this.actif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: actif ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: actif ? const Color(0xFF1A1A1A) : const Color(0xFFE8E8E8),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: actif ? Colors.white : const Color(0xFF888780),
          ),
        ),
      ),
    );
  }
}
