import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/data_repository.dart';
import 'summary_event.dart';
import 'summary_state.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final DataRepository _dataRepository;

  SummaryBloc(this._dataRepository) : super(SummaryInitial()) {
    on<SummaryLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    SummaryLoadRequested event,
    Emitter<SummaryState> emit,
  ) async {
    emit(SummaryLoading());
    try {
      final summary = await _dataRepository.getSummary(event.month);
      emit(SummaryLoaded(summary));
    } catch (e) {
      emit(SummaryError(e.toString()));
    }
  }
}

