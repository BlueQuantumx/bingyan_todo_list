import 'package:flutter/material.dart';

import '/model.dart';

class TodoCheckBox extends StatefulWidget {
  const TodoCheckBox({
    super.key,
    this.priority = Priority.none,
    required this.onChanged,
  });

  final Priority priority;
  final void Function(bool) onChanged;

  @override
  State<TodoCheckBox> createState() => _TodoCheckBoxState();
}

class _TodoCheckBoxState extends State<TodoCheckBox> {
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
