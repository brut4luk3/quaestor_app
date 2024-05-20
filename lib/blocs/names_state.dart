import 'package:equatable/equatable.dart';

abstract class NamesState extends Equatable {
  @override
  List<Object> get props => [];
}

class NamesInitial extends NamesState {}

class NamesLoading extends NamesState {}

class NamesLoaded extends NamesState {
  final List names;

  NamesLoaded({required this.names});

  @override
  List<Object> get props => [names];
}

class NamesError extends NamesState {}