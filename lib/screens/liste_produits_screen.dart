import 'package:flutter/material.dart';
import '../models/produit_transforme.dart';
import '../widgets/produit_card.dart';
import '../widgets/hero_carousel.dart';
// Enum pour les filtres disponibles
enum FiltreStatut { tous, enStock, vendus }
class ListeProduitsScreen extends StatefulWidget {
// La liste est reçue depuis main.dart
final List<ProduitTransforme> produits;
const ListeProduitsScreen({super.key, required this.produits});
@override
State<ListeProduitsScreen> createState() => _ListeProduitsScreenState();
}
class _ListeProduitsScreenState extends State<ListeProduitsScreen> {
// late = sera initialisé dans initState, pas tout de suite
late List<ProduitTransforme> _produits;
FiltreStatut _filtre = FiltreStatut.tous;
@override
void initState() {
super.initState();
_produits = widget.produits; // copie la liste reçue
}
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// GETTER — chiffre d'affaires total
// Calculé automatiquement à chaque rebuild
// Ne compte QUE les produits vendu == true
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
int get _chiffreAffaires {
return _produits
.where((p) => p.vendu) // filtre vendus
.fold(0, (sum, p) => sum + p.valeurTotale()); // somme des valeurs
}
int get _nbVendus => _produits.where((p) => p.vendu).length;
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// GETTER — liste filtrée selon le filtre actif
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// SUPPRESSION AVEC CONFIRMATION
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
void _confirmerSuppression(ProduitTransforme produit) {
showDialog(
context: context,
builder: (ctx) => AlertDialog(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16)),
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
onPressed: () {
Navigator.pop(ctx); // ferme le dialog
setState(() {
// Supprime le produit par son ID unique
_produits.removeWhere((p) => p.id == produit.id);
// Le getter _chiffreAffaires recalcule automatiquement
});
},
child: const Text('Supprimer',
style: TextStyle(color: Colors.red)),
),
],
),
);
}
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NAVIGATION VERS LE DÉTAIL
// await = on attend que l'utilisateur revienne
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
void _ouvrirDetail(ProduitTransforme produit) async {
final resultat = await Navigator.pushNamed(
context,
'/detail',
arguments: produit, // ← PASSAGE D'ARGUMENT (obligatoire barème)
);
if (resultat == 'supprimer') {
// L'utilisateur a supprimé depuis le détail
setState(() {
_produits.removeWhere((p) => p.id == produit.id);
});
} else if (resultat is ProduitTransforme) {
// L'utilisateur a modifié le produit
setState(() {
final idx = _produits.indexWhere((p) => p.id == resultat.id);
if (idx != -1) _produits[idx] = resultat;
});
}
}
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NAVIGATION VERS LE FORMULAIRE (création)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
void _ouvrirFormulaire() async {
// Pas d'argument → formulaire en mode création
final nouveau = await Navigator.pushNamed(context, '/formulaire');
if (nouveau is ProduitTransforme) {
setState(() {
_produits.add(nouveau); // ajoute à la fin
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
return Scaffold(
backgroundColor: const Color(0xFFF7F6F3),
body: SafeArea(
child: CustomScrollView(
// CustomScrollView permet de mélanger SliverAppBar et liste
slivers: [
// ── CONTENU SCROLLABLE ──
SliverToBoxAdapter(
child: Padding(
padding: const EdgeInsets.symmetric(horizontal: 16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const SizedBox(height: 16),
// ── BARRE HAUT ──
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
border:
Border.all(color: const Color(0xFFE8E8E8)),
),
child: const Icon(Icons.info_outline,
size: 18, color: Color(0xFF888780)),
),
),
],
),
const SizedBox(height: 12),
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// HERO CAROUSEL — remplace le titre "GIE Produits"
// Images qui défilent horizontalement, texte centré
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
HeroCarousel(
height: 180,
slides: const [
CarouselSlide(
titre: 'GIE Produits',
sousTitre: 'Gestion des produits naturels',
imagePath: 'assets/images/hero_bg.jpg',
couleurFond: Color(0xFF2D5016),
),
CarouselSlide(
titre: 'Plantes médicinales',
sousTitre: 'Sénégal · ODD 5',
imagePath: 'assets/images/hero_bg.jpg',
couleurFond: Color(0xFF4A3728),
),
CarouselSlide(
titre: 'Égalité des genres',
sousTitre: 'Autonomisation des femmes',
couleurFond: Color(0xFF1A3A5C),
),
],
),
const SizedBox(height: 16),
// ── CARTE CHIFFRE D'AFFAIRES ──
Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(16),
border: Border.all(
color: const Color(0xFFE8E8E8), width: 0.8),
),
child: Row(
children: [
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
'Chiffre d\'affaires',
style: TextStyle(
fontSize: 12,
color: Color(0xFF888780)),
),
const SizedBox(height: 4),
// ← _chiffreAffaires recalculé à chaque setState
Text(
_formatFcfa(_chiffreAffaires),
style: const TextStyle(
fontSize: 22,
fontWeight: FontWeight.w600,
color: Color(0xFF1A1A1A),
),
),
const SizedBox(height: 2),
Text(
'$_nbVendus produit${_nbVendus > 1 ? 's' : ''} vendu${_nbVendus > 1 ?
style: const TextStyle(
fontSize: 12,
color: Color(0xFF888780)),
),
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
// ── CHIPS DE FILTRE ──
Row(
children: [
_ChipFiltre(
label: 'Tous',
actif: _filtre == FiltreStatut.tous,
// setState redessine l'écran avec le nouveau filtre
onTap: () =>
setState(() => _filtre = FiltreStatut.tous),
),
const SizedBox(width: 8),
_ChipFiltre(
label: 'En stock',
actif: _filtre == FiltreStatut.enStock,
onTap: () => setState(
() => _filtre = FiltreStatut.enStock),
),
const SizedBox(width: 8),
_ChipFiltre(
label: 'Vendus',
actif: _filtre == FiltreStatut.vendus,
onTap: () => setState(
() => _filtre = FiltreStatut.vendus),
),
],
),
const SizedBox(height: 14),
],
),
),
),
// ── LISTE DES PRODUITS ──
_produitsFiltres.isEmpty
? SliverFillRemaining(
child: Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Text('🌿',
style: TextStyle(fontSize: 44)),
const SizedBox(height: 12),
Text(
_filtre == FiltreStatut.tous
? 'Aucun produit.\nAppuie sur + pour commencer.'
: 'Aucun produit dans cette catégorie.',
textAlign: TextAlign.center,
style: const TextStyle(
fontSize: 14, color: Color(0xFF888780)),
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
// ── FAB ──
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
// ── WIDGET CHIP FILTRE (StatelessWidget) ──
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
color: actif
? const Color(0xFF1A1A1A)
: const Color(0xFFE8E8E8),
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
