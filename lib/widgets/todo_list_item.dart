import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_list2/models/todo.dart';

class  TodoListItem extends StatelessWidget {
  const TodoListItem ({super.key, required this.todo, required this.onDelete, required this.onEdit});

  final Todo todo;
  final Function(Todo) onDelete;
  final Function(Todo) onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      //padding: const EdgeInsets.all(8.0),
      child: Slidable(
        child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.grey[200],
        ),

        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
                DateFormat('dd/MM/yyyy - HH-mm').format(todo.dateTime), style: TextStyle(
                fontSize: 12,
              )
            ),
            Text(
              todo.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),),
          ],
        ),
      ),

        endActionPane: ActionPane(motion: ScrollMotion(), extentRatio: 0.55,
            children: [
             SlidableAction(
                 onPressed: (BuildContext context){
                   onDelete(todo);
                   print('Delete');
                 },
               icon: Icons.delete,
               label: 'Deletar',
               backgroundColor: Colors.red,
             ),
              SlidableAction(
                onPressed: (BuildContext context){
                  onEdit(todo);
                  print('Editar');
                },
                icon: Icons.border_color,
                label: 'Editar',
                backgroundColor: Colors.blue,
              ),
        ]),
      ),
    );
  }
}
