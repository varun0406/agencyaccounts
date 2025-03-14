import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database_service.dart';

class AddBillScreen extends StatefulWidget {
  final Key? key;

  AddBillScreen({this.key}) : super(key: key);

  @override
  AddBillScreenState createState() => AddBillScreenState();
}

class AddBillScreenState extends State<AddBillScreen> {
  final DatabaseService dbService = DatabaseService();
  String? selectedSupplier;
  String? selectedClient;
  final TextEditingController billNoController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController commissionController = TextEditingController();
  final TextEditingController billDateController = TextEditingController();
  final TextEditingController lrNumberController = TextEditingController();
  final TextEditingController itemDescController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController netAmountController = TextEditingController();
  final TextEditingController metersAmountController = TextEditingController();
  final TextEditingController GSTController = TextEditingController();
  final TextEditingController CDController = TextEditingController();
  final TextEditingController otherPlusController = TextEditingController();
  final TextEditingController otherMinusController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    rateController.addListener(_updateTotalAmount);
    metersAmountController.addListener(_updateTotalAmount);
    GSTController.addListener(_updateNetAmount);
    CDController.addListener(_updateNetAmount);
    otherPlusController.addListener(_updateNetAmount);
    otherMinusController.addListener(_updateNetAmount);
  }

  @override
  void dispose() {
    rateController.removeListener(_updateTotalAmount);
    metersAmountController.removeListener(_updateTotalAmount);
    GSTController.removeListener(_updateNetAmount);
    CDController.removeListener(_updateNetAmount);
    otherPlusController.removeListener(_updateNetAmount);
    otherMinusController.removeListener(_updateNetAmount);
    rateController.dispose();
    metersAmountController.dispose();
    GSTController.dispose();
    CDController.dispose();
    otherPlusController.dispose();
    otherMinusController.dispose();
    super.dispose();
  }

  void _updateTotalAmount() {
    double rate = double.tryParse(rateController.text) ?? 0.0;
    double meters = double.tryParse(metersAmountController.text) ?? 0.0;
    double totalAmount = rate * meters;
    totalAmountController.text = totalAmount.toStringAsFixed(2);
    _updateNetAmount();
  }

  void _updateNetAmount() {
    double totalAmount = double.tryParse(totalAmountController.text) ?? 0.0;
    double gstPercentage = double.tryParse(GSTController.text) ?? 0.0;
    double cd = double.tryParse(CDController.text) ?? 0.0;
    double otherPlus = double.tryParse(otherPlusController.text) ?? 0.0;
    double otherMinus = double.tryParse(otherMinusController.text) ?? 0.0;
    double gstAmount = totalAmount * (gstPercentage / 100);
    double netAmount = totalAmount - cd + gstAmount + otherPlus - otherMinus;
    netAmountController.text = netAmount.toStringAsFixed(2);
  }

  void _addBill() async {
    if (selectedSupplier != null && selectedClient != null && amountController.text.isNotEmpty) {
      await dbService.addBill(
        selectedSupplier!,
        selectedClient!,
        double.parse(amountController.text),
        double.parse(commissionController.text),
        billDateController.text,
        lrNumberController.text,
        itemDescController.text,
        double.parse(rateController.text),
        double.parse(totalAmountController.text),
        double.parse(netAmountController.text),
        double.parse(metersAmountController.text),
        double.parse(GSTController.text),
        double.parse(CDController.text),
        billNoController.text,
        double.parse(otherPlusController.text),
        double.parse(otherMinusController.text),
        remarksController.text
      );
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        billDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Bill")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Supplier Dropdown
              StreamBuilder<QuerySnapshot>(
                stream: dbService.getSuppliers(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  List<DropdownMenuItem<String>> supplierItems = snapshot.data!.docs
                      .map((doc) {
                        String name = doc['name'] ?? 'Unknown';
                        return DropdownMenuItem(
                          value: name,
                          child: Text(name),
                        );
                      }).toList();
                  return DropdownButtonFormField<String>(
                    value: selectedSupplier,
                    items: supplierItems,
                    onChanged: (value) => setState(() => selectedSupplier = value),
                    decoration: InputDecoration(labelText: "Select Supplier"),
                  );
                },
              ),

              // Client Dropdown
              StreamBuilder<QuerySnapshot>(
                stream: dbService.getClients(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                    List<DropdownMenuItem<String>> clientItems = snapshot.data!.docs.map((doc) {
                    String name = doc['name'] ?? 'Unknown';
                    return DropdownMenuItem(
                      value: name,
                      child: Text(name),
                    );
                    }).toList();
                  return DropdownButtonFormField<String>(
                    value: selectedClient,
                    items: clientItems,
                    onChanged: (value) => setState(() => selectedClient = value),
                    decoration: InputDecoration(labelText: "Select Client"),
                  );
                },
              ),

              TextField(controller: billNoController, decoration: InputDecoration(labelText: "Bill No")),
              TextField(
                controller: billDateController,
                decoration: InputDecoration(
                  labelText: "Bill Date",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
              ),
              TextField(controller: lrNumberController, decoration: InputDecoration(labelText: "LR Number")),
              TextField(controller: itemDescController, decoration: InputDecoration(labelText: "Item Description")),
              TextField(controller: rateController, decoration: InputDecoration(labelText: "Rate"), keyboardType: TextInputType.number),
              TextField(controller: metersAmountController, decoration: InputDecoration(labelText: "Meters Amount"), keyboardType: TextInputType.number),
              TextField(controller: totalAmountController, decoration: InputDecoration(labelText: "Total Amount"), keyboardType: TextInputType.number, readOnly: true),
              TextField(controller: CDController, decoration: InputDecoration(labelText: "Cash Discount"), keyboardType: TextInputType.number),
              TextField(controller: GSTController, decoration: InputDecoration(labelText: "GST (%)"), keyboardType: TextInputType.number),
              TextField(controller: otherPlusController, decoration: InputDecoration(labelText: "Other Plus"), keyboardType: TextInputType.number),
              TextField(controller: otherMinusController, decoration: InputDecoration(labelText: "Other Minus"), keyboardType: TextInputType.number),
              TextField(controller: netAmountController, decoration: InputDecoration(labelText: "Net Amount"), keyboardType: TextInputType.number, readOnly: true),
              TextField(controller: amountController, decoration: InputDecoration(labelText: "Amount"), keyboardType: TextInputType.number),
              TextField(controller: commissionController, decoration: InputDecoration(labelText: "Commission"), keyboardType: TextInputType.number),
              TextField(controller: remarksController, decoration: InputDecoration(labelText: "Remarks")),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _addBill, child: Text("Save Bill")),
            ],
          ),
        ),
      ),
    );
  }
}
