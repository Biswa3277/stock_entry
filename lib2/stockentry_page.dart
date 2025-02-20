import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'barcode_scanner_page.dart'; // Import the scanner page
import 'stock_entry.dart'; // Import stock entry model

class StockEntryPage extends StatefulWidget {
  final String invoiceId;

  StockEntryPage({required this.invoiceId});

  @override
  _StockEntryPageState createState() => _StockEntryPageState();
}

class _StockEntryPageState extends State<StockEntryPage> {
  late Box<StockEntry> stockBox;
  StockEntry? currentEntry;

  @override
  void initState() {
    super.initState();
    _loadStockEntry();
  }

  Future<void> _loadStockEntry() async {
    stockBox = await Hive.openBox<StockEntry>('stock_entries');
    setState(() {
      currentEntry = stockBox.values
          .firstWhere((entry) => entry.invoiceId == widget.invoiceId);
    });
  }

  // Navigate to Barcode Scanner Page
  void _scanBarcode() async {
    final scannedProduct = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BarcodeScannerPage()),
    );

    if (scannedProduct != null) {
      setState(() {
        currentEntry?.products.add(scannedProduct);
        stockBox.put(widget.invoiceId, currentEntry!); // Save updated entry
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text(widget.invoiceId,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: _scanBarcode, // Open barcode scanner
          ),
        ],
        backgroundColor: Colors.blue[100],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search product...",
                prefixIcon: Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
          // List of Scanned Products
          Expanded(
            child: currentEntry == null
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: currentEntry!.products.length,
                    itemBuilder: (context, index) {
                      var product = currentEntry!.products[index];
                      return ListTile(
                        leading: Icon(Icons.shopping_cart),
                        title: Text(product.productName),
                        subtitle: Text(
                            "Qty: ${product.quantity} | Price: ₹${product.price}"),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
