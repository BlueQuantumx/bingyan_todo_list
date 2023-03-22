import 'package:flutter/material.dart';

import 'package:bingyan_todo_list/model.dart';
import 'package:bingyan_todo_list/components/todo_item.dart';

class TaskListWidget extends StatefulWidget {
  const TaskListWidget({super.key});

  @override
  State<TaskListWidget> createState() => _TaskListWidgetState();
}

final GlobalKey<AnimatedListState> animatedListStateKey = GlobalKey();

class _TaskListWidgetState extends State<TaskListWidget> {
  @override
  Widget build(BuildContext context) {
    var tasks = context.listenModel.allTasks;
    return Stack(children: [
      if (tasks.isEmpty)
        const Center(child: Text("Create a new Todo to begin ")),
      AnimatedList(
          key: animatedListStateKey,
          initialItemCount: tasks.length,
          itemBuilder: (context, index, animation) {
            final task = tasks[index];
            return ItemCard(
              index: index,
              task: task,
              animation: animation,
            );
          }),
    ]);
  }
}
