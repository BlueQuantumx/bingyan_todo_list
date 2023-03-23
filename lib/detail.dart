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
    Task task = context.listenModel.tasks
        .firstWhere((element) => element.id == widget.task.id);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TodoCheckbox(task: task),
            PopupMenuButton(
              initialValue: task.priority,
              onSelected: (value) {
                context.model.modifyTask(task..priority = value);
              },
              icon: Icon(
                Icons.priority_high_rounded,
                color: colorByPriority(task.priority),
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
                final model = context.model;
                final tmpDate = await showDatePicker(
                  context: context,
                  initialDate: task.due ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                model.modifyTask(task..due = tmpDate);
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
                  border: InputBorder.none, hintText: "Title"),
              onTapOutside: (event) {
                final value = _titleController.text;
                if (value.isEmpty) return;
                context.model.modifyTask(task..title = value);
              },
              onSubmitted: (value) {
                if (value.isEmpty) return;
                context.model.modifyTask(task..title = value);
              },
            ),
            const Divider(),
            Expanded(
              child: TextField(
                expands: true,
                maxLines: null,
                controller: _descriptionController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Description",
                ),
                onTapOutside: (event) {
                  final value = _descriptionController.text;
                  context.model.modifyTask(
                    task..description = value.isEmpty ? null : value,
                  );
                },
                onSubmitted: (value) {
                  context.model.modifyTask(
                    task..description = value.isEmpty ? null : value,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
