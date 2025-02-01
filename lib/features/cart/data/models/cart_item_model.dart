import 'package:e_commerce/features/cart/domain/entities/cart_item.dart';

class CartItemModel {
  final String id;
  final String name;
  final double price;
  final String size;
  final String imageUrl;
  final int quantity;

  CartItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.size,
    required this.imageUrl,
    required this.quantity,
  });

  CartItem toEntity() => CartItem(
        id: id,
        name: name,
        price: price,
        size: size,
        imageUrl: imageUrl,
        quantity: quantity,
      );

  factory CartItemModel.fromEntity(CartItem item) => CartItemModel(
        id: item.id,
        name: item.name,
        price: item.price,
        size: item.size,
        imageUrl: item.imageUrl,
        quantity: item.quantity,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'size': size,
        'imageUrl': imageUrl,
        'quantity': quantity,
      };

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        id: json['id'] as String,
        name: json['name'] as String,
        price: json['price'] as double,
        size: json['size'] as String,
        imageUrl: json['imageUrl'] as String,
        quantity: json['quantity'] as int,
      );
}
