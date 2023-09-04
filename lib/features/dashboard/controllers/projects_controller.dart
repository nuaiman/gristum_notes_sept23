import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gristum_notes_app/features/dashboard/controllers/stumps_controller.dart';
import 'package:gristum_notes_app/models/project_model.dart';
import 'package:gristum_notes_app/models/stump_model.dart';

import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class ProjectsController extends StateNotifier<List<ProjectModel>> {
  ProjectsController() : super([]);

  // void addSingleProject(ProjectModel project) {
  //   final newState = [...state, project];
  //   state = newState;
  // }

  String dbName = 'projects';

  Future<Database> _getDatabse() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, '$dbName.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE todo(id TEXT PRIMARY KEY, customerName TEXT, customerPhone TEXT, customerEmail TEXT, note TEXT, isComplete BOOLEAN, isCancelled BOOLEAN, address TEXT, latitude REAL, longitude REAL, firstCallDate TEXT, nextCallDate TEXT, stumps TEXT, stumpsCount INTEGER, totalCost REAL)');
      },
      version: 1,
    );
    return db;
  }

  List<ProjectModel> get todos => state;

  // int getActiveTodoCount() {
  //   final activeTodos = state.where((todo) => !todo.isDone).toList();
  //   return activeTodos.length;
  // }

  void addProject(ProjectModel project) async {
    final newProject = ProjectModel(
      id: project.id,
      firstCallDate: project.firstCallDate,
      nextCallDate: project.nextCallDate,
      customerName: project.customerName,
      customerPhone: project.customerPhone,
      customerEmail: project.customerEmail,
      note: project.note,
      address: project.address,
      latitude: project.latitude,
      longitude: project.longitude,
      stumps: project.stumps,
      stumpsCount: project.stumpsCount,
      totalCost: project.totalCost,
      isCancelled: project.isCancelled,
      isComplete: project.isComplete,
    );

    final db = await _getDatabse();
    db.insert(
      dbName,
      {
        'id': project.id,
        'customerName': project.customerName,
        'customerPhone': project.customerPhone,
        'customerEmail': project.customerEmail,
        'note': project.note,
        'isComplete': project.isComplete,
        'isCancelled': project.isCancelled,
        'address': project.address,
        'latitude': project.latitude,
        'longitude': project.longitude,
        'firstCallDate': project.firstCallDate.toString(),
        'nextCallDate': project.nextCallDate.toString(),
        'stumps': jsonEncode(project.stumps),
        'stumpsCount': project.stumpsCount,
        'totalCost': project.totalCost,
      },
    );

    state = [newProject, ...state];
  }

  Future<void> loadProjects(WidgetRef ref) async {
    final db = await _getDatabse();
    final data = await db.query(dbName);
    final stumps = data.map((row) {
      final List<dynamic> stumpsList = json.decode(row['stumps'] as String);
      final List<String> stumpIds = List<String>.from(stumpsList);
      List<StumpModel> stumps = [];
      for (String i in stumpIds) {
        final stump = ref
            .read(stumpsListControllerProvider)
            .firstWhere((element) => element.id == i);
        stumps.add(stump);
      }
      return ProjectModel(
        id: row['id'] as String,
        customerName: row['customerName'] as String,
        customerPhone: row['customerPhone'] as String,
        customerEmail: row['customerEmail'] as String,
        note: row['note'] as String,
        stumps: stumps,
        address: row['address'] as String,
        firstCallDate: DateTime.parse(row['firstCallDate'] as String),
        nextCallDate: DateTime.parse(row['nextCallDate'] as String),
        latitude: row['latitude'] as double,
        longitude: row['longitude'] as double,
        stumpsCount: row['stumpsCount'] as int,
        totalCost: row['totalCost'] as double,
        isCancelled: row['isCancelled'] as bool,
        isComplete: row['isComplete'] as bool,
      );
    }).toList();
    state = stumps;
  }

  // void updateTodoStatus(String updatableStumpId, bool value) async {
  //   final newStumpList = state.map((todo) {
  //     if (todo.id == updatableStumpId) {
  //       return ProjectModel(
  //         id: updatableStumpId,
  //         isDone: value,
  //         description: todo.description,
  //         images: todo.images,
  //       );
  //     }
  //     return todo;
  //   }).toList();

  //   final db = await _getDatabse();
  //   final data = {
  //     'isDone': value == true ? 'true' : 'false',
  //   };
  //   db.update('todo', data, where: "id = ?", whereArgs: [updatableTodoId]);

  //   state = newTodoList;
  // }

  // void editStump(
  //     String updatableStumpId, ProjectModel updateAbleProject) async {
  //   final newProjectList = state.map((stump) {
  //     if (stump.id == updatableStumpId) {
  //       return ProjectModel(
  //         id: updatableStumpId,
  //         height: updateAbleStump.height,
  //         width: updateAbleStump.width,
  //         cost: updateAbleStump.cost,
  //         price: updateAbleStump.price,
  //         imagesPath: updateAbleStump.imagesPath,
  //         note: updateAbleStump.note,
  //         videoPath: updateAbleStump.videoPath,
  //       );
  //     }
  //     return stump;
  //   }).toList();
  //   final db = await _getDatabse();
  //   final data = {
  //     'width': updateAbleStump.width,
  //     'hight': updateAbleStump.height,
  //     'note': updateAbleStump.note,
  //     'price': updateAbleStump.price,
  //     'cost': updateAbleStump.cost,
  //     'imagesPath': json.encode(updateAbleStump.imagesPath),
  //     'videoPath': updateAbleStump.videoPath,
  //   };
  //   db.update(dbName, data, where: "id = ?", whereArgs: [updatableStumpId]);
  //   state = newStumpList;
  // }

  void removeStump(ProjectModel deleatableProject) async {
    final db = await _getDatabse();
    await db.rawDelete(
      'DELETE FROM todo WHERE id = ?',
      [deleatableProject.id],
    );
    state = state.where((project) => project != deleatableProject).toList();
  }

  // void reorderStump(int oldIndex, int newIndex) async {
  //   final tile = state.removeAt(oldIndex);
  //   state.insert(newIndex, tile);
  //   final db = await _getDatabse();
  //   await db.rawDelete('DELETE FROM $dbName');
  //   for (var stump in state) {
  //     db.insert(
  //       dbName,
  //       {
  //         'id': stump.id,
  //         'width': stump.width,
  //         'hight': stump.height,
  //         'note': stump.note,
  //         'price': stump.price,
  //         'cost': stump.cost,
  //         'imagesPath': json.encode(stump.imagesPath),
  //         'videoPath': stump.videoPath,
  //       },
  //     );
  //   }
  // }
}
// -----------------------------------------------------------------------------

final projectsControllerProvider =
    StateNotifierProvider<ProjectsController, List<ProjectModel>>((ref) {
  return ProjectsController();
});
