import 'package:firebase_database/firebase_database.dart';

class Contact {
  String? id;
  String name;
  String phone;
  String address;
  String relationship;

  Contact({
    required this.name,
    required this.phone,
    required this.address,
    required this.relationship});

  Contact.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.key!,
        name = (snapshot.value as Map<String, dynamic>)['name'] ?? '',
        phone = (snapshot.value as Map<String, dynamic>)['phone'] ?? '',
        address = (snapshot.value as Map<String, dynamic>)['address'] ?? '',
        relationship = (snapshot.value as Map<String, dynamic>)['relationship'] ?? '';

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'relationship': relationship,
    };
  }

  String get getId => id ?? '';
}