import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/api.dart';
import 'names_event.dart';
import 'names_state.dart';

class NamesBloc extends Bloc<NamesEvent, NamesState> {
  final Api api;

  NamesBloc({required this.api}) : super(NamesInitial()) {
    on<LoadNamesEvent>((event, emit) async {
      emit(NamesLoading());
      try {
        final names = await api.fetchNames();
        emit(NamesLoaded(names: names));
      } catch (_) {
        emit(NamesError());
      }
    });
  }
}