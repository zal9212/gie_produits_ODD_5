import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/produit_transforme.dart';
import '../widgets/badge_statut.dart';

class DetailProduitScreen extends StatelessWidget {
  const DetailProduitScreen({super.key});
  @override
  Widget build(BuildContext context) {
// ── RÉCUPÉRATION DE L'ARGUMENT ──
// L'objet a été passé via arguments: dans Navigator.pushNamed
    final produit =
        ModalRoute.of(context)!.settings.arguments as ProduitTransforme;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F3),
      body: SafeArea(
        child: SingleChildScrollView(
          // ← tout l'écran est scrollable
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
// ── BARRE HAUT ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
// Bouton retour
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE8E8E8)),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new,
                            size: 16, color: Color(0xFF1A1A1A)),
                      ),
                    ),
// Badge statut en haut à droite
                    BadgeStatut(vendu: produit.vendu),
                  ],
                ),
                const SizedBox(height: 20),
// ── HERO IMAGE ou EMOJI ──
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0EDE6),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: produit.imagePath != null
                      ? Image.file(
                          File(produit.imagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _heroFallback(produit),
                        )
                      : _heroFallback(produit),
                ),
                const SizedBox(height: 16),
// ── NOM + CATÉGORIE ──
                Text(
                  produit.produit,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${produit.categorie.label} · GIE Féminin',
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF888780)),
                ),
                const SizedBox(height: 16),
// ── GRILLE STATS 2×2 ──
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
// IMPORTANT : désactive le scroll interne car on est
// déjà dans un SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.2,
                  children: [
                    _StatBox(
                      label: 'Quantité produite',
                      valeur: '${produit.quantiteProduite} unités',
                    ),
                    _StatBox(
                      label: 'Prix unitaire',
                      valeur: _formatFcfa(produit.prixUnitaire),
                    ),
                    _StatBox(
                      label: 'Date de production',
                      valeur: DateFormat('dd MMM yyyy', 'fr_FR')
                          .format(produit.dateProduction),
                    ),
                    _StatBox(
                      label: 'Catégorie',
                      valeur: produit.categorie.label,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
// ── VALEUR TOTALE ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border:
                        Border.all(color: const Color(0xFFE8E8E8), width: 0.8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Valeur totale',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF888780))),
                          const SizedBox(height: 4),
                          Text(
// Appel de la méthode valeurTotale() du modèle
                            _formatFcfa(produit.valeurTotale()),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.calculate_outlined,
                            size: 20, color: Color(0xFF888780)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
// ── BOUTONS MODIFIER / SUPPRIMER ──
                Row(
                  children: [
// Bouton Modifier
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
// Passe le produit au formulaire en mode modification
                          final modifie = await Navigator.pushNamed(
                            context,
                            '/formulaire',
                            arguments: produit, // ← passage d'argument
                          );
                          if (modifie is ProduitTransforme) {
// Retourne le produit modifié à la liste
                            Navigator.pop(context, modifie);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit_outlined,
                                  size: 16, color: Colors.white),
                              SizedBox(width: 6),
                              Text('Modifier',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
// Bouton Supprimer
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _confirmerSuppression(context, produit),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE8E8E8)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete_outline,
                                  size: 16, color: Color(0xFF888780)),
                              SizedBox(width: 6),
                              Text('Supprimer',
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xFF888780))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

// ── SUPPRESSION AVEC CONFIRMATION ──
  void _confirmerSuppression(BuildContext context, ProduitTransforme produit) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Supprimer le produit ?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        content: Text(
          'Voulez-vous supprimer « ${produit.produit} » ?\nCette action est irréversible.',
          style: const TextStyle(fontSize: 14, color: Color(0xFF888780)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), // ferme uniquement le dialog
            child: const Text('Annuler',
                style: TextStyle(color: Color(0xFF888780))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // 1. ferme le dialog
              Navigator.pop(context, 'supprimer'); // 2. retourne à la liste
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

// ── HERO FALLBACK (pas d'image) ──
  Widget _heroFallback(ProduitTransforme produit) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(produit.categorie.emoji, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 8),
          Text(produit.categorie.label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF888780))),
        ],
      ),
    );
  }

// Formater un montant FCFA avec séparateurs de milliers
  String _formatFcfa(int montant) {
    final f = NumberFormat('#,###', 'fr_FR');
    return '${f.format(montant)} FCFA';
  }
}

// ── WIDGET STAT BOX ──
class _StatBox extends StatelessWidget {
  final String label;
  final String valeur;
  const _StatBox({required this.label, required this.valeur});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 10, color: Color(0xFF888780))),
          const SizedBox(height: 3),
          Text(valeur,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A)),
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
