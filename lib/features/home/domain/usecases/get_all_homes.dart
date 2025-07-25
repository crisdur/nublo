import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/home/home.dart';
import '../repositories/home_repository.dart';

class GetAllHomes extends NetworkUseCase<List<Home>, NoParams> {
  GetAllHomes(this.repository);

  final HomeRepository repository;

  @override
  Future<Either<Failure, List<Home>>> execute(NoParams params) async {
    return await repository.getAllHomes();
  }
} 