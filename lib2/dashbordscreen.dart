import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stock Entry Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StockEntryScreen()),
                );
              },
              child: Text('Stock Entry'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StockOutScreen()),
                );
              },
              child: Text('Stock Out'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StockTransferScreen()),
                );
              },
              child: Text('Stock Transfer'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StockOverviewScreen()),
                );
              },
              child: Text('Stock Overview'),
            ),
          ],
        ),
      ),
    );
  }
}

class StockEntryScreen extends StatefulWidget {
  @override
  _StockEntryScreenState createState() => _StockEntryScreenState();
}

class _StockEntryScreenState extends State<StockEntryScreen> {
  int currentQuantity = 0;
  List<String> scannedProductList = [];

  Future<void> scanProduct() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE);

    if (barcode != '-1') {
      // Dummy data for testing
      String productDetails = 'Product: $barcode, Stock: 100';
      setState(() {
        scannedProductList.add(productDetails);
        currentQuantity++;
      });
    }
  }

  Future<void> submitStock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('scannedStock', scannedProductList);

    // Simulating sending data to the server
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Stock Submitted!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stock Entry')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: scanProduct,
            child: Text('Scan Product'),
          ),
          Text('Current Scanned Quantity: $currentQuantity'),
          Expanded(
            child: ListView.builder(
              itemCount: scannedProductList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(scannedProductList[index]),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: submitStock,
            child: Text('Submit Stock Entry'),
          ),
        ],
      ),
    );
  }
}

class StockOutScreen extends StatefulWidget {
  @override
  _StockOutScreenState createState() => _StockOutScreenState();
}

class _StockOutScreenState extends State<StockOutScreen> {
  List<String> scannedProductList = [];
  int currentQuantity = 0;

  Future<void> scanProduct() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE);

    if (barcode != '-1') {
      // Dummy data for testing
      String productDetails = 'Product: $barcode, Stock Out Quantity: 10';
      setState(() {
        scannedProductList.add(productDetails);
        currentQuantity++;
      });
    }
  }

  Future<void> submitStockOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('scannedStockOut', scannedProductList);

    // Simulating sending data to the server
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Stock Out Submitted!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stock Out')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: scanProduct,
            child: Text('Scan Product'),
          ),
          Text('Current Scanned Quantity: $currentQuantity'),
          Expanded(
            child: ListView.builder(
              itemCount: scannedProductList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(scannedProductList[index]),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: submitStockOut,
            child: Text('Submit Stock Out'),
          ),
        ],
      ),
    );
  }
}

class StockTransferScreen extends StatefulWidget {
  @override
  _StockTransferScreenState createState() => _StockTransferScreenState();
}

class _StockTransferScreenState extends State<StockTransferScreen> {
  List<String> scannedProductList = [];

  Future<void> scanProduct() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE);

    if (barcode != '-1') {
      // Dummy data for testing
      String productDetails = 'Product: $barcode, Transfer Quantity: 50';
      setState(() {
        scannedProductList.add(productDetails);
      });
    }
  }

  Future<void> submitTransfer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('scannedTransfer', scannedProductList);

    // Simulating sending data to the server
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Stock Transfer Submitted!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stock Transfer')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: scanProduct,
            child: Text('Scan Product'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: scannedProductList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(scannedProductList[index]),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: submitTransfer,
            child: Text('Submit Stock Transfer'),
          ),
        ],
      ),
    );
  }
}

class StockOverviewScreen extends StatefulWidget {
  @override
  _StockOverviewScreenState createState() => _StockOverviewScreenState();
}

class _StockOverviewScreenState extends State<StockOverviewScreen> {
  List<String> scannedStock = [];

  @override
  void initState() {
    super.initState();
    loadStockData();
  }

  Future<void> loadStockData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      scannedStock = prefs.getStringList('scannedStock') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stock Overview')),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(hintText: 'Search stock'),
            onChanged: (query) {
              // Implement stock search logic here
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: scannedStock.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(scannedStock[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
