import 'package:flutter/material.dart';
import '../services/database_service.dart';
// Import the HomeScreen widget

class AddClientScreen extends StatefulWidget {
  @override
  _AddClientScreenState createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final DatabaseService dbService = DatabaseService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void _addClient() async {
    if (nameController.text.isNotEmpty && numberController.text.isNotEmpty && addressController.text.isNotEmpty) {
      await dbService.addClient(nameController.text, addressController.text, numberController.text);
      nameController.clear();
      numberController.clear();
      addressController.clear();
       Navigator.pop(context); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Client")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Client Name"),
            ),
            TextField(
              controller: numberController,
              decoration: InputDecoration(labelText: "Client Number"),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: "Client Address"),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _addClient, child: Text("Save Client")),
          ],
        ),
      ),
    );
  }
}
