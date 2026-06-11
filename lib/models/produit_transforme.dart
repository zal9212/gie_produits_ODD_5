enum CategorieProduit { boisson, cosmetique, alimentaire, autre}

// l'extension permet d'ajouter des methodes sur un type existant
extension CategorieProduitExt on CategorieProduit {

  String get label {
    switch (this) {

      case CategorieProduit.boisson: return 'Boissson';
      case CategorieProduit.cosmetique: return 'Cosmétique';
      case CategorieProduit.alimentaire: return 'Alimentaire';
      case CategorieProduit.autre: return  'Autre';
    }

  }

  String get icon {
    switch (this) {
      case CategorieProduit.boisson: return '';
      case CategorieProduit.alimentaire: return '';
      case CategorieProduit.cosmetique: return '';
      case CategorieProduit.autre: return '';

    }
  }
}


class ProduitTransforme {
  // Attributs pour produit transformer
  final String id; 
  String produit;
  CategorieProduit categorie;
  int quantiteProduite;
  int prixUnitaire;
  DateTime dateProduction;
  bool vendu;
  String? imagePath;

  // constructeur de la classe

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


  // Calcule  de la valeur totale: valeur totale = quantité × prix

  int valeurTotale() => quantiteProduite * prixUnitaire;

  // methode  de copie pour la modification d'un produit

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