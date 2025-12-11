import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/data_repository.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final DataRepository _dataRepository;

  TransactionBloc(this._dataRepository) : super(TransactionInitial()) {
    on<TransactionLoadRequested>(_onLoadRequested);
    on<TransactionCreateRequested>(_onCreateRequested);
    on<TransactionUpdateRequested>(_onUpdateRequested);
    on<TransactionDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onLoadRequested(
    TransactionLoadRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      final transactions = await _dataRepository.getTransactions(month: event.month);
      emit(TransactionLoaded(transactions));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onCreateRequested(
    TransactionCreateRequested event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await _dataRepository.createTransaction(event.transaction);
      if (state is TransactionLoaded) {
        final updated = await _dataRepository.getTransactions();
        emit(TransactionLoaded(updated));
      }
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onUpdateRequested(
    TransactionUpdateRequested event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await _dataRepository.updateTransaction(event.id, event.transaction);
      if (state is TransactionLoaded) {
        final updated = await _dataRepository.getTransactions();
        emit(TransactionLoaded(updated));
      }
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onDeleteRequested(
    TransactionDeleteRequested event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await _dataRepository.deleteTransaction(event.id);
      if (state is TransactionLoaded) {
        final currentTransactions = (state as TransactionLoaded).transactions;
        final updated = currentTransactions.where((t) => t.id != event.id).toList();
        emit(TransactionLoaded(updated));
      }
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}

