import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../api_service.dart';

enum Filter { all, done, notDone } //filteralternativ

class TodoProvider with ChangeNotifier { //provider för att hantera todo-listan
  List<Todo> _todos = [];
  bool isLoading = false;
  Filter _filter = Filter.all; //standardfilter är alla todos

  List<Todo> get todos => _todos; //getter för todos
  bool get loading => isLoading; //denna raden kommer det upp röd text på ibland, men det funkar ändå så har inte ändrat
  Filter get filter => _filter; //getter för filter

  List<Todo> get filteredTodos { //returnerar filtrerade todos baserat på valt filter
    switch (_filter) {
      case Filter.done:
        return _todos.where((todo) => todo.done).toList();
      case Filter.notDone:
        return _todos.where((todo) => !todo.done).toList();
      default:
        return _todos;
    }
  }

  void setFilter(Filter filter) { 
    _filter = filter;
    notifyListeners();
  }

  Future<void> loadTodos() async { //laddar todos från API:et
    isLoading = true;
    notifyListeners();

     //här kommer några olika felmedelanden
    try {
      _todos = await ApiService.fetchTodos();
    } catch (e) {
      print("Fel vid hämtning: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> addTodo(String title) async {
    try {
      final newTodo = await ApiService.addTodo(title);
      _todos = newTodo;
      notifyListeners();
    } catch (e) {
      print("Fel vid addTodo: $e");
    }
  }

  Future<void> toggleDone(Todo todo) async {
  try {
    await ApiService.updateTodo(
      Todo(
        id: todo.id,
        title: todo.title,
        done: !todo.done,
      ),
    );

    todo.done = !todo.done;
    notifyListeners();
  } catch (e) {
    print("Fel vid toggleDone: $e");
    rethrow;
  }
}


  Future<void> deleteTodo(Todo todo) async {
    try {
      await ApiService.deleteTodo(todo.id);
      _todos.removeWhere((t) => t.id == todo.id);
      notifyListeners();
    } catch (e) {
      print("Fel vid deleteTodo: $e");
    }
  }
}

  void deleteTodo(Todo todo) {}
