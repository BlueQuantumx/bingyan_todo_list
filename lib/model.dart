import 'package:flutter/material.dart';

import 'package:isar/isar.dart';
import 'package:scoped_model/scoped_model.dart';

part 'model.g.dart';

extension TodoModelExtension on BuildContext {
  TodoModel get model {
    return ScopedModel.of(this);
  }

  TodoModel get listenModel {
    return ScopedModel.of(this, rebuildOnChange: true);
  }
}

class TodoModel extends Model {
  static TodoModel? _todoModel;

  TodoModel.inner() {
    init();
  }

  factory TodoModel() {
    return _todoModel ?? TodoModel.inner();
  }

  List<TaskList>? taskLists;

  Future<void> init() async {
    final isar = await Isar.open([TaskListSchema]);
    taskLists = await isar.taskLists.where().findAll();
  }
}

@collection
class TaskList {
  Id id = Isar.autoIncrement;
  late String title;

  final tasks = IsarLinks<Task>();
}

@collection
class Task {
  Id id = Isar.autoIncrement;
  String? title;
  String? description;

  DateTime? created;
  DateTime? due;
}
