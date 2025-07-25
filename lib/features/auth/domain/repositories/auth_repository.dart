import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/auth/auth.dart';
 
abstract class AuthRepository {
  Future<Either<Failure, List<Auth>>> getAllAuths();
} 