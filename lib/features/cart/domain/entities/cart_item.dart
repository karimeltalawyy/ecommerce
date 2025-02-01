import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String id;
  final String name;
  final double price;
  final String size;
  final String imageUrl;
  final int quantity;

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.size,
    required this.imageUrl,
    required this.quantity,
  });

  @override
  List<Object?> get props => [id, name, price, size, imageUrl, quantity];

  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    String? size,
    String? imageUrl,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      size: size ?? this.size,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }
}
