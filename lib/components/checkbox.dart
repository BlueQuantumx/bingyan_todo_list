import 'package:flutter/material.dart';

import '/model.dart';

class TodoCheckbox extends StatefulWidget {
  const TodoCheckbox({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<TodoCheckbox> createState() => _TodoCheckboxState();
}

class _TodoCheckboxState extends State<TodoCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      side: BorderSide(color: colorByPriority(widget.task.priority), width: 2),
      activeColor: colorByPriority(widget.task.priority),
      value: widget.task.done,
      onChanged: (value) {
        context.model.modifyTask(widget.task..done = value!);
        // final isar = context.model.isar;
        // isar.writeTxnSync(
        //   () {
        //     isar.tasks.putSync(widget.task..done = value!);
        //   },
        // );
        // setState(() {});
      },
    );
  }
}
