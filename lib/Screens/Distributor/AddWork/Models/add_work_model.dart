
import 'package:cloud_firestore/cloud_firestore.dart';

class AddWorkModel {
  final String item;
  final String quantity;
  final String totalPrice;
  final DateTime lastUpdatedTime;
  final String workerId;
  String? docID;

  AddWorkModel(
      {required this.item,
        required this.quantity,
        required this.totalPrice,
        required this.lastUpdatedTime,
        required this.workerId,
        this.docID
      });

  factory AddWorkModel.fromFirestore(DocumentSnapshot doc) {
    Map? data = doc.data() as Map?;
    return AddWorkModel(
        item: data!["item"],
        quantity: data["quantity"],
        totalPrice: data['totalPrice'],
        lastUpdatedTime: DateTime.parse(data['lastUpdatedTime'].toDate().toString()),
        workerId: data['workerId'],
        docID: doc.id
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'item': item,
      'quantity': quantity,
      'totalPrice':totalPrice,
      'lastUpdatedTime': lastUpdatedTime,
      'workerId':workerId,
    };
    return data;
  }
}