
import 'package:cloud_firestore/cloud_firestore.dart';

class AddWorkerModel {
  final String name;
  final String mobileNumber;
  final String email;
  final String address;
  final String password;
  final String distributorEmail;
  final DateTime lastUpdatedTime;
  String? docID;

  AddWorkerModel(
      {required this.name,
        required this.mobileNumber,
        required this.email,
        required this.address,
        required this.password,
        required this.distributorEmail,
        required this.lastUpdatedTime,
        this.docID
      });

  factory AddWorkerModel.fromFirestore(DocumentSnapshot doc) {
    Map? data = doc.data() as Map?;
    return AddWorkerModel(
        name: data!["name"],
        mobileNumber: data["mobileNumber"],
        email: data['email'],
        address: data['address'],
        password: data['password'],
        distributorEmail: data['distributor'],
        lastUpdatedTime: DateTime.parse(data['lastUpdatedTime'].toDate().toString()),
        docID: doc.id
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'name': name,
      'mobileNumber': mobileNumber,
      'email': email,
      'distributor' : distributorEmail,
      'password' : password,
      'address' : address,
      'lastUpdatedTime': lastUpdatedTime,
    };
    return data;
  }
}