import 'package:flutter/material.dart'; //importerar flutter biblotek

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
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),//färgtema
  useMaterial3: true, //designsystem som gör appen mer modern
),

      home: const TodoListScreen(), //sätter startsidan
      debugShowCheckedModeBanner: false, //tar bort debug-bannern
    );
  }
}

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( //skapar en grundläggande layout för appen
      appBar: AppBar(
        title: const Text('TIG333 TODO'), //Titeln i appen
      ),
      body: ListView( //skapar en scroll-lista
        children: const [//listan med uppgifter
          TodoItem(title: 'Skriv en bok', done: false), //false = inte klar
          TodoItem(title: 'Gör läxor', done: false),
          TodoItem(title: 'Städa rummet', done: true), //true = klar
          TodoItem(title: 'Kolla på tv', done: false),
          TodoItem(title: 'Träna', done: true),
          TodoItem(title: 'Laga mat', done: false),
          TodoItem(title: 'Läs en artikel', done: false),
        ],
      ),
      floatingActionButton: FloatingActionButton( //knapp för att kunna lägga till en uppgift
  onPressed: () { //när knappen trycks
    Navigator.push( //navigerar till en ny skärm
      context,
      MaterialPageRoute(builder: (context) => const AddTodoScreen()), //skärmen som öppnas är AddTodoScreen
    );
  },
  child: const Icon(Icons.add), //plus-ikon på knappen
),

    );
  }
}

class TodoItem extends StatelessWidget { //skapar en widget för varje uppgift
  final String title;//titel på uppgiften
  final bool done; //om uppgiften är klar eller inte

  const TodoItem({super.key, required this.title, this.done = false});

  @override
  Widget build(BuildContext context) {
    return ListTile( //färdig rad
      leading: Checkbox( //checkbox för att markera om uppgiften är klar
        value: done,
        onChanged: null, // ingen funktion än så länge
      ),
      title: Text(//titel på uppgiften
        title,
        style: TextStyle(
          color: const Color.fromARGB(255, 226, 118, 154),//rosa färg
          decoration: done ? TextDecoration.lineThrough : null, //om uppgiften är klar, dra ett streck över texten
        ),
      ),
      trailing: const Icon( //ikon för att ta bort uppgiften
        Icons.close,
      color: Color.fromARGB(255, 226, 118, 154), //även den är rosa
      ),
    );
  }
}

class AddTodoScreen extends StatelessWidget { //skapar en ny skärm för att lägga till en uppgift
  const AddTodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              decoration: InputDecoration(
                hintText: 'Vad vill du lägga till?',
                hintStyle: const TextStyle(color: Colors.pinkAccent), // rosa hint-text
                filled: true,
                fillColor: Colors.pink[50], // ljusrosa bakgrund
                contentPadding: const EdgeInsets.symmetric( // padding inuti textfältet
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder( // rundade hörn på textfältet
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.pink), // rosa kant
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16), 
                  borderSide: const BorderSide(color: Colors.pinkAccent, width: 2), // rosa kant
                ),
              ),
              style: const TextStyle(color: Colors.pink), // rosa text
            ),
            const SizedBox(height: 20), // mellanrum mellan textfältet och knappen

            
            ElevatedButton.icon( //knapp med ikon för att lägga till uppgiften
              onPressed: () { //när knappen trycks
                
              },
              icon: const Icon(Icons.add, color: Colors.white), // vit plus-ikon
              label: const Text(
                'ADD', // texten på knappen
                style: TextStyle(
                  fontSize: 18, //storlek på texten
                  fontWeight: FontWeight.bold, //fet text
                  color: Colors.white, // vit text
                ),
              ),
              style: ElevatedButton.styleFrom( // stil på knappen
                backgroundColor: Colors.pink, // rosa knapp
                padding: const EdgeInsets.symmetric(vertical: 14), //padding
                shape: RoundedRectangleBorder( // form på knappen
                  borderRadius: BorderRadius.circular(30), // rundade hörn
                ),
                elevation: 4, // liten skugga
              ),
            ),
          ],
        ),
      ),
    );
  }
}
