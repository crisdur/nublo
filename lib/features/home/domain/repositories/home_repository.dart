import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/home/home.dart';
 
abstract class HomeRepository {
  Future<Either<Failure, List<Home>>> getAllHomes();
} 