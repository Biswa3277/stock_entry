import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stock_entry/stockEntryList.dart';
import 'package:stock_entry/stockin.dart';
import 'package:stock_entry/models/stockin_model.dart';

// 1. Main Page (Stock Entries Overview)
class StockEntriesOverviewPage extends StatefulWidget {
  @override
  _StockEntriesOverviewPageState createState() =>
      _StockEntriesOverviewPageState();
}

class _StockEntriesOverviewPageState extends State<StockEntriesOverviewPage> {
  late Box<StockEntry> _stockBox;

  @override
  void initState() {
    super.initState();
    _stockBox = Hive.box<StockEntry>('stockEntries');
  }

  void _navigateToCreateEntry(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StockInputPage()),
    );
  }

  void _navigateToEntryDetail(String invoiceId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StockEntryListPage(invoiceId: invoiceId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Entries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToCreateEntry(context),
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<StockEntry>>(
        valueListenable: _stockBox.listenable(),
        builder: (context, box, _) {
          final entries = box.values.toList().reversed.toList();
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(entry.vendorName),
                  subtitle: Text('Invoice ID: ${entry.invoiceId}'),
                  trailing: Chip(
                    label: Text(entry.status),
                    backgroundColor: entry.status == 'draft'
                        ? Colors.orange[100]
                        : Colors.green[100],
                  ),
                  onTap: () => _navigateToEntryDetail(entry.invoiceId),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
