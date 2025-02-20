import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:stock_entry/screens/dashboard_screen.dart';
// import 'package:stock_entry/stock_input_page.dart';
import 'stock_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(StockEntryAdapter());
  Hive.registerAdapter(ScannedProductAdapter());

  await addDummyData(); // Initialize with dummy data

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Entry Inventory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StockInputPage(),
    );
  }
}

Future<void> addDummyData() async {
  var box = await Hive.openBox<StockEntry>('stock_entries');

  // Clear existing data (Optional: If you want fresh dummy data every time)
  await box.clear();

  // Create dummy entries
  List<StockEntry> dummyEntries = [
    StockEntry(
      invoiceId: "INV001",
      vendorName: "Vendor A",
      invoicePhoto: null,
      status: "draft",
      products: [
        ScannedProduct(
            productId: "P001",
            productName: "Product 1",
            quantity: 10,
            price: 150.0),
        ScannedProduct(
            productId: "P002",
            productName: "Product 2",
            quantity: 5,
            price: 75.0),
      ],
    ),
    StockEntry(
      invoiceId: "INV002",
      vendorName: "Vendor B",
      invoicePhoto: null,
      status: "completed",
      products: [
        ScannedProduct(
            productId: "P003",
            productName: "Product 3",
            quantity: 8,
            price: 200.0),
        ScannedProduct(
            productId: "P004",
            productName: "Product 4",
            quantity: 12,
            price: 125.0),
      ],
    ),
    StockEntry(
      invoiceId: "INV003",
      vendorName: "Vendor C",
      invoicePhoto: null,
      status: "draft",
      products: [
        ScannedProduct(
            productId: "P005",
            productName: "Product 5",
            quantity: 15,
            price: 300.0),
      ],
    ),
  ];

  // Add dummy data to Hive
  for (var entry in dummyEntries) {
    await box.add(entry);
  }
  print(box);
  print("Dummy data added successfully!");
}
