import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TodoProvider>(context, listen: false).loadTodos());
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          'Att göra lista',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton<Filter>(
            color: Colors.pink[50],
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onSelected: (Filter filter) {
              todoProvider.setFilter(filter);
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<Filter>(
                  value: Filter.all,
                  child: Text('Alla', style: TextStyle(color: Colors.pink)),
                ),
                const PopupMenuItem<Filter>(
                  value: Filter.done,
                  child: Text('Gjorda', style: TextStyle(color: Colors.pink)),
                ),
                const PopupMenuItem<Filter>(
                  value: Filter.notDone,
                  child: Text('Inte gjorda', style: TextStyle(color: Colors.pink)),
                ),
              ];
            },
          ),
        ],
      ),
      body: todoProvider.loading
          ? const Center(child: CircularProgressIndicator(color: Colors.pink))
          : ListView.builder(
              itemCount: todoProvider.filteredTodos.length,
              itemBuilder: (ctx, index) {
                final todo = todoProvider.filteredTodos[index];
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.pink[50],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      checkColor: const Color.fromARGB(255, 247, 246, 246),
                      activeColor: Colors.pink,
                      value: todo.done,
                      onChanged: (_) => todoProvider.toggleDone(todo),
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        color: Colors.pink[800],
                        decoration: todo.done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.pink),
                      onPressed: () => todoProvider.deleteTodo(todo),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () async {
          final newTodo = await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              String title = '';
              return AlertDialog(
                backgroundColor: Colors.pink[100],
                title: const Text('Lägg till ny todo',
                    style: TextStyle(color: Colors.white)),
                content: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Skriv här',
                    hintStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  onChanged: (text) {
                    title = text;
                  },
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Tillbaka'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.pink,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(title);
                    },
                    child: const Text('Lägg till'),
                  ),
                ],
              );
            },
          );

          if (newTodo != null && newTodo.isNotEmpty) {
            todoProvider.addTodo(newTodo);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
