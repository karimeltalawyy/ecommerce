import 'package:e_commerce/core/errors/exceptions.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:hive/hive.dart';

abstract class HomeLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();
  Future<void> cacheProducts(List<ProductModel> products);
  Future<List<String>> getCachedCategories();
  Future<void> cacheCategories(List<String> categories);
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final Box<dynamic> productsBox;
  final Box<dynamic> categoriesBox;

  HomeLocalDataSourceImpl({
    required this.productsBox,
    required this.categoriesBox,
  });

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    try {
      final productsJson = productsBox.get('products') as List<dynamic>?;
      if (productsJson != null) {
        return productsJson
            .map((product) =>
                ProductModel.fromJson(Map<String, dynamic>.from(product)))
            .toList();
      } else {
        throw CacheException(message: 'No cached products found');
      }
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      await productsBox.put(
        'products',
        products.map((product) => product.toJson()).toList(),
      );
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<List<String>> getCachedCategories() async {
    try {
      final categories = categoriesBox.get('categories') as List<dynamic>?;
      if (categories != null) {
        return categories.map((e) => e.toString()).toList();
      } else {
        throw CacheException(message: 'No cached categories found');
      }
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> cacheCategories(List<String> categories) async {
    try {
      await categoriesBox.put('categories', categories);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
