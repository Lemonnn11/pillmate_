import 'package:flutter/cupertino.dart';
import 'package:pillmate/models/daily_med.dart';
import 'package:pillmate/models/medicine.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/personal_information.dart';class SqliteService {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'pillmate.db'),
      onCreate: (database, version) async {
        await database.execute(
            "CREATE TABLE IF NOT EXISTS PERSONAL_INFO(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, dob TEXT,blood_type TEXT,gender TEXT,weight REAL,height REAL,health_condition TEXT,drug_allergies TEXT,personal_medicine TEXT);",
        );
        await database.execute(
            "CREATE TABLE IF NOT EXISTS MEDICINE(qrcode_id TEXT PRIMARY KEY, phar_id TEXT, dosage_per_take INTEGER, time_per_day INTEGER, time_of_med TEXT, time_period_for_med TEXT, take_med_when TEXT, expired_date TEXT, dispensing_date TEXT, condition_of_use TEXT, additional_advice TEXT, amount INTEGER, quantity REAL, adverse_drug_reaction TEXT, type_of_medicine TEXT, generic_name TEXT,  trade_name TEXT, saved_date TEXT, amount_taken INTEGER, status INTEGER, medication_schedule TEXT);",
        );
        await database.execute(
          "CREATE TABLE IF NOT EXISTS DAILY_MED(id INTEGER PRIMARY KEY AUTOINCREMENT, day INTEGER, amount_taken INTEGER, daily_med INTEGER, morning_time_hour INTEGER, morning_time_minute INTEGER, noon_time_hour INTEGER, noon_time_minute INTEGER, evening_time_hour INTEGER, evening_time_minute INTEGER, night_time_hour INTEGER, night_time_minute INTEGER);",
        );
        // await database.execute(
        //   "CREATE TABLE [IF NOT EXISTS] PERSONAL_INFO(id INTEGER PRIMARY KEY AUTOINCREMENT, dob TEXT, blood_type TEXT, gender TEXT, weight REAL, height REAL, health_condition TEXT, drug_allergies TEXT, personal_medicine TEXT); CREATE TABLE [IF NOT EXISTS] MEDICINE(id INTEGER PRIMARY KEY AUTOINCREMENT, trade_name TEXT, generic_name TEXT, form TEXT, expired_date TEXT, amount INTEGER, amount_taken INTEGER, quantity REAL, dossage_per_take TEXT, time_of_med TEXT,take_med_when TEXT, time_period_for_med TEXT, condition_of_use TEXT, additional_advice TEXT, adverseDrugReaction TEXT, dispensing_date TEXT, saved_date TEXT, pharmacy TEXT);",
        // );
      },
      version: 1,
    );
  }

  Future<int> createPersonalInfoItem(PersonalInformationModel personalInformation) async {
    int res = 0;
    final Database db = await initializeDB();
    res = await db.insert('PERSONAL_INFO', personalInformation.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<int> createMedicineItem(MedicineModel medicine) async {
    int res = 0;
    final Database db = await initializeDB();
    res = await db.insert('MEDICINE', medicine.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<int> createDailyMedItem(DaileyMedModel daileyMedModel) async {
    int res = 0;
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('DAILY_MED');
    final List<DaileyMedModel> list = queryResult.map((e) => DaileyMedModel.fromMap(e)).toList();
    bool flag = false;
    DateTime dt = DateTime.now();
    for(int i = 0; i < list.length;i++){
      if(list[i].day == dt.day){
        flag = true;
      }
    }
   if(!flag){
     res = await db.insert('DAILY_MED', daileyMedModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
   }
    return res;
  }

  Future<void> deleteMedicineItem(String qrcodeID) async {
    final db = await initializeDB();
    try{
      await db.delete("MEDICINE", where: "qrcode_id = ?", whereArgs: [qrcodeID]);
    }catch(e){
      debugPrint("Error found: $e");
    }
  }

  Future<void> inactivateStatus(MedicineModel medicine)async {
    final Database db = await initializeDB();
    await db.update("MEDICINE", medicine.toMap(), where: 'qrcode_id = ?', whereArgs: [medicine.qrcodeID]);
  }

  Future<void> increaseAmountTaken(String qrcodeID, int amountTaken, String medicationSchedule) async {
    final Database db = await initializeDB();
    print(medicationSchedule);
    await db.rawUpdate(''' UPDATE MEDICINE SET amount_taken = ?, medication_schedule = ? WHERE qrcode_id = ? ''', [amountTaken + 1, medicationSchedule,qrcodeID]);
  }

  Future<void> alterMedicationSchedule(String qrcodeID, String medicationSchedule) async {
    final Database db = await initializeDB();
    print(medicationSchedule);
    await db.rawUpdate(''' UPDATE MEDICINE SET medication_schedule = ? WHERE qrcode_id = ? ''', [medicationSchedule,qrcodeID]);
  }

  Future<List<MedicineModel>> getMedicines() async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('MEDICINE');
    return queryResult.map((e) => MedicineModel.fromMap(e)).toList();
  }

  Future<List<MedicineModel>> getActiveMedicine() async{
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('MEDICINE',
    where: 'status = 1');
    return queryResult.map((e) => MedicineModel.fromMap(e)).toList();
  }

  Future<List<DaileyMedModel>> getDailyMedicines() async {
    final db = await initializeDB();
    DateTime dt = DateTime.now();

    final List<Map<String, Object?>> queryResult = await db.query('DAILY_MED',
        where: 'day = ?',
        whereArgs: [dt.day]);

    return queryResult.map((e) => DaileyMedModel.fromMap(e)).toList();
  }

  Future<void> alterDailyAmountTaken(int amountTaken) async {
    final Database db = await initializeDB();
    await db.rawUpdate(''' UPDATE DAILY_MED SET amount_taken = ? ''', [amountTaken+1]);
  }

  Future<void> alterDailyMed(int med) async {
    final Database db = await initializeDB();
    List<DaileyMedModel> list = await getDailyMedicines();
    if(list[0].dailyMed == 0){
      await db.rawUpdate(''' UPDATE DAILY_MED SET daily_med = ? ''', [med]);
    }
  }

  Future<void> increaseDailyMed(int med) async {
    final Database db = await initializeDB();
    List<DaileyMedModel> list = await getDailyMedicines();
    await db.rawUpdate(''' UPDATE DAILY_MED SET daily_med = ? ''', [list[0].dailyMed + med]);
  }

  Future<List<MedicineModel>> getInactiveMedicine() async{
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('MEDICINE',
        where: 'status = 0');
    return queryResult.map((e) => MedicineModel.fromMap(e)).toList();
  }

  Future<List<PersonalInformationModel>> getPersonalInfo() async {
    final db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('PERSONAL_INFO');
    return queryResult.map((e) => PersonalInformationModel.fromMap(e)).toList();
  }
}