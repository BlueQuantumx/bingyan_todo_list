import 'package:flutter/material.dart';

import '/model.dart';

class TodoCheckbox extends StatefulWidget {
  const TodoCheckbox({
    super.key,
    this.priority = Priority.none,
    required this.onChanged,
  });

  final Priority priority;
  final void Function(bool) onChanged;

  @override
  State<TodoCheckbox> createState() => _TodoCheckboxState();
}

class _TodoCheckboxState extends State<TodoCheckbox> {
  bool done = false;

  Color colorByPriority() {
    switch (widget.priority) {
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
      value: done,
      onChanged: (value) {
        widget.onChanged(value!);
        setState(() {
          done = value;
        });
      },
    );
  }
}
