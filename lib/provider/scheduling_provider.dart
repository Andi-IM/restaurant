import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:dicoding_restaurant/utils/background_service.dart';
import 'package:dicoding_restaurant/utils/date_time_provider.dart';
import 'package:flutter/material.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  Future<bool> shceduledNews(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
      print('Scheduling Reminder Activated!');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Sceduling Reminder Aborted!');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
