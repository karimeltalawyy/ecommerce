import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/exceptions.dart';
import 'package:e_commerce/core/errors/failures.dart';
import 'package:e_commerce/core/network/network_info.dart';
import 'package:e_commerce/features/home/data/datasources/home_local_datasource.dart';
import 'package:e_commerce/features/home/data/datasources/home_remote_datasource.dart';
import 'package:e_commerce/features/home/domain/entities/product_entity.dart';
import 'package:e_commerce/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getProducts();
        await localDataSource.cacheProducts(products);
        return Right(products);
      } on ServerException catch (e) {
        return Left(
            ServerFailure(message: e.message, statusCode: e.statusCode));
      }
    } else {
      try {
        final localProducts = await localDataSource.getCachedProducts();
        return Right(localProducts);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(
      String category) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getProductsByCategory(category);
        return Right(products);
      } on ServerException catch (e) {
        return Left(
            ServerFailure(message: e.message, statusCode: e.statusCode));
      }
    } else {
      return Left(const NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final categories = await remoteDataSource.getCategories();
        await localDataSource.cacheCategories(categories);
        return Right(categories);
      } on ServerException catch (e) {
        return Left(
            ServerFailure(message: e.message, statusCode: e.statusCode));
      }
    } else {
      try {
        final localCategories = await localDataSource.getCachedCategories();
        return Right(localCategories);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }
}
