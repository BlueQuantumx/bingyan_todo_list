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
  Color colorByPriority() {
    switch (widget.task.priority) {
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

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      side: BorderSide(color: colorByPriority(), width: 2),
      activeColor: colorByPriority(),
      value: context.model.isar.tasks.getSync(widget.task.id)!.done,
      onChanged: (value) {
        final isar = context.model.isar;
        isar.writeTxnSync(
          () {
            isar.tasks.putSync(widget.task..done = value!);
          },
        );
        setState(() {});
      },
    );
  }
}
