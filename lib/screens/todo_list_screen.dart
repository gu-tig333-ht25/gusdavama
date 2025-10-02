//i denna fil hanteras hela todo-listan, inklusive visning, filtrering och tillägg av nya todos.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import 'add_todo_screen.dart';


class TodoListScreen extends StatefulWidget { //stateful widget
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() { //init state = skapas för widgetträdet
    super.initState();
    Future.microtask(() => //säkerställer att loadTodos körs efter initState
        Provider.of<TodoProvider>(context, listen: false).loadTodos()); //laddar in todos, listen:false laddar bara datan en gång
  }

  @override
  Widget build(BuildContext context) { 
    final todoProvider = Provider.of<TodoProvider>(context); //hämtar todoProvider

    return Scaffold(
      appBar: AppBar( //appbar med titel och filtreringsmeny
        backgroundColor:  Colors.pink,
        title: const Text(
          'Att göra lista', //titel
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton<Filter>( // Filtreringsmeny i appbaren
            color: Colors.pink[50],
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onSelected: (Filter filter) {
              todoProvider.setFilter(filter);
            },
            itemBuilder: (BuildContext context) { //menyval
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
      body: todoProvider.loading //visar en laddningsindikator medan todos laddas
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
                    trailing: IconButton( //knapp för att ta bort todo
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
    final newTodo = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => AddTodoScreen()),
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
