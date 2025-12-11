import 'package:equatable/equatable.dart';

abstract class SummaryEvent extends Equatable {
  const SummaryEvent();

  @override
  List<Object?> get props => [];
}

class SummaryLoadRequested extends SummaryEvent {
  final String month; // "YYYY-MM"

  const SummaryLoadRequested(this.month);

  @override
  List<Object?> get props => [month];
}

