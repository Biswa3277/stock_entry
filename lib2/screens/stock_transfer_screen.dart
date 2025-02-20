import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../lib/services/api_service.dart';
import '../../lib/services/local_storage_service.dart';

class StockTransferScreen extends StatefulWidget {
  @override
  _StockTransferScreenState createState() => _StockTransferScreenState();
}

class _StockTransferScreenState extends State<StockTransferScreen> {
  List<Map<String, dynamic>> scannedProducts = [];
  String selectedLogistics = '';

  // void onBarcodeScanned() async {
  //   final barcode = "423846yg";
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

  void submitStockTransfer() async {
    if (selectedLogistics.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Select a logistic location first!")));
      return;
    }

    await ApiService.submitStockTransfer(scannedProducts, selectedLogistics);
    setState(() {
      scannedProducts.clear();
      LocalStorageService.clearScannedProducts();
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Stock Transferred!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stock Transfer")),
      body: Column(
        children: [
          DropdownButton<String>(
            hint: Text("Select Logistics"),
            value: selectedLogistics.isNotEmpty ? selectedLogistics : null,
            onChanged: (String? newValue) {
              setState(() {
                selectedLogistics = newValue!;
              });
            },
            items: ['Warehouse A', 'Warehouse B', 'Warehouse C']
                .map((logistics) => DropdownMenuItem<String>(
                      value: logistics,
                      child: Text(logistics),
                    ))
                .toList(),
          ),
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
                  subtitle: Text("Qty: ${scannedProducts[index]['quantity']}"),
                );
              },
            ),
          ),
          ElevatedButton(
              onPressed: submitStockTransfer, child: Text("Submit Transfer")),
        ],
      ),
    );
  }
}
