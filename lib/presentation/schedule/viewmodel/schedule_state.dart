import 'package:equatable/equatable.dart';
import '../../../data/models/schedule_model.dart';

/// Base state for schedule feature
abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

/// Initial state when screen is first opened
class ScheduleInitial extends ScheduleState {}

/// Loading state for initial data fetch
class ScheduleLoading extends ScheduleState {}

/// State when schedules are successfully loaded
class ScheduleLoaded extends ScheduleState {
  final List<ScheduleModel> schedules;
  final DateTime? lastUpdated;

  const ScheduleLoaded(this.schedules, {this.lastUpdated});

  @override
  List<Object?> get props => [schedules, lastUpdated];
}

/// Refreshing state when user pulls to refresh
/// Keeps showing existing data while fetching new data
class ScheduleRefreshing extends ScheduleLoaded {
  const ScheduleRefreshing(super.schedules, {super.lastUpdated});
}

/// Error state when data fetch fails
class ScheduleError extends ScheduleState {
  final String message;

  const ScheduleError(this.message);

  @override
  List<Object?> get props => [message];
}
