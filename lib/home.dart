import 'package:flutter/material.dart';
import 'package:taskapp/search.dart';
import 'package:taskapp/sql_helper.dart';
import 'package:taskapp/taskdata.dart';

List<Map<String, dynamic>> _task = [];

class TaskHomeScreen extends StatefulWidget {
  const TaskHomeScreen({Key? key}) : super(key: key);

  @override
  State<TaskHomeScreen> createState() => _TaskHomeScreenState();
}

class _TaskHomeScreenState extends State<TaskHomeScreen> {
  bool _isLoading = true;

  void _refreshTask() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _task = data;
      _isLoading = false;
      // print("NEW DATA LENGTH............... ${_task.length}");
    });
  }
  @override
  void initState() {
    super.initState();
    _refreshTask();
  }
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  bool isCompleted = false;
  Future<void> _addItem() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskData(
            isCompleted: isCompleted),
      ),
    );
    _nameController.text = result['name'];
    _descriptionController.text = result['description'];
    _dateController.text = result['date'];
    _timeController.text = result['time'];
    _priorityController.text = result['priority'];
    await SQLHelper.createItem(
      _nameController.text,
      _descriptionController.text,
      _dateController.text,
      _timeController.text,
      _priorityController.text,
      isCompleted,
    );
    _refreshTask();
  }
  Future<void> _updateItem(int id, int index) async {
    if (_task[index]['isCompleted'] == 1) {
      isCompleted = true;
    } else {
      isCompleted = false;
    }
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskData(
            name: _task[index]['name'],
            description: _task[index]['description'],
            date: _task[index]['date'],
            time: _task[index]['time'],
            priority: _task[index]['priority'],
            isCompleted: isCompleted),
      ),
    );
    _nameController.text = result['name'];
    _descriptionController.text = result['description'];
    _dateController.text = result['date'];
    _timeController.text = result['time'];
    _priorityController.text = result['priority'];
    isCompleted = result['isCompleted'];
    await SQLHelper.updateItem(
      id,
      _nameController.text,
      _descriptionController.text,
      _dateController.text,
      _timeController.text,
      _priorityController.text,
      isCompleted,
    );
    _refreshTask();
  }
  Color _getColor(String priority) {
    switch (priority) {
      case 'High':
        {
          return Colors.red;
        }
      case 'Average':
        {
          return Colors.blue;
        }
      case 'Low':
        {
          return Colors.green;
        }
      default:
        {
          return Colors.white;
        }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
            child: Text(
          'TASK',
          style: TextStyle(color: Colors.white),
        ),),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const SearchTask()));
          }, icon: const Icon(Icons.search))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _task.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  _updateItem(_task[index]['id'], index);
                },
                child: Card(
                  color: Colors.white30,
                  elevation: 5,
                  // margin: const EdgeInsets.all(15),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _task[index]['name'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            ),
                            IconButton(
                                onPressed: () {
                                  _deleteItem(_task[index]['id']);
                                },
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                        Text(
                          _task[index]['description'],
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Priority: ${_task[index]['priority']} & Date: ${_task[index]['date']}",
                          style: TextStyle(
                            color: _getColor(
                              _task[index]['priority'],
                            ),
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        child: const Icon(
          Icons.add,
          size: 28,
        ),
        onPressed: () => _addItem(),
      ),
    );
  }

  Future<void> _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    _refreshTask();
  }
}
