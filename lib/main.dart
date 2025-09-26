//denna filen är huvudfilen som startar appen

import 'package:flutter/material.dart'; //importer
import 'package:provider/provider.dart';
import 'screens/todo_list_screen.dart';
import 'providers/todo_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TIG333 TODO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (_) => TodoProvider(),
        child: TodoListScreen(),
      ),
    );
  }
}