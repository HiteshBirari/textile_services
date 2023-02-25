

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/add_item_model.dart';

class AddItemDatabase {
  static final AddItemDatabase _databaseInstance = AddItemDatabase._();

  factory AddItemDatabase() {
    return _databaseInstance;
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  AddItemDatabase._();

  Future<bool> addItem({required AddItemModel data}) async {
    try {
      await FirebaseFirestore.instance
          .collection('Items')
          .doc()
          .set(data.toMap());
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> updateItem({required AddItemModel data}) async {
    try {
      await FirebaseFirestore.instance
          .collection('Items')
          .doc(data.docID)
          .update(data.toMap());
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> deleteItem(AddItemModel data) async {
    try {
      await FirebaseFirestore.instance
          .collection('Items')
          .doc(data.docID)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }





  Future<List<AddItemModel>?> getAllItem() async {
    List<AddItemModel> itemList = [];
    try {
      var snap = await FirebaseFirestore.instance
          .collection('Items')
          .get();
      snap.docs.forEach((doc) {
        itemList.add(AddItemModel.fromFirestore(doc));
      });
      return itemList;
    } catch (err) {
      print(err);
      return itemList;
    }
  }

  Future<int> getItemCount() async {
    int count = 0;
    try {
      var snap =
      await FirebaseFirestore.instance.collection('Items').where('distributor',isEqualTo:_auth.currentUser!.email).count().get();
      count = snap.count;
      return count;
    } catch (err) {
      print(err);
      return count;
    }
  }

  Stream<QuerySnapshot> listenItem() {
    return FirebaseFirestore.instance
        .collection('Items').where('distributor',isEqualTo:_auth.currentUser!.email)
        .orderBy("lastUpdatedTime", descending: true)
        .snapshots();
  }
}