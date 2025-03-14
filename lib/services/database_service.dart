import 'package:cloud_firestore/cloud_firestore.dart';
class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add Supplier
  Future<void> addSupplier(String name, String address, String whatsappNumber,String commissionController) async {
    await _db.collection('suppliers').add({
      'name': name,
      'address': address,
      'whatsappNumber': whatsappNumber,
      "Commission": commissionController
    });
  }
  // Add Bill
  Future<void> addBill(String supplier, String client, double amount, double commission, String billDate, String lrNumber, String itemDesc, double rate, double totalAmount, double netAmount, double meters, double GST, double CD, String bill_no, double otherPlus, double otherMinus, String Remarks) async {
    await _db.collection('bills').add({
      'supplier': supplier,
      'client': client,
      'amount': amount,
      'commission': commission,
      'billDate': billDate,
      'lrNumber': lrNumber,
      'itemDesc': itemDesc,
      'rate': rate,
      'totalAmount': totalAmount,
      'netAmount': netAmount,
      'meters': meters,
      'GST': GST,
      'CD': CD,
      'bill_no': bill_no,
      'otherPlus': otherPlus,
      'otherMinus': otherMinus,
      'Remarks': Remarks,
      'paid': false,
    });
  }
  // Get Bills
  Stream<QuerySnapshot> getBills() {
    return _db.collection('bills').snapshots();
  }

  // Add Client
  Future<void> addClient(String name, String address, String number) async {
    await _db.collection('clients').add({
      'name': name,
      'address': address,
      'number': number,
    });
  }
  

  // Get Suppliers
  Stream<QuerySnapshot> getSuppliers() {
    return _db.collection('suppliers').snapshots();
  }

  // Get Clients
  Stream<QuerySnapshot> getClients() {
    return _db.collection('clients').snapshots();
  }
}
