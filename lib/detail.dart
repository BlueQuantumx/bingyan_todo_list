import 'package:flutter/material.dart';

import 'package:bingyan_todo_list/components/checkbox.dart';
import 'package:bingyan_todo_list/model.dart';
import 'package:bingyan_todo_list/utils/date_time_util.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.task});

  final Task task;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController.text = task.title;
    _descriptionController.text = task.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    Task task = widget.task;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TodoCheckbox(task: task),
            TextButton.icon(
              onPressed: () async {
                final isar = context.model.isar;
                final tmpPriority = await showMenu(
                  context: context,
                  position: RelativeRect.fill,
                  items: Priority.values
                      .map((e) => PopupMenuItem(
                            value: e,
                            child: Text(e.name),
                          ))
                      .toList(),
                );
                isar.writeTxnSync(() {
                  isar.tasks
                      .putSync(task..priority = tmpPriority ?? Priority.none);
                });
                setState(() {});
              },
              icon: const Icon(Icons.menu_rounded),
              label: Text(
                task.priority == Priority.none
                    ? "Priority"
                    : task.priority.name,
              ),
            ),
            TextButton.icon(
              onPressed: () async {
                final isar = context.model.isar;
                final tmpDate = await showDatePicker(
                  context: context,
                  initialDate: task.due ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                isar.writeTxnSync(() {
                  isar.tasks.putSync(task..due = tmpDate);
                });
                setState(() {});
              },
              icon: const Icon(Icons.date_range_rounded),
              label: Text(task.due?.humanizedPromisingDate ?? "Date"),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                if (value.isEmpty) return;
                final isar = context.model.isar;
                isar.writeTxnSync(() {
                  final isarData = isar.tasks.getSync(task.id);
                  isarData!.title = value;
                  isar.tasks.putSync(isarData);
                });
              },
            ),
            const Divider(),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: (task.description == null ? "Description" : null),
              ),
              onSubmitted: (value) {
                final isar = context.model.isar;
                isar.writeTxnSync(() {
                  final isarData = isar.tasks.getSync(task.id);
                  isarData!.description = value.isEmpty ? null : value;
                  isar.tasks.putSync(isarData);
                });
                setState(() {});
              },
            )
          ],
        ),
      ),
    );
  }
}
