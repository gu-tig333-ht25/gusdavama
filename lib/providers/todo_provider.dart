import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../api_service.dart';

enum Filter { all, done, notDone }

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  bool isLoading = false;
  Filter _filter = Filter.all;

  List<Todo> get todos => _todos;
  bool get loading => isLoading;
  Filter get filter => _filter;

  List<Todo> get filteredTodos {
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

  Future<void> loadTodos() async {
    isLoading = true;
    notifyListeners();

    try {
      _todos = await ApiService.fetchTodos();
    } catch (e) {
      print("❌ Fel vid hämtning: $e");
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
      print("❌ Fel vid addTodo: $e");
    }
  }

  Future<void> toggleDone(Todo todo) async {
    try {
      todo.done = !todo.done;
      await ApiService.updateTodo(todo);
      notifyListeners();
    } catch (e) {
      print("Fel vid toggleDone: $e");
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
