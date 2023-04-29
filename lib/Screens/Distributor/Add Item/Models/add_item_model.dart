

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddItemModel{

  String itemName;
  num itemPrice;
  String? itemImage;
  final String distributorEmail;
  final DateTime lastUpdatedTime;
  String? docID;

  AddItemModel({required this.itemName, required this.itemPrice,  this.itemImage,required this.distributorEmail,required this.lastUpdatedTime,this.docID});

  factory AddItemModel.fromFirestore(DocumentSnapshot doc) {
    Map? data = doc.data() as Map?;
    return AddItemModel(
        itemName: data!["itemName"],
        itemPrice: data["itemPrice"],
        itemImage: data['image'],
        distributorEmail: data['distributor'],
        lastUpdatedTime: DateTime.parse(data['lastUpdatedTime'].toDate().toString()),
        docID: doc.id
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'itemName': itemName,
      'itemPrice': itemPrice,
      'itemImage':itemImage,
      'distributor' : distributorEmail,
      'lastUpdatedTime': lastUpdatedTime,
    };
    return data;
  }
}