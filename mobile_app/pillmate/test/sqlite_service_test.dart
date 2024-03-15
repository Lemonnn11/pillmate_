import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pillmate/models/app_config.dart';
import 'package:pillmate/models/daily_med.dart';
import 'package:pillmate/models/medicine.dart';
import 'package:pillmate/models/personal_information.dart';
import 'package:pillmate/services/sqlite_service.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'sqlite_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SqliteService>()])
void main(){
  late Database database;
  late MockSqliteService sqliteService;
  AppConfigModel appConfigModel = new AppConfigModel(1, 0, 0, 0);
  PersonalInformationModel personalInformationModel = new PersonalInformationModel(1, "Pannavich Thanormvongse", "11/04/02", "ชาย", 0, 0, "ฉันไม่มีโรคประจำตัว ", "ฉันไม่มียาที่แพ้", "", "");
  MedicineModel medicineModel = new MedicineModel("8c5ea443-83e4-4d92-88d9-5d0e06a06db8", "Fy751CumG69MLZfZLvqe", 2, 3, "หลังอาหาร", "...", "เช้า กลางวัน เย็น", "2023-11-04T00:00:00.000Z", "2024-02-19T01:44:23.470Z", "ลดคลื่นไส้อาเจียน", "ยานี้อาจระคายเคืองกระเพาะอาหาร ให้รับประทานหลังอาหารทันที", 10, 250.0, "หากมีอาการผื่นแพ้ เยื่อบุผิวลอก ให้หยุดใช้ยาและหากมีอาการหนักควรปรึกษาแพทย์ทันที", "Tablet", "Paracetamol", "Bakamol Tab. 500 mg", "12 มีนาคม 2567 เวลา 16:29 น", 0, 1, "12 เย็น,13 เช้า กลางวัน เย็น,14 เช้า กลางวัน เย็น,15 เช้า กลางวัน เย็น");
  DaileyMedModel dailyMedModel = new DaileyMedModel(1, 14, 0, 0, 9, 0, 12,0, 17, 0, 21, 0, 1);
  List<DaileyMedModel> dailyMedList = List.generate(1, (index) => dailyMedModel);
  List<MedicineModel> medicineList = List.generate(5, (index) => medicineModel);
  MedicineModel activeMedicineModel = new MedicineModel("8c5ea443-83e4-4d92-88d9-5d0e06a06db8", "Fy751CumG69MLZfZLvqe", 2, 3, "หลังอาหาร", "...", "เช้า กลางวัน เย็น", "2023-11-04T00:00:00.000Z", "2024-02-19T01:44:23.470Z", "ลดคลื่นไส้อาเจียน", "ยานี้อาจระคายเคืองกระเพาะอาหาร ให้รับประทานหลังอาหารทันที", 10, 250.0, "หากมีอาการผื่นแพ้ เยื่อบุผิวลอก ให้หยุดใช้ยาและหากมีอาการหนักควรปรึกษาแพทย์ทันที", "Tablet", "Paracetamol", "Bakamol Tab. 500 mg", "12 มีนาคม 2567 เวลา 16:29 น", 0, 1, "12 เย็น,13 เช้า กลางวัน เย็น,14 เช้า กลางวัน เย็น,15 เช้า กลางวัน เย็น");
  List<MedicineModel> activeMedicineList = List.generate(5, (index) => activeMedicineModel);
  MedicineModel inactiveMedicineModel = new MedicineModel("8c5ea443-83e4-4d92-88d9-5d0e06a06db8", "Fy751CumG69MLZfZLvqe", 2, 3, "หลังอาหาร", "...", "เช้า กลางวัน เย็น", "2023-11-04T00:00:00.000Z", "2024-02-19T01:44:23.470Z", "ลดคลื่นไส้อาเจียน", "ยานี้อาจระคายเคืองกระเพาะอาหาร ให้รับประทานหลังอาหารทันที", 10, 250.0, "หากมีอาการผื่นแพ้ เยื่อบุผิวลอก ให้หยุดใช้ยาและหากมีอาการหนักควรปรึกษาแพทย์ทันที", "Tablet", "Paracetamol", "Bakamol Tab. 500 mg", "12 มีนาคม 2567 เวลา 16:29 น", 0, 0, "12 เย็น,13 เช้า กลางวัน เย็น,14 เช้า กลางวัน เย็น,15 เช้า กลางวัน เย็น");
  List<MedicineModel> inactiveMedicineList = List.generate(5, (index) => inactiveMedicineModel);
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

  group("SqlService test", () {
    test("initial database", () async {
      when(sqliteService.initializeDB()).thenAnswer((_) async => database);
      expect(await sqliteService.initializeDB(), database);
    });

    test("create app config",() async {
      when(sqliteService.createAppConfigItem(appConfigModel)).thenAnswer((_) async => 1);
      expect(await sqliteService.createAppConfigItem(appConfigModel), 1);
    });

    test("create personal information",() async {
      when(sqliteService.createPersonalInfoItem(personalInformationModel)).thenAnswer((_) async => 1);
      expect(await sqliteService.createPersonalInfoItem(personalInformationModel), 1);
    });

    test("create medicine",() async {
      when(sqliteService.createMedicineItem(medicineModel)).thenAnswer((_) async => 1);
      expect(await sqliteService.createMedicineItem(medicineModel), 1);
    });

    test("create daily medicine",() async {
      when(sqliteService.createDailyMedItem(dailyMedModel)).thenAnswer((_) async => 1);
      expect(await sqliteService.createDailyMedItem(dailyMedModel), 1);
    });

    test("create duplicated daily medicine",() async {
      when(sqliteService.createDailyMedItem(dailyMedModel)).thenAnswer((_) async => 0);
      expect(await sqliteService.createDailyMedItem(dailyMedModel), 0);
    });

    test("delete medicine",() async {
      List<MedicineModel> medicineList1 = List.generate(1, (index) => medicineModel);
      when(sqliteService.getMedicineById("8c5ea443-83e4-4d92-88d9-5d0e06a06db8")).thenAnswer((_) async => medicineList1);
      expect(await sqliteService.getMedicineById("8c5ea443-83e4-4d92-88d9-5d0e06a06db8"), medicineList1);
      sqliteService.deleteMedicineItem("8c5ea443-83e4-4d92-88d9-5d0e06a06db8");
      when(sqliteService.getMedicineById("8c5ea443-83e4-4d92-88d9-5d0e06a06db8")).thenAnswer((_) async => []);
      expect(await sqliteService.getMedicineById("8c5ea443-83e4-4d92-88d9-5d0e06a06db8"), []);
    });

    test("get medicine by id",() async {
      List<MedicineModel> medicineList1 = List.generate(1, (index) => medicineModel);
      when(sqliteService.getMedicineById("8c5ea443-83e4-4d92-88d9-5d0e06a06db8")).thenAnswer((_) async => medicineList1);
      expect(await sqliteService.getMedicineById("8c5ea443-83e4-4d92-88d9-5d0e06a06db8"), medicineList1);
    });

    test("inactive status",() async {
      MedicineModel medicineModel2 = new MedicineModel("8c5ea443-83e4-4d92-88d9-5d0e06a06db8", "Fy751CumG69MLZfZLvqe", 2, 3, "หลังอาหาร", "...", "เช้า กลางวัน เย็น", "2023-11-04T00:00:00.000Z", "2024-02-19T01:44:23.470Z", "ลดคลื่นไส้อาเจียน", "ยานี้อาจระคายเคืองกระเพาะอาหาร ให้รับประทานหลังอาหารทันที", 10, 250.0, "หากมีอาการผื่นแพ้ เยื่อบุผิวลอก ให้หยุดใช้ยาและหากมีอาการหนักควรปรึกษาแพทย์ทันที", "Tablet", "Paracetamol", "Bakamol Tab. 500 mg", "12 มีนาคม 2567 เวลา 16:29 น", 0, 0, "12 เย็น,13 เช้า กลางวัน เย็น,14 เช้า กลางวัน เย็น,15 เช้า กลางวัน เย็น");
      List<MedicineModel> medicineList1 = List.generate(1, (index) => medicineModel);
      List<MedicineModel> medicineList2 = List.generate(1, (index) => medicineModel2);
      when(sqliteService.getMedicineById("8c5ea443-83e4-4d92-88d9-5d0e06a06db8")).thenAnswer((_) async => medicineList1);
      List<MedicineModel>? tmpList = await sqliteService.getMedicineById("8c5ea443-83e4-4d92-88d9-5d0e06a06db8");
      expect(tmpList?.first.status, 1);
      sqliteService.inactivateStatus(tmpList?.first);
      when(sqliteService.getMedicineById("8c5ea443-83e4-4d92-88d9-5d0e06a06db8")).thenAnswer((_) async => medicineList2);
      List<MedicineModel>? tmpList2 = await sqliteService.getMedicineById("8c5ea443-83e4-4d92-88d9-5d0e06a06db8");
      expect(tmpList2?.first.status, 0);
    });

    test("increase amount taken",() async {
      MedicineModel medicineModel2 = new MedicineModel("8c5ea443-83e4-4d92-88d9-5d0e06a06db8", "Fy751CumG69MLZfZLvqe", 2, 3, "หลังอาหาร", "...", "เช้า กลางวัน เย็น", "2023-11-04T00:00:00.000Z", "2024-02-19T01:44:23.470Z", "ลดคลื่นไส้อาเจียน", "ยานี้อาจระคายเคืองกระเพาะอาหาร ให้รับประทานหลังอาหารทันที", 10, 250.0, "หากมีอาการผื่นแพ้ เยื่อบุผิวลอก ให้หยุดใช้ยาและหากมีอาการหนักควรปรึกษาแพทย์ทันที", "Tablet", "Paracetamol", "Bakamol Tab. 500 mg", "12 มีนาคม 2567 เวลา 16:29 น", 1, 1, "12 เย็น,13 เช้า กลางวัน เย็น,14 เช้า กลางวัน เย็น,15 เช้า กลางวัน เย็น");
      List<MedicineModel> medicineList1 = List.generate(1, (index) => medicineModel);
      List<MedicineModel> medicineList2 = List.generate(1, (index) => medicineModel2);
      when(sqliteService.getMedicineById("8c5ea443-83e4-4d92-88d9-5d0e06a06db8")).thenAnswer((_) async => medicineList1);
      List<MedicineModel>? tmpList = await sqliteService.getMedicineById("8c5ea443-83e4-4d92-88d9-5d0e06a06db8");
      expect(tmpList?.first.amountTaken, 0);
      sqliteService.increaseAmountTaken("8c5ea443-83e4-4d92-88d9-5d0e06a06db8", 1, "12 เย็น,13 เช้า กลางวัน เย็น,14 เช้า กลางวัน เย็น,15 เช้า กลางวัน เย็น");
      when(sqliteService.getMedicineById("8c5ea443-83e4-4d92-88d9-5d0e06a06db8")).thenAnswer((_) async => medicineList2);
      List<MedicineModel>? tmpList2 = await sqliteService.getMedicineById("8c5ea443-83e4-4d92-88d9-5d0e06a06db8");
      expect(tmpList2?.first.amountTaken, 1);
    });

    test("alter medication schedule",() async {
      MedicineModel medicineModel2 = new MedicineModel("8c5ea443-83e4-4d92-88d9-5d0e06a06db8", "Fy751CumG69MLZfZLvqe", 2, 3, "หลังอาหาร", "...", "เช้า กลางวัน เย็น", "2023-11-04T00:00:00.000Z", "2024-02-19T01:44:23.470Z", "ลดคลื่นไส้อาเจียน", "ยานี้อาจระคายเคืองกระเพาะอาหาร ให้รับประทานหลังอาหารทันที", 10, 250.0, "หากมีอาการผื่นแพ้ เยื่อบุผิวลอก ให้หยุดใช้ยาและหากมีอาการหนักควรปรึกษาแพทย์ทันที", "Tablet", "Paracetamol", "Bakamol Tab. 500 mg", "12 มีนาคม 2567 เวลา 16:29 น", 0, 1, "13 เช้า กลางวัน เย็น,14 เช้า กลางวัน เย็น,15 เช้า กลางวัน เย็น,16 เช้า");
      List<MedicineModel> medicineList1 = List.generate(1, (index) => medicineModel);
      List<MedicineModel> medicineList2 = List.generate(1, (index) => medicineModel2);
      when(sqliteService.getMedicineById("8c5ea443-83e4-4d92-88d9-5d0e06a06db8")).thenAnswer((_) async => medicineList1);
      List<MedicineModel>? tmpList = await sqliteService.getMedicineById("8c5ea443-83e4-4d92-88d9-5d0e06a06db8");
      expect(tmpList?.first.medicationSchedule, "12 เย็น,13 เช้า กลางวัน เย็น,14 เช้า กลางวัน เย็น,15 เช้า กลางวัน เย็น");
      sqliteService.alterMedicationSchedule("8c5ea443-83e4-4d92-88d9-5d0e06a06db8", "13 เช้า กลางวัน เย็น,14 เช้า กลางวัน เย็น,15 เช้า กลางวัน เย็น,16 เช้า");
      when(sqliteService.getMedicineById("8c5ea443-83e4-4d92-88d9-5d0e06a06db8")).thenAnswer((_) async => medicineList2);
      List<MedicineModel>? tmpList2 = await sqliteService.getMedicineById("8c5ea443-83e4-4d92-88d9-5d0e06a06db8");
      expect(tmpList2?.first.medicationSchedule, "13 เช้า กลางวัน เย็น,14 เช้า กลางวัน เย็น,15 เช้า กลางวัน เย็น,16 เช้า");
    });

    test("get medicines",() async {
      when(sqliteService.getMedicines()).thenAnswer((_) async => medicineList);
      expect(await sqliteService.getMedicines(), medicineList);
    });

    test("get active medicines",() async {
      when(sqliteService.getActiveMedicine()).thenAnswer((_) async => activeMedicineList);
      expect(await sqliteService.getActiveMedicine(), activeMedicineList);
    });

    test("get inactive medicines",() async {
      when(sqliteService.getInactiveMedicine()).thenAnswer((_) async => inactiveMedicineList);
      expect(await sqliteService.getInactiveMedicine(), inactiveMedicineList);
    });

    test("get daily medicines",() async {
      when(sqliteService.getDailyMedicines()).thenAnswer((_) async => dailyMedList);
      expect(await sqliteService.getDailyMedicines(), dailyMedList);
    });

    test("test alter amount taken of daily medicine", () async {
      DaileyMedModel daileyMedModel2 = new DaileyMedModel(1, 14, 1, 0, 9, 0, 12,0, 17, 0, 21, 0, 1);
      List<DaileyMedModel> dailyMedList2 = List.generate(1, (index) => daileyMedModel2);
      when(sqliteService.getDailyMedicines()).thenAnswer((_) async => dailyMedList);
      List<DaileyMedModel>? tmpList = await sqliteService.getDailyMedicines();
      expect(tmpList?.first.amountTaken, 0);
      sqliteService.alterDailyMed(0);
      when(sqliteService.getDailyMedicines()).thenAnswer((_) async => dailyMedList2);
      List<DaileyMedModel>? tmpList2 = await sqliteService.getDailyMedicines();
      expect(tmpList2?.first.amountTaken, 1);
      });

    test("test alter dailyMed of daily medicine", () async {
      DaileyMedModel daileyMedModel2 = new DaileyMedModel(1, 14, 0, 6, 9, 0, 12,0, 17, 0, 21, 0, 1);
      List<DaileyMedModel> dailyMedList2 = List.generate(1, (index) => daileyMedModel2);
      when(sqliteService.getDailyMedicines()).thenAnswer((_) async => dailyMedList);
      List<DaileyMedModel>? tmpList = await sqliteService.getDailyMedicines();
      expect(tmpList?.first.dailyMed, 0);
      sqliteService.alterDailyMed(1);
      when(sqliteService.getDailyMedicines()).thenAnswer((_) async => dailyMedList2);
      List<DaileyMedModel>? tmpList2 = await sqliteService.getDailyMedicines();
      expect(tmpList2?.first.dailyMed, 6);
    });

    test("test increase dailyMed of daily medicine", () async {
      DaileyMedModel daileyMedModel2 = new DaileyMedModel(1, 14, 0, 3, 9, 0, 12,0, 17, 0, 21, 0, 1);
      List<DaileyMedModel> dailyMedList2 = List.generate(1, (index) => daileyMedModel2);
      when(sqliteService.getDailyMedicines()).thenAnswer((_) async => dailyMedList);
      List<DaileyMedModel>? tmpList = await sqliteService.getDailyMedicines();
      expect(tmpList?.first.dailyMed, 0);
      sqliteService.increaseDailyMed(3);
      when(sqliteService.getDailyMedicines()).thenAnswer((_) async => dailyMedList2);
      List<DaileyMedModel>? tmpList2 = await sqliteService.getDailyMedicines();
      expect(tmpList2?.first.dailyMed, 3);
    });

    test("test decrease dailyMed of daily medicine", () async {
      DaileyMedModel daileyMedModel1 = new DaileyMedModel(1, 14, 0, 3, 9, 0, 12,0, 17, 0, 21, 0, 1);
      DaileyMedModel daileyMedModel2 = new DaileyMedModel(1, 14, 0, 0, 9, 0, 12,0, 17, 0, 21, 0, 1);
      List<DaileyMedModel> dailyMedList1 = List.generate(1, (index) => daileyMedModel1);
      List<DaileyMedModel> dailyMedList2 = List.generate(1, (index) => daileyMedModel2);
      when(sqliteService.getDailyMedicines()).thenAnswer((_) async => dailyMedList1);
      List<DaileyMedModel>? tmpList = await sqliteService.getDailyMedicines();
      expect(tmpList?.first.dailyMed, 3);
      sqliteService.alterDailyMed(1);
      when(sqliteService.getDailyMedicines()).thenAnswer((_) async => dailyMedList2);
      List<DaileyMedModel>? tmpList2 = await sqliteService.getDailyMedicines();
      expect(tmpList2?.first.dailyMed, 0);
    });

    test("test update notification time", () async {
      DaileyMedModel daileyMedModel1 = new DaileyMedModel(1, 14, 0, 0, 9, 0, 12,0, 17, 0, 21, 0, 1);
      DaileyMedModel daileyMedModel2 = new DaileyMedModel(1, 14, 0, 0, 10, 30, 13, 30, 18, 30, 22, 30, 1);
      List<DaileyMedModel> dailyMedList1 = List.generate(1, (index) => daileyMedModel1);
      List<DaileyMedModel> dailyMedList2 = List.generate(1, (index) => daileyMedModel2);
      when(sqliteService.getDailyMedicines()).thenAnswer((_) async => dailyMedList1);
      List<DaileyMedModel>? tmpList = await sqliteService.getDailyMedicines();
      expect(tmpList?.first.morningTimeHour, 9);
      expect(tmpList?.first.morningTimeMinute, 0);
      expect(tmpList?.first.noonTimeHour, 12);
      expect(tmpList?.first.noonTimeMinute, 0);
      expect(tmpList?.first.eveningTimeHour, 17);
      expect(tmpList?.first.eveningTimeMinute, 0);
      expect(tmpList?.first.nightTimeHour, 21);
      expect(tmpList?.first.nightTimeMinute, 0);
      sqliteService.updateNotificationTime(10, 30, 13, 30, 18, 30, 22, 30);
      when(sqliteService.getDailyMedicines()).thenAnswer((_) async => dailyMedList2);
      List<DaileyMedModel>? tmpList2 = await sqliteService.getDailyMedicines();
      expect(tmpList2?.first.morningTimeHour, 10);
      expect(tmpList2?.first.morningTimeMinute, 30);
      expect(tmpList2?.first.noonTimeHour, 13);
      expect(tmpList2?.first.noonTimeMinute, 30);
      expect(tmpList2?.first.eveningTimeHour, 18);
      expect(tmpList2?.first.eveningTimeMinute, 30);
      expect(tmpList2?.first.nightTimeHour, 22);
      expect(tmpList2?.first.nightTimeMinute, 30);
    });

    test("turn off notification", () async{
      DaileyMedModel daileyMedModel2 = new DaileyMedModel(1, 14, 0, 0, 9, 0, 12,0, 17, 0, 21, 0, 0);
      List<DaileyMedModel> dailyMedList2 = List.generate(1, (index) => daileyMedModel2);
      when(sqliteService.getDailyMedicines()).thenAnswer((_) async => dailyMedList);
      List<DaileyMedModel>? tmpList = await sqliteService.getDailyMedicines();
      expect(tmpList?.first.isNotified, 1);
      sqliteService.alterDailyMed(1);
      when(sqliteService.getDailyMedicines()).thenAnswer((_) async => dailyMedList2);
      List<DaileyMedModel>? tmpList2 = await sqliteService.getDailyMedicines();
      expect(tmpList2?.first.isNotified, 0);
    });

    test("turn on notification", () async{
      DaileyMedModel daileyMedModel1 = new DaileyMedModel(1, 14, 0, 0, 9, 0, 12,0, 17, 0, 21, 0, 0);
      DaileyMedModel daileyMedModel2 = new DaileyMedModel(1, 14, 0, 0, 9, 0, 12,0, 17, 0, 21, 0, 1);
      List<DaileyMedModel> dailyMedList1 = List.generate(1, (index) => daileyMedModel1);
      List<DaileyMedModel> dailyMedList2 = List.generate(1, (index) => daileyMedModel2);
      when(sqliteService.getDailyMedicines()).thenAnswer((_) async => dailyMedList1);
      List<DaileyMedModel>? tmpList = await sqliteService.getDailyMedicines();
      expect(tmpList?.first.isNotified, 0);
      sqliteService.alterDailyMed(1);
      when(sqliteService.getDailyMedicines()).thenAnswer((_) async => dailyMedList2);
      List<DaileyMedModel>? tmpList2 = await sqliteService.getDailyMedicines();
      expect(tmpList2?.first.isNotified, 1);
    });

    test("turn off edit font size", () async{
      AppConfigModel appConfigModel1 = new AppConfigModel(1, 0, 1, 0);
      AppConfigModel appConfigModel2 = new AppConfigModel(1, 0, 0, 0);
      when(sqliteService.getEditFontSizeStatus()).thenAnswer((_) async => appConfigModel1.editFontSize == 1 ? true:false);
      expect(await sqliteService.getEditFontSizeStatus(), true);
      sqliteService.turnOffChangeFontSize();
      when(sqliteService.getEditFontSizeStatus()).thenAnswer((_) async => appConfigModel2.editFontSize == 1 ? true:false);
      expect(await sqliteService.getEditFontSizeStatus(), false);
    });

    test("turn on edit font size", () async{
      AppConfigModel appConfigModel1 = new AppConfigModel(1, 0, 0, 0);
      AppConfigModel appConfigModel2 = new AppConfigModel(1, 0, 1, 0);
      when(sqliteService.getEditFontSizeStatus()).thenAnswer((_) async => appConfigModel1.editFontSize == 1 ? true:false);
      expect(await sqliteService.getEditFontSizeStatus(), false);
      sqliteService.turnOnChangeFontSize();
      when(sqliteService.getEditFontSizeStatus()).thenAnswer((_) async => appConfigModel2.editFontSize == 1 ? true:false);
      expect(await sqliteService.getEditFontSizeStatus(), true);
    });

    test("turn off dark mode", () async{
      AppConfigModel appConfigModel1 = new AppConfigModel(1, 1, 0, 0);
      AppConfigModel appConfigModel2 = new AppConfigModel(1, 0, 0, 0);
      when(sqliteService.getDarkModeStatus()).thenAnswer((_) async => appConfigModel1.darkMode == 1 ? true:false);
      expect(await sqliteService.getDarkModeStatus(), true);
      sqliteService.turnOffDarkMode();
      when(sqliteService.getDarkModeStatus()).thenAnswer((_) async => appConfigModel2.darkMode == 1 ? true:false);
      expect(await sqliteService.getDarkModeStatus(), false);
    });

    test("turn on dark mode", () async{
      AppConfigModel appConfigModel1 = new AppConfigModel(1, 0, 0, 0);
      AppConfigModel appConfigModel2 = new AppConfigModel(1, 1, 0, 0);
      when(sqliteService.getDarkModeStatus()).thenAnswer((_) async => appConfigModel1.darkMode == 1 ? true:false);
      expect(await sqliteService.getDarkModeStatus(), false);
      sqliteService.turnOnDarkMode();
      when(sqliteService.getDarkModeStatus()).thenAnswer((_) async => appConfigModel2.darkMode == 1 ? true:false);
      expect(await sqliteService.getDarkModeStatus(), true);
    });

    test("alter amount of font size changes", () async{
      AppConfigModel appConfigModel1 = new AppConfigModel(1, 0, 1, 0);
      AppConfigModel appConfigModel2 = new AppConfigModel(1, 0, 1, 1);
      when(sqliteService.getFontSizeChange()).thenAnswer((_) async => appConfigModel1.fontSizeChange);
      expect(await sqliteService.getFontSizeChange(),  appConfigModel1.fontSizeChange);
      sqliteService.alterFontSize(1);
      when(sqliteService.getFontSizeChange()).thenAnswer((_) async => appConfigModel2.fontSizeChange);
      expect(await sqliteService.getFontSizeChange(), appConfigModel2.fontSizeChange);
    });

    test("get edit font size status", () async {
      when(sqliteService.getEditFontSizeStatus()).thenAnswer((_) async => appConfigModel.editFontSize == 1 ? true: false);
      expect(await sqliteService.getEditFontSizeStatus(), false);
    });

    test("get amount of font size changes", () async {
      when(sqliteService.getFontSizeChange()).thenAnswer((_) async => appConfigModel.fontSizeChange);
      expect(await sqliteService.getFontSizeChange(), 0);
    });

    test("get dark mode status", () async {
      when(sqliteService.getDarkModeStatus()).thenAnswer((_) async => appConfigModel.darkMode == 1 ? true: false);
      expect(await sqliteService.getDarkModeStatus(), false);
    });

    test("get personal information", () async {
      List<PersonalInformationModel> personalInfoList = List.generate(1, (index) => personalInformationModel);
      when(sqliteService.getPersonalInfo()).thenAnswer((_) async => personalInfoList);
      expect(await sqliteService.getPersonalInfo(), personalInfoList);
    });
  });
}