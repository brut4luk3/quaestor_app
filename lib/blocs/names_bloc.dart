import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/api.dart';
import 'names_event.dart';
import 'names_state.dart';

class NamesBloc extends Bloc<NamesEvent, NamesState> {
  final Api api;

  NamesBloc({required this.api}) : super(NamesInitial()) {
    on<LoadNamesEvent>(_onLoadNames);
  }

  Future<void> _onLoadNames(LoadNamesEvent event, Emitter<NamesState> emit) async {
    emit(NamesLoading());
    try {
      final names = await api.fetchNames();
      // Adicionando logs para depuração
      print('Names loaded: ${names.length}');
      emit(NamesLoaded(names: names));
    } catch (e) {
      // Adicionando logs para depuração
      print('Error loading names: $e');
      emit(NamesError());
    }
  }
}