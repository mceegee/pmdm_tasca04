import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/utils/utils.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      child: Icon(
        Icons.filter_center_focus,
      ),
      onPressed: () async {
        // String barcodeScanRes = "geo:39.7259514,2.9136474";
        // String barcodeScanRes = "https://paucasesnovescifp.cat/";

        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#fc03e3', 'CANCEL·LAR', false, ScanMode.QR);
        print(barcodeScanRes);
        final scanListProvider =
            Provider.of<ScanListProvider>(context, listen: false);
        ScanModel newScan = ScanModel(valor: barcodeScanRes);
        scanListProvider.newScan(barcodeScanRes);
        launchURL(context, newScan);
      },
    );
  }
}
