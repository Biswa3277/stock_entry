import 'package:hive/hive.dart';

class LocalStorageService {
  static Box? _box;

  static Future<void> init() async {
    _box = await Hive.openBox('scanned_products');
  }

  static void saveScannedProducts(List<Map<String, dynamic>> products) {
    _box?.put('products', products);
  }

  static List<Map<String, dynamic>> getScannedProducts() {
    return _box
            ?.get('products', defaultValue: [])?.cast<Map<String, dynamic>>() ??
        [];
  }

  static void clearScannedProducts() {
    _box?.delete('products');
  }
}
