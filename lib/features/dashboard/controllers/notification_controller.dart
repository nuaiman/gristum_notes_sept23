import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gristum_notes_app/models/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends StateNotifier<NotificationModel> {
  NotificationController()
      : super(
          NotificationModel(
            allowed: true,
            twoDays: true,
            oneDay: true,
            oneHour: true,
          ),
        );

  void loadNotificationStatus() async {
    final prefs = await SharedPreferences.getInstance();

    final allowed = prefs.getBool('allowed') ?? true;
    final twoDays = prefs.getBool('2Days') ?? true;
    final oneDay = prefs.getBool('1Day') ?? true;
    final oneHour = prefs.getBool('1Hour') ?? true;

    state = state.copyWith(
      allowed: allowed,
      twoDays: twoDays,
      oneDay: oneDay,
      oneHour: oneHour,
    );
  }

  void updateAllowedNotification(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == false) {
      const allowed = false;
      const twoDays = false;
      const oneDay = false;
      const oneHour = false;
      prefs.setBool('allowed', false);
      prefs.setBool('2Days', false);
      prefs.setBool('1Day', false);
      prefs.setBool('1Hour', false);
      state = state.copyWith(
        allowed: allowed,
        twoDays: twoDays,
        oneDay: oneDay,
        oneHour: oneHour,
      );
      return;
    }
    prefs.setBool('allowed', value);
    final allowed = value;
    state = state.copyWith(
      allowed: allowed,
    );
  }

  void update2DaysNotification(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('2Days', value);
    final twoDays = value;
    state = state.copyWith(
      twoDays: twoDays,
    );
  }

  void update1DayNotification(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('1Day', value);
    final oneDay = value;
    state = state.copyWith(
      oneDay: oneDay,
    );
  }

  void update1HourNotification(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('1Hour', value);
    final oneHour = value;
    state = state.copyWith(
      oneHour: oneHour,
    );
  }
}
// -----------------------------------------------------------------------------

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, NotificationModel>((ref) {
  return NotificationController();
});
