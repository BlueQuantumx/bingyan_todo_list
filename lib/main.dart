import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TodoModel().init();

  runApp(ScopedModel(
    model: TodoModel(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bingyan Todos',
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bingyan Todos"),
      ),
      body: const TaskList(),
    );
  }
}

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    var tasks = context.listenModel.taskLists ?? [];
    if (tasks.isNotEmpty) {
      return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(tasks[index].title),
              onTap: () {},
            );
          });
    } else {
      return const Placeholder();
    }
  }
}
