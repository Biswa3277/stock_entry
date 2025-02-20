// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stockin_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockEntryAdapter extends TypeAdapter<StockEntry> {
  @override
  final int typeId = 0;

  @override
  StockEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockEntry(
      invoiceId: fields[0] as String,
      vendorName: fields[1] as String,
      itemQuantity: fields[2] as String?,
      invoicePhoto: fields[3] as String?,
      products: (fields[4] as List).cast<ScannedProduct>(),
      status: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StockEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.invoiceId)
      ..writeByte(1)
      ..write(obj.vendorName)
      ..writeByte(2)
      ..write(obj.itemQuantity)
      ..writeByte(3)
      ..write(obj.invoicePhoto)
      ..writeByte(4)
      ..write(obj.products)
      ..writeByte(5)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ScannedProductAdapter extends TypeAdapter<ScannedProduct> {
  @override
  final int typeId = 1;

  @override
  ScannedProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScannedProduct(
      productId: fields[0] as String,
      productName: fields[1] as String,
      quantity: fields[2] as int,
      price: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ScannedProduct obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScannedProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
