

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:textile_service/Screens/Distributor/Register%20Screen/Models/distributor_model.dart';

class DistributorDatabase {
  static final DistributorDatabase _databaseInstance = DistributorDatabase._();

  factory DistributorDatabase() {
    return _databaseInstance;
  }

  DistributorDatabase._();

  Future<bool> addDistributor({required DistributorModel data}) async {
    try {
      await FirebaseFirestore.instance
          .collection('Distributors')
          .doc()
          .set(data.toMap());
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> updateDistributor({required DistributorModel data}) async {
    try {
      await FirebaseFirestore.instance
          .collection('Distributors')
          .doc(data.docID)
          .update(data.toMap());
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> deleteDistributor(DistributorModel client) async {
    try {
      await FirebaseFirestore.instance
          .collection('Distributors')
          .doc(client.docID)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }





  Future<List<DistributorModel>?> getAllDistributors() async {
    List<DistributorModel> distributorList = [];
    try {
      var snap = await FirebaseFirestore.instance
          .collection('Distributors')
          .get();
      snap.docs.forEach((doc) {
        distributorList.add(DistributorModel.fromFirestore(doc));
      });
      return distributorList;
    } catch (err) {
      print(err);
      return distributorList;
    }
  }

  Future<int> getDistributorCount() async {
    int count = 0;
    try {
      var snap =
      await FirebaseFirestore.instance.collection('Distributors').count().get();
      count = snap.count;
      return count;
    } catch (err) {
      print(err);
      return count;
    }
  }


  Stream<QuerySnapshot> listenDistributor() {
    return FirebaseFirestore.instance
        .collection('Distributors')
        .orderBy("lastUpdatedTime", descending: true)
        .snapshots();
  }
}