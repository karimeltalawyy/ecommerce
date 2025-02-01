import 'package:e_commerce/features/cart/domain/entities/cart_item.dart';
import 'package:e_commerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:e_commerce/features/home/domain/entities/product_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCartItems extends CartEvent {}

class UpdateCartItem extends CartEvent {
  final CartItem item;
  UpdateCartItem(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveCartItem extends CartEvent {
  final String id;
  RemoveCartItem(this.id);

  @override
  List<Object?> get props => [id];
}

class AddToCart extends CartEvent {
  final Product product;
  final String size;

  AddToCart({
    required this.product,
    this.size = 'M', // Default size, you can modify this as needed
  });

  @override
  List<Object?> get props => [product, size];
}

// States
abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double subtotal;
  final double shipping;
  final double total;

  CartLoaded({
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.total,
  });

  @override
  List<Object?> get props => [items, subtotal, shipping, total];
}

class CartError extends CartState {
  final String message;
  CartError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc({required this.repository}) : super(CartInitial()) {
    on<LoadCartItems>(_onLoadCartItems);
    on<UpdateCartItem>(_onUpdateCartItem);
    on<RemoveCartItem>(_onRemoveCartItem);
    on<AddToCart>(_onAddToCart);
  }

  Future<void> _onLoadCartItems(
      LoadCartItems event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await repository.getCartItems();
      final subtotal = _calculateSubtotal(items);
      const shipping = 5.0;
      final total = subtotal + shipping;

      emit(CartLoaded(
        items: items,
        subtotal: subtotal,
        shipping: shipping,
        total: total,
      ));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  double _calculateSubtotal(List<CartItem> items) {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  Future<void> _onUpdateCartItem(
      UpdateCartItem event, Emitter<CartState> emit) async {
    try {
      await repository.updateCartItem(event.item);
      add(LoadCartItems());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveCartItem(
      RemoveCartItem event, Emitter<CartState> emit) async {
    try {
      await repository.removeCartItem(event.id);
      add(LoadCartItems());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      final cartItem = CartItem(
        id: event.product.id.toString(),
        name: event.product.title,
        price: event.product.price,
        size: event.size,
        imageUrl: event.product.image,
        quantity: 1,
      );

      await repository.updateCartItem(cartItem);
      add(LoadCartItems());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
