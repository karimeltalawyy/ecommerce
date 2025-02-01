import 'package:hive/hive.dart';
import 'package:e_commerce/features/cart/data/models/cart_item_model.dart';

class CartItemModelAdapter extends TypeAdapter<CartItemModel> {
  @override
  final int typeId = 0;

  @override
  CartItemModel read(BinaryReader reader) {
    final map = Map<String, dynamic>.from(reader.readMap());
    return CartItemModel(
      id: map['id'] as String,
      name: map['name'] as String,
      price: map['price'] as double,
      size: map['size'] as String,
      imageUrl: map['imageUrl'] as String,
      quantity: map['quantity'] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CartItemModel obj) {
    writer.writeMap({
      'id': obj.id,
      'name': obj.name,
      'price': obj.price,
      'size': obj.size,
      'imageUrl': obj.imageUrl,
      'quantity': obj.quantity,
    });
  }
}
