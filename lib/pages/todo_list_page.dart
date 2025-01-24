import 'package:flutter/material.dart';
import 'package:todo_list2/models/todo.dart';
import 'package:todo_list2/repositores/todo_repository.dart';
import 'package:todo_list2/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoPos;

  String? errorText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',
                          errorText: errorText,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          String text = todoController.text;

                          if (text.isEmpty) {
                            setState(() {
                              errorText = 'O titulo não pode ser vazio!';
                            });
                            return;
                          }

                          setState(() {
                            Todo newTodo = Todo(
                              title: text,
                              dateTime: DateTime.now(),
                            );
                            todos.add(newTodo);
                            errorText = null;
                          });
                          todoController.clear();
                          todoRepository.saveTodoList(todos);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(14)),
                        child: Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.white,
                        ))
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,
                          onEdit: onEdit,
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                            'Você possui ${todos.length} tarefas pendentes')),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: showDeleteTodoConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(14)),
                      child: Text(
                        'Limpar Tudo',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Tarefa ${todo.title} foi removida com sucesso!',
        style: TextStyle(color: Color(0xff060708)),
      ),
      backgroundColor: Colors.white,
      action: SnackBarAction(
        label: 'Desfazer',
        onPressed: () {
          setState(() {
            todos.insert(deletedTodoPos!, deletedTodo!);
          });
          todoRepository.saveTodoList(todos);
        },
        textColor: const Color(0xff00d7f3),
      ),
      duration: const Duration(seconds: 5),
    ));
  }

  void showDeleteTodoConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar Tudo?'),
        content: Text('Você tem certeza que deseja apagar todas as tarefas?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Color(0xff00d7f3)),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTodos();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Limpar Tudo'),
          ),
        ],
      ),
    );
  }

  void onEdit(Todo todo) {
    TextEditingController controller = TextEditingController(text: todo.title);
    String? errorText;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Editar Tarefa"),
              content: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Novo Título",
                  errorText: errorText, // Exibe o texto de erro, se definido
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fecha o diálogo
                  },
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    String text2 = controller.text;

                    if (text2.isEmpty) {
                      setState(() {
                        errorText = 'O título não pode ser vazio!'; // Define o texto de erro
                      });
                      return;
                    }


                    setState(() {
                      todo.title = text2;  // Atualiza o título e remove o erro
                      errorText = null; // Limpa o texto de erro
                    });

                    this.setState(() {

                    });

                    Navigator.of(context).pop(); // Fecha o diálogo
                  },
                  child: Text(
                    "Salvar",
                    style: TextStyle(color: Color(0xff00d7f3)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }


  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}
