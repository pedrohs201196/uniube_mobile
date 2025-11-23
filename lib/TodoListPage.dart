import 'package:flutter/material.dart';

class TodoListPage extends StatefulWidget {
  final DateTime selectedDate;

  TodoListPage({required this.selectedDate});

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Map<String, dynamic>> _tasks = [];

  //ordenar tarefas
  void _sortTasks() {
    _tasks.sort((a, b) {
      if (a["done"] == b["done"]) {
        return a["text"].toLowerCase().compareTo(b["text"].toLowerCase());
      }
      return a["done"] ? 1 : -1; // pendentes primeiro
    });
  }

  //adicionar tarefa
  void _showAddTaskDialog() {
    TextEditingController _dialogController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Adicionar tarefa",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          content: TextField(
            controller: _dialogController,
            decoration: InputDecoration(
              hintText: "Digite a tarefa",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_dialogController.text.trim().isEmpty) {
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text("Você não pode deixar a descrição vazia"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                setState(() {
                  _tasks.add({
                    "text": _dialogController.text.trim(),
                    "done": false,
                  });
                  _sortTasks();
                });

                Navigator.pop(context);
              },
              child: Text("Salvar",
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  //remover tarefas
  void _showConfirmDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Remover todas as tarefas",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text("Tem certeza que deseja apagar todas as tarefas?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                setState(() {
                  _tasks.clear();
                });
                Navigator.pop(context);
              },
              child: Text("Confirmar",
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        "${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}";

    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD), // azul claro

      appBar: AppBar(
        title: Text(
          "Tarefas de $formattedDate",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),

      body: Column(
        children: [
          Expanded(
            child: _tasks.isEmpty
                ? Center(
                    child: Text(
                      "Nenhuma tarefa para este dia",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(2, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: task["done"],
                            onChanged: (value) {
                              setState(() {
                                task["done"] = value!;
                                _sortTasks();
                              });
                            },
                            activeColor: Colors.amber,
                          ),
                          title: Text(
                            task["text"],
                            style: TextStyle(
                              fontSize: 16,
                              decoration: task["done"]
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _tasks.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      //botões inferiores
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(18.0),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _showAddTaskDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  "Adicionar tarefa",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _showConfirmDeleteDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade300,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  "Remover todas",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
