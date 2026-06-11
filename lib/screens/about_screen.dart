import 'package:flutter/material.dart';
class AboutScreen extends StatelessWidget {
const AboutScreen({super.key});
@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFFF7F6F3),
body: SafeArea(
// ━━ SingleChildScrollView = tout l'écran est scrollable ━━
child: SingleChildScrollView(
padding: const EdgeInsets.symmetric(horizontal: 20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const SizedBox(height: 16),
// Bouton retour
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
const SizedBox(height: 24),
const Text(
'À propos',
style: TextStyle(
fontSize: 32,
fontWeight: FontWeight.w600,
color: Color(0xFF1A1A1A)),
),
const SizedBox(height: 24),
// ── CARTE IDENTITÉ ÉTUDIANT ──
_Carte(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
// Avatar avec initiales
Container(
width: 48, height: 48,
decoration: BoxDecoration(
color: const Color(0xFF1A1A1A),
borderRadius: BorderRadius.circular(14),
),
child: const Center(
child: Text('MS',
style: TextStyle(
color: Colors.white,
fontWeight: FontWeight.w600,
fontSize: 16)),
),
),
const SizedBox(width: 12),
const Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Mamadou Saliou DIALLO',
style: TextStyle(
fontSize: 15,
fontWeight: FontWeight.w500,
color: Color(0xFF1A1A1A)),
),
SizedBox(height: 2),
Text(
'Sujet n° 13 · Promotion DAR26',
style: TextStyle(
fontSize: 12,
color: Color(0xFF888780)),
),
],
),
),
],
),
const SizedBox(height: 16),
const Divider(color: Color(0xFFE8E8E8), height: 1),
const SizedBox(height: 16),
_LigneInfo(
icone: Icons.school_outlined,
label: 'Module',
valeur: 'Développement Multiplateforme · ESMT Dakar',
),
const SizedBox(height: 12),
_LigneInfo(
icone: Icons.flag_outlined,
label: 'ODD',
valeur: 'ODD 5 — Égalité entre les sexes',
),
const SizedBox(height: 12),
_LigneInfo(
icone: Icons.phone_android_outlined,
label: 'Application',
valeur: 'GIE Produits — Gestion d\'un groupement féminin',
),
],
),
),
const SizedBox(height: 14),
// ── CARTE SOURCE DES DONNÉES ──
_Carte(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
'Source des données',
style: TextStyle(
fontSize: 14,
fontWeight: FontWeight.w500,
color: Color(0xFF1A1A1A)),
),
const SizedBox(height: 12),
_LigneInfo(
icone: Icons.link_outlined,
label: 'Site',
valeur: 'jolofteranga.com/collections/plantes-medicinales',
),
const SizedBox(height: 12),
_LigneInfo(
icone: Icons.store_outlined,
label: 'Source',
valeur: 'Jolof Teranga — GIE sénégalais de plantes médicinales et produits naturels
),
const SizedBox(height: 12),
_LigneInfo(
icone: Icons.calendar_today_outlined,
label: 'Date de collecte',
// ← REMPLACE PAR TA VRAIE DATE
valeur: 'Juin 2026',
),
const SizedBox(height: 12),
_LigneInfo(
icone: Icons.inventory_2_outlined,
label: 'Produits documentés',
valeur:
'Poudre de Nep-Nep · Thé Wass · Feuilles de Nguer · Poudre de Baobab · Huile de
),
],
),
),
const SizedBox(height: 30),
// Footer
const Center(
child: Text(
'ESMT · Licence 3 · 2026',
style: TextStyle(fontSize: 12, color: Color(0xFFB4B2A9)),
),
),
const SizedBox(height: 24),
],
),
),
),
);
}
}
// ── WIDGETS PRIVÉS HELPERS ──
// Carte blanche avec bordure
class _Carte extends StatelessWidget {
final Widget child;
const _Carte({required this.child});
@override
Widget build(BuildContext context) {
return Container(
width: double.infinity,
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(18),
border: Border.all(color: const Color(0xFFE8E8E8), width: 0.8),
),
child: child,
);
}
}
// Ligne d'information avec icône
class _LigneInfo extends StatelessWidget {
final IconData icone;
final String label;
final String valeur;
const _LigneInfo({
required this.icone,
required this.label,
required this.valeur,
});
@override
Widget build(BuildContext context) {
return Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Icon(icone, size: 16, color: const Color(0xFF888780)),
const SizedBox(width: 10),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(label,
style: const TextStyle(
fontSize: 11, color: Color(0xFF888780))),
const SizedBox(height: 2),
Text(valeur,
style: const TextStyle(
fontSize: 13, color: Color(0xFF1A1A1A))),
],
),
),
],
);
}
}