import 'package:bingyan_todo_list/components/task_list.dart';
import 'package:bingyan_todo_list/utils/date_time_util.dart';
import 'package:flutter/material.dart';

import 'package:bingyan_todo_list/model.dart';

class NewTodoModalSheet extends StatefulWidget {
  const NewTodoModalSheet({super.key});

  @override
  State<NewTodoModalSheet> createState() => _NewTodoModalSheetState();
}

class _NewTodoModalSheetState extends State<NewTodoModalSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? dueTime;
  Priority priority = Priority.none;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          maxLength: 20,
          autofocus: true,
          controller: _titleController,
          decoration: const InputDecoration(
            hintText: "Title",
            filled: true,
            border: OutlineInputBorder(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
                hintText: "Description",
                filled: true,
                border: OutlineInputBorder()),
          ),
        ),
        ButtonBar(
          children: [
            PopupMenuButton(
              initialValue: priority,
              onSelected: (value) {
                setState(() {
                  priority = value;
                });
              },
              icon: Icon(
                Icons.priority_high_rounded,
                color: colorByPriority(priority),
              ),
              itemBuilder: (context) {
                return Priority.values
                    .map((e) => PopupMenuItem(
                          value: e,
                          child: Text(e.name),
                        ))
                    .toList();
              },
            ),
            TextButton.icon(
              onPressed: () async {
                final tmpTime = await showDatePicker(
                  context: context,
                  initialDate: dueTime ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                setState(() {
                  dueTime = tmpTime;
                });
              },
              icon: const Icon(Icons.date_range_rounded),
              label: Text(dueTime?.humanizedPromisingDate ?? "Date"),
            ),
            TextButton.icon(
              onPressed: () {
                if (_titleController.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          icon: Icon(Icons.error_outline_rounded),
                          title: Text("Title can't be empty!"),
                        );
                      });
                } else {
                  animatedListStateKey.currentState!
                      .insertItem(context.model.tasks.length);
                  context.model.addTask(Task(
                    title: _titleController.text,
                    description: _descriptionController.text.isEmpty
                        ? null
                        : _descriptionController.text,
                    created: DateTime.now(),
                    due: dueTime,
                    priority: priority,
                  ));
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.check_rounded),
              label: const Text("Add"),
            ),
          ],
        )
      ]),
    );
  }
}
