import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/data_repository.dart';
import 'goal_event.dart';
import 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  final DataRepository _dataRepository;

  GoalBloc(this._dataRepository) : super(GoalInitial()) {
    on<GoalLoadRequested>(_onLoadRequested);
    on<GoalCreateRequested>(_onCreateRequested);
    on<GoalDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onLoadRequested(
    GoalLoadRequested event,
    Emitter<GoalState> emit,
  ) async {
    emit(GoalLoading());
    try {
      final goals = await _dataRepository.getGoals(month: event.month);
      emit(GoalLoaded(goals));
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  Future<void> _onCreateRequested(
    GoalCreateRequested event,
    Emitter<GoalState> emit,
  ) async {
    try {
      await _dataRepository.createGoal(event.goal);
      if (state is GoalLoaded) {
        final updated = await _dataRepository.getGoals();
        emit(GoalLoaded(updated));
      }
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  Future<void> _onDeleteRequested(
    GoalDeleteRequested event,
    Emitter<GoalState> emit,
  ) async {
    try {
      await _dataRepository.deleteGoal(event.id);
      if (state is GoalLoaded) {
        final currentGoals = (state as GoalLoaded).goals;
        final updated = currentGoals.where((g) => g.id != event.id).toList();
        emit(GoalLoaded(updated));
      }
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }
}

