import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/produit_transforme.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static Future<Database>? _databaseFuture;

  DatabaseHelper._init();

  Future<Database> get database async {
    _databaseFuture ??= _initDB('gie_produits.db');
    _database = await _databaseFuture;
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE produits(
        id TEXT PRIMARY KEY,
        produit TEXT NOT NULL,
        categorie TEXT NOT NULL,
        quantite_produite INTEGER NOT NULL,
        prix_unitaire INTEGER NOT NULL,
        date_production TEXT NOT NULL,
        vendu INTEGER NOT NULL DEFAULT 0,
        image_path TEXT
      )
    ''');
  }

  Future<int> insert(ProduitTransforme produit) async {
    final db = await database;
    return await db.insert('produits', produit.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<ProduitTransforme?> getById(String id) async {
    final db = await database;
    final maps = await db.query('produits', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return ProduitTransforme.fromJson(maps.first);
  }

  Future<List<ProduitTransforme>> getAll() async {
    final db = await database;
    final maps = await db.query('produits', orderBy: 'date_production DESC');
    return maps.map((m) => ProduitTransforme.fromJson(m)).toList();
  }

  Future<int> update(ProduitTransforme produit) async {
    final db = await database;
    return await db.update('produits', produit.toJson(),
        where: 'id = ?', whereArgs: [produit.id]);
  }

  Future<int> delete(String id) async {
    final db = await database;
    return await db.delete('produits', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    db.close();
    _database = null;
  }
}
