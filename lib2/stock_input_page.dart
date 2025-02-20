import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stock_entry/stockentry_page.dart';
import 'dart:io';

import 'package:stock_entry/stockin_list.dart';

class StockInputPage extends StatefulWidget {
  @override
  _StockInputPageState createState() => _StockInputPageState();
}

class _StockInputPageState extends State<StockInputPage> {
  final TextEditingController _vendorController = TextEditingController();
  final TextEditingController _invoiceController = TextEditingController();
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
      _invoiceController.text = 'INV-${DateTime.now().millisecondsSinceEpoch}';
    });
  }

  void _proceedToStockEntry() {
    if (_vendorController.text.isEmpty || _invoiceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    // Navigate to stock entry page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StockEntryPage(invoiceId: _invoiceController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stock Input')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _vendorController,
              decoration: InputDecoration(labelText: 'Vendor Name'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _invoiceController,
                    decoration: InputDecoration(labelText: 'Invoice ID'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.autorenew),
                  onPressed: _generateInvoiceId,
                ),
              ],
            ),
            SizedBox(height: 16),
            _invoiceImage != null
                ? Image.file(_invoiceImage!, height: 100)
                : TextButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: Text('Capture Invoice'),
                    onPressed: _pickInvoiceImage,
                  ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _proceedToStockEntry,
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
