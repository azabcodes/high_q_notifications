import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class RequestSourceFailure extends Failure {
  const RequestSourceFailure({required super.message});
}

class ApiFailure extends Failure {
  const ApiFailure({required super.message});
}
