

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:textile_service/Screens/Distributor/Add%20Worker/Models/add_worker_model.dart';

class AddWorkerDatabase {
  static final AddWorkerDatabase _databaseInstance = AddWorkerDatabase._();

  factory AddWorkerDatabase() {
    return _databaseInstance;
  }

  AddWorkerDatabase._();

  Future<bool> addWorker({required AddWorkerModel data}) async {
    try {
      await FirebaseFirestore.instance
          .collection('Workers')
          .doc()
          .set(data.toMap());
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> updateWorker({required AddWorkerModel data}) async {
    try {
      await FirebaseFirestore.instance
          .collection('Workers')
          .doc(data.docID)
          .update(data.toMap());
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> deleteWorker(AddWorkerModel data) async {
    try {
      await FirebaseFirestore.instance
          .collection('Workers')
          .doc(data.docID)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }





  Future<List<AddWorkerModel>?> getAllWorkers() async {
    List<AddWorkerModel> workersList = [];
    try {
      var snap = await FirebaseFirestore.instance
          .collection('Workers')
          .get();
      snap.docs.forEach((doc) {
        workersList.add(AddWorkerModel.fromFirestore(doc));
      });
      return workersList;
    } catch (err) {
      print(err);
      return workersList;
    }
  }

  Future<int> getWorkerCount() async {
    int count = 0;
    try {
      var snap =
      await FirebaseFirestore.instance.collection('Workers').count().get();
      count = snap.count;
      return count;
    } catch (err) {
      print(err);
      return count;
    }
  }

  Stream<QuerySnapshot> listenWorker() {
    return FirebaseFirestore.instance
        .collection('Workers')
        .orderBy("lastUpdatedTime", descending: true)
        .snapshots();
  }
}