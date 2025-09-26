class Todo { //klass för att representera en todo
  final String id; //final eftersom id inte ska ändras
  final String title;
  bool done; //om todo är klar eller inte

  Todo({ //konstruktor för att skapa en todo
    required this.id, //id och title är obligatoriska
    required this.title,
    this.done = false, //done är frivillig och standardvärdet är false
  });

  factory Todo.fromJson(Map<String, dynamic> json) { //fabrikmetod för att skapa en todo från JSON
    return Todo(
      id: json['id'],
      title: json['title'],
      done: json['done'],
    );
  }

  Map<String, dynamic> toJson() { //metod för att konvertera en todo till JSON
    return {
      'id': id,
      'title': title,
      'done': done,
    };
  }
}
