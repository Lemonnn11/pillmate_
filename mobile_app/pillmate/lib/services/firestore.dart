import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  final FirebaseFirestore firestore ;
  FirestoreService({required this.firestore});

  Future<String?> getPharmacyName(String pharID) async {
    final querySnapshot = await firestore.collection("pharmacies").where("pharID", isEqualTo: pharID).get();
    for (var docSnapshot in querySnapshot.docs) {
      return docSnapshot.data()?['storeName'];
    }
  }
  }