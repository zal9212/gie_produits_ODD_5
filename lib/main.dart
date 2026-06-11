import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'models/produit_transforme.dart';
import 'screens/liste_produits_screen.dart';
import 'screens/detail_produit_screen.dart';
import 'screens/formulaire_screen.dart';
import 'screens/about_screen.dart';
void main() async {
WidgetsFlutterBinding.ensureInitialized();
// Initialise les données de localisation pour le français
// Obligatoire pour DateFormat('dd MMM yyyy', 'fr_FR')
await initializeDateFormatting('fr_FR', null);
runApp(const GieProduitsApp());
}
class GieProduitsApp extends StatelessWidget {
const GieProduitsApp({super.key});
@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'GIE Produits',
debugShowCheckedModeBanner: false,
// ── THÈME PERSONNALISÉ ──
theme: ThemeData(
useMaterial3: true,
colorScheme: ColorScheme.fromSeed(
seedColor: const Color(0xFF2D5016), // vert naturel/karité
brightness: Brightness.light,
),
scaffoldBackgroundColor: const Color(0xFFF7F6F3),
appBarTheme: const AppBarTheme(
backgroundColor: Color(0xFFF7F6F3),
elevation: 0,
scrolledUnderElevation: 0,
),
),
// ── ROUTES NOMMÉES ──
// 3 des 4 routes déclarées normalement
initialRoute: '/',
routes: {
'/about': (context) => const AboutScreen(),
'/detail': (context) => const DetailProduitScreen(),
'/formulaire': (context) => const FormulaireScreen(),
},
// Route '/' via onGenerateRoute pour passer les données initiales
onGenerateRoute: (settings) {
if (settings.name == '/') {
return MaterialPageRoute(
builder: (_) => ListeProduitsScreen(
produits: _donneesInitiales(),
),
);
}
return null;
},
);
}
}
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// DONNÉES INITIALES — 5 produits réels
// Source : jolofteranga.com/collections/plantes-medicinales
// Collecte : Juin 2026
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
List<ProduitTransforme> _donneesInitiales() {
return [
ProduitTransforme(
id: '1',
produit: 'Poudre de Nep-Nep',
categorie: CategorieProduit.alimentaire,
quantiteProduite: 25,
prixUnitaire: 4500,
dateProduction: DateTime(2026, 5, 8),
vendu: false,
),
ProduitTransforme(
id: '2',
produit: 'Thé Wass (kinkeliba)',
categorie: CategorieProduit.boisson,
quantiteProduite: 40,
prixUnitaire: 3200,
dateProduction: DateTime(2026, 5, 12),
vendu: true,
),
ProduitTransforme(
id: '3',
produit: 'Feuilles de Nguer',
categorie: CategorieProduit.cosmetique,
quantiteProduite: 20,
prixUnitaire: 3900,
dateProduction: DateTime(2026, 5, 20),
vendu: false,
),
ProduitTransforme(
id: '4',
produit: 'Poudre de Baobab',
categorie: CategorieProduit.alimentaire,
quantiteProduite: 35,
prixUnitaire: 5000,
dateProduction: DateTime(2026, 6, 1),
vendu: true,
),
ProduitTransforme(
id: '5',
produit: 'Huile de coco bio',
categorie: CategorieProduit.cosmetique,
quantiteProduite: 15,
prixUnitaire: 6500,
dateProduction: DateTime(2026, 6, 3),
vendu: false,
),
];
}
