import 'package:flutter/material.dart'; //importerar flutter biblotek

//skapar en klass för varje uppgift
class Todo {
  String title; //titel på uppgiften
  bool done; //om uppgiften är klar eller inte

  Todo({
    required this.title,
    this.done = false, //false = inte klar (standardvärde)
  });
}

void main() { // Startar
  runApp(const TodoApp()); //visar ToDoApp
}

class TodoApp extends StatelessWidget { //skapar huvud-widgeten, den är också stateless, att den inte kan ändras
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) { //bestämmer hur widgeten ska se ut
    return MaterialApp(
      title: 'TIG333 TODO', // titeln på appen
      theme: ThemeData( //temat för appen
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink), //färgtema
        useMaterial3: true, //designsystem som gör appen mer modern
      ),

      home: const TodoListScreen(), //sätter startsidan
      debugShowCheckedModeBanner: false, //tar bort debug-bannern
    );
  }
}

//olika filter-alternativ för listan
enum Filter { all, done, notDone }

class TodoListScreen extends StatefulWidget { //stateful nu istället för stateless som i steg 1
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState(); //kopplar state-klassen
}

//skapar state-klassen som håller i själva datan
class _TodoListScreenState extends State<TodoListScreen> {
  //lista med uppgifter
  final List<Todo> _todos = [
    Todo(title: 'Skriv en bok'), //som sagt är defualt false
    Todo(title: 'Gör läxor'),
    Todo(title: 'Städa rummet', done: true), //true = klar
    Todo(title: 'Kolla på tv'),
    Todo(title: 'Träna', done: true),
    Todo(title: 'Laga mat'),
    Todo(title: 'Läs en artikel'),
  ];

  //håller reda på vilket filter som är valt
  Filter _filter = Filter.all; //standard = visa alla

  //funktion för att lägga till en ny uppgift
  void _addTodo(String title) {
    setState(() { //uppdaterar UI
      _todos.add(Todo(title: title)); //lägger till en ny uppgift
    });
  }

  //funktion för att ta bort en uppgift
  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index); //tar bort uppgiften på plats index
    });
  }

  //funktion för att markera en uppgift som klar/inte klar
  void _toggleDone(int index) {
    setState(() {
      _todos[index].done = !_todos[index].done; //växlar mellan klar/inte klar
    });
  }

  //returnerar en lista baserat på valt filter
  List<Todo> get _filteredTodos {
    if (_filter == Filter.done) {
      return _todos.where((todo) => todo.done).toList(); //bara klara
    } else if (_filter == Filter.notDone) {
      return _todos.where((todo) => !todo.done).toList(); //bara oklara
    }
    return _todos; //alla
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( //skapar en grundläggande layout för appen
      appBar: AppBar(
        title: const Text('TIG333 TODO'), //Titeln i appen
        actions: [
          //meny för att välja filter
          PopupMenuButton<Filter>(
            onSelected: (value) {
              setState(() {
                _filter = value; //ändrar filter och uppdaterar listan
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: Filter.all, child: Text('Alla')),
              const PopupMenuItem(value: Filter.done, child: Text('Gjorda')),
              const PopupMenuItem(value: Filter.notDone, child: Text('Inte gjorda')),
            ],
          ),
        ],
      ),
      body: ListView.builder( //skapar en scroll-lista dynamiskt
        itemCount: _filteredTodos.length, //antal uppgifter (efter filter)
        itemBuilder: (context, index) {
          final todo = _filteredTodos[index]; //hämtar uppgiften
          final originalIndex = _todos.indexOf(todo); //för att kunna ta bort/toggla i rätt lista

          return TodoItem( //skapar en widget för varje uppgift
            title: todo.title,
            done: todo.done,
            onToggle: () => _toggleDone(originalIndex), //funktion för att toggla
            onDelete: () => _removeTodo(originalIndex), //funktion för att ta bort
          );
        },
      ),
      floatingActionButton: FloatingActionButton( //knapp för att kunna lägga till en uppgift
        onPressed: () async { //när knappen trycks
        
          final newTodo = await Navigator.push( //navigerar till en ny skärm
            context,
            MaterialPageRoute(builder: (context) => const AddTodoScreen()), //skärmen som öppnas är AddTodoScreen
          );

          //om användaren skrev något → lägg till i listan
          if (newTodo != null && newTodo is String) {
            _addTodo(newTodo);
          }
        },
        child: const Icon(Icons.add), //plus-ikon på knappen
      ),
    );
  }
}

