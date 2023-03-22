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

Color colorByPriority(Priority priority) {
  switch (priority) {
    case Priority.high:
      return Colors.red;
    case Priority.midium:
      return Colors.yellow;
    case Priority.low:
      return Colors.blue;
    default:
      return Colors.grey;
  }
}

class TodoModel extends Model {
  static TodoModel? _todoModel;

  TodoModel.inner() {
    isar = Isar.openSync([TaskListSchema, TaskSchema]);
    // var stream = isar.tasks.watchLazy(fireImmediately: true);
    // stream.listen(
    //   (event) {
    //     notifyListeners();
    //   },
    // );
    init();
  }

  factory TodoModel() {
    return _todoModel ?? (_todoModel = TodoModel.inner());
  }

  List<TaskList>? taskLists;
  late List<Task> tasks;

  late Isar isar;

  void init() {
    tasks = isar.tasks.where().sortByDue().findAllSync();
    // taskLists = await isar.taskLists.where().findAll();
  }

  List<Task> get allTasks => tasks;

  Future<void> addTask(Task task, [int? index]) async {
    if (index != null) {
      tasks.insert(index, task);
    } else {
      tasks.add(task);
    }
    notifyListeners();
    isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
  }

  Future<void> modifyTask(Task task) async {
    isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    tasks.remove(task);
    isar.writeTxn(() async {
      await isar.tasks.delete(task.id);
    });
    notifyListeners();
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
