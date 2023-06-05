

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:textile_service/Screens/Distributor/Add%20Worker/Models/add_worker_model.dart';

import '../Models/add_work_model.dart';

class AddWorkDatabase {
  static final AddWorkDatabase _databaseInstance = AddWorkDatabase._();

  factory AddWorkDatabase() {
    return _databaseInstance;
  }

  AddWorkDatabase._();

  Future<bool> addWork({required AddWorkModel data}) async {
    try {
      await FirebaseFirestore.instance
          .collection('AssignedWork')
          .doc()
          .set(data.toMap());
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> updateWork({required AddWorkModel data}) async {
    try {
      await FirebaseFirestore.instance
          .collection('AssignedWork')
          .doc(data.docID)
          .update(data.toMap());
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> deleteWork(AddWorkModel data) async {
    try {
      await FirebaseFirestore.instance
          .collection('AssignedWork')
          .doc(data.docID)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<AddWorkModel>> getAllWork() async {
    List<AddWorkModel> workList = [];
    try {
      var snap = await FirebaseFirestore.instance
          .collection('AssignedWork')
          .get();
      snap.docs.forEach((doc) {
        workList.add(AddWorkModel.fromFirestore(doc));
      });
      return workList;
    } catch (err) {
      print(err);
      return workList;
    }
  }

  Future<int> getWorkCount() async {
    int count = 0;
    try {
      var snap =
      await FirebaseFirestore.instance.collection('AssignedWork').count().get();
      count = snap.count;
      return count;
    } catch (err) {
      print(err);
      return count;
    }
  }

  Stream<QuerySnapshot> listenWork(String id) {
    return FirebaseFirestore.instance
        .collection('AssignedWork').where('workerId', isEqualTo: id).orderBy("lastUpdatedTime", descending: true)
        .snapshots();
  }
}