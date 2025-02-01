import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/errors/failures.dart';
import 'package:e_commerce/core/usecases/usecase.dart';
import 'package:e_commerce/features/home/domain/repositories/home_repository.dart';

class GetCategories implements UseCase<List<String>, NoParams> {
  final HomeRepository repository;

  const GetCategories(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await repository.getCategories();
  }
}
