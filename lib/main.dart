import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stock_entry/models/stockin_model.dart';
import 'package:stock_entry/stockDashboard.dart';
import 'models/product_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Initialize dummy data for products (if not already present)
  Future<void> initializeDummyProducts() async {
    final productBox = Hive.box<Product>('products');
    if (productBox.isEmpty) {
      await productBox.addAll([
        Product(
          productBarcode: '123456789',
          boxBarcode: '987654321',
          name: 'Premium Coffee Beans',
          imagePath: 'assets/default_product.png',
          price: 12.99,
          itemsPerBox: 12,
        ),
        Product(
          productBarcode: '555555555',
          boxBarcode: '999999999',
          name: 'Organic Tea Bags',
          imagePath: 'assets/default_product.png',
          price: 8.99,
          itemsPerBox: 24,
        ),
      ]);
    }
  }

  // Create dummy data
  StockEntry _createDummyEntry() {
    return StockEntry(
      invoiceId: 'INV-${DateTime.now().millisecondsSinceEpoch}',
      vendorName: 'Sample Vendor',
      itemQuantity: '15',
      products: [
        ScannedProduct(
          productId: 'PROD-001',
          productName: 'Widget A',
          quantity: 10,
          price: 29.99,
        ),
        ScannedProduct(
          productId: 'PROD-002',
          productName: 'Gadget B',
          quantity: 5,
          price: 49.99,
        ),
      ],
      status: 'draft',
    );
  }

  // Register both adapters
  Hive.registerAdapter(StockEntryAdapter());
  Hive.registerAdapter(ScannedProductAdapter());
  Hive.registerAdapter(ProductAdapter());

  await Hive.openBox<StockEntry>('stockEntries');
  await Hive.openBox<Product>('products');

  await initializeDummyProducts();

  final stockBox = Hive.box<StockEntry>('stockEntries');
  final entry = _createDummyEntry();
  await stockBox.put(entry.invoiceId, entry);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(title: const Text('Stock Entries')),
        // body: StockInputPage(),
        body: DashboardScreen(),
      ),
    );
  }
}

class StockEntryDemo extends StatefulWidget {
  @override
  _StockEntryDemoState createState() => _StockEntryDemoState();
}

class _StockEntryDemoState extends State<StockEntryDemo> {
  late Box<StockEntry> stockBox;
  List<StockEntry> entries = [];

  @override
  void initState() {
    super.initState();
    stockBox = Hive.box<StockEntry>('stockEntries');
    _loadEntries();
  }

  // Create dummy data
  StockEntry _createDummyEntry() {
    return StockEntry(
      invoiceId: 'INV-${DateTime.now().millisecondsSinceEpoch}',
      vendorName: 'Sample Vendor',
      itemQuantity: '15',
      products: [
        ScannedProduct(
          productId: 'PROD-001',
          productName: 'Widget A',
          quantity: 10,
          price: 29.99,
        ),
        ScannedProduct(
          productId: 'PROD-002',
          productName: 'Gadget B',
          quantity: 5,
          price: 49.99,
        ),
      ],
      status: 'draft',
    );
  }

  Future<void> _saveEntry() async {
    final entry = _createDummyEntry();
    await stockBox.put(entry.invoiceId, entry);
    _loadEntries();
  }

  // print(entry.invoiceId);
  // entry.products.forEach((product) {
  //   print(
  //       'Product ID: ${product.productId}, Product Name: ${product.productName}, Quantity: ${product.quantity}, Price: ${product.price}');
  // });

  // await stockBox.put(entry.invoiceId, entry);

  // final loadedEntrie = stockBox.values.toList();
  // loadedEntrie.forEach((item) {
  //   print(item.invoiceId);
  // });

  // _loadEntries();

  Future<void> _loadEntries() async {
    final loadedEntries = stockBox.values.toList();
    setState(() {
      entries = loadedEntries;
    });
  }

  Future<void> _clearEntries() async {
    await stockBox.clear();
    _loadEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _saveEntry,
            child: const Text('Add Dummy Entry'),
          ),
          ElevatedButton(
            onPressed: _clearEntries,
            child: const Text('Clear Entries'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Card(
                  child: ListTile(
                    title: Text('Invoice: ${entry.invoiceId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Vendor: ${entry.vendorName}'),
                        Text('Status: ${entry.status}'),
                        const SizedBox(height: 8),
                        const Text('Products:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ...entry.products.map((product) => Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '${product.quantity}x ${product.productName} - \$${product.price}',
                              ),
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
