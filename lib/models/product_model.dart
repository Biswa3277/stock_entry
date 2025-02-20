import 'package:hive/hive.dart';

part 'product_model.g.dart';

// Product model for local storage
@HiveType(typeId: 2)
class Product {
  @HiveField(0)
  final String productBarcode;

  @HiveField(1)
  final String boxBarcode;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String imagePath;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final int itemsPerBox;

  Product({
    required this.productBarcode,
    required this.boxBarcode,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.itemsPerBox,
  });
}
