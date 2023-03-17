import 'package:bingyan_todo_list/model.dart';
import 'package:flutter/material.dart';

class NewTodoModalPage extends StatefulWidget {
  const NewTodoModalPage({super.key});

  @override
  State<NewTodoModalPage> createState() => _NewTodoModalPageState();
}

class _NewTodoModalPageState extends State<NewTodoModalPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

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
            ElevatedButton.icon(
              onPressed: () {
                final isar = context.model.isar;
                isar.writeTxnSync(() {
                  isar.tasks.putSync(Task(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    created: DateTime.now(),
                  ));
                });
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.check_rounded),
              label: const Text("Add"),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close_rounded),
              label: const Text("Cancel"),
            ),
          ],
        )
      ]),
    );
  }
}
