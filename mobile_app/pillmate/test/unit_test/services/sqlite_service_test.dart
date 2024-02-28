
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pillmate/models/app_config.dart';
import 'package:pillmate/services/sqlite_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockSqliteService extends Mock implements SqliteService{}


void main(){
  late Database database;
  late MockSqliteService sqliteService;
  AppConfigModel appConfigModel = AppConfigModel(1, 0, 1, 2);
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
    // when(sqliteService.createAppConfigItem(appConfigModel)).thenAnswer((_) async => 1);
  });

  group('Database Test', () {
    test('sqflite version', () async {
      expect(await database.getVersion(), 0);
    });

    test('create app config item', () async {
      int res = await database.insert('APP_CONFIG', appConfigModel.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
      var i = await database.query('APP_CONFIG');
      expect(i.length, 1);
    });
  });

  // group('Service Test', () {
  //   test("create app config", () async {
  //     expect(await sqliteService.createAppConfigItem(appConfigModel), 1);
  //   });
  // });
}
