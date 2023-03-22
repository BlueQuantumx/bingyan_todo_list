import 'package:bingyan_todo_list/components/task_list.dart';
import 'package:bingyan_todo_list/detail.dart';
import 'package:bingyan_todo_list/new_todo.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TodoModel().init();

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
      // routes: {"/detail": (context) => const DetailPage()},
      onGenerateRoute: (settings) {
        if (settings.name == "/detail") {
          int id = settings.arguments as int;
          final task = context.model.allTasks.firstWhere(
            (element) => element.id == id,
          );
          return MaterialPageRoute(
              builder: (context) => DetailPage(task: task));
        }
        return MaterialPageRoute(builder: (context) => const Placeholder());
      },
      theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
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
      drawer: const MyNavigationDrawer(),
      body: const TaskListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => AnimatedPadding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              duration: Duration.zero,
              child: const NewTodoModalPage(),
            ),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class MyNavigationDrawer extends StatefulWidget {
  const MyNavigationDrawer({
    super.key,
  });

  @override
  State<MyNavigationDrawer> createState() => _MyNavigationDrawerState();
}

class _MyNavigationDrawerState extends State<MyNavigationDrawer> {
  int navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: (value) {
        setState(() {
          navIndex = value;
        });
      },
      selectedIndex: navIndex,
      children: [
            const DrawerHeader(
              child: Text("Bingyan Todos"),
            ),
            const NavigationDrawerDestination(
                icon: Icon(Icons.list_rounded), label: Text("All")),
          ] +
          (context.model.taskLists
                  ?.map((e) => NavigationDrawerDestination(
                        icon: const Icon(Icons.list_rounded),
                        label: Text(e.title),
                      ))
                  .toList() ??
              []),
    );
  }
}
