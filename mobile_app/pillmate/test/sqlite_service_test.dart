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
  DaileyMedModel daileyMedModel = new DaileyMedModel(1, 14, 0, 0, 9, 0, 12,0, 17, 0, 21, 0, 1);
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
      when(sqliteService.createDailyMedItem(daileyMedModel)).thenAnswer((_) async => 1);
      expect(await sqliteService.createDailyMedItem(daileyMedModel), 1);
    });

    test("create duplicated daily medicine",() async {
      when(sqliteService.createDailyMedItem(daileyMedModel)).thenAnswer((_) async => 0);
      expect(await sqliteService.createDailyMedItem(daileyMedModel), 0);
    });

    test("delete medicine",() async {
      List<MedicineModel> medicineList1 = List.generate(1, (index) => medicineModel);
      when(sqliteService.getMedicineById("8c5ea443-83e4-4d92-88d9-5d0e06a06db8")).thenAnswer((_) async => medicineList1);
      expect(await sqliteService.getMedicineById("8c5ea443-83e4-4d92-88d9-5d0e06a06db8"), medicineList1);
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
  });
}