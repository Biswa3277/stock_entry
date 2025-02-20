import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeScannerPage extends StatefulWidget {
  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  String _barcode = "Scan a product";

  Future<void> scanBarcode() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666", // Scanner color
      "Cancel", // Cancel button text
      true, // Flash enabled
      ScanMode.BARCODE,
    );

    if (barcode != "-1") {
      setState(() {
        _barcode = barcode;
      });
    }
  }

  void saveProduct() {
    if (_barcode != "Scan a product") {
      Navigator.pop(
        context,
        ScannedProduct(
            productId: _barcode,
            productName: "Product $_barcode",
            quantity: 1,
            price: 100.0),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    scanBarcode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan Product")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Scanned Product: $_barcode", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveProduct,
              child: Text("Confirm Product"),
            ),
          ],
        ),
      ),
    );
  }
}
