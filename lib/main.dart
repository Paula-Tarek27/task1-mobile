import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> myModels = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost:8000/api/mymodels/'));
    if (response.statusCode == 200) {
      setState(() {
        myModels = json.decode(response.body);
      });
    } else {
      print('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: myModels.length,
        itemBuilder: (BuildContext context, int index) {
          final myModel = myModels[index];
          return ListTile(
            title: Text(myModel['name']),
            subtitle: Text(myModel['description']),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deleteData(myModel['id']);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
           MaterialPageRoute(builder: (context) => CreateMyModelScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> deleteData(int id) async {
    final response = await http.delete(Uri.parse('http://localhost:8000/api/mymodels/$id/'));
    if (response.statusCode == 204) {
      setState(() {
        myModels.removeWhere((element) => element['id'] == id);
      });
    } else {
      print('Failed to delete data');
    }
  }
}

class CreateMyModelScreen extends StatefulWidget {
  @override
  _CreateMyModelScreenState createState() => _CreateMyModelScreenState();
}

class _CreateMyModelScreenState extends State<CreateMyModelScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> createData() async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/api/mymodels/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'name': nameController.text,
          'description': descriptionController.text,
        },
      ),
    );
    if (response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      print('Failed to create data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create MyModel'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: createData,
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
