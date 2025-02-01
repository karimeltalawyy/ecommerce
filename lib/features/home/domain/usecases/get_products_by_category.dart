import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/failures.dart';
import 'package:e_commerce/core/usecases/usecase.dart';
import 'package:e_commerce/features/home/domain/entities/product_entity.dart';
import 'package:e_commerce/features/home/domain/repositories/home_repository.dart';
import 'package:equatable/equatable.dart';

class GetProductsByCategory implements UseCase<List<Product>, CategoryParams> {
  final HomeRepository repository;

  const GetProductsByCategory(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(CategoryParams params) async {
    return await repository.getProductsByCategory(params.category);
  }
}

class CategoryParams extends Equatable {
  final String category;

  const CategoryParams({required this.category});

  @override
  List<Object?> get props => [category];
}
