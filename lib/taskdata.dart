import 'package:flutter/material.dart';

class TaskData extends StatefulWidget {
  final String? name;
  final String? description;
  final String? date;
  final String? time;
  final String? priority;
  final bool isCompleted;
  const TaskData({
    Key? key,
    this.name,
    this.description,
    this.date,
    this.time,
    this.priority,
    required this.isCompleted,
  }) : super(key: key);

  @override
  State<TaskData> createState() => _TaskDataState();
}

class _TaskDataState extends State<TaskData> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  bool completed = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    descriptionController = TextEditingController(text: widget.description);
    dateController = TextEditingController(text: widget.date);
    timeController = TextEditingController(text: widget.time);
    priorityController = TextEditingController(text: widget.priority);
    completed = widget.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          Checkbox(
            value: completed,
            onChanged: (value) {
              setState(() {
                completed = value!;
              });
            },
          ),
          TextButton(
            onPressed: () {
              final editedContact = {
                'name': nameController.text,
                'description': descriptionController.text,
                'date': dateController.text,
                'time': timeController.text,
                'priority': priorityController.text,
                'isCompleted': completed,
              };
              Navigator.pop(context, editedContact);
            },
            child: const Text('Save'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Task Name',
                // border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: dateController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Date...',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: timeController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Time...',
                // border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: priorityController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Priority...',
                // border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: descriptionController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Type something...',
                // border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
