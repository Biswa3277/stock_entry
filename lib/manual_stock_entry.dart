import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stock_entry/models/stockin_model.dart';

class ManualStockEntry extends StatefulWidget {
  final String invoiceId;

  const ManualStockEntry({required this.invoiceId});

  @override
  _ManualStockEntryState createState() => _ManualStockEntryState();
}

class _ManualStockEntryState extends State<ManualStockEntry> {
  late StockEntry _stockEntry;
  late Box<StockEntry> _stockBox;

  final _productIdController = TextEditingController();
  final _productNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _stockBox = Hive.box<StockEntry>('stockEntries');
    _stockEntry = _stockBox.get(widget.invoiceId) ??
        StockEntry(
          invoiceId: widget.invoiceId,
          vendorName: 'Unknown',
          itemQuantity: 'Unknown',
          products: [],
          status: 'draft',
        );
  }

  Future<void> _saveEntry() async {
    await _stockBox.put(_stockEntry.invoiceId, _stockEntry);
  }

  void _addProduct() {
    final newProduct = ScannedProduct(
      productId: _productIdController.text,
      productName: _productNameController.text,
      quantity: int.tryParse(_quantityController.text) ?? 0,
      price: double.tryParse(_priceController.text) ?? 0.0,
    );

    setState(() {
      _stockEntry.products.add(newProduct);
      _stockEntry.status = 'in-progress';
    });

    _saveEntry();
    _clearProductFields();
  }

  void _completeEntry() async {
    setState(() => _stockEntry.status = 'completed');
    await _saveEntry();
    Navigator.pop(context);
  }

  void _clearProductFields() {
    _productIdController.clear();
    _productNameController.clear();
    _quantityController.clear();
    _priceController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Stock Entry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveEntry,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildEntryHeader(),
            const SizedBox(height: 20),
            _buildProductForm(),
            const SizedBox(height: 20),
            _buildProductList(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _completeEntry,
              child: const Text('Complete Entry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Invoice ID: ${_stockEntry.invoiceId}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Vendor: ${_stockEntry.vendorName}'),
            if (_stockEntry.invoicePhoto != null)
              Image.file(File(_stockEntry.invoicePhoto!)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Add New Product:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        TextField(
          controller: _productIdController,
          decoration: const InputDecoration(labelText: 'Product ID'),
        ),
        TextField(
          controller: _productNameController,
          decoration: const InputDecoration(labelText: 'Product Name'),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: _addProduct,
          child: const Text('Add Product'),
        ),
      ],
    );
  }

  Widget _buildProductList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Added Products:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _stockEntry.products.length,
          itemBuilder: (context, index) {
            final product = _stockEntry.products[index];
            return Card(
              child: ListTile(
                title: Text(product.productName),
                subtitle: Text('ID: ${product.productId}'),
                trailing: Text(
                  '${product.quantity} x \$${product.price.toStringAsFixed(2)}',
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
