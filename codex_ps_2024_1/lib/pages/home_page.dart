import 'package:codex_ps_2024_1/data/task_model.dart';
import 'package:flutter/material.dart';


class TaskListScreen extends StatelessWidget {
  final List<TaskModel> tasks = [
    TaskModel(
      name: 'Task 1',
      createdDate: DateTime.now(),
      isCompleted: false,
      description: 'Description for Task 1',
    ),
    TaskModel(
      name: 'Task 2',
      createdDate: DateTime.now().add(Duration(days: 1)),
      isCompleted: true,
      description: 'Description for Task 2',
    ),
    TaskModel(
      name: 'Task 3',
      createdDate: DateTime.now().add(Duration(days: 2)),
      isCompleted: false,
      description: 'Description for Task 3',
    ),
  ];

  void _showTaskDialog(BuildContext context, TaskModel task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(task.name),
          content: Text("Choose an action:"),
          actions: <Widget>[
            TextButton(
              child: Text("Complete Task"),
              onPressed: () {
                Navigator.of(context).pop();
                // You can add logic to mark the task as complete here
              },
            ),
            TextButton(
              child: Text("View Task"),
              onPressed: () {
                Navigator.of(context).pop();
                // Logic to view the task details can be added here
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      floatingActionButton:
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  TaskListScreen()),
                  );
          }, child: const Icon(Icons.add)),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          TaskModel task = tasks[index];

          return ListTile(
            leading: Icon(
              task.isCompleted ? Icons.check_circle : Icons.circle,
              color: task.isCompleted ? Colors.green : Colors.red,
            ),
            title: Text(task.name),
            subtitle: Text(task.description),
            trailing: Text(
              "${task.createdDate?.toLocal()}".split(' ')[0], // Shows only date
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            onTap: () {
              _showTaskDialog(context, task);
            },
          );
        },
      ),
    );
  }
}
