import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DumpAssignController extends GetxController {
  var selectedItem = ''.obs;
  var employees = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

  void fetchEmployees() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Petugas')
        .get();
    employees.value =
        querySnapshot.docs.map((doc) => doc['name'].toString()).toList();
  }

  void setSelectedItem(value) {
    selectedItem.value = value;
  }
}
