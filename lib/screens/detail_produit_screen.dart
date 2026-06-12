import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/produit_transforme.dart';
import '../widgets/badge_statut.dart';

class DetailProduitScreen extends StatelessWidget {
  const DetailProduitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is! ProduitTransforme) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F6F3),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    size: 48, color: Color(0xFF888780)),
                const SizedBox(height: 16),
                const Text('Produit introuvable',
                    style: TextStyle(fontSize: 18, color: Color(0xFF888780))),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Retour'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    final produit = arg;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE8E8E8)),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new,
                            size: 16, color: Color(0xFF1A1A1A)),
                      ),
                    ),
                    BadgeStatut(vendu: produit.vendu),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity, height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0EDE6),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: produit.imagePath != null
                      ? kIsWeb
                          ? Image.network(produit.imagePath!, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _heroFallback(produit))
                          : Image.file(File(produit.imagePath!), fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _heroFallback(produit))
                      : _heroFallback(produit),
                ),
                const SizedBox(height: 16),
                Text(produit.produit, style: const TextStyle(
                    fontSize: 26, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                const SizedBox(height: 4),
                Text('${produit.categorie.label} · GIE Féminin',
                    style: const TextStyle(fontSize: 14, color: Color(0xFF888780))),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2, shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.2,
                  children: [
                    _StatBox(label: 'Quantité produite',
                        valeur: '${produit.quantiteProduite} unités'),
                    _StatBox(label: 'Prix unitaire',
                        valeur: _formatFcfa(produit.prixUnitaire)),
                    _StatBox(label: 'Date de production',
                        valeur: DateFormat('dd MMM yyyy', 'fr_FR')
                            .format(produit.dateProduction)),
                    _StatBox(label: 'Catégorie', valeur: produit.categorie.label),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity, padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE8E8E8), width: 0.8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Valeur totale',
                              style: TextStyle(fontSize: 12, color: Color(0xFF888780))),
                          const SizedBox(height: 4),
                          Text(_formatFcfa(produit.valeurTotale()),
                              style: const TextStyle(fontSize: 22,
                                  fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                        ],
                      ),
                      Container(
                        width: 40, height: 40,
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
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final modifie = await Navigator.pushNamed(
                              context, '/formulaire', arguments: produit);
                          if (!context.mounted) return;
                          if (modifie is ProduitTransforme) {
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
                              Icon(Icons.edit_outlined, size: 16, color: Colors.white),
                              SizedBox(width: 6),
                              Text('Modifier', style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
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
                                  style: TextStyle(fontSize: 14, color: Color(0xFF888780))),
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
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler',
                style: TextStyle(color: Color(0xFF888780))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, 'supprimer');
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _heroFallback(ProduitTransforme produit) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(produit.categorie.icon, size: 56, color: const Color(0xFF1A1A1A)),
          const SizedBox(height: 8),
          Text(produit.categorie.label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF888780))),
        ],
      ),
    );
  }

  String _formatFcfa(int montant) {
    final f = NumberFormat('#,###', 'fr_FR');
    return '${f.format(montant)} FCFA';
  }
}

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
                  fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A)),
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
