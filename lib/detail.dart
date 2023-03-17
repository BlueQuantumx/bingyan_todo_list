import 'package:bingyan_todo_list/model.dart';
import 'package:flutter/material.dart';

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
    _descriptionController.text = task.description ?? "Description";
  }

  @override
  Widget build(BuildContext context) {
    Task task = widget.task;
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
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
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                final isar = context.model.isar;
                isar.writeTxnSync(() {
                  final isarData = isar.tasks.getSync(task.id);
                  isarData!.description = value;
                  isar.tasks.putSync(isarData);
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
