import 'package:equatable/equatable.dart';

// The "Failure" class is an abstract class that extends the "Equatable" class and provides a basic implementation for handling errors.

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);
}

class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class CacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class DeviceIsOfflineFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class EndOfTheListFailure extends Failure {
  @override
  List<Object?> get props => [];
}
