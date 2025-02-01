import 'package:e_commerce/features/cart/domain/entities/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartItems();
  Future<void> updateCartItem(CartItem item);
  Future<void> removeCartItem(String id);
}
