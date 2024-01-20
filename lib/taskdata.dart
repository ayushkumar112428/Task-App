import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  String? selectedDate;
  String? selectedTime;
  TextEditingController priorityController = TextEditingController();
  bool completed = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    descriptionController = TextEditingController(text: widget.description);
    selectedDate = widget.date;
    selectedTime = widget.time;
    priorityController = TextEditingController(text: widget.priority);
    completed = widget.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: ()async{
            DateTime? pickDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2030));
            if(pickDate!=null){
              selectedDate = DateFormat('dd-MM-yyyy').format(pickDate);
            }
          }, icon: const Icon(Icons.date_range)),
          IconButton(onPressed: () async{
            TimeOfDay? pickTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
            if(pickTime!=null){
              selectedTime = pickTime.format(context);
            }
          }, icon: const Icon(Icons.access_time_rounded)),
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
                'date': selectedDate,
                'time': selectedTime,
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
        padding: const EdgeInsets.symmetric(horizontal: 12),
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
