import 'package:equatable/equatable.dart';
import '../../models/goal.dart';

abstract class GoalEvent extends Equatable {
  const GoalEvent();

  @override
  List<Object?> get props => [];
}

class GoalLoadRequested extends GoalEvent {
  final String? month;

  const GoalLoadRequested({this.month});

  @override
  List<Object?> get props => [month];
}

class GoalCreateRequested extends GoalEvent {
  final Goal goal;

  const GoalCreateRequested(this.goal);

  @override
  List<Object?> get props => [goal];
}

class GoalDeleteRequested extends GoalEvent {
  final String id;

  const GoalDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}

