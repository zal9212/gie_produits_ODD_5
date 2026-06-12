import 'dart:convert' show base64Encode;
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../models/produit_transforme.dart';

class FormulaireScreen extends StatefulWidget {
  const FormulaireScreen({super.key});
  @override
  State<FormulaireScreen> createState() => _FormulaireScreenState();
}

class _FormulaireScreenState extends State<FormulaireScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _quantiteController = TextEditingController();
  final _prixController = TextEditingController();
  final _dateController = TextEditingController();
  CategorieProduit _categorie = CategorieProduit.boisson;
  bool _vendu = false;
  DateTime _dateProduction = DateTime.now();
  String? _imagePath;
  bool _modeModification = false;
  ProduitTransforme? _produitOriginal;
  final ImagePicker _picker = ImagePicker();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_modeModification) return;
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is ProduitTransforme) {
      _modeModification = true;
      _produitOriginal = arg;
      _nomController.text = arg.produit;
      _quantiteController.text = arg.quantiteProduite.toString();
      _prixController.text = arg.prixUnitaire.toString();
      _categorie = arg.categorie;
      _vendu = arg.vendu;
      _dateProduction = arg.dateProduction;
      _dateController.text = DateFormat('dd/MM/yyyy').format(arg.dateProduction);
      _imagePath = arg.imagePath;
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _quantiteController.dispose();
    _prixController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _choisirDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateProduction,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF2D5016),
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _dateProduction = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _choisirImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD0CEC8),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choisir depuis la galerie'),
              onTap: () async {
                Navigator.pop(ctx);
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 70,
                );
                if (image != null) {
                  await _sauvegarderImage(image);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Prendre une photo'),
              onTap: () async {
                Navigator.pop(ctx);
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 70,
                );
                if (image != null) {
                  await _sauvegarderImage(image);
                }
              },
            ),
            if (_imagePath != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Supprimer l\'image',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _imagePath = null);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }



  Future<void> _sauvegarderImage(XFile image) async {
    if (kIsWeb) {
      final bytes = await image.readAsBytes();
      setState(() => _imagePath =
          'data:image/jpeg;base64,${base64Encode(bytes)}');
      return;
    }
    final dir = await getApplicationDocumentsDirectory();
    final ext = p.extension(image.path);
    final nom = '${DateTime.now().millisecondsSinceEpoch}$ext';
    final chemin = p.join(dir.path, nom);
    await File(image.path).copy(chemin);
    setState(() => _imagePath = chemin);
  }

  void _enregistrer() {
    if (!_formKey.currentState!.validate()) return;
    final produit = ProduitTransforme(
      id: _modeModification
          ? _produitOriginal!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      produit: _nomController.text.trim(),
      categorie: _categorie,
      quantiteProduite: int.parse(_quantiteController.text.trim()),
      prixUnitaire: int.parse(_prixController.text.trim()),
      dateProduction: _dateProduction,
      vendu: _vendu,
      imagePath: _imagePath,
    );
    Navigator.pop(context, produit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F3),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 20),
                      Text(
                        _modeModification
                            ? 'Modifier\nle produit'
                            : 'Nouveau\nproduit',
                        style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A), height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: _choisirImage,
                        child: Container(
                          width: double.infinity, height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _imagePath != null
                                  ? const Color(0xFF2D5016)
                                  : const Color(0xFFE8E8E8),
                              width: _imagePath != null ? 1.5 : 0.8,
                            ),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: _imagePath != null
                              ? Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    kIsWeb
                                        ? Image.network(_imagePath!, fit: BoxFit.cover)
                                        : Image.file(File(_imagePath!), fit: BoxFit.cover),
                                    Positioned(
                                      bottom: 8, right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.6),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Text('Changer',
                                            style: TextStyle(color: Colors.white, fontSize: 12)),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate_outlined,
                                        size: 32, color: const Color(0xFF888780)),
                                    const SizedBox(height: 8),
                                    const Text('Ajouter une photo du produit',
                                        style: TextStyle(fontSize: 13, color: Color(0xFF888780))),
                                    const SizedBox(height: 4),
                                    const Text('Galerie ou appareil photo',
                                        style: TextStyle(fontSize: 11, color: Color(0xFFB4B2A9))),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _Label('Nom du produit'),
                      TextFormField(
                        controller: _nomController,
                        decoration: _deco('Ex : Poudre de Nep-Nep'),
                        textCapitalization: TextCapitalization.sentences,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Le nom est obligatoire';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _Label('Catégorie'),
                      DropdownButtonFormField<CategorieProduit>(
                        value: _categorie,
                        decoration: _deco(null),
                        icon: const Icon(Icons.keyboard_arrow_down,
                            color: Color(0xFF888780)),
                        items: CategorieProduit.values
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Row(
                                    children: [
                                      Icon(c.icon, size: 20),
                                      const SizedBox(width: 8),
                                      Text(c.label),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: (val) => setState(() => _categorie = val!),
                        validator: (v) => v == null ? 'Choisir une catégorie' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Label('Quantité'),
                                TextFormField(
                                  controller: _quantiteController,
                                  decoration: _deco('Ex : 50'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (v) {
                                    if (v == null || v.isEmpty) return 'Obligatoire';
                                    if (int.parse(v) <= 0) return 'Doit être > 0';
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Label('Prix (FCFA)'),
                                TextFormField(
                                  controller: _prixController,
                                  decoration: _deco('Ex : 4500'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (v) {
                                    if (v == null || v.isEmpty) return 'Obligatoire';
                                    if (int.parse(v) <= 0) return 'Doit être > 0';
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _Label('Date de production'),
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        onTap: _choisirDate,
                        decoration: _deco('jj/mm/aaaa').copyWith(
                          suffixIcon: const Icon(Icons.calendar_today_outlined,
                              size: 18, color: Color(0xFF888780)),
                        ),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'La date est obligatoire' : null,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE8E8E8), width: 0.8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Produit vendu',
                                style: TextStyle(fontSize: 14, color: Color(0xFF1A1A1A))),
                            Switch(
                              value: _vendu,
                              onChanged: (val) => setState(() => _vendu = val),
                              activeThumbColor: const Color(0xFF2D5016),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: GestureDetector(
                  onTap: _enregistrer,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        _modeModification
                            ? 'Enregistrer les modifications'
                            : 'Ajouter le produit',
                        style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _deco(String? hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 14, color: Color(0xFFB4B2A9)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 0.8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8E8E8), width: 0.8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1A1A1A), width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 0.8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(text,
          style: const TextStyle(fontSize: 12, color: Color(0xFF888780))),
    );
  }
}
