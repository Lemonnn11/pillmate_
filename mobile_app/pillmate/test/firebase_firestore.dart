import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pillmate/services/firestore.dart';

void main(){
  late FakeFirebaseFirestore firestore;
  late FirestoreService firestoreService;
  setUpAll(() async {
    firestore = FakeFirebaseFirestore();
    await firestore.collection('pharmacies').add({
      'address': '447 Thanon Si Ayutthaya, Thung Phaya Thai, Ratchathewi, Bangkok 10400',
      'city': 'กรุงเทพมหานคร',
      'email': 'lemonn123@gmail.com',
      'latitude': '13.77765254802144',
      'longitude': '100.52532826905029',
      'pharID': 'Fy751CumG69MLZfZLvqe',
      'phoneNumber': '0968123561',
      'province': 'ราชเทวี',
      'serviceDate': 'Mon - Sat',
      'serviceTime': '8:00 - 17:00',
      'storeName': 'ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน',
    });
    await firestore.collection('pharmacies').add({
      'address': '999 มหาวิทยาลัยมหิดล Phutthamonthon Sai 4 Rd, Tambon Salaya,, ศาลายา, พุทธมณฑล, นครปฐม 73170',
      'city': 'นครปฐม',
      'email': 'monrcr9@hotmail.com',
      'latitude': '13.77765254802144',
      'longitude': '100.52532826905029',
      'pharID': 'EB0p4lBLsZJ4jH9F16YI',
      'phoneNumber': '0968123561',
      'province': 'พุทธมณฑล',
      'serviceDate': 'Mon - Sat',
      'serviceTime': '8:00 - 17:00',
      'storeName': 'ขายยาเภสัชมหิดล',
    });
    firestoreService = FirestoreService(firestore: firestore);
  });

  group('Test get pharmacy name from Firebase firestore', () {
    test('get pharmacy name by given ID', () async {
      final res = await firestoreService.getPharmacyName('Fy751CumG69MLZfZLvqe');
      expect(res, 'ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน');
    });
  });

  group('Test get all pharmacies from Firebase firestore', () {
    test('get all pharmacies', () async {
      final List<Map<String, dynamic>> pharmacies = [
        {
          'pharID': 'Fy751CumG69MLZfZLvqe',
          'storeName': 'ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน',
          'address': '447 Thanon Si Ayutthaya, Thung Phaya Thai, Ratchathewi, Bangkok 10400',
          'province': 'ราชเทวี',
          'city': 'กรุงเทพมหานคร',
          'latitude': '13.77765254802144',
          'longitude': '100.52532826905029',
          'phoneNumber': '0968123561',
          'serviceTime': '8:00 - 17:00',
          'serviceDate': 'Mon - Sat'
        },
        {
          'pharID': 'EB0p4lBLsZJ4jH9F16YI',
          'storeName': 'ขายยาเภสัชมหิดล',
          'address': '999 มหาวิทยาลัยมหิดล Phutthamonthon Sai 4 Rd, Tambon Salaya,, ศาลายา, พุทธมณฑล, นครปฐม 73170',
          'province': 'พุทธมณฑล',
          'city': 'นครปฐม',
          'latitude': '13.77765254802144',
          'longitude': '100.52532826905029',
          'phoneNumber': '0968123561',
          'serviceTime': '8:00 - 17:00',
          'serviceDate': 'Mon - Sat'
        }
      ];
      final res = await firestoreService.getPharmaciesInfo();
      expect(res, pharmacies);
    });
  });

  group('Test search specific pharmacy from Firebase firestore', () {
    test('search specific pharmacy by given query province', () async {
      final List<Map<String, dynamic>> pharmacies = [
        {
          'pharID': 'Fy751CumG69MLZfZLvqe',
          'storeName': 'ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน',
          'address': '447 Thanon Si Ayutthaya, Thung Phaya Thai, Ratchathewi, Bangkok 10400',
          'province': 'ราชเทวี',
          'city': 'กรุงเทพมหานคร',
          'latitude': '13.77765254802144',
          'longitude': '100.52532826905029',
          'phoneNumber': '0968123561',
          'serviceTime': '8:00 - 17:00',
          'serviceDate': 'Mon - Sat'
        }
      ];
      final res = await firestoreService.searchPharmacy('ราชเทวี');
      expect(res, pharmacies);
    });

    test('search specific pharmacy by given query city', () async {
      final List<Map<String, dynamic>> pharmacies = [
        {
          'pharID': 'Fy751CumG69MLZfZLvqe',
          'storeName': 'ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน',
          'address': '447 Thanon Si Ayutthaya, Thung Phaya Thai, Ratchathewi, Bangkok 10400',
          'province': 'ราชเทวี',
          'city': 'กรุงเทพมหานคร',
          'latitude': '13.77765254802144',
          'longitude': '100.52532826905029',
          'phoneNumber': '0968123561',
          'serviceTime': '8:00 - 17:00',
          'serviceDate': 'Mon - Sat'
        }
      ];
      final res = await firestoreService.searchPharmacy('กรุงเทพมหานคร');
      expect(res, pharmacies);
    });

    test('get all pharmacies', () async {
      final List<Map<String, dynamic>> pharmacies = [
        {
          'pharID': 'Fy751CumG69MLZfZLvqe',
          'storeName': 'ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน',
          'address': '447 Thanon Si Ayutthaya, Thung Phaya Thai, Ratchathewi, Bangkok 10400',
          'province': 'ราชเทวี',
          'city': 'กรุงเทพมหานคร',
          'latitude': '13.77765254802144',
          'longitude': '100.52532826905029',
          'phoneNumber': '0968123561',
          'serviceTime': '8:00 - 17:00',
          'serviceDate': 'Mon - Sat'
        }
      ];
      final res = await firestoreService.searchPharmacy('ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน');
      expect(res, pharmacies);
    });
  });
}