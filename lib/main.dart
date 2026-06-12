import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'screens/liste_produits_screen.dart';
import 'screens/detail_produit_screen.dart';
import 'screens/formulaire_screen.dart';
import 'screens/about_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    sqflite.databaseFactory = databaseFactoryFfiWeb;
  }
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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D5016),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F6F3),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F6F3),
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/about': (context) => const AboutScreen(),
        '/detail': (context) => const DetailProduitScreen(),
        '/formulaire': (context) => const FormulaireScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (_) => const ListeProduitsScreen(),
          );
        }
        return null;
      },
    );
  }
}
