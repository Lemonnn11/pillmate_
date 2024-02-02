import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillmate/constants/constants.dart';
import 'package:ionicons/ionicons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pillmate/models/daily_med.dart';
import 'package:pillmate/models/medicine.dart';
import 'package:pillmate/models/personal_information.dart';
import 'package:pillmate/pages/add_drug.dart';
import 'package:pillmate/pages/drug_information.dart';
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
      await _sqliteService.increaseAmountTaken(qrcodeID, amountTaken, tmpp);
      await _sqliteService.alterDailyAmountTaken(amoungMedTaken);
      setState(() {
        getMedicines();
        amoungMedTaken +=1;
      });
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
  }

  Future<void> scheduledNotification() async {
    if(_morningDrugsList.isNotEmpty){
      _notificationList.add(true);
    }else{
      _notificationList.add(false);
    }
    if(_noonDrugsList.isNotEmpty){
      _notificationList.add(true);
    }else{
      _notificationList.add(false);
    }
    if(_eveningDrugsList.isNotEmpty){
      _notificationList.add(true);
    }else{
      _notificationList.add(false);
    }
    if(_nightDrugsList.isNotEmpty){
      _notificationList.add(true);
    }else{
      _notificationList.add(false);
    }
    await LocalNotificationService.showScheduleNotification(_notificationList, _dailyMedList[0]);
  }

  Future<void> getMedicines() async {
    final data = await _sqliteService.getMedicines();
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
    await _sqliteService.createDailyMedItem(new DaileyMedModel(1, dt.day, 0, dailyActiveMed, 9, 0, 12,0, 17, 0, 21, 0));
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
            if(last.length + dailyMed.length - 1 <= listWhen.length+1){
              for(int i = 1; i <= dailyMed.length-1;i++){
                for(int j = 0; j < listWhen.length;j++){
                  if(last[last.length-1] == listWhen[j] && j != listWhen.length-1){
                    tmp += ' ';
;                    tmp += listWhen[j+1];
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
          await _sqliteService.alterMedicationSchedule(element.qrcodeID, tmp);
          setState(() {
            getMedicines();
          });
        }
        if(dailyMed[0] == DateTime.now().day.toString()){
          for(int i = 0; i < dailyMed.length;i++){
            if(dailyMed[i] == 'เช้า'){
              _morningDrugsList.add(element);
            }
            else if(dailyMed[i] == 'กลางวัน'){
              _noonDrugsList.add(element);
            }
            else if(dailyMed[i] == 'เย็น'){
              _eveningDrugsList.add(element);
            }
            else if(dailyMed[i] == 'ก่อนนอน'){
              _nightDrugsList.add(element);
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
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Stack(
              children: [
                Container(
                  height:222.2,
                  width: screenWidth,
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0)),
                          gradient: LinearGradient(colors: [
                            kLightGreen,
                            kTeal,
                            kTeal,
                          ],

                              begin: Alignment.topLeft, end: Alignment.bottomRight),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(isLoggedIn! ? name == '' ? 'สวัสดี, ยินดีต้อนรับ': 'สวัสดี, คุณ' + name: 'สวัสดี, ยินดีต้อนรับ',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'PlexSansThaiMd',
                                              color: Colors.black,
                                            ),),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(date,
                                            style: TextStyle(
                                              fontSize: 16,
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
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6.0),
                                        boxShadow: [
                                    BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0.8,
                                    blurRadius: 0.8,
                                  ),]
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 7, horizontal: screenWidth*0.0425),
                                      child: Column(
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
                                          color: Colors.black,
                                        ),),
                                          Text(isLoggedIn! ? amoungMedTaken.toString() + ' จาก ' + dailyActiveMed.toString() + ' ของวันนี้': '0 จาก 0 ของวันนี้',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'PlexSansThaiRg',
                                              color: Colors.black,
                                            ),),
                                          SizedBox(
                                            height: screenHeight*0.007,

                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 4),
                                            child: Container(
                                              width: screenWidth*0.6,
                                              height: 9,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(6.0)
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                child: LinearProgressIndicator(
                                                  value: dailyActiveMed == 0? 0.0: (amoungMedTaken/dailyActiveMed),
                                                  backgroundColor: Color(0xffdddddd),
                                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xffED6B81)),
                                                ),
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
                                ],
                              ),
                            ),
                            Positioned(
                                left: screenWidth*0.65,
                                child: Container(
                              width: screenWidth*0.332,
                              child: Image.asset('images/heart.png'),)),
                            Positioned(
                                left: screenWidth*0.71,
                                top: 66,
                                child: Container(
                                  width: screenWidth*0.035,
                                  child: Image.asset('images/Star1.png'),)),
                            Positioned(
                                left: screenWidth*0.89,
                                top: 106,
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
                    bottom: 0,
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
                                color: Colors.white,
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
                                            fontSize: 16,
                                            fontFamily: 'PlexSansThaiRg'
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          width: screenWidth*0.17,
                                            child: Image.asset('images/scanQR.jpg')),
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
                                  color: Colors.white,
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
                                              fontSize: 16,
                                              fontFamily: 'PlexSansThaiRg'
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                            width: screenWidth*0.17,
                                            child: Image.asset('images/scanQR.jpg')),
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
            Container(
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
                              fontSize: 18,
                              fontFamily: 'PlexSansThaiMd',
                              color: Color(0xff047E60)
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
                                  fontSize: 16,
                                  fontFamily: 'PlexSansThaiMd',
                                  color: Color(0xff121212)
                              ),
                            ): Text(
                              'ทั้งหมด',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'PlexSansThaiRg',
                                  color: Color(0xff121212)
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
                                  fontSize: 16,
                                  fontFamily: 'PlexSansThaiMd',
                                  color: Color(0xff121212)
                              ),
                            ):Text(
                              'เช้า',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'PlexSansThaiRg',
                                  color: Color(0xff121212)
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
                                  fontSize: 16,
                                  fontFamily: 'PlexSansThaiMd',
                                  color: Color(0xff121212)
                              ),
                            ):Text(
                              'กลางวัน',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'PlexSansThaiRg',
                                  color: Color(0xff121212)
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
                                  fontSize: 16,
                                  fontFamily: 'PlexSansThaiMd',
                                  color: Color(0xff121212)
                              ),
                            ): Text(
                              'เย็น',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'PlexSansThaiRg',
                                  color: Color(0xff121212)
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
                                  fontSize: 18,
                                  fontFamily: 'PlexSansThaiMd',
                                  color: Color(0xff121212)
                              ),
                            ):Text(
                              'ก่อนนอน',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'PlexSansThaiRg',
                                  color: Color(0xff121212)
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
                      color: Color(0xff059E78),
                    ),
                    Container(
                      child: isLoggedIn! ? Column(
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
                                        fontSize: 16,
                                        fontFamily: 'PlexSansThaiRg',
                                        color: Color(0xff121212)
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth*0.72,
                                    height: screenHeight*0.0015,
                                    color: Color(0xffD8D8D8),
                                  ),
                                  Text(
                                    '09:00',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'PlexSansThaiMd',
                                        color: Color(0xff121212)
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
                                        fontSize: 16,
                                        fontFamily: 'PlexSansThaiRg',
                                        color: Color(0xff121212)
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth*0.625,
                                    height: screenHeight*0.0015,
                                    color: Color(0xffD8D8D8),
                                  ),
                                  Text(
                                    '12:00',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'PlexSansThaiMd',
                                        color: Color(0xff121212)
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
                                        fontSize: 16,
                                        fontFamily: 'PlexSansThaiRg',
                                        color: Color(0xff121212)
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth*0.71,
                                    height: screenHeight*0.0015,
                                    color: Color(0xffD8D8D8),
                                  ),
                                  Text(
                                    '17:00',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'PlexSansThaiMd',
                                        color: Color(0xff121212)
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
                                        fontSize: 16,
                                        fontFamily: 'PlexSansThaiRg',
                                        color: Color(0xff121212)
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth*0.605,
                                    height: screenHeight*0.0015,
                                    color: Color(0xffD8D8D8),
                                  ),
                                  Text(
                                    '21:00',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'PlexSansThaiMd',
                                        color: Color(0xff121212)
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
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ): Container()
                        ],
                      ):
                      Container(
                        height: screenHeight*0.4,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ไม่พบข้อมูล กรุณา'
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.pushNamed(context, '/log-in');
                                  },
                                  child: Text(
                                      'เช้าสู่ระบบ',
                                      style: TextStyle(decoration: TextDecoration.underline,decorationColor: Color(0xff059E78), color: Color(0xff059E78)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 70,
        width: 70,
        child: FittedBox(
          child: FloatingActionButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('icons/qrcode-scan.png', width: 22, height: 22,) ,
                Text('สแกน', style: TextStyle(
                  color: Colors.white,
                  fontSize: 10
                ),)
              ],
            ),
            shape: CircleBorder(),
            backgroundColor: Color(0xff059E78),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => QRCodeScanner()
              ));
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => AddDrug()
              // ));
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ReusableBottomNavigationBar(isLoggedIn: isLoggedIn,),
    );
  }
}
