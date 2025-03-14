import 'package:flutter/material.dart';

class SupplierListScreen extends StatefulWidget {
  const SupplierListScreen({super.key});

  @override
  _SupplierListScreenState createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  List<String> suppliers = ["Supplier 1", "Supplier 2", "Supplier 3"];

  void _addSupplier(String supplierName) {
    setState(() {
      suppliers.add(supplierName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Suppliers")),
      body: ListView.builder(
        itemCount: suppliers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(suppliers[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSupplierDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddSupplierDialog() {
    TextEditingController supplierController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Supplier"),
        content: TextField(
          controller: supplierController,
          decoration: InputDecoration(labelText: "Supplier Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              _addSupplier(supplierController.text);
              Navigator.pop(context);
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }
}
