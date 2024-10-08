import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pillmate/constants/constants.dart';
import 'package:ionicons/ionicons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pillmate/models/app_config.dart';
import 'package:pillmate/models/daily_med.dart';
import 'package:pillmate/models/medicine.dart';
import 'package:pillmate/models/on_boarding.dart';
import 'package:pillmate/models/personal_information.dart';
import 'package:pillmate/pages/add_drug.dart';
import 'package:pillmate/pages/drug_information.dart';
import 'package:pillmate/pages/on_boarding_1.dart';
import 'package:pillmate/pages/qr_code_scanner.dart';
import 'package:pillmate/services/local_notification_service.dart';
import '../apis/firebase_notification_api.dart';
import '../components/reusable_bottom_navigation_bar.dart';
import '../components/reusable_notification_card.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../services/sqlite_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late SqliteService _sqliteService;
  String cat = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool? isLoggedIn = false;
  String date = '';
  String name = '';
  int dailyActiveMed = 0;
  int amoungMedTaken = 0;
  List<MedicineModel> _drugsList = [];
  List<PersonalInformationModel> _personsList = [];
  List<DaileyMedModel> _dailyMedList = [];
  List<MedicineModel> _morningDrugsList = [];
  List<MedicineModel> _noonDrugsList = [];
  List<MedicineModel> _eveningDrugsList = [];
  List<MedicineModel> _nightDrugsList = [];
  List<bool> _notificationList = [];
  bool haveSchedule = false;
  bool editFontsize = false;
  int change = 0;
  bool darkMode = false;
  //
  // Future<String?> _getCurrentUser() async {
  //   try {
  //     final user = await _auth.currentUser;
  //     final username = user?.displayName;
  //     if (user != null) {
  //       setState(() {
  //         isLoggedIn = true;
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }

  void authChangesListener(){
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        setState(() {
          isLoggedIn = false;
          print("isLoggedIn: " + isLoggedIn.toString());
        });
      } else {
        setState(() {
          isLoggedIn = true;
          print("isLoggedIn: " + isLoggedIn.toString());

        });
      }
    });
  }

  int checkDayOverAmountOfdayInMonth(int day){
    var dt = DateTime.now();
    switch(dt.month.toString()){
      case '1': {
        if(day > 31){
          return day-31;
        }else{
          return day;
        }
      }

      case '2': {
        bool isLeapYear = false;
        if (dt.year % 4 == 0) {
          if (dt.year % 100 == 0) {
            if (dt.year % 400 == 0) {
              isLeapYear = true;
            } else {
              isLeapYear = false;
            }
          } else {
            isLeapYear = true;
          }
        } else {
          isLeapYear = false;
        }
        if(isLeapYear){
          if(day > 29){
            return day-29;
          }else{
            return day;
          }
        }else{
          if(day > 28){
            return day-28;
          }else{
            return day;
          }
        }

      }

      case '3': {
        if(day > 31){
          return day-31;
        }else{
          return day;
        }
      }

      case '4': {
        if(day > 30){
          return day-30;
        }else{
          return day;
        }
      }

      case '5': {
        if(day > 31){
          return day-31;
        }else{
          return day;
        }
      }

      case '6': {
        if(day > 30){
          return day-30;
        }else{
          return day;
        }
      }

      case '7': {
        if(day > 31){
          return day-31;
        }else{
          return day;
        }
      }

      case '8': {
        if(day > 31){
          return day-31;
        }else{
          return day;
        }
      }
      break;

      case '9': {
        if(day > 30){
          return day-30;
        }else{
          return day;
        }
      }

      case '10': {
        if(day > 31){
          return day-31;
        }else{
          return day;
        }
      }
      case '11': {
        if(day > 30){
          return day-30;
        }else{
          return day;
        }
      }

      case '12': {
        if(day > 31){
          return day-31;
        }else{
          return day;
        }
      }
    }
    return day;
  }

  Future<void> onClickedFromChild(bool isClicked, String qrcodeID, int amountTaken, String medicationSchedule, String when) async {
    if(isClicked){
      final listOfString = medicationSchedule.split(',');
      final dailyMed = listOfString[0].split(' ');
      String tmpp = '';
      bool flag = false;
      if(dailyMed.length > 1){
        for(int i = 0; i < dailyMed.length;i++){
          if(dailyMed[i] == when && flag == false){
            flag = true;
          }else{
            if(i == dailyMed.length - 1){
              tmpp += dailyMed[i];
            }
            else{
              tmpp += dailyMed[i];
              tmpp += ' ';
            }
          }
        }
        tmpp+=',';
      }

      for(int i = 1; i < listOfString.length;i++){
        if(listOfString.length-1 == i){
          tmpp+=listOfString[i];
        }else{
          tmpp+=listOfString[i];
          tmpp += ',';
        }
      }
      await _sqliteService.increaseAmountTaken(qrcodeID, amountTaken, tmpp).then((_) =>
          setState(() {
            getMedicines();
            amoungMedTaken +=1;
          })
      );
      await _sqliteService.alterDailyAmountTaken(amoungMedTaken);
    }
  }

  @override
  void initState() {
    super.initState();
    NotificationApi.init();
    FirebaseMessaging.onBackgroundMessage((message) => _firebaseBackgroundMessage(message));
    authChangesListener();
    this._sqliteService= SqliteService();
    this._sqliteService.initializeDB();
    getMedicines();
    getPersons();
    setHeader();
    getDailyMeds();
    createAppConfig();
    initFontSize();
    initDarkMode();
    getActiveNoti();
  }

  Future<void> createAppConfig() async {
    await _sqliteService.createAppConfigItem(new AppConfigModel(1, 0, 0, 0));
  }

  Future<void> initFontSize() async {
    bool status = await _sqliteService.getEditFontSizeStatus();
    int change = await _sqliteService.getFontSizeChange();
    setState(() {
      editFontsize = status;
      this.change = change;
    });
  }

  Future<void> initDarkMode() async {
    bool status = await _sqliteService.getDarkModeStatus();
    setState(() {
      darkMode = status;
    });
  }

  Future<void> getActiveNoti() async{
    List<PendingNotificationRequest> activeNoti = await LocalNotificationService.getActiveNotifications();
    print('activeNoti: ${activeNoti}');
  }

  Future<void> scheduledNotification() async {
    if(_morningDrugsList.isNotEmpty){
      _notificationList.add(true);
      haveSchedule = true;
    }else{
      _notificationList.add(false);
    }
    if(_noonDrugsList.isNotEmpty){
      _notificationList.add(true);
      haveSchedule = true;
    }else{
      _notificationList.add(false);
    }
    if(_eveningDrugsList.isNotEmpty){
      _notificationList.add(true);
      haveSchedule = true;
    }else{
      _notificationList.add(false);
    }
    if(_nightDrugsList.isNotEmpty){
      _notificationList.add(true);
      haveSchedule = true;
    }else{
      _notificationList.add(false);
    }
    if(_dailyMedList[0].isNotified == 1){
      await LocalNotificationService.showScheduleNotification(_notificationList, _dailyMedList[0]);
    }
  }

  Future<void> getMedicines() async {
    final data = await _sqliteService.getActiveMedicine();
    this._drugsList = data;
    addToSperateList();
  }

  Future<void> getPersons() async {
    final data = await _sqliteService.getPersonalInfo();
    this._personsList = data;
    setState(() {
      final tmp = _personsList[0].name.split(' ');
      name= tmp[0];
    });
  }
  
  Future<void> getDailyMeds() async {
    DateTime dt = DateTime.now();
    final data = await _sqliteService.getDailyMedicines();
    await _sqliteService.createDailyMedItem(new DaileyMedModel(1, dt.day, 0, dailyActiveMed, 9, 0, 12,0, 17, 0, 21, 0, 1));
    this._dailyMedList = data;
      print(_drugsList.length);
      if(_drugsList.length != 0 || _drugsList != null){
        for(int i = 0; i < _drugsList.length;i++){
          final tmpList = _drugsList[i].medicationSchedule.split(',');
          final first = tmpList[0].split(' ');
          if(first[0] == dt.day.toString()){
            dailyActiveMed += first.length-1;
          }
        }
        _sqliteService.alterDailyMed(dailyActiveMed);

      }
    scheduledNotification();
      setState(() {
        amoungMedTaken = _dailyMedList[0].amountTaken;
        dailyActiveMed = _dailyMedList[0].dailyMed;
      });
  }

  void setHeader(){
    var dt = DateTime.now();
    date += 'วัน';
    switch (dt.weekday) {
      case 1:
        date += 'จันทร์';
        break;
      case 2:
        date += 'อังคาร';
        break;
      case 3:
        date += 'พุธ';
        break;
      case 4:
        date += 'พฤหัสบดี';
        break;
      case 5:
        date += 'ศุกร์';
        break;
      case 6:
        date += 'เสาร์';
        break;
      case 7:
        date += 'อาทิตย์';
        break;
      default:
        date += 'ไม่ทราบ';
    }
    date += 'ที่ ';
    date += dt.day.toString();
    switch (dt.month) {
      case 1:
        date += ' มกราคม';
        break;
      case 2:
        date += ' กุมภาพันธ์';
        break;
      case 3:
        date += ' มีนาคม';
        break;
      case 4:
        date += ' เมษายน';
        break;
      case 5:
        date += ' พฤษภาคม';
        break;
      case 6:
        date += ' มิถุนายน';
        break;
      case 7:
        date += ' กรกฎาคม';
        break;
      case 8:
        date += ' สิงหาคม';
        break;
      case 9:
        date += ' กันยายน';
        break;
      case 10:
        date += ' ตุลาคม';
        break;
      case 11:
        date += ' พฤศจิกายน';
        break;
      case 12:
        date += ' ธันวาคม';
        break;
      default:
        date += ' ไม่ทราบ';
    }

  }

  void addToSperateList(){
    _morningDrugsList.clear();
    _noonDrugsList.clear();
    _eveningDrugsList.clear();
    _nightDrugsList.clear();
    final now = DateTime.now();
    int currentHour = 8;
    _drugsList.forEach((element) async {
      if(element.takeMedWhen != null || element.takeMedWhen != "" ){
        // print(element.medicationSchedule);
        String tmp = '';
        var listOfMed = element.medicationSchedule.split(',');
        final dailyMed = listOfMed[0].split(' ');
        if(dailyMed[0] == (DateTime.now().day-1).toString()){
          tmp = element.medicationSchedule;
          print(tmp);
          if(
            dailyMed.length != 1
          ){
            final listWhen = element.takeMedWhen.split(' ');
            final diff = listWhen.length - dailyMed.length - 1;
            final last = listOfMed[listOfMed.length - 1].split(' ');
            print('${last.length} ${listWhen.length}');
            if(last.length + dailyMed.length - 1 <= listWhen.length+1){
                for(int i = 1; i <= dailyMed.length-1;i++){
                  for(int j = 0; j < listWhen.length;j++){
                    if(last[last.length-1] == listWhen[j] && j != listWhen.length-1){
                      tmp += ' ';
                      tmp += listWhen[j+1];
                    }
                  }
                }
            }
            else{
              if(last.length < listWhen.length + 1){
                var diff =  listWhen.length + 1 - last.length;
                for(int i = 0; i < diff;i++){
                  for(int j = 0; j < listWhen.length;j++){
                    if(last[last.length-1] == listWhen[j]&& j != listWhen.length-1){
                      tmp += ' ';
                      tmp += listWhen[j+1];
                    }
                  }
                }
                tmp += ',';
                var more = dailyMed.length - 1 - diff;
                tmp += checkDayOverAmountOfdayInMonth(int.parse(last[0])+ 1).toString();
                tmp += ' ';
                for(int j = 0; j < more;j++){
                    if(j == more - 1 || j == 0){
                      tmp += listWhen[j];
                    }else{
                      tmp += ' ';
                      tmp += listWhen[j];
                    }
                }
              }else{
                tmp += ',';
                tmp += checkDayOverAmountOfdayInMonth(int.parse(last[0])+ 1).toString();
                tmp += ' ';
                for(int j = 0; j < dailyMed.length-1;j++){
                  if(j == 0){
                    tmp += listWhen[j];
                  }else{
                    tmp += ' ';
                    tmp += listWhen[j];
                  }
                }
              }
            }
          }
          final tempList = tmp.split(',');
          tmp = '';
          for(int i = 1;i < tempList.length;i++){
            if(i == tempList.length-1){
              tmp+=tempList[i];
            }else{
              tmp+=tempList[i];
              tmp+=',';
            }
          }
          print('tmp: ${tmp}');
          await _sqliteService.alterMedicationSchedule(element.qrcodeID, tmp);
        }
        if(dailyMed[0] == DateTime.now().day.toString()){
          for(int i = 0; i < dailyMed.length;i++){
            if(dailyMed[i] == 'เช้า'){
              setState(() {
                _morningDrugsList.add(element);
              });
            }
            else if(dailyMed[i] == 'กลางวัน'){
              setState(() {
                _noonDrugsList.add(element);
              });
            }
            else if(dailyMed[i] == 'เย็น'){
              setState(() {
                _eveningDrugsList.add(element);
              });
            }
            else if(dailyMed[i] == 'ก่อนนอน'){
              setState(() {
                _nightDrugsList.add(element);
              });
            }
          }
        }
      }
    });

  }

  Future _firebaseBackgroundMessage(RemoteMessage message) async {
    if(message.notification != null){
      print("notification received");
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: !darkMode ? Colors.white: kBlackDarkModeBg,
      body: SingleChildScrollView(
        child: Stack(children: <Widget>[
          Stack(
            children: [
              Container(
                height: 285,
                width: screenWidth,
                child: Column(
                  children: [
                    Container(
                      height: 240,
                      decoration: !darkMode ? BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0)),
                        gradient:  LinearGradient(colors: [
                          kLightGreen,
                          kTeal,
                          kTeal,
                        ],
                            begin: Alignment.topLeft, end: Alignment.bottomRight),
                      ): BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0)),
                        color: kGreenDarkMode
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(isLoggedIn! ? name == '' ? 'สวัสดี, ยินดีต้อนรับ': 'สวัสดี, คุณ' + name: 'สวัสดี, ยินดีต้อนรับ',
                                          style: TextStyle(
                                            fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                            fontFamily: 'PlexSansThaiMd',
                                            color: Colors.black,
                                          ),),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(date,
                                          style: TextStyle(
                                            fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                            fontFamily: 'PlexSansThaiRg',
                                            color: Colors.black,
                                          ),)
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Ionicons.notifications_outline,
                                            color: Color(0xff059E78),
                                            size: 27,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 110,
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.0425),
                              child: Container(
                                width: screenWidth,
                                height: 83,
                                decoration: BoxDecoration(
                                    color: !darkMode ? Colors.white: kBlackDarkMode,
                                    borderRadius: BorderRadius.circular(6.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 0.8,
                                        blurRadius: 0.8,
                                      ),]
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: screenWidth*0.0425),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('ความคืบหน้าการกินยาของคุณวันนี้',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'PlexSansThaiMd',
                                                    color: !darkMode ? Colors.black: Colors.white,
                                                  ),),
                                                Text(isLoggedIn! ? amoungMedTaken.toString() + ' จาก ' + dailyActiveMed.toString() + ' ของวันนี้': '0 จาก 0 ของวันนี้',
                                                  style: TextStyle(
                                                    fontSize: editFontsize ?  12 + change.toDouble() : 12,
                                                    fontFamily: 'PlexSansThaiRg',
                                                    color: !darkMode ? Colors.black: Colors.white,
                                                  ),),
                                                SizedBox(
                                                  height: screenHeight*0.007,

                                                ),
                                                Container(
                                                  width: screenWidth*0.6,
                                                  height: 9,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6.0)
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    child: LinearProgressIndicator(
                                                      value: isLoggedIn! ? 0.0: dailyActiveMed == 0  ? 0.0: (amoungMedTaken/dailyActiveMed),
                                                      backgroundColor: Color(0xffdddddd),
                                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xffED6B81)),
                                                    ),
                                                  ),
                                                )
                                              ]
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                width: screenWidth*0.20,
                                                child: Image.asset('images/yellowShape.png'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              top: 50,
                              left: screenWidth*0.65,
                              child: Container(
                                width: screenWidth*0.332,
                                child: Image.asset('images/heart.png'),)),
                          Positioned(
                              left: screenWidth*0.71,
                              top: 115,
                              child: Container(
                                width: screenWidth*0.035,
                                child: Image.asset('images/Star1.png'),)),
                          Positioned(
                              left: screenWidth*0.89,
                              top: 146,
                              child: Container(
                                width: screenWidth*0.035,
                                child: Image.asset('images/Star2.png'),)),
        
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: 205,
                  child:  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap:() async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => QRCodeScanner()
                            ));
                          },
                          child: Container(
                            width: screenWidth * 0.444,
                            height: 65,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                color: !darkMode ? Colors.white: kBlackDarkMode,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0.8,
                                    blurRadius: 0.8,
                                  ),]
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: screenHeight*0.005, horizontal: screenWidth*0.035),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'สแกนยา',
                                        style: TextStyle(
                                            fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                            fontFamily: 'PlexSansThaiRg',
                                            color: !darkMode ? Colors.black: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          width: 60,
                                          child: Image.asset('images/scandrug_0.png')),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth*0.032),
                        GestureDetector(
                          onTap: (){
                            if(isLoggedIn!){
                              Navigator.pushNamed(context, '/my-drug-list');
                            }
                            else{
                              Navigator.pushNamed(context, '/log-in');
                            }
                          },
                          child: Container(
                            width: screenWidth * 0.444,
                            height: 65,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                color: !darkMode ? Colors.white: kBlackDarkMode,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0.8,
                                    blurRadius: 0.8,
                                  ),]
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: screenHeight*0.005, horizontal: screenWidth*0.035),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'ยาของฉัน',
                                        style: TextStyle(
                                            fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                            fontFamily: 'PlexSansThaiRg',
                                          color: !darkMode ? Colors.black: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                          width: 59,
                                          child: Image.asset('images/mydrugs_0.png')),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
          Positioned(
            child: Padding(
              padding: EdgeInsets.only(top: 265.0),
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: screenHeight*0.008),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              'ตารางการทานยา',
                              style: TextStyle(
                                  fontSize: editFontsize ?  18 + change.toDouble() : 18,
                                  fontFamily: 'PlexSansThaiMd',
                                  color: !darkMode ? Color(0xff047E60): kGreenDarkMode,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                cat = '';
                              });
                            },
                            child: Container(
                                child: cat == '' ? Text(
                                  'ทั้งหมด',
                                  style: TextStyle(
                                      fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                      fontFamily: 'PlexSansThaiMd',
                                      color: !darkMode ? Color(0xff121212): kGreenDarkMode,
                                  ),
                                ): Text(
                                  'ทั้งหมด',
                                  style: TextStyle(
                                      fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                      fontFamily: 'PlexSansThaiRg',
                                      color: !darkMode ? Color(0xff121212): Colors.white,
                                  ),
                                )
                            ),
                          ),
                          GestureDetector(
                              onTap: (){
                                setState(() {
                                  cat = 'เช้า';
                                });
                              },
                              child: Container(
                                child: cat == 'เช้า' ? Text(
                                  'เช้า',
                                  style: TextStyle(
                                      fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                      fontFamily: 'PlexSansThaiMd',
                                      color: !darkMode ? Color(0xff121212): kGreenDarkMode,
                                  ),
                                ):Text(
                                  'เช้า',
                                  style: TextStyle(
                                      fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                      fontFamily: 'PlexSansThaiRg',
                                      color: !darkMode ? Color(0xff121212): Colors.white,
                                  ),
                                ),
                              )
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                cat = 'กลางวัน';
                              });
                            },
                            child: Container(
                                child:  cat == 'กลางวัน' ? Text(
                                  'กลางวัน',
                                  style: TextStyle(
                                      fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                      fontFamily: 'PlexSansThaiMd',
                                      color: !darkMode ? Color(0xff121212): kGreenDarkMode,
                                  ),
                                ):Text(
                                  'กลางวัน',
                                  style: TextStyle(
                                      fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                      fontFamily: 'PlexSansThaiRg',
                                      color: !darkMode ? Color(0xff121212): Colors.white,
                                  ),
                                )
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                cat = 'เย็น';
                              });
                            },
                            child: Container(
                                child: cat == 'เย็น' ? Text(
                                  'เย็น',
                                  style: TextStyle(
                                      fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                      fontFamily: 'PlexSansThaiMd',
                                      color: !darkMode ? Color(0xff121212): kGreenDarkMode,
                                  ),
                                ): Text(
                                  'เย็น',
                                  style: TextStyle(
                                      fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                      fontFamily: 'PlexSansThaiRg',
                                      color:  !darkMode ? Color(0xff121212): Colors.white,
                                  ),
                                )
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                cat = 'ก่อนนอน';
                              });
                            },
                            child: Container(
                                child:  cat == 'ก่อนนอน'? Text(
                                  'ก่อนนอน',
                                  style: TextStyle(
                                      fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                      fontFamily: 'PlexSansThaiMd',
                                      color: !darkMode ? Color(0xff121212): kGreenDarkMode,
                                  ),
                                ):Text(
                                  'ก่อนนอน',
                                  style: TextStyle(
                                      fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                      fontFamily: 'PlexSansThaiRg',
                                      color:!darkMode ? Color(0xff121212): Colors.white,
                                  ),
                                )
                            ),
                          ),
                          SizedBox(
                            width: screenWidth*0.1,
                          )
                        ],
                      ),
                      SizedBox(
                        height: screenHeight*0.005,
                      ),
                      Container(
                        width: screenWidth,
                        height: screenHeight*0.0025,
                        color: !darkMode ? Color(0xff059E78): kLightGreenDarkMode,
                      ),
                      Column(
                        children: [
                          Container(
                            child: !isLoggedIn! ?
                            Container(
                              height: screenHeight*0.4,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        'ไม่พบข้อมูล กรุณา',
                                        style: TextStyle(
                                          fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                          color: !darkMode ? Colors.black: Colors.white
                                        ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 2),
                                      child: GestureDetector(
                                        onTap: (){
                                          Navigator.pushNamed(context, '/log-in');
                                        },
                                        child: Text(
                                          'เข้าสู่ระบบ',

                                          style: TextStyle(fontSize: editFontsize ?  14 + change.toDouble() : 14,decoration: TextDecoration.underline,decorationColor: !darkMode ? Color(0xff059E78): kGreenDarkMode, color: !darkMode ? Color(0xff059E78): kGreenDarkMode),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ):
                            haveSchedule ?
                            Column(
                              children: [
                                SizedBox(height: screenHeight*0.01,),
                                (_morningDrugsList.length != 0 && (cat == '' || cat == 'เช้า')) ?
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'เช้า',
                                          style: TextStyle(
                                              fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                              fontFamily: 'PlexSansThaiRg',
                                              color:!darkMode? Color(0xff121212): Colors.white
                                          ),
                                        ),
                                        Container(
                                          width: screenWidth*0.72,
                                          height: screenHeight*0.0015,
                                          color: !darkMode ? Color(0xffD8D8D8):Color(0xffE7E7E7) ,
                                        ),
                                        Text(
                                          '09:00',
                                          style: TextStyle(
                                              fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                              fontFamily: 'PlexSansThaiMd',
                                              color:!darkMode? Color(0xff121212): Colors.white
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: Column(
                                        children: _morningDrugsList.map((drug) {
                                          return ReusableNotificationCard(
                                            image: Image.asset('images/para.png'),
                                            medicineModel: drug,
                                            callback: onClickedFromChild,
                                            when: 'เช้า',
                                            editFontsize: editFontsize,
                                            change: change,
                                            darkMode: darkMode,
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  ],
                                )
                                    : Container(),
                                (_noonDrugsList.length != 0 && (cat == '' || cat == 'กลางวัน')) ?
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'กลางวัน',
                                          style: TextStyle(
                                              fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                              fontFamily: 'PlexSansThaiRg',
                                              color: !darkMode? Color(0xff121212): Colors.white
                                          ),
                                        ),
                                        Container(
                                          width: screenWidth*0.625,
                                          height: screenHeight*0.0015,
                                          color:!darkMode ? Color(0xffD8D8D8):Color(0xffE7E7E7) ,
                                        ),
                                        Text(
                                          '12:00',
                                          style: TextStyle(
                                              fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                              fontFamily: 'PlexSansThaiMd',
                                              color: !darkMode? Color(0xff121212): Colors.white
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: Column(
                                        children: _noonDrugsList.map((drug) {
                                          return ReusableNotificationCard(
                                            image: Image.asset('images/para.png'),
                                            medicineModel: drug,
                                            callback: onClickedFromChild,
                                            when: 'กลางวัน',
                                            editFontsize: editFontsize,
                                            change: change,
                                            darkMode: darkMode,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                )
                                    : Container(),
                                (_eveningDrugsList.length != 0 && (cat == '' || cat == 'เย็น'))?
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'เย็น',
                                          style: TextStyle(
                                              fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                              fontFamily: 'PlexSansThaiRg',
                                              color: !darkMode? Color(0xff121212): Colors.white
                                          ),
                                        ),
                                        Container(
                                          width: screenWidth*0.71,
                                          height: screenHeight*0.0015,
                                          color: !darkMode ? Color(0xffD8D8D8):Color(0xffE7E7E7) ,
                                        ),
                                        Text(
                                          '17:00',
                                          style: TextStyle(
                                              fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                              fontFamily: 'PlexSansThaiMd',
                                              color: !darkMode? Color(0xff121212): Colors.white
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: Column(
                                        children: _eveningDrugsList.map((drug) {
                                          return ReusableNotificationCard(
                                            image: Image.asset('images/para.png'),
                                            medicineModel: drug,
                                            callback: onClickedFromChild,
                                            when: 'เย็น',
                                            editFontsize: editFontsize,
                                            change: change,
                                            darkMode: darkMode,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ):
                                Container(),
                                ( _nightDrugsList.length != 0 &&(cat == '' || cat == 'ก่อนนอน'))?
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'ก่อนนอน',
                                          style: TextStyle(
                                              fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                              fontFamily: 'PlexSansThaiRg',
                                              color: !darkMode? Color(0xff121212): Colors.white
                                          ),
                                        ),
                                        Container(
                                          width: screenWidth*0.605,
                                          height: screenHeight*0.0015,
                                          color: !darkMode ? Color(0xffD8D8D8):Color(0xffE7E7E7) ,
                                        ),
                                        Text(
                                          '21:00',
                                          style: TextStyle(
                                              fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                              fontFamily: 'PlexSansThaiMd',
                                              color: !darkMode? Color(0xff121212): Colors.white
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: Column(
                                        children: _nightDrugsList.map((drug) {
                                          return ReusableNotificationCard(
                                            image: Image.asset('images/para.png'),
                                            medicineModel: drug,
                                            callback: onClickedFromChild,
                                            when: 'ก่อนนอน',
                                            editFontsize: editFontsize,
                                            change: change,
                                            darkMode: darkMode,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ): Container()
                              ],
                            ): Container(
                              height: screenHeight*0.4,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        'คุณยังไม่มีตารางการทานยาในวันนี้',
                                      style: TextStyle(
                                        fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                        color: !darkMode ? Colors.black: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
      floatingActionButton: Container(
        height: 70,
        width: 70,
        child: FittedBox(
          child: FloatingActionButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(! darkMode ? 'icons/qrcode-scan.png': 'icons/qrcode-scan-black.png', width: 22, height: 22,) ,
                Text('สแกน', style: TextStyle(
                    color: !darkMode ? Colors.white: Colors.black,
                    fontSize: editFontsize ?  10 + change.toDouble() : 10
                ),)
              ],
            ),
            shape: CircleBorder(),
            backgroundColor: !darkMode ? Color(0xff059E78): Color(0xff94DDB5),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => QRCodeScanner()
              ));
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => AddDrug()
              // ));
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ReusableBottomNavigationBar(isLoggedIn: isLoggedIn, page: 'homepage', darkMode: darkMode,),
    );
  }
}
