import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../lib/services/api_service.dart';
import '../../lib/services/local_storage_service.dart';

class StockEntryScreen extends StatefulWidget {
  @override
  _StockEntryScreenState createState() => _StockEntryScreenState();
}

class _StockEntryScreenState extends State<StockEntryScreen> {
  List<Map<String, dynamic>> scannedProducts = [];

  // void onBarcodeScanned(String barcode) async {
  //   final product = await ApiService.fetchProductDetails(barcode);
  //   if (product != null) {
  //     setState(() {
  //       scannedProducts.add(product);
  //       LocalStorageService.saveScannedProducts(scannedProducts);
  //     });
  //   }
  // }

  void onBarcodeScanned(BarcodeCapture barcode) async {
    final scannedValue = barcode.barcodes.first.rawValue;
    if (scannedValue != null) {
      final product = await ApiService.fetchProductDetails(scannedValue);
      if (product != null) {
        setState(() {
          scannedProducts.add(product);
          LocalStorageService.saveScannedProducts(scannedProducts);
        });
      }
    }
  }

  void submitStockEntry() async {
    await ApiService.submitStockOut(scannedProducts);
    setState(() {
      scannedProducts.clear();
      LocalStorageService.clearScannedProducts();
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Stock Entry Submitted!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stock Entry")),
      body: Column(
        children: [
          Expanded(
              child: MobileScanner(
            onDetect: onBarcodeScanned,
          )),
          Expanded(
            child: ListView.builder(
              itemCount: scannedProducts.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(scannedProducts[index]['name']),
                    subtitle:
                        Text("Qty: ${scannedProducts[index]['quantity']}"));
              },
            ),
          ),
          ElevatedButton(
              onPressed: submitStockEntry, child: Text("Submit All")),
        ],
      ),
    );
  }
}
