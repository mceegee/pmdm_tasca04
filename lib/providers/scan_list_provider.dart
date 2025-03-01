import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:qr_scan/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String tipusSeleccionat = 'http';

  // Afegeix Scan
  Future<ScanModel> newScan(String valor) async {
    final newScan = new ScanModel(valor: valor);
    final id = await DbProvider.db.insertScan(newScan);
    newScan.id = id;

    if (newScan.tipus == tipusSeleccionat) {
      this.scans.add(newScan);
      notifyListeners();
    }
    return newScan;
  }

  // Carrega Scans
  carregaScans() async {
    final scans = await DbProvider.db.getAllScans();
    this.scans = [
      ...scans
    ]; // https://dart.dev/language/collections#spread-operators
    notifyListeners();
  }

  // Carrega Scan per tipus
  carregaScansPerTipus(String tipus) async {
    final scans = await DbProvider.db.getScanByType(tipus);
    this.scans = [...scans];
    this.tipusSeleccionat = tipus;
    notifyListeners();
  }

  // Esborra les entrades de la BBDD
  esborraTots() async {
    DbProvider.db.deleteAllScans();
    scans.clear();
    notifyListeners();
  }

  // Esborra per ID
  esborraPerId(int id) async {
    DbProvider.db.deleteScan(id);
    for (int i = 0; i < scans.length; i++) {
      if (scans.elementAt(i).id == id) {
        scans.removeAt(i);
        break;
      }
    }
    notifyListeners();
  }

}
