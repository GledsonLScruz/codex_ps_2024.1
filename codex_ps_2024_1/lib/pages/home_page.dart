import 'dart:convert';

import 'package:codex_ps_2024_1/data/task_model.dart';
import 'package:codex_ps_2024_1/request/requests.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<TaskModel> tasks = [];

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
              onPressed: () async {
                Navigator.of(context).pop();
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                String? userId = await prefs.getString("userId");
                if (userId == null) return;
                task.isCompleted = true;
                TaskModel? result = await Request.editTask(task, userId);
                if (result != null) {
                  var int = tasks.indexWhere((e) => e.id == task.id);
                  setState(() {
                    tasks[int] = task;
                  });
                }
              },
            ),
            TextButton(
              child: Text("Delete Task"),
              onPressed: () async {
                Navigator.of(context).pop();
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                String? userId = await prefs.getString("userId");
                if (userId == null) return;
                var result = await Request.deleteTask(task, userId);
                if (result) {
                  var int = tasks.indexWhere((e) => e.id == task.id);
                  var aux = tasks;
                  aux.removeAt(int);
                  setState(() {
                    tasks = aux;
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) async {
      String? userId = prefs.getString("userId");
      if (userId != null) {
        List<TaskModel> tasksRequest = await Request.getTasks(userId);
        setState(() {
          tasks = tasksRequest;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(onPressed: () {showEditProfileDialog(context);}, icon: Icon(Icons.edit))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            TaskModel? task = await showTaskDialog(context);
            if (task != null) {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              String? userId = await prefs.getString("userId");
              if (userId == null) return;
              TaskModel? result = await Request.addTask(task, userId);
              if (result != null) {
                setState(() {
                  tasks.add(result);
                });
              }
            }
          },
          child: const Icon(Icons.add)),
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

class TaskDialog extends StatefulWidget {
  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _createTask(BuildContext context) {
    String taskName = _nameController.text;
    String taskDescription = _descriptionController.text;

    if (taskName.isNotEmpty && taskDescription.isNotEmpty) {
      TaskModel newTask = TaskModel(
          name: taskName,
          description: taskDescription,
          createdDate: DateTime.now(),
          isCompleted: false);
      Navigator.of(context).pop(newTask); // Return the created task
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create New Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Task Name'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Task Description'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog without saving
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _createTask(context),
          child: Text('Create'),
        ),
      ],
    );
  }
}

// Function to show the dialog
Future<TaskModel?> showTaskDialog(BuildContext context) {
  return showDialog<TaskModel>(
    context: context,
    builder: (context) => TaskDialog(),
  );
}

Future<void> showEditProfileDialog(BuildContext context) async {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _image = File(image.path);
    }
  }

  Future<void> _updateProfile() async {
    String name = nameController.text;
    String age = ageController.text;

    if (name.isEmpty || age.isEmpty || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select an image.')),
      );
      return;
    }

    File imageFile = File('path_to_your_image.jpg');

    String base64Image = await imageToBase64(imageFile);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString("userId");
    if (userId == null) return;

    var response = await Request.editProfile(
        userId, nameController.text, ageController.text, base64Image);

    if (!response) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile.')),
      );
    }
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null ? Icon(Icons.person, size: 40) : null,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text('Update'),
            onPressed: _updateProfile,
          ),
        ],
      );
    },
  );
}

Future<String> imageToBase64(File imageFile) async {
  // Read the file as bytes
  final bytes = await imageFile.readAsBytes();

  // Convert bytes to base64 string
  String base64String = base64Encode(bytes);

  return base64String;
}
