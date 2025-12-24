import '../models/schedule_model.dart';
import '../services/schedule_service.dart';

class ScheduleRepository {
  final ScheduleService _scheduleService;

  ScheduleRepository(this._scheduleService);

  /// Get current outage schedules
  Future<List<ScheduleModel>> getCurrentSchedules({int limit = 7}) {
    return _scheduleService.getCurrentSchedules(limit: limit);
  }

  /// Get the latest schedule
  Future<ScheduleModel> getLatestSchedule() {
    return _scheduleService.getLatestSchedule();
  }
}