class TodoItem extends StatelessWidget { //skapar en widget för varje uppgift
  final String title; //titel på uppgiften
  final bool done; //om uppgiften är klar eller inte
  final VoidCallback onToggle; //funktion för att toggla status
  final VoidCallback onDelete; //funktion för att ta bort

  const TodoItem({
    super.key,
    required this.title,
    this.done = false,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile( //färdig rad
      leading: Checkbox( //checkbox för att markera om uppgiften är klar
        value: done,
        onChanged: (_) => onToggle(), //togglar status när man trycker
      ),
      title: Text( //titel på uppgiften
        title,
        style: TextStyle(
          color: const Color.fromARGB(255, 226, 118, 154), //rosa färg
          decoration: done ? TextDecoration.lineThrough : null, //om uppgiften är klar, dra ett streck över texten
        ),
      ),
      trailing: IconButton( //ikon för att ta bort uppgiften
        icon: const Icon(Icons.close, color: Color.fromARGB(255, 226, 118, 154)), //även den är rosa
        onPressed: onDelete, //tar bort uppgiften
      ),
    );
  }
}

class AddTodoScreen extends StatelessWidget { //skapar en ny skärm för att lägga till en uppgift
  const AddTodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController(); //kontroller för textfältet
    return Scaffold(
      appBar: AppBar( //appbaren högst upp
        title: const Text('TIG333 TODO'), //titeln i appen
      ),
      body: Padding( //lägger till padding runt innehållet
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // gör så att knappen tar upp hela bredden
          children: [
            TextField( //textfält för att skriva in en ny uppgift
              controller: _controller, //kopplar textfältet till controllern
              decoration: InputDecoration(
                hintText: 'Vad vill du lägga till?', //grå hjälptext som försvinner när man börjar skriva
                hintStyle: const TextStyle(color: Colors.pinkAccent), //rosa hint-text
                filled: true,
                fillColor: Colors.pink[50], //ljusrosa bakgrund
                contentPadding: const EdgeInsets.symmetric( // padding inuti textfältet
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder( // rundade hörn på textfältet
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.pink), //rosa kant
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.pinkAccent, width: 2), //rosa kant
                ),
              ),
              style: const TextStyle(color: Colors.pink), // rosa text
            ),
            const SizedBox(height: 20), //mellanrum mellan textfältet och knappen

            ElevatedButton.icon( //knapp med ikon för att lägga till uppgiften
              onPressed: () { //när knappen trycks
                final text = _controller.text; //hämtar texten användaren skrev
                if (text.isNotEmpty) {
                  Navigator.pop(context, text); //stänger sidan och skickar tillbaka texten
                }
              },
              icon: const Icon(Icons.add, color: Colors.white), //vit plus-ikon
              label: const Text(
                'ADD', // texten på knappen
                style: TextStyle(
                  fontSize: 18, //storlek på texten
                  fontWeight: FontWeight.bold, //fet text
                  color: Colors.white, //vit text
                ),
              ),
              style: ElevatedButton.styleFrom( //stil på knappen
                backgroundColor: Colors.pink, //rosa knapp
                padding: const EdgeInsets.symmetric(vertical: 14), //padding
                shape: RoundedRectangleBorder( //form på knappen
                  borderRadius: BorderRadius.circular(30), // rundade hörn
                ),
                elevation: 4, //liten skugga
              ),
            ),
          ],
        ),
      ),
    );
  }
}
