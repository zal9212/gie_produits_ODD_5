import 'dart:io'; // pour File() — lire une image depuis le disque
import 'package:flutter/material.dart';
import '../models/produit_transforme.dart';
import 'badge_statut.dart';

class ProduitCard extends StatelessWidget {
  final ProduitTransforme produit;
  final VoidCallback onTap; // callback = fonction passee en parametre
  final VoidCallback onDelete; // appelee quand on tape la poubelle
  const ProduitCard({
    super.key,
    required this.produit,
    required this.onTap,
    required this.onDelete,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // toute la carte est tappable
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8E8E8), width: 0.8),
        ),
        child: Row(
          children: [
// image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 50,
                height: 50,
                child: produit.imagePath != null
// Si l'utilisateur a uploadé une image -> l'afficher
                    ? Image.file(
                        File(produit.imagePath!),
                        fit: BoxFit.cover,
// En cas d'erreur de chargement -> fallback emoji
                        errorBuilder: (_, __, ___) => _iconeFallback(),
                      )
// Sinon icone
                    : _iconeFallback(),
              ),
            ),
            const SizedBox(width: 12),
//  INFOS PRODUIT 
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produit.produit,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A1A),
                    ),
                    overflow: TextOverflow.ellipsis, // "..." si trop long
                    maxLines: 1,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${produit.quantiteProduite} unités · ${produit.prixUnitaire} FCFA',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888780),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
//  BADGE + POUBELLE
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BadgeStatut(vendu: produit.vendu),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: onDelete,
                  child: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Color(0xFFB4B2A9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// icone fallback
  Widget _iconeFallback() {
    return Container(
      color: const Color(0xFFF5F5F3),
      child: Center(
        child: Text(
          produit.categorie.icon,
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
