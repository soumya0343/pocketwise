import 'package:equatable/equatable.dart';
import '../../models/transaction.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class TransactionLoadRequested extends TransactionEvent {
  final String? month;

  const TransactionLoadRequested({this.month});

  @override
  List<Object?> get props => [month];
}

class TransactionCreateRequested extends TransactionEvent {
  final Transaction transaction;

  const TransactionCreateRequested(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class TransactionUpdateRequested extends TransactionEvent {
  final String id;
  final Transaction transaction;

  const TransactionUpdateRequested(this.id, this.transaction);

  @override
  List<Object?> get props => [id, transaction];
}

class TransactionDeleteRequested extends TransactionEvent {
  final String id;

  const TransactionDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}

