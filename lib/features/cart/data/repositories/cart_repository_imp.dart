import 'package:e_commerce/features/cart/data/models/cart_item_model.dart';
import 'package:e_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:e_commerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CartRepositoryImpl implements CartRepository {
  final Box<CartItemModel> cartBox;

  CartRepositoryImpl({required this.cartBox});

  @override
  Future<List<CartItem>> getCartItems() async {
    return cartBox.values.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateCartItem(CartItem item) async {
    final model = CartItemModel.fromEntity(item);
    await cartBox.put(item.id, model);
  }

  @override
  Future<void> removeCartItem(String id) async {
    await cartBox.delete(id);
  }
}
