import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stock_entry/stockentries_overview.dart';
import 'dart:io';

import 'package:stock_entry/models/stockin_model.dart';

class StockInputPage extends StatefulWidget {
  @override
  _StockInputPageState createState() => _StockInputPageState();
}

class _StockInputPageState extends State<StockInputPage> {
  final TextEditingController _vendorController = TextEditingController();
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _itemQuantityController = TextEditingController();
  File? _invoiceImage;

  Future<void> _pickInvoiceImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _invoiceImage = File(pickedFile.path);
      });
    }
  }

  void _generateInvoiceId() {
    setState(() {
      _invoiceController.text =
          '${_vendorController.text}-${DateTime.now().millisecond}';
    });
  }

  void _proceedToStockEntry() {
    if (_vendorController.text.isEmpty ||
        _invoiceController.text.isEmpty ||
        _itemQuantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Create a new StockEntry with empty products
    final newEntry = StockEntry(
      invoiceId: _invoiceController.text,
      vendorName: _vendorController.text,
      itemQuantity: _itemQuantityController.text,
      invoicePhoto: _invoiceImage?.path,
      products: [],
      status: 'draft',
    );

    // Save the new StockEntry to the database
    Hive.box<StockEntry>('stockEntries').put(newEntry.invoiceId, newEntry);

    // Clear form fields
    _vendorController.clear();
    _invoiceController.clear();
    _invoiceImage = null;

    // Navigate to stock entry page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StockEntriesOverviewPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stock Input')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _vendorController,
              decoration: InputDecoration(labelText: 'Vendor Name'),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _invoiceController,
                    decoration: const InputDecoration(labelText: 'Invoice ID'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.autorenew),
                  onPressed: _generateInvoiceId,
                ),
              ],
            ),
            TextField(
              controller: _itemQuantityController,
              decoration:
                  const InputDecoration(labelText: 'Total Item Quantity'),
            ),
            const SizedBox(height: 16),
            _invoiceImage != null
                ? Image.file(_invoiceImage!, height: 100)
                : TextButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: Text('Capture Invoice'),
                    onPressed: _pickInvoiceImage,
                  ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _proceedToStockEntry,
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
