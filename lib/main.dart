import 'package:flutter/material.dart';

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
  String title;
  bool done;

  Todo({required this.title, required this.done});
}

class _MyHomePageState extends State<MyHomePage> {
  final _todoController = TextEditingController();
  List<Todo> _todos = [];

  void _addTodo() {
    if (_todoController.text != '') {
      final _todo = Todo(title: _todoController.text, done: false);
      setState(() {
        _todos.add(_todo);
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
              padding: EdgeInsets.only(top: 15.0, right: 20.0, left: 20.0),
              child: Text(
                'What should I do ?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 20.0, left: 20.0, bottom: 15.0),
              child: TextField(
                controller: _todoController,
                decoration: InputDecoration(icon: Icon(Icons.checklist_sharp)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (BuildContext context, int index) {
                  final int _reverseIndex = _todos.length - index - 1;
                  return Card(
                    margin: EdgeInsets.all(10.0),
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            value: _todos[_reverseIndex].done,
                            onChanged: (bool? value) {
                              setState(() {
                                _todos[_reverseIndex].done = value!;
                              });
                            },
                          ),
                          Text(
                            _todos[_reverseIndex].title,
                            style: TextStyle(fontSize: 20),
                          ),
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
