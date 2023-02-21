
import 'package:cloud_firestore/cloud_firestore.dart';

class DistributorModel {
  final String name;
  final String mobileNumber;
  final String email;
  final DateTime lastUpdatedTime;
  String? docID;

  DistributorModel(
      {required this.name,
        required this.mobileNumber,
        required this.email,
        required this.lastUpdatedTime,
        this.docID
      });

  factory DistributorModel.fromFirestore(DocumentSnapshot doc) {
    Map? data = doc.data() as Map?;
    return DistributorModel(
        name: data!["name"],
        mobileNumber: data["mobileNumber"],
        email: data['email'],
        lastUpdatedTime: DateTime.parse(data['lastUpdatedTime'].toDate().toString()),
        docID: doc.id
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'name': name,
      'mobileNumber': mobileNumber,
      'email': email,
      'lastUpdatedTime': lastUpdatedTime,
    };
    return data;
  }
}