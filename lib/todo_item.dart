import 'package:flutter/material.dart';

import 'package:bingyan_todo_list/components/checkbox.dart';
import 'package:bingyan_todo_list/model.dart';
import 'package:bingyan_todo_list/utils/date_time_util.dart';

class ItemCard extends StatelessWidget {
  final Task task;
  const ItemCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key(task.id.toString()),
      background: Container(color: Colors.red),
      onDismissed: (direction) {
        context.model.isar.writeTxnSync(() {
          final isar = context.model.isar;
          isar.tasks.deleteSync(task.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${task.title} dismissed'),
          showCloseIcon: true,
          duration: const Duration(seconds: 3),
        ));
      },
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
    );
  }
}
