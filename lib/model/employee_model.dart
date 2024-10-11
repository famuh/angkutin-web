import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  final String id;
  final String name;
  final String zone;

  Employee({required this.id, required this.name, required this.zone});

  factory Employee.fromDocument(DocumentSnapshot doc) {
    return Employee(
      id: doc.id,
      name: doc['name'],
      zone: doc['zone'],
    );
  }
}
