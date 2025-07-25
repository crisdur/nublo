import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/home/home.dart';
import '../../../domain/usecases/get_all_homes.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this.getAllHomes,
  }) : super(const HomeState.initial());

  final GetAllHomes getAllHomes;

  Future<void> loadAllHomes() async {
    emit(const HomeState.loading());
    
    final Either<Failure, List<Home>> result = 
        await getAllHomes(NoParams());

    result.fold(
      (failure) => emit(HomeState.error(failure.message?.toString() ?? 'Error loading homes')),
      (items) => emit(HomeState.success(items)),
    );
  }
} 