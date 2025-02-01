import 'package:e_commerce/features/home/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<List<String>> getCategories();
  Future<List<Product>> getProductsByCategory(String category);
}
