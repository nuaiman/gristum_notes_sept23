import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gristum_notes_app/models/project_model.dart';

class ProjectsController extends StateNotifier<List<ProjectModel>> {
  ProjectsController() : super([]);

  void addSingleProject(ProjectModel project) {
    final newState = [...state, project];
    state = newState;
  }
}
// -----------------------------------------------------------------------------

final projectsControllerProvider =
    StateNotifierProvider<ProjectsController, List<ProjectModel>>((ref) {
  return ProjectsController();
});
