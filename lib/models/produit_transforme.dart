import 'package:flutter/material.dart';

enum CategorieProduit { boisson, cosmetique, alimentaire, autre }

extension CategorieProduitExt on CategorieProduit {
  String get label {
    switch (this) {
      case CategorieProduit.boisson: return 'Boissson';
      case CategorieProduit.cosmetique: return 'Cosmétique';
      case CategorieProduit.alimentaire: return 'Alimentaire';
      case CategorieProduit.autre: return 'Autre';
    }
  }

  IconData get icon {
    switch (this) {
      case CategorieProduit.boisson: return Icons.local_drink_outlined;
      case CategorieProduit.alimentaire: return Icons.restaurant_outlined;
      case CategorieProduit.cosmetique: return Icons.spa_outlined;
      case CategorieProduit.autre: return Icons.category_outlined;
    }
  }
}

class ProduitTransforme {
  final String id;
  String produit;
  CategorieProduit categorie;
  int quantiteProduite;
  int prixUnitaire;
  DateTime dateProduction;
  bool vendu;
  String? imagePath;

  ProduitTransforme({
    required this.id,
    required this.produit,
    required this.categorie,
    required this.quantiteProduite,
    required this.dateProduction,
    this.imagePath,
    required this.prixUnitaire,
    this.vendu = false,
  });

  int valeurTotale() => quantiteProduite * prixUnitaire;

  Map<String, dynamic> toJson() => {
        'id': id,
        'produit': produit,
        'categorie': categorie.name,
        'quantite_produite': quantiteProduite,
        'prix_unitaire': prixUnitaire,
        'date_production': dateProduction.toIso8601String(),
        'vendu': vendu ? 1 : 0,
        'image_path': imagePath,
      };

  factory ProduitTransforme.fromJson(Map<String, dynamic> json) =>
      ProduitTransforme(
        id: json['id'] as String,
        produit: json['produit'] as String,
        categorie: CategorieProduit.values.firstWhere(
            (e) => e.name == json['categorie']),
        quantiteProduite: json['quantite_produite'] as int,
        prixUnitaire: json['prix_unitaire'] as int,
        dateProduction: DateTime.parse(json['date_production'] as String),
        vendu: (json['vendu'] as int) == 1,
        imagePath: json['image_path'] as String?,
      );

  ProduitTransforme copyWith({
    String? produit,
    CategorieProduit? categorie,
    int? quantiteProduite,
    int? prixUnitaire,
    DateTime? dateProduction,
    bool? vendu,
    String? imagePath,
  }) {
    return ProduitTransforme(
      id: id,
      produit: produit ?? this.produit,
      categorie: categorie ?? this.categorie,
      quantiteProduite: quantiteProduite ?? this.quantiteProduite,
      dateProduction: dateProduction ?? this.dateProduction,
      prixUnitaire: prixUnitaire ?? this.prixUnitaire,
      vendu: vendu ?? this.vendu,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
