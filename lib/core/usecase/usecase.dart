import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_app_bloc/core/error/failures.dart';

/// The "UseCase" class is an abstract class that takes two generic types: "Type" and "Params".
/// The class defines a single method called "call" that takes a "Params" object as an argument and returns a Future of "Either<Failure?, Type?>" object.
/// The "Either" object is used to represent either a failure or a successful result.
abstract class UseCase<Type, Params> {
  Future<Either<Failure?, Type?>?>? call(Params params);
}

abstract class UseCaseCastList<Type, Params> {
  Future<Either<Failure?, Type?>?>? call(Params params);
}

abstract class SearchUseCase<Type, Params> {
  Future<Either<Failure?, Type?>?>? call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
