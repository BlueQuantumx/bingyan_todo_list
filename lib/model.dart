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
    isar = Isar.openSync([TaskListSchema, TaskSchema]);
    var stream = isar.tasks.watchLazy(fireImmediately: true);
    stream.listen(
      (event) {
        notifyListeners();
      },
    );
    init();
  }

  factory TodoModel() {
    return _todoModel ?? (_todoModel = TodoModel.inner());
  }

  List<TaskList>? taskLists;

  late Isar isar;

  Future<void> init() async {
    taskLists = await isar.taskLists.where().findAll();
  }

  List<Task> get allTasks => isar.tasks.where().sortByDue().findAllSync();

  Future<void> addTask(Task task) async {
    await isar.tasks.put(task);
  }
}

@collection
class TaskList {
  Id id = Isar.autoIncrement;
  late String title;

  final tasks = IsarLinks<Task>();
}

enum Priority {
  none,
  low,
  midium,
  high,
}

@collection
class Task {
  Id id = Isar.autoIncrement;

  String title;
  String? description;

  DateTime? created;
  DateTime? due;

  @enumerated
  Priority priority;

  bool done = false;

  Task({
    required this.title,
    this.description,
    this.created,
    this.due,
    this.priority = Priority.none,
  });
}
