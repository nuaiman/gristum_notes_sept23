import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gristum_notes_app/models/project_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectsController extends StateNotifier<List<ProjectModel>> {
  ProjectsController() : super([]);

  void addProject(ProjectModel project) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = jsonEncode(project);
    final newState = [...state, project];
    // -------------------------------------------------------------------------
    state = newState;
    // -------------------------------------------------------------------------
    prefs.setString(project.id, encodedData);
  }

  void deleteProject(ProjectModel project) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove(project.id);

    state.removeWhere((element) => element.id == project.id);

    final newState = [...state];
    state = newState;
  }

  void loadProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final projectIdsList = prefs.getKeys();

    projectIdsList.remove('hightLimit');
    projectIdsList.remove('percentLimit');
    projectIdsList.remove('allowed');
    projectIdsList.remove('2Days');
    projectIdsList.remove('1Day');
    projectIdsList.remove('1Hour');

    if (projectIdsList.isNotEmpty) {
      for (String i in projectIdsList) {
        // if (i == 'hightLimit') {
        //   return;
        // }
        // if (i == 'percentLimit') {
        //   return;
        // }
        final projectJson = prefs.getString(i);
        final decodedJson = jsonDecode(projectJson!);
        final project = ProjectModel.fromJson(decodedJson);
        if (state.contains(project)) {
          return;
        }
        state.add(project);
        final newState = [...state];
        state = newState.toSet().toList();
      }
      final newState = [...state];
      state = newState.toSet().toList();
    }
  }

  void editProjects(ProjectModel project) async {
    final prefs = await SharedPreferences.getInstance();

    final projectIndex =
        state.indexWhere((element) => element.id == project.id);
    state.removeAt(projectIndex);
    state.insert(projectIndex, project);

    final encodedData = jsonEncode(project);
    // -------------------------------------------------------------------------
    final newState = [...state];
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
