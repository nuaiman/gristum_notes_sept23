import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gristum_notes_app/models/project_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectsController extends StateNotifier<List<ProjectModel>> {
  ProjectsController() : super([]);

  void addProject(ProjectModel project) async {
    print('adding');
    final prefs = await SharedPreferences.getInstance();
    final encodedData = jsonEncode(project);
    final newState = [...state, project];
    // -------------------------------------------------------------------------
    state = newState;
    // -------------------------------------------------------------------------
    prefs.setString(project.id, encodedData);
  }

  void loadProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final projectIdsList = prefs.getKeys();

    if (projectIdsList.isNotEmpty) {
      for (String i in projectIdsList) {
        final projectJson = prefs.getString(i);
        final decodedJson = jsonDecode(projectJson!);
        final project = ProjectModel.fromJson(decodedJson);
        if (state.contains(project)) {
          return;
        }
        state.add(project);
      }
      final newState = [...state];
      state = newState.toSet().toList();
    }
  }

  void editProjects(ProjectModel project) async {
    print('editing');

    final prefs = await SharedPreferences.getInstance();

    final projectIndex =
        state.indexWhere((element) => element.id == project.id);
    state.removeAt(projectIndex);
    state.insert(projectIndex, project);

    final encodedData = jsonEncode(project);
    // -------------------------------------------------------------------------
    final newState = [...state, project];
    state = newState;
    // -------------------------------------------------------------------------
    prefs.setString(project.id, encodedData);
  }
}
// -----------------------------------------------------------------------------

final projectsControllerProvider =
    StateNotifierProvider<ProjectsController, List<ProjectModel>>((ref) {
  return ProjectsController();
});
