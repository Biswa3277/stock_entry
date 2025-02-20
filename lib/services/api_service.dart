import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>?> fetchProductDetails(
      String barcode) async {
    final response =
        await http.get(Uri.parse('https://api.example.com/products/$barcode'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }

  static Future<void> submitStockOut(
      List<Map<String, dynamic>> stockData) async {
    await http.post(Uri.parse('https://api.example.com/stock/submit'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'products': stockData}));
  }

  static Future<void> submitStockTransfer(
      List<Map<String, dynamic>> stockData, String logistics) async {
    await http.post(Uri.parse('https://api.example.com/stock/transfer'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'products': stockData, 'destination': logistics}));
  }

  static Future<List<Map<String, dynamic>>> searchStock(String query) async {
    final response = await http
        .get(Uri.parse('https://api.example.com/stock/search?q=$query'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    }
    return [];
  }
}
