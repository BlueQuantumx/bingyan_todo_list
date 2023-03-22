import 'package:bingyan_todo_list/components/task_list.dart';
import 'package:flutter/material.dart';

import 'package:bingyan_todo_list/components/checkbox.dart';
import 'package:bingyan_todo_list/model.dart';
import 'package:bingyan_todo_list/utils/date_time_util.dart';

class ItemCard extends StatelessWidget {
  const ItemCard(
      {super.key,
      required this.index,
      required this.task,
      required this.animation});

  final int index;
  final Task task;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key(task.id.toString()),
      background: Container(color: Colors.red),
      onDismissed: (direction) {
        final model = context.model;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${task.title} dismissed'),
          showCloseIcon: true,
          action: SnackBarAction(
              label: "Undo",
              onPressed: () {
                animatedListStateKey.currentState!.insertItem(index);
                model.addTask(task, index);
              }),
        ));
        AnimatedList.of(context)
            .removeItem(index, (context, animation) => Container());
        model.deleteTask(task);
      },
      child: SizeTransition(
        sizeFactor: animation,
        child: ListTile(
          horizontalTitleGap: 0,
          leading: SizedBox(
            width: 30,
            child: Center(
              child: TodoCheckbox(task: task),
            ),
          ),
          title: Text(task.title),
          subtitle: Text(task.description ?? "..."),
          trailing: Text(task.due?.toDueTimeString ?? ""),
          onTap: () {
            Navigator.pushNamed(context, "/detail", arguments: task.id);
          },
        ),
      ),
    );
  }
}
