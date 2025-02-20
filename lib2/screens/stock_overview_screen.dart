import 'package:flutter/material.dart';
import '../../lib/services/api_service.dart';

class StockOverviewScreen extends StatefulWidget {
  @override
  _StockOverviewScreenState createState() => _StockOverviewScreenState();
}

class _StockOverviewScreenState extends State<StockOverviewScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> stockList = [];

  void searchStock() async {
    final result = await ApiService.searchStock(searchController.text);
    setState(() {
      stockList = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stock Overview")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search by Product Name or Barcode",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: searchStock,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: stockList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(stockList[index]['name']),
                  subtitle: Text("Stock: ${stockList[index]['stock']}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
