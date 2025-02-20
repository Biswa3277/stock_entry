import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stock_entry/models/product_model.dart';

class ManualSearchScreen extends StatefulWidget {
  final String? initialBarcode;
  final Function(Product, int) onProductSelected;

  const ManualSearchScreen(
      {this.initialBarcode, required this.onProductSelected});

  @override
  _ManualSearchScreenState createState() => _ManualSearchScreenState();
}

class _ManualSearchScreenState extends State<ManualSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialBarcode ?? '';
    _performSearch();
  }

  void _performSearch() async {
    final query = _searchController.text.toLowerCase();
    final productBox = Hive.box<Product>('products');

    setState(() {
      _searchResults = productBox.values.where((product) {
        return product.name.toLowerCase().contains(query) ||
            product.productBarcode.contains(query) ||
            product.boxBarcode.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manual Product Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by name or barcode',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final product = _searchResults[index];
                return ListTile(
                  leading: Image.asset(product.imagePath, width: 50),
                  title: Text(product.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product Barcode: ${product.productBarcode}'),
                      Text('Box Barcode: ${product.boxBarcode}'),
                      Text('Items per box: ${product.itemsPerBox}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _showQuantityDialog(product),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showQuantityDialog(Product product) {
    int quantity = 1;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Select Quantity"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(product.name),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => setState(
                          () => quantity = quantity > 1 ? quantity - 1 : 1),
                    ),
                    Text('$quantity', style: TextStyle(fontSize: 24)),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => setState(() => quantity++),
                    ),
                  ],
                ),
                if (product.itemsPerBox > 1)
                  TextButton(
                    child: Text('Add Full Box (${product.itemsPerBox} items)'),
                    onPressed: () {
                      quantity = product.itemsPerBox;
                      Navigator.pop(context);
                      widget.onProductSelected(product, quantity);
                    },
                  ),
              ],
            ),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: Text("Add"),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onProductSelected(product, quantity);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
