import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gristum_notes_app/models/stump_model.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class StumpsListControllerNotifier extends StateNotifier<List<StumpModel>> {
  StumpsListControllerNotifier() : super([]);

  String dbName = 'stumps';

  Future<Database> _getDatabse() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, '$dbName.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE todo(id TEXT PRIMARY KEY, width REAL, hight REAL, note TEXT, price REAL, cost REAL, imagesPath TEXT, videoPath TEXT)');
      },
      version: 1,
    );
    return db;
  }

  List<StumpModel> get todos => state;

  // int getActiveTodoCount() {
  //   final activeTodos = state.where((todo) => !todo.isDone).toList();
  //   return activeTodos.length;
  // }

  void addStump(StumpModel stump) async {
    final newStump = StumpModel(
      id: stump.id,
      width: stump.width,
      height: stump.height,
      note: stump.note,
      price: stump.price,
      cost: stump.cost,
      imagesPath: stump.imagesPath,
      videoPath: stump.videoPath,
    );

    final db = await _getDatabse();
    db.insert(
      dbName,
      {
        'id': stump.id,
        'width': stump.width,
        'hight': stump.height,
        'note': stump.note,
        'price': stump.price,
        'cost': stump.cost,
        'imagesPath': json.encode(stump.imagesPath),
        'videoPath': stump.videoPath,
      },
    );

    state = [newStump, ...state];
  }

  Future<void> loadStumps() async {
    final db = await _getDatabse();
    final data = await db.query(dbName);
    final stumps = data.map((row) {
      final List<dynamic> imageList = json.decode(row['imagesPath'] as String);
      final List<String> images = List<String>.from(imageList);
      return StumpModel(
        id: row['id'] as String,
        width: row['width'] as double,
        height: row['height'] as double,
        price: row['price'] as double,
        cost: row['cost'] as double,
        note: row['note'] as String,
        videoPath: row['videoPath'] as String,
        imagesPath: images,
      );
    }).toList();
    state = stumps;
  }

  // void updateTodoStatus(String updatableStumpId, bool value) async {
  //   final newStumpList = state.map((todo) {
  //     if (todo.id == updatableStumpId) {
  //       return StumpModel(
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

  void editStump(String updatableStumpId, StumpModel updateAbleStump) async {
    final newStumpList = state.map((stump) {
      if (stump.id == updatableStumpId) {
        return StumpModel(
          id: updatableStumpId,
          height: updateAbleStump.height,
          width: updateAbleStump.width,
          cost: updateAbleStump.cost,
          price: updateAbleStump.price,
          imagesPath: updateAbleStump.imagesPath,
          note: updateAbleStump.note,
          videoPath: updateAbleStump.videoPath,
        );
      }
      return stump;
    }).toList();

    final db = await _getDatabse();
    final data = {
      'width': updateAbleStump.width,
      'hight': updateAbleStump.height,
      'note': updateAbleStump.note,
      'price': updateAbleStump.price,
      'cost': updateAbleStump.cost,
      'imagesPath': json.encode(updateAbleStump.imagesPath),
      'videoPath': updateAbleStump.videoPath,
    };
    db.update(dbName, data, where: "id = ?", whereArgs: [updatableStumpId]);

    state = newStumpList;
  }

  void removeStump(StumpModel deleatableStump) async {
    final db = await _getDatabse();
    await db.rawDelete(
      'DELETE FROM todo WHERE id = ?',
      [deleatableStump.id],
    );
    state = state.where((stump) => stump != deleatableStump).toList();
  }

  void reorderStump(int oldIndex, int newIndex) async {
    final tile = state.removeAt(oldIndex);
    state.insert(newIndex, tile);
    final db = await _getDatabse();
    await db.rawDelete('DELETE FROM $dbName');
    for (var stump in state) {
      db.insert(
        dbName,
        {
          'id': stump.id,
          'width': stump.width,
          'hight': stump.height,
          'note': stump.note,
          'price': stump.price,
          'cost': stump.cost,
          'imagesPath': json.encode(stump.imagesPath),
          'videoPath': stump.videoPath,
        },
      );
    }
  }
}
// -----------------------------------------------------------------------------

final stumpsListControllerProvider =
    StateNotifierProvider<StumpsListControllerNotifier, List<StumpModel>>(
        (ref) {
  return StumpsListControllerNotifier();
});
