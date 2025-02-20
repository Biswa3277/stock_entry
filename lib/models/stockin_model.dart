import 'package:hive/hive.dart';

part 'stockin_model.g.dart';

@HiveType(typeId: 0)
class StockEntry extends HiveObject {
  @HiveField(0)
  String invoiceId;

  @HiveField(1)
  String vendorName;

  @HiveField(2)
  String? itemQuantity;

  @HiveField(3)
  String? invoicePhoto;

  @HiveField(4)
  List<ScannedProduct> products;

  @HiveField(5)
  String status;

  StockEntry({
    required this.invoiceId,
    required this.vendorName,
    required this.itemQuantity,
    this.invoicePhoto,
    required this.products,
    this.status = 'draft',
  });
}

@HiveType(typeId: 1)
class ScannedProduct {
  @HiveField(0)
  String productId;

  @HiveField(1)
  String productName;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  double price;

  ScannedProduct({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  ScannedProduct copyWith({
    String? productId,
    String? productName,
    int? quantity,
    double? price,
  }) {
    return ScannedProduct(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}
