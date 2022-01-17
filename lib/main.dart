import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ToDo List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Todo {
  String id;
  String title;
  bool done;
  DateTime createdAt;

  Todo({required this.id, required this.title, required this.done,required this.createdAt});
}

class _MyHomePageState extends State<MyHomePage> {
  final _uuid = const Uuid();
  final _todoController = TextEditingController();
  final _todos = <Todo>[];
  final _timer = <String, Timer>{};

  void _addTodo() {
    if (_todoController.text != '') {
      final todo = Todo(id: _uuid.v1(), title: _todoController.text, done: false, createdAt: DateTime.now());
      setState(() {
        _todos.insert(0, todo);
        _todoController.clear();
      });
    }
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height:15),
                  const Text(
                    'What should I do?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(icon: Icon(Icons.checklist_sharp)),
                  ),
                  const SizedBox(height:15),
                ],
              ),
            ),
            if (_todos.isEmpty) const Text('I have nothing to do.', style: TextStyle(fontSize: 20)),
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: _todos[index].done ? Colors.grey : Colors.white,
                    margin: const EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget> [
                          Row(
                            children: <Widget> [
                              Checkbox(
                                value: _todos[index].done,
                                onChanged: (bool? _) {
                                  setState(() {
                                    _todos[index].done = !_todos[index].done;
                                    final Todo todo = _todos[index];
                                    _timer[todo.id]?.cancel();
                                    if (todo.done) {
                                      _timer[todo.id] = Timer(const Duration(seconds: 3), (){
                                        setState(() {
                                          _todos.removeWhere((Todo t) => t == todo);
                                        });
                                      });
                                    }
                                  });
                                },
                              ),
                              Text(
                                _todos[index].title,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Text('${_todos[index].createdAt.year}/${_todos[index].createdAt.month}/${_todos[index].createdAt.day}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
