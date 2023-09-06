import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gristum_notes_app/models/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends StateNotifier<SettingsModel> {
  SettingsController()
      : super(
          SettingsModel(height: 0, percent: 0),
        );

  void loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final height = prefs.getString('hightLimit') ?? 12.0;
    final percent = prefs.getString('percentLimit') ?? 10.0;

    state = state.copyWith(
      height: height as double,
      percent: percent as double,
    );

    final newState = state;
    state = newState;
  }

  void updateHeightLimit(double height) async {
    state = state.copyWith(height: height);
    final newState = state;
    state = newState;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('hightLimit', height.toString());
  }

  void updatePercentLimit(double percent) async {
    state = state.copyWith(percent: percent);
    final newState = state;
    state = newState;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('percentLimit', percent.toString());
  }
}
// -----------------------------------------------------------------------------

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsModel>((ref) {
  return SettingsController();
});
