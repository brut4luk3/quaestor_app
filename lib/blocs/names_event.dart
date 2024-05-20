import 'package:equatable/equatable.dart';

abstract class NamesEvent extends Equatable {
  const NamesEvent();

  @override
  List<Object> get props => [];
}

class LoadNamesEvent extends NamesEvent {
  const LoadNamesEvent();

  @override
  List<Object> get props => [];
}