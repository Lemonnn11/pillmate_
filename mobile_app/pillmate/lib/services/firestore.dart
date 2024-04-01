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

  Future<List<Map<String, String>>> getPharmaciesInfo() async {
    List<Map<String, String>> _pharList = [];
    final querySnapshot = await firestore.collection("pharmacies").get();
    print(querySnapshot.docs.length);
    for(var pharmacy in querySnapshot.docs){
      final pharmacyData = pharmacy.data();
      Map<String, String>? pharmaciesInfo = {};
      pharmaciesInfo['pharID'] = pharmacyData['pharID'].toString();
      pharmaciesInfo['storeName'] = pharmacyData['storeName'].toString();
      pharmaciesInfo['address'] = pharmacyData['address'].toString();
      pharmaciesInfo['province'] = pharmacyData['province'].toString();
      pharmaciesInfo['city'] = pharmacyData['city'].toString();
      pharmaciesInfo['latitude'] = pharmacyData['latitude'].toString();
      pharmaciesInfo['longitude'] = pharmacyData['longitude'].toString();
      pharmaciesInfo['phoneNumber'] = pharmacyData['phoneNumber'].toString();
      pharmaciesInfo['serviceTime'] = pharmacyData['serviceTime'].toString();
      pharmaciesInfo['serviceDate'] = pharmacyData['serviceDate'].toString();
      _pharList.add(pharmaciesInfo);
    }
    print(_pharList);
    return _pharList;
  }
  }