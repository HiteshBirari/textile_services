
import 'package:cloud_firestore/cloud_firestore.dart';

class AddWorkModel {
  final String item;
  final String? itemImage;
  final String quantity;
  final String totalPrice;
  final String status;
  final DateTime lastUpdatedTime;
  final String workerId;
  String? docID;

  AddWorkModel(
      {required this.item,
        required this.itemImage,
        required this.quantity,
        required this.totalPrice,
        required this.status,
        required this.lastUpdatedTime,
        required this.workerId,
        this.docID
      });

  factory AddWorkModel.fromFirestore(DocumentSnapshot doc) {
    Map? data = doc.data() as Map?;
    return AddWorkModel(
        item: data!["item"],
        itemImage: data["itemImage"],
        quantity: data["quantity"],
        totalPrice: data['totalPrice'],
        status: data['status'],
        lastUpdatedTime: DateTime.parse(data['lastUpdatedTime'].toDate().toString()),
        workerId: data['workerId'],
        docID: doc.id
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'item': item,
      'itemImage':itemImage,
      'quantity': quantity,
      'totalPrice':totalPrice,
      'status':status,
      'lastUpdatedTime': lastUpdatedTime,
      'workerId':workerId,
    };
    return data;
  }
}