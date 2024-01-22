import 'package:flutter/material.dart';
import 'package:taskapp/sql_helper.dart';
import 'package:taskapp/taskdata.dart';

class SearchTask extends StatefulWidget {
  const SearchTask({super.key});

  @override
  State<SearchTask> createState() => _SearchTaskState();
}

class _SearchTaskState extends State<SearchTask> {
  List<Map<String, dynamic>> _task = [];
  List<Map<String, dynamic>> _foundTask = [];
  bool _isLoading = true;
  void _refreshTask() async {
    final data = await SQLHelper.getItemsOrderBy();
    setState(() {
      _task = data;
      _foundTask = _task;
      _isLoading = false;
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    _refreshTask();
    super.initState();
  }
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _task;
    } else {
      results = _task.where((user) => user["name"].toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    // Refresh the UI
    setState(() {
      _foundTask = results;
    });
  }
  bool isCompleted = false;
  Future<void> _updateItem(int id, int index) async {
    // print("............................update...............................");
    if (_foundTask[index]['isCompleted'] == 1) {
      isCompleted = true;
    } else {
      isCompleted = false;
    }
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskData(
            name: _foundTask[index]['name'],
            description: _foundTask[index]['description'],
            date: _foundTask[index]['date'],
            time: _foundTask[index]['time'],
            priority: _foundTask[index]['priority'],
            isCompleted: isCompleted),
      ),
    );
    await SQLHelper.updateItem(
      id,
      result['name'],
      result['description'],
      result['date'],
      result['time'],
      result['priority'],
      result['isCompleted'],
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
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      ): Padding(
        padding: const EdgeInsets.only(top: 40,left: 7,right: 7,bottom: 7),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
                hintText: "Search",
                suffixIcon: const Icon(Icons.search),
                // prefix: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: _foundTask.isNotEmpty
                  ? ListView.builder(
                itemCount: _foundTask.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    _updateItem(_foundTask[index]['id'], index);
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
                                _foundTask[index]['name'],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                              IconButton(
                                  onPressed: () {
                                    _deleteItem(_foundTask[index]['id']);
                                  },
                                  icon: const Icon(Icons.delete))
                            ],
                          ),
                          Text(
                            _foundTask[index]['description'],
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
                            "Priority: ${_foundTask[index]['priority']} & Date: ${_task[index]['date']}",
                            style: TextStyle(
                              color: _getColor(
                                _foundTask[index]['priority'],
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
              ): const Text(
                'No results found Please try with different search',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    _refreshTask();
  }
}

