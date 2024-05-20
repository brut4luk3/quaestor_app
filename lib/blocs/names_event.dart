import 'package:equatable/equatable.dart';

abstract class NamesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadNamesEvent extends NamesEvent {}