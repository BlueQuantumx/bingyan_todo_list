import 'package:bingyan_todo_list/utils/date_time_util.dart';
import 'package:flutter/material.dart';

import 'package:bingyan_todo_list/model.dart';

class NewTodoModalPage extends StatefulWidget {
  const NewTodoModalPage({super.key});

  @override
  State<NewTodoModalPage> createState() => _NewTodoModalPageState();
}

class _NewTodoModalPageState extends State<NewTodoModalPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? dueTime;
  Priority priority = Priority.none;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
              hintText: "Title", filled: true, border: OutlineInputBorder()),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
                hintText: "Description",
                filled: true,
                border: InputBorder.none),
            minLines: 5,
            maxLines: 10,
          ),
        ),
        ButtonBar(
          children: [
            TextButton.icon(
              onPressed: () async {
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
                setState(() {
                  priority = tmpPriority ?? Priority.none;
                });
              },
              icon: const Icon(Icons.menu_rounded),
              label: Text(
                priority == Priority.none ? "Priority" : priority.name,
              ),
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
                          title: Text("Title can't  be empty!"),
                        );
                      });
                } else {
                  final isar = context.model.isar;
                  isar.writeTxnSync(() {
                    isar.tasks.putSync(Task(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      created: DateTime.now(),
                      due: dueTime,
                    ));
                  });
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.check_rounded),
              label: const Text("Add"),
            ),
            // ElevatedButton.icon(
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            //   icon: const Icon(Icons.close_rounded),
            //   label: const Text("Cancel"),
            // ),
          ],
        )
      ]),
    );
  }
}
