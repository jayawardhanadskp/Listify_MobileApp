import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import '../services/config.dart';

class DashboardScreen extends StatefulWidget {
  final token;
  const DashboardScreen({super.key, required this.token});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late String userId;
  List? items;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodedToken['_id'];
    getTodoList(userId);
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController discController = TextEditingController();

  void showAddTodo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: discController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    addTodo();
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void addTodo() async {
    if (titleController.text.isNotEmpty && discController.text.isNotEmpty) {
      var regBody = {
        "userId": userId,
        "title": titleController.text,
        "desc": discController.text,
      };

      try {
        var response = await http.post(
          Uri.parse(storeTodo),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody),
        );

        var jsonresponse = jsonDecode(response.body);
        if (jsonresponse['status'] == true) {
          Navigator.pop(context);
          titleController.clear();
          discController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Added Successfully')));
          getTodoList(userId);
        } else {
          print('Error adding todo');
        }
      } catch (e) {
        print('Failed to add todo: $e');
      }
    }
  }

  void getTodoList(String userId) async {
    var regBody = {"userId": userId};

    try {
      var response = await http.post(
        Uri.parse(getTodList),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      var jsonresponse = jsonDecode(response.body);
      if (jsonresponse['status'] == true) {
        items = jsonresponse['success'];
        setState(() {});
      } else {
        print('Error fetching todos');
      }
    } catch (e) {
      print('Failed to fetch todos: $e');
    }
  }

  void deleteItem(id) async {
    var regBody = {"id": id};

    try {
      var response = await http.post(
        Uri.parse(deleteTodo),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      var jsonresponse = jsonDecode(response.body);
      print(jsonresponse);

      if (jsonresponse['status'] == true) {
        getTodoList(userId);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Item Deleted')));
      }
    } catch (e) {
      print('Failed to fetch todos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: showAddTodo,
        child: const Icon(Icons.add),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(userId),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: items?.length ?? 0,
                itemBuilder: (context, index) {
                  return Slidable(
                    key: ValueKey(index),
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      dismissible: DismissiblePane(onDismissed: () {}),
                      children: [
                        SlidableAction(
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                          onPressed: (BuildContext context) {
                            print('Deleting: ${items![index]['_id']}');
                            deleteItem('${items![index]['_id']}');
                          },
                        ),
                      ],
                    ),
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Icons.task),
                        title: Text(items![index]['title'] ?? 'No title'),
                        subtitle:
                            Text(items![index]['desc'] ?? 'No description'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
