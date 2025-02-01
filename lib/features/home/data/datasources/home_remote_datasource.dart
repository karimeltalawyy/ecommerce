import 'package:dio/dio.dart';
import 'package:e_commerce/core/errors/exceptions.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<ProductModel>> getProductsByCategory(String category);
  Future<List<String>> getCategories();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await dio.get('https://fakestoreapi.com/products');

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((product) => ProductModel.fromJson(product))
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to fetch products',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await dio.get(
        'https://fakestoreapi.com/products/category/$category',
      );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((product) => ProductModel.fromJson(product))
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to fetch products by category',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await dio.get(
        'https://fakestoreapi.com/products/categories',
      );

      if (response.statusCode == 200) {
        return (response.data as List).map((e) => e.toString()).toList();
      } else {
        throw ServerException(
          message: 'Failed to fetch categories',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
