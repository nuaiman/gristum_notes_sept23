import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gristum_notes_app/models/stump_model.dart';

class StumpsController extends StateNotifier<List<StumpModel>> {
  StumpsController() : super([]);
}
// -----------------------------------------------------------------------------

final stumpsControllerProvider =
    StateNotifierProvider<StumpsController, List<StumpModel>>((ref) {
  return StumpsController();
});
