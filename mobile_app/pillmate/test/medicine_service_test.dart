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
  late Database database;
  late MockSqliteService sqliteService;

  setUpAll(() async {
    sqfliteFfiInit();
    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await database.execute(
      "CREATE TABLE IF NOT EXISTS PERSONAL_INFO(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, dob TEXT,blood_type TEXT,gender TEXT,weight REAL,height REAL,health_condition TEXT,drug_allergies TEXT,personal_medicine TEXT);",
    );
    await database.execute(
      "CREATE TABLE IF NOT EXISTS MEDICINE(qrcode_id TEXT PRIMARY KEY, phar_id TEXT, dosage_per_take INTEGER, time_per_day INTEGER, time_of_med TEXT, time_period_for_med TEXT, take_med_when TEXT, expired_date TEXT, dispensing_date TEXT, condition_of_use TEXT, additional_advice TEXT, amount INTEGER, quantity REAL, adverse_drug_reaction TEXT, type_of_medicine TEXT, generic_name TEXT,  trade_name TEXT, saved_date TEXT, amount_taken INTEGER, status INTEGER, medication_schedule TEXT);",
    );
    await database.execute(
      "CREATE TABLE IF NOT EXISTS DAILY_MED(id INTEGER PRIMARY KEY AUTOINCREMENT, day INTEGER, amount_taken INTEGER, daily_med INTEGER, morning_time_hour INTEGER, morning_time_minute INTEGER, noon_time_hour INTEGER, noon_time_minute INTEGER, evening_time_hour INTEGER, evening_time_minute INTEGER, night_time_hour INTEGER, night_time_minute INTEGER, is_notified INTEGER);",
    );
    await database.execute(
      "CREATE TABLE IF NOT EXISTS APP_CONFIG(id INTEGER PRIMARY KEY AUTOINCREMENT, dark_mode INTEGER, edit_font_size INTEGER, font_size_change INTEGER);",
    );
    sqliteService = MockSqliteService();
    sqliteService.db = database;
  });

  group('test separate drugs list based on time', () {
    test('seperate drugs list into map of list based on time', () {
      when(sqliteService.initializeDB()).thenAnswer((_) async => database);
      MedicineService medicineService = MedicineService();
      late Map<String, dynamic> data;
      DateTime dt = DateTime.now();
      String time = DateFormat("HH:mm").format(DateTime.now());
      String info = '{"timePeriodForMed":"...","date":"2024-02-19T01:44:23.470Z","pharID":"Fy751CumG69MLZfZLvqe","additionalAdvice":"ยานี้อาจระคายเคืองกระเพาะอาหาร ให้รับประทานหลังอาหารทันที","quantity":250,"amountOfMeds":10,"genericName":"Paracetamol","expiredDate":"2023-11-04T00:00:00.000Z","adverseDrugReaction":"หากมีอาการผื่นแพ้ เยื่อบุผิวลอก ให้หยุดใช้ยาและหากมีอาการหนักควรปรึกษาแพทย์ทันที","timeOfMed":"หลังอาหาร","typeOfMedicine":"Tablet","tradeName":"Bakamol Tab. 500 mg","dosagePerTake":2,"takeMedWhen":"เช้า กลางวัน เย็น","QRCodeID":"8c5ea443-83e4-4d92-88d9-5d0e06a06db8","timePerDay":3,"conditionOfUse":"ลดคลื่นไส้อาเจียน"}';
      data = json.decode(info);
      MedicineModel med1 = new MedicineModel(data['QRCodeID'], data['pharID'], data['dosagePerTake'], data['timePerDay'],data['timeOfMed'] , data['timePeriodForMed'],  data['takeMedWhen'], data['expiredDate'], data['date'], data['conditionOfUse'], data['additionalAdvice'], data['amountOfMeds'], data['quantity'].toDouble(), data['adverseDrugReaction'], data['typeOfMedicine'], data['genericName'], data['tradeName'], dt.day.toString() + " " + 'มีนาคม' + ' ' + (dt.year + 543).toString() + ' เวลา ' + time + ' น', 0, 1, '13 เช้า กลางวัน เย็น,14 เช้า กลางวัน เย็น,15 เช้า');
      List<MedicineModel> _drugsList = [med1];
      final res = medicineService.addToSperateList(_drugsList);
      print(res);
    });
  });
}