import 'package:equatable/equatable.dart';
import 'package:e_commerce/features/home/domain/entities/product_entity.dart';

class HomeState extends Equatable {
  final List<Product> products;
  final List<String> categories;
  final String? selectedCategory;
  final String? error;
  final bool isLoading;

  const HomeState({
    this.products = const [],
    this.categories = const [],
    this.selectedCategory,
    this.error,
    this.isLoading = false,
  });

  HomeState copyWith({
    List<Product>? products,
    List<String>? categories,
    String? selectedCategory,
    String? error,
    bool? isLoading,
  }) {
    return HomeState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        products,
        categories,
        selectedCategory,
        error,
        isLoading,
      ];
}
