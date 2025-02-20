import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stock_entry/stock_entry.dart';

class StockEntryListPage extends StatefulWidget {
  @override
  _StockEntryListPageState createState() => _StockEntryListPageState();
}

class _StockEntryListPageState extends State<StockEntryListPage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> stockEntries = [];

  late Box<StockEntry> stockBox;

  @override
  void initState() {
    super.initState();
    loadStockEntries();
  }

  void loadStockEntries() async {
    var box = await Hive.openBox('stock_entries');
    setState(() {
      stockEntries =
          box.values.map((e) => Map<String, dynamic>.from(e)).toList();
    });
  }

  void filterEntries(String query) {
    // Implement search filter logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stock Entry List"),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Implement filter logic
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search by Invoice ID",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: filterEntries,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: stockEntries.length,
              itemBuilder: (context, index) {
                final entry = stockEntries[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text("Invoice: ${entry['invoice_id']}"),
                    subtitle: Text(
                        "Vendor: ${entry['vendor_name']}\nDate: ${entry['date']}"),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Items: ${entry['items'].length}"),
                        Text(entry['status'],
                            style: TextStyle(
                                color: entry['status'] == 'Draft'
                                    ? Colors.orange
                                    : Colors.green)),
                      ],
                    ),
                    onTap: () {
                      if (entry['status'] == 'Draft') {
                        // Navigate to stock entry continuation
                      } else {
                        // Navigate to stock details view
                      }
                    },
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
