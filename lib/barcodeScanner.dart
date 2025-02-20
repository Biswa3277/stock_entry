// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';

// class BarcodeScannerScreen extends StatefulWidget {
//   @override
//   _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
// }

// class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
//   final MobileScannerController controller = MobileScannerController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Scan Barcode"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.flash_on),
//             onPressed: () => controller.toggleTorch(),
//           ),
//         ],
//       ),
//       body: MobileScanner(
//         controller: controller,
//         onDetect: (capture) {
//           final List<Barcode> barcodes = capture.barcodes;
//           if (barcodes.isNotEmpty) {
//             Navigator.pop(context, barcodes.first.rawValue);
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:stock_entry/manual_search_screen.dart';

class BarcodeScannerScreen extends StatefulWidget {
  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  String _barcode = "Scan a product";

  Future<void> scanBarcode() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666",
      "Cancel",
      true,
      ScanMode.BARCODE,
    );

    if (barcode != "-1") {
      setState(() {
        _barcode = barcode;
      });
    }
  }

  // void saveProduct() {
  //   if (_barcode != "Scan a product") {
  //     Navigator.pop(
  //       context,
  //       ScannedProduct(
  //           productId: _barcode,
  //           productName: "Product $_barcode",
  //           quantity: 1,
  //           price: 100.0),
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
    scanBarcode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Product"),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.flash_on),
          //   onPressed: () => controller.toggleTorch(),
          // ),
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ManualSearchScreen(
                  onProductSelected: (product, quantity) {
                    Navigator.pop(
                        context, {'product': product, 'quantity': quantity});
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Scanned Product: $_barcode", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _barcode);
              },
              child: Text("Confirm Product"),
            ),
          ],
        ),
      ),
    );
  }
}
