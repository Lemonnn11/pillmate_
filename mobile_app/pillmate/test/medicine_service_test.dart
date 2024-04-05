import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:pillmate/models/medicine.dart';
import 'package:pillmate/services/medicine_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'sqlite_service_test.mocks.dart';

void main(){
  late MockSqliteService sqliteService;
  setUpAll(() async {
    sqliteService = MockSqliteService();
  });

  group('test separate drugs list based on time', () {
    test('seperate drugs list into map of list based on time', () async {
      MedicineService medicineService = MedicineService(sqliteService: sqliteService);
      late Map<String, dynamic> data;
      DateTime dt = DateTime.now();
      String time = DateFormat("HH:mm").format(DateTime.now());
      String info = '{"timePeriodForMed":"...","date":"2024-02-19T01:44:23.470Z","pharID":"Fy751CumG69MLZfZLvqe","additionalAdvice":"ยานี้อาจระคายเคืองกระเพาะอาหาร ให้รับประทานหลังอาหารทันที","quantity":250,"amountOfMeds":10,"genericName":"Paracetamol","expiredDate":"2023-11-04T00:00:00.000Z","adverseDrugReaction":"หากมีอาการผื่นแพ้ เยื่อบุผิวลอก ให้หยุดใช้ยาและหากมีอาการหนักควรปรึกษาแพทย์ทันที","timeOfMed":"หลังอาหาร","typeOfMedicine":"Tablet","tradeName":"Bakamol Tab. 500 mg","dosagePerTake":2,"takeMedWhen":"เช้า กลางวัน เย็น","QRCodeID":"8c5ea443-83e4-4d92-88d9-5d0e06a06db8","timePerDay":3,"conditionOfUse":"ลดคลื่นไส้อาเจียน"}';
      data = json.decode(info);
      MedicineModel med1 = new MedicineModel(data['QRCodeID'], data['pharID'], data['dosagePerTake'], data['timePerDay'],data['timeOfMed'] , data['timePeriodForMed'],  data['takeMedWhen'], data['expiredDate'], data['date'], data['conditionOfUse'], data['additionalAdvice'], data['amountOfMeds'], data['quantity'].toDouble(), data['adverseDrugReaction'], data['typeOfMedicine'], data['genericName'], data['tradeName'], dt.day.toString() + " " + 'มีนาคม' + ' ' + (dt.year + 543).toString() + ' เวลา ' + time + ' น', 0, 1, '5 เช้า กลางวัน เย็น,6 เช้า กลางวัน เย็น,7 เช้า');
      List<MedicineModel> _drugsList = [med1];
      final res = await medicineService.addToSperateList(_drugsList);
      expect(res, {'morning': [med1], 'noon': [med1], 'evening': [med1], 'night': []});
    });
  });
  group('test separate drugs list based on category', () {
    test('seperate drugs list into map of list based on category', () async {
      MedicineService medicineService = MedicineService(sqliteService: sqliteService);
      late Map<String, dynamic> data;
      DateTime dt = DateTime.now();
      String time = DateFormat("HH:mm").format(DateTime.now());
      String info = '{"timePeriodForMed":"...","date":"2024-02-19T01:44:23.470Z","pharID":"Fy751CumG69MLZfZLvqe","additionalAdvice":"ยานี้อาจระคายเคืองกระเพาะอาหาร ให้รับประทานหลังอาหารทันที","quantity":250,"amountOfMeds":10,"genericName":"Paracetamol","expiredDate":"2023-11-04T00:00:00.000Z","adverseDrugReaction":"หากมีอาการผื่นแพ้ เยื่อบุผิวลอก ให้หยุดใช้ยาและหากมีอาการหนักควรปรึกษาแพทย์ทันที","timeOfMed":"หลังอาหาร","typeOfMedicine":"Tablet","tradeName":"Bakamol Tab. 500 mg","dosagePerTake":2,"takeMedWhen":"เช้า กลางวัน เย็น","QRCodeID":"8c5ea443-83e4-4d92-88d9-5d0e06a06db8","timePerDay":3,"conditionOfUse":"ลดคลื่นไส้อาเจียน"}';
      data = json.decode(info);
      MedicineModel med1 = new MedicineModel(data['QRCodeID'], data['pharID'], data['dosagePerTake'], data['timePerDay'],data['timeOfMed'] , data['timePeriodForMed'],  data['takeMedWhen'], data['expiredDate'], data['date'], data['conditionOfUse'], data['additionalAdvice'], data['amountOfMeds'], data['quantity'].toDouble(), data['adverseDrugReaction'], "Capsule", data['genericName'], data['tradeName'], dt.day.toString() + " " + 'มีนาคม' + ' ' + (dt.year + 543).toString() + ' เวลา ' + time + ' น', 0, 1, '5 เช้า กลางวัน เย็น,6 เช้า กลางวัน เย็น,7 เช้า');
      MedicineModel med2 = new MedicineModel(data['QRCodeID'], data['pharID'], data['dosagePerTake'], data['timePerDay'],data['timeOfMed'] , data['timePeriodForMed'],  data['takeMedWhen'], data['expiredDate'], data['date'], data['conditionOfUse'], data['additionalAdvice'], data['amountOfMeds'], data['quantity'].toDouble(), data['adverseDrugReaction'], "Tablet", data['genericName'], data['tradeName'], dt.day.toString() + " " + 'มีนาคม' + ' ' + (dt.year + 543).toString() + ' เวลา ' + time + ' น', 0, 1, '5 เช้า กลางวัน เย็น,6 เช้า กลางวัน เย็น,7 เช้า');
      MedicineModel med3 = new MedicineModel(data['QRCodeID'], data['pharID'], data['dosagePerTake'], data['timePerDay'],data['timeOfMed'] , data['timePeriodForMed'],  data['takeMedWhen'], data['expiredDate'], data['date'], data['conditionOfUse'], data['additionalAdvice'], data['amountOfMeds'], data['quantity'].toDouble(), data['adverseDrugReaction'], "Capsule", data['genericName'], data['tradeName'], dt.day.toString() + " " + 'มีนาคม' + ' ' + (dt.year + 543).toString() + ' เวลา ' + time + ' น', 0, 0, '5 เช้า กลางวัน เย็น,6 เช้า กลางวัน เย็น,7 เช้า');
      MedicineModel med4 = new MedicineModel(data['QRCodeID'], data['pharID'], data['dosagePerTake'], data['timePerDay'],data['timeOfMed'] , data['timePeriodForMed'],  data['takeMedWhen'], data['expiredDate'], data['date'], data['conditionOfUse'], data['additionalAdvice'], data['amountOfMeds'], data['quantity'].toDouble(), data['adverseDrugReaction'], "Tablet", data['genericName'], data['tradeName'], dt.day.toString() + " " + 'มีนาคม' + ' ' + (dt.year + 543).toString() + ' เวลา ' + time + ' น', 0, 0, '5 เช้า กลางวัน เย็น,6 เช้า กลางวัน เย็น,7 เช้า');
      when(sqliteService.getActiveMedicine()).thenAnswer((_) async => [med1, med2]);
      when(sqliteService.getInactiveMedicine()).thenAnswer((_) async => [med3, med4]);
      final res = await medicineService.getMedicines();
      expect(res, {'capsuleDrugsList': [med1], 'tabDrugsList': [med2], 'inactiveCapsuleDrugsList': [med3], 'inactiveTabDrugsList': [med4]});
    });
  });
}