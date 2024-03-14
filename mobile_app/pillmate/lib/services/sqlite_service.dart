import 'package:flutter/cupertino.dart';
import 'package:pillmate/models/app_config.dart';
import 'package:pillmate/models/daily_med.dart';
import 'package:pillmate/models/medicine.dart';
import 'package:pillmate/models/on_boarding.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/personal_information.dart';
import 'local_notification_service.dart';
class SqliteService {
  late Database db;
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    db = await openDatabase(
      join(path, 'pillmate.db'),
      onCreate: (database, version) async {
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
        // await database.execute(
        //   "CREATE TABLE [IF NOT EXISTS] PERSONAL_INFO(id INTEGER PRIMARY KEY AUTOINCREMENT, dob TEXT, blood_type TEXT, gender TEXT, weight REAL, height REAL, health_condition TEXT, drug_allergies TEXT, personal_medicine TEXT); CREATE TABLE [IF NOT EXISTS] MEDICINE(id INTEGER PRIMARY KEY AUTOINCREMENT, trade_name TEXT, generic_name TEXT, form TEXT, expired_date TEXT, amount INTEGER, amount_taken INTEGER, quantity REAL, dossage_per_take TEXT, time_of_med TEXT,take_med_when TEXT, time_period_for_med TEXT, condition_of_use TEXT, additional_advice TEXT, adverseDrugReaction TEXT, dispensing_date TEXT, saved_date TEXT, pharmacy TEXT);",
        // );
      },
      version: 1,
    );
    return db;
  }

  Future<int> createPersonalInfoItem(PersonalInformationModel personalInformation) async {
    int res = 0;
    db = await initializeDB();
    res = await db.insert('PERSONAL_INFO', personalInformation.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<int> createAppConfigItem(AppConfigModel appConfigModel) async {
    int res = 0;
    db = await initializeDB();
    res = await db.insert('APP_CONFIG', appConfigModel.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
    return res;
  }

  Future<int> createMedicineItem(MedicineModel medicine) async {
    int res = 0;
    db = await initializeDB();
    res = await db.insert('MEDICINE', medicine.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<int> createDailyMedItem(DaileyMedModel daileyMedModel) async {
    int res = 0;
    db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('DAILY_MED');
    final List<DaileyMedModel> list = queryResult.map((e) => DaileyMedModel.fromMap(e)).toList();
    bool flag = false;
    DateTime dt = DateTime.now();
    late DaileyMedModel dailyMedModel1 ;
    if(list.length != 0){
      dailyMedModel1 = new DaileyMedModel(1, daileyMedModel.day, daileyMedModel.amountTaken, daileyMedModel.dailyMed, daileyMedModel.morningTimeHour, daileyMedModel.morningTimeHour, daileyMedModel.noonTimeHour , daileyMedModel.noonTimeMinute, daileyMedModel.eveningTimeHour, daileyMedModel.eveningTimeMinute, daileyMedModel.nightTimeHour, daileyMedModel.nightTimeMinute, list[0].isNotified);
    }else{
      dailyMedModel1 = new DaileyMedModel(1, daileyMedModel.day, daileyMedModel.amountTaken, daileyMedModel.dailyMed, daileyMedModel.morningTimeHour, daileyMedModel.morningTimeHour, daileyMedModel.noonTimeHour , daileyMedModel.noonTimeMinute, daileyMedModel.eveningTimeHour, daileyMedModel.eveningTimeMinute, daileyMedModel.nightTimeHour, daileyMedModel.nightTimeMinute, 1);
    }
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
    db = await initializeDB();
    try{
      await db.delete("MEDICINE", where: "qrcode_id = ?", whereArgs: [qrcodeID]);
    }catch(e){
      debugPrint("Error found: $e");
    }
  }

  Future<List<MedicineModel>?> getMedicineById(String qrcodeID) async {
    db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query("MEDICINE", where: "qrcode_id = ?", whereArgs: [qrcodeID]);
    List<MedicineModel> list = queryResult.map((e) => MedicineModel.fromMap(e)).toList();
    return list;
  }

  Future<void> inactivateStatus(MedicineModel medicine)async {
    db = await initializeDB();
    await db.update("MEDICINE", medicine.toMap(), where: 'qrcode_id = ?', whereArgs: [medicine.qrcodeID]);
  }

  Future<void> increaseAmountTaken(String qrcodeID, int amountTaken, String medicationSchedule) async {
    db = await initializeDB();
    print(medicationSchedule);
    await db.rawUpdate(''' UPDATE MEDICINE SET amount_taken = ?, medication_schedule = ? WHERE qrcode_id = ? ''', [amountTaken + 1, medicationSchedule,qrcodeID]);
  }

  Future<void> alterMedicationSchedule(String qrcodeID, String medicationSchedule) async {
    db = await initializeDB();
    print(medicationSchedule);
    await db.rawUpdate(''' UPDATE MEDICINE SET medication_schedule = ? WHERE qrcode_id = ? ''', [medicationSchedule,qrcodeID]);
  }

  Future<List<MedicineModel>> getMedicines() async {
    db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('MEDICINE');
    return queryResult.map((e) => MedicineModel.fromMap(e)).toList();
  }

  Future<List<MedicineModel>> getActiveMedicine() async{
    db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('MEDICINE',
    where: 'status = 1');
    return queryResult.map((e) => MedicineModel.fromMap(e)).toList();
  }

  Future<List<DaileyMedModel>> getDailyMedicines() async {
    db = await initializeDB();
    DateTime dt = DateTime.now();

    final List<Map<String, Object?>> queryResult = await db.query('DAILY_MED',
        where: 'day = ?',
        whereArgs: [dt.day]);

    return queryResult.map((e) => DaileyMedModel.fromMap(e)).toList();
  }

  Future<void> alterDailyAmountTaken(int amountTaken) async {
    db = await initializeDB();
    await db.rawUpdate(''' UPDATE DAILY_MED SET amount_taken = ? ''', [amountTaken+1]);
  }

  Future<void> alterDailyMed(int med) async {
    db = await initializeDB();
    List<DaileyMedModel> list = await getDailyMedicines();
    if(list[0].dailyMed == 0){
      await db.rawUpdate(''' UPDATE DAILY_MED SET daily_med = ? ''', [med]);
    }
  }


  Future<void> increaseDailyMed(int med) async {
    db = await initializeDB();
    List<DaileyMedModel> list = await getDailyMedicines();
    await db.rawUpdate(''' UPDATE DAILY_MED SET daily_med = ? ''', [list[0].dailyMed + med]);
  }

  Future<void> decreaseDailyMed(int med) async {
    db = await initializeDB();
    List<DaileyMedModel> list = await getDailyMedicines();
    await db.rawUpdate(''' UPDATE DAILY_MED SET daily_med = ? ''', [list[0].dailyMed - med]);
  }

  Future<void> updateNotificationTime(int morningHour, int morningMinute, int noonHour, int noonMinute, int eveningHour, int eveningMinute, int nightHour, int nightMinute)async {
    db = await initializeDB();
    List<DaileyMedModel> list = await getDailyMedicines();
    await db.rawUpdate(''' UPDATE DAILY_MED SET morning_time_hour = ?, morning_time_minute = ? , noon_time_hour = ?, noon_time_minute = ?, evening_time_hour = ?, evening_time_minute = ?, night_time_hour = ?, night_time_minute = ? ''', [morningHour, morningMinute, noonHour, noonMinute, eveningHour, eveningMinute, nightHour, nightMinute]);
  }

  Future<void> turnOffNotification() async {
    db = await initializeDB();
    List<DaileyMedModel> list = await getDailyMedicines();
    await LocalNotificationService.cancelAllNotifications();
    await db.rawUpdate(''' UPDATE DAILY_MED SET is_notified = ? ''', [0]);
  }

  Future<void> turnOnNotification() async {
    db = await initializeDB();
    List<DaileyMedModel> list = await getDailyMedicines();
    await db.rawUpdate(''' UPDATE DAILY_MED SET is_notified = ? ''', [1]);
  }

  Future<void> turnOffChangeFontSize() async {
    db = await initializeDB();
    await db.rawUpdate(''' UPDATE APP_CONFIG SET edit_font_size = ? ''', [0]);
  }

  Future<void> turnOnChangeFontSize() async {
    db = await initializeDB();
    await db.rawUpdate(''' UPDATE APP_CONFIG SET edit_font_size = ? ''', [1]);
  }

  Future<void> turnOffDarkMode() async {
    db = await initializeDB();
    await db.rawUpdate(''' UPDATE APP_CONFIG SET dark_mode = ? ''', [0]);
  }

  Future<void> turnOnDarkMode() async {
    db = await initializeDB();
    List<DaileyMedModel> list = await getDailyMedicines();
    await db.rawUpdate(''' UPDATE APP_CONFIG SET dark_mode = ? ''', [1]);
  }

  Future<void> alterFontSize(int change) async {
    db = await initializeDB();
    await db.rawUpdate(''' UPDATE APP_CONFIG SET font_size_change = ? ''', [change]);
  }

  Future<List<MedicineModel>> getInactiveMedicine() async{
    db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('MEDICINE',
        where: 'status = 0');
    return queryResult.map((e) => MedicineModel.fromMap(e)).toList();
  }


  Future<bool> getEditFontSizeStatus() async {
    db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('APP_CONFIG',
        where: 'id = 1');
    List<AppConfigModel> list = queryResult.map((e) => AppConfigModel.fromMap(e)).toList();
    return list[0].editFontSize == 0 ? false: true;
   }

  Future<int> getFontSizeChange() async {
    db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('APP_CONFIG',
        where: 'id = 1');
    List<AppConfigModel> list = queryResult.map((e) => AppConfigModel.fromMap(e)).toList();
    return list[0].fontSizeChange;
  }

  Future<bool> getDarkModeStatus() async {
    db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('APP_CONFIG',
        where: 'id = 1');
    List<AppConfigModel> list = queryResult.map((e) => AppConfigModel.fromMap(e)).toList();
    return list[0].darkMode == 0 ? false: true;
  }

  Future<List<PersonalInformationModel>> getPersonalInfo() async {
    db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('PERSONAL_INFO');
    return queryResult.map((e) => PersonalInformationModel.fromMap(e)).toList();
  }
}