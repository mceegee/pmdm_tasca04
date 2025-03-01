import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {
  static Database? _database;
  static final DbProvider db = DbProvider._();

  DbProvider._();

  Future<Database> get database async {
    if (_database == null) _database = await initDB();

    return _database!;
  }

// Inicialització de la BBDD
  Future<Database> initDB() async {
    // Get path
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'Scans.db');
    print(path);

    // Create DB
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE Scans(
          id INTEGER PRIMARY KEY,
          tipus TEXT,
          valor TEXT
          )
        ''');
    });
  }

// insertar dades a la BBDD
  Future<int> insertRawScan(ScanModel newScan) async {
    final id = newScan.id;
    final tipus = newScan.tipus;
    final valor = newScan.valor;

    final db = await database;

    final res = await db.rawInsert('''
      INSERT INTO Scans(id, tipus, valor)
      VALUES($id, $tipus, $valor)
    ''');

    return res;
  }

// insertar dades a la BBDD
  Future<int> insertScan(ScanModel newScan) async {
    final db = await database;
    final res = await db.insert('Scans', newScan.toMap());
    print(res);
    return res;
  }

//Retorna tota la taula
  Future<List<ScanModel>> getAllScans() async {
    final db = await database;

    final res = await db.query('Scans');
    return res.isNotEmpty ? res.map((e) => ScanModel.fromMap(e)).toList() : [];
  }

// retorna resultat d'un ID concret
  Future<ScanModel?> getScanById(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    if (res.isNotEmpty) {
      return ScanModel.fromMap(res.first);
    }
    return null;
  }

// retorna resultat d'un tipus concret
  Future<List<ScanModel>> getScanByType(String tipus) async {
    final db = await database;
    final res = await db.query('Scans', where: 'tipus = ?', whereArgs: [tipus]);

    return res.isNotEmpty ? res.map((e) => ScanModel.fromMap(e)).toList() : [];
  }

// Update de la taula
  Future<int> updateScan(ScanModel sm) async {
    final db = await database;
    final res =
        db.update('Scans', sm.toMap(), where: 'id = ?', whereArgs: [sm.id]);

    return res;
  }

// Elimina totes les dades de la BBDD
  Future<int> deleteAllScans() async {
    final db = await database;
    final res = await db.rawDelete('''
    DELETE FROM Scans
    ''');
    return res;
  }

// Elimina una entrada concreta
  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);

    return res;
  }
}
