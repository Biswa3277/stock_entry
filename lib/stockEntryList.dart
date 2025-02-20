import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stock_entry/barcodeScanner.dart';
import 'package:stock_entry/manual_search_screen.dart';
import 'package:stock_entry/models/product_model.dart';
import 'package:stock_entry/models/stockin_model.dart';

class StockEntryListPage extends StatefulWidget {
  final String invoiceId;

  const StockEntryListPage({super.key, required this.invoiceId});

  @override
  _StockEntryListPageState createState() => _StockEntryListPageState();
}

class _StockEntryListPageState extends State<StockEntryListPage> {
  late StockEntry _stockEntry;
  late Box<StockEntry> _stockBox;
  List<ScannedProduct> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _stockBox = Hive.box<StockEntry>('stockEntries');
    _stockEntry = _stockBox.get(widget.invoiceId)!;
    _filteredProducts = _stockEntry.products;

    _searchController.addListener(_filterProducts);
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _stockEntry.products.where((product) {
        return product.productName.toLowerCase().contains(query) ||
            product.productId.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _scanBarcode() async {
    final barcode = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BarcodeScannerScreen()),
    );

    if (barcode != null) {
      _handleScannedBarcode(barcode);
    }
  }

  void _addOrUpdateProduct(ScannedProduct newProduct) {
    setState(() {
      final existingIndex = _stockEntry.products
          .indexWhere((p) => p.productId == newProduct.productId);

      if (existingIndex != -1) {
        // Update existing product quantity
        _stockEntry.products[existingIndex] =
            _stockEntry.products[existingIndex].copyWith(
                quantity: _stockEntry.products[existingIndex].quantity +
                    newProduct.quantity);
      } else {
        // Add new product
        _stockEntry.products.add(newProduct);
      }

      _filterProducts();
    });
    _saveEntry();
  }

  void _addScannedProduct(Product product, int quantity) {
    final newProduct = ScannedProduct(
      productId: product.productBarcode,
      productName: product.name,
      quantity: quantity,
      price: product.price,
    );

    setState(() {
      _stockEntry.products.add(newProduct);
      _filterProducts();
    });
    _saveEntry();
  }

  Future<void> _handleScannedBarcode(String barcode) async {
    // Check both product and box barcodes
    final product = await _fetchProductByBarcode(barcode);

    if (product != null) {
      final isBox = barcode == product.boxBarcode;
      final quantity = isBox ? product.itemsPerBox : 1;
      // _showProductConfirmationDialog(product);
      _showProductConfirmationDialog(product, quantity);
    } else {
      // Navigate to manual search with scanned barcode
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ManualSearchScreen(
            initialBarcode: barcode,
            onProductSelected: (product, quantity) {
              _addOrUpdateProduct(ScannedProduct(
                productId: product.productBarcode,
                productName: product.name,
                quantity: quantity,
                price: product.price,
              ));
            },
          ),
        ),
      );
    }
  }

  // Future<void> _handleScannedBarcode(String barcode) async {
  //   try {
  //     final product = await _fetchProductByBarcode(barcode);
  //     _showProductConfirmationDialog(product);
  //   } catch (e) {
  //     _showManualEntryDialog(barcode);
  //   }
  // }

  Future<Product?> _fetchProductByBarcode(String barcode) async {
    // Replace with actual API call or local Hive lookup
    await Future.delayed(Duration(seconds: 1)); // Mock API delay

    // Check local Hive storage
    final productBox = Hive.box<Product>('products');
    for (final product in productBox.values) {
      if (product.productBarcode == barcode || product.boxBarcode == barcode) {
        return product;
      }
    }
    return null;
  }

  void _showProductConfirmationDialog(Product product, int initialQuantity) {
    int quantity = initialQuantity; // Use the passed quantity

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Confirm Product"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(product.imagePath, height: 100),
                const SizedBox(height: 10),
                Text(product.name, style: const TextStyle(fontSize: 18)),
                Text("\$${product.price.toStringAsFixed(2)}"),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text("Quantity:"),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => setState(
                          () => quantity = quantity > 1 ? quantity - 1 : 1),
                    ),
                    Text("$quantity"),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() => quantity++),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: const Text("Confirm"),
                onPressed: () {
                  _addScannedProduct(product, quantity);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showManualEntryDialog(String? barcode) {
    final manualIdController = TextEditingController(text: barcode);
    final manualNameController = TextEditingController();
    final manualPriceController = TextEditingController();
    int quantity = 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Manual Entry"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: manualIdController,
                    decoration:
                        const InputDecoration(labelText: "Product ID/Barcode"),
                  ),
                  TextField(
                    controller: manualNameController,
                    decoration:
                        const InputDecoration(labelText: "Product Name"),
                  ),
                  TextField(
                    controller: manualPriceController,
                    decoration: const InputDecoration(labelText: "Price"),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("Quantity:"),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => setState(
                            () => quantity = quantity > 1 ? quantity - 1 : 1),
                      ),
                      Text("$quantity"),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() => quantity++),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: const Text("Add Product"),
                onPressed: () {
                  _addManualProduct(
                    manualIdController.text,
                    manualNameController.text,
                    double.parse(manualPriceController.text),
                    quantity,
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _addManualProduct(String id, String name, double price, int quantity) {
    final newProduct = ScannedProduct(
      productId: id,
      productName: name,
      quantity: quantity,
      price: price,
    );

    setState(() {
      _stockEntry.products.add(newProduct);
      _filterProducts();
    });
    _saveEntry();
  }

  Future<void> _saveEntry() async {
    await _stockBox.put(_stockEntry.invoiceId, _stockEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Invoice: ${_stockEntry.invoiceId}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanBarcode,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search products...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/default_product.png'),
                  ),
                  title: Text(product.productName),
                  subtitle: Text('ID: ${product.productId}'),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('\$${product.price.toStringAsFixed(2)}'),
                      Text('Qty: ${product.quantity}'),
                    ],
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
