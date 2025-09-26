import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/todo.dart';

// Din API-nyckel
const String apiKey = "a7ce3e7f-bc6a-4268-be10-48d99bb27c63";
// Bas-URL till Todo API
const String baseUrl = "https://todoapp-api.apps.k8s.gu.se";

class ApiService {
  // Hämta alla todos från servern
  static Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse("$baseUrl/todos?key=$apiKey"));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception("Misslyckades att hämta todos");
    }
  }

  // Lägg till en todo
  static Future<List<Todo>> addTodo(String title) async {
    final response = await http.post(
      Uri.parse("$baseUrl/todos?key=$apiKey"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"title": title, "done": false}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception("Misslyckades att lägga till todo");
    }
  }

  // Uppdatera en todo
  static Future<void> updateTodo(Todo todo) async {
    final response = await http.put(
      Uri.parse("$baseUrl/todos/${todo.id}?key=$apiKey"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"title": todo.title, "done": todo.done}),
    );

    if (response.statusCode != 200) {
      throw Exception("Misslyckades att uppdatera todo");
    }
  }

  // Ta bort en todo
  static Future<void> deleteTodo(String id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/todos/$id?key=$apiKey"),
    );

    if (response.statusCode != 200) {
      throw Exception("Misslyckades att ta bort todo");
    }
  }
}
