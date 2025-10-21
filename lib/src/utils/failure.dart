import 'package:equatable/equatable.dart';

abstract class HighQFailure extends Equatable {
  final String message;

  const HighQFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class HighQRequestSourceFailure extends HighQFailure {
  const HighQRequestSourceFailure({required super.message});
}

class HighQApiFailure extends HighQFailure {
  const HighQApiFailure({required super.message});
}
