import 'package:flutter/material.dart';
import '../services/database_service.dart';

class AddSupplierScreen extends StatefulWidget {
  @override
  _AddSupplierScreenState createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final DatabaseService dbService = DatabaseService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController commissionController = TextEditingController();

  void _addSupplier() async {
    if (nameController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        whatsappController.text.isNotEmpty &&
        commissionController.text.isNotEmpty) {
      await dbService.addSupplier(
        nameController.text,
        addressController.text,
        whatsappController.text,
        commissionController.text,
      );
      nameController.clear();
      addressController.clear();
      whatsappController.clear();
      commissionController.clear();
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    whatsappController.dispose();
    commissionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Supplier")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Supplier Name"),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: "Supplier Address"),
            ),
            TextField(
              controller: whatsappController,
              decoration: InputDecoration(labelText: "WhatsApp Number"),
            ),
            TextField(
              controller: commissionController,
              decoration: InputDecoration(labelText: "Commission Percentage"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _addSupplier, child: Text("Save Supplier")),
          ],
        ),
      ),
    );
  }
}
