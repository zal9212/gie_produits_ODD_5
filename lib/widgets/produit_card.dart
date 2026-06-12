import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../models/produit_transforme.dart';
import 'badge_statut.dart';

class ProduitCard extends StatelessWidget {
  final ProduitTransforme produit;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ProduitCard({
    super.key,
    required this.produit,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 50,
                height: 50,
                child: produit.imagePath != null
                    ? kIsWeb
                        ? Image.network(produit.imagePath!, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _fallback())
                        : Image.file(File(produit.imagePath!), fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _fallback())
                    : _fallback(),
              ),
            ),
            const SizedBox(width: 12),
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
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${produit.quantiteProduite} unités · ${produit.prixUnitaire} FCFA',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF888780)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BadgeStatut(vendu: produit.vendu),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: onDelete,
                  child: const Icon(Icons.delete_outline,
                      size: 18, color: Color(0xFFB4B2A9)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      color: const Color(0xFFF5F5F3),
      child: Center(
        child: Icon(produit.categorie.icon,
            size: 22, color: const Color(0xFF1A1A1A)),
      ),
    );
  }
}
