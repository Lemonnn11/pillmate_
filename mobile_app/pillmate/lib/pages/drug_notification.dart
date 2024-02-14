import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pillmate/pages/qr_code_scanner.dart';
import '../components/reusable_bottom_navigation_bar.dart';
import 'package:ionicons/ionicons.dart';

import '../models/daily_med.dart';
import '../services/local_notification_service.dart';
import '../services/sqlite_service.dart';
import 'add_drug.dart';

class DrugNotification extends StatefulWidget {
  const DrugNotification({super.key});

  @override
  State<DrugNotification> createState() => _DrugNotificationState();
}

class _DrugNotificationState extends State<DrugNotification> {
  bool isEdit = false;
  late SqliteService _sqliteService;
  List<DaileyMedModel> _dailyMedList = [];
  TextEditingController morning = TextEditingController();
  TextEditingController noon= TextEditingController();
  TextEditingController evening = TextEditingController();
  TextEditingController night = TextEditingController();
  bool isSwitched = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool? isLoggedIn = false;

  @override
  void dispose() {
    super.dispose();
    morning.dispose();
    noon.dispose();
    evening.dispose();
    night.dispose();
  }

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


  Future<void> getDailyMeds() async {
    final data = await _sqliteService.getDailyMedicines();
    setState(() {
      this._dailyMedList = data;
      print("noti: " + _dailyMedList[0].morningTimeHour.toString());
      if(_dailyMedList[0].morningTimeHour < 10){
        morning.text = '0${_dailyMedList[0].morningTimeHour}:';
      }else{
        morning.text = "${_dailyMedList[0].morningTimeHour}:";
      }
      if(_dailyMedList[0].morningTimeMinute < 10){
        morning.text += "0${_dailyMedList[0].morningTimeMinute}";
      }else{
        morning.text += _dailyMedList[0].morningTimeMinute.toString();
      }
      if(_dailyMedList[0].noonTimeHour < 10){
        noon.text = '0${_dailyMedList[0].noonTimeHour}:';
      }else{
        noon.text = '${_dailyMedList[0].noonTimeHour}:';
      }
      if(_dailyMedList[0].noonTimeMinute < 10){
        noon.text += '0${_dailyMedList[0].noonTimeMinute}';
      }else{
        noon.text += _dailyMedList[0].noonTimeMinute.toString();
      }
      if(_dailyMedList[0].eveningTimeHour < 10){
        evening.text = '0${_dailyMedList[0].eveningTimeHour}:';
      }else{
        evening.text = '${_dailyMedList[0].eveningTimeHour}:';
      }
      if(_dailyMedList[0].noonTimeMinute < 10){
        evening.text += '0${_dailyMedList[0].eveningTimeMinute}';
      }else{
        evening.text += _dailyMedList[0].eveningTimeMinute.toString();
      }
      if(_dailyMedList[0].eveningTimeHour < 10){
        night.text = '0${_dailyMedList[0].nightTimeHour}:';
      }else{
        night.text = '${_dailyMedList[0].nightTimeHour}:';
      }
      if(_dailyMedList[0].noonTimeMinute < 10){
        night.text += '0${_dailyMedList[0].nightTimeMinute}';
      }else{
        night.text += _dailyMedList[0].nightTimeMinute.toString();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this._sqliteService= SqliteService();
    this._sqliteService.initializeDB();
    getDailyMeds();
    authChangesListener();
    initIsNotified();
  }

  Future<void> initIsNotified() async {
    List<DaileyMedModel> daileyMedModel = await _sqliteService.getDailyMedicines();
    print(daileyMedModel[0].isNotified);
    if(daileyMedModel[0].isNotified == 0){
      setState(() {
        isSwitched = false;
      });
    }else{
      setState(() {
        isSwitched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 45,
        title: Padding(
          padding: EdgeInsets.only(top: 5, left: screenWidth*0.154),
          child: Text(
            'การแจ้งเตือน',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'PlexSansThaiSm',
                color: Colors.black
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Ionicons.chevron_back_outline, color: Colors.black,size: 30), onPressed: () {
          Navigator.pop(context);
          this.isEdit = false;
        },
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              List<String> tmpMorning = morning.text.split(':');
              int morningHour = int.parse(tmpMorning[0]);
              int morningMinute = int.parse(tmpMorning[1]);
              List<String> tmpNoon = noon.text.split(':');
              int noonHour = int.parse(tmpNoon[0]);
              int noonMinute = int.parse(tmpNoon[1]);
              List<String> tmpEvening = evening.text.split(':');
              int eveningHour = int.parse(tmpEvening[0]);
              int eveningMinute = int.parse(tmpEvening[1]);
              List<String> tmpNight = night.text.split(':');
              int nightHour = int.parse(tmpNight[0]);
              int nightMinute = int.parse(tmpNight[1]);
              await _sqliteService.updateNotificationTime(morningHour, morningMinute, noonHour, noonMinute, eveningHour, eveningMinute, nightHour, nightMinute);
              setState(() {
                this.isEdit = !isEdit;
              });
            },
            child: Padding(padding: EdgeInsets.only(top: 11, right: 9),
                child: this.isEdit ? Text( 'บันทึก', style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'PlexSansThaiRg',
                    color: Colors.black
                ),): Text('แก้ไข', style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'PlexSansThaiRg',
                    color: Colors.black
                ),)),
          )
        ],
      ),
      body: Container(
        width: screenWidth,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: 15),
          child: ListView(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: Container(
                      width: screenWidth*0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('การตั้งค่าการแจ้งเตือน',style: TextStyle(fontSize: 16, fontFamily: 'PlexSansThaiMd', color:  Colors.black),),
                          Text('เปลี่ยนเวลาการแจ้งเตือนให้เข้ากับชีวิตประจำวันของคุณ',style: TextStyle(fontSize: 13, fontFamily: 'PlexSansThaiRg', color:  Colors.black),),
                        ],
                      ),
                    ),
                  ),
                  CupertinoSwitch(value: isSwitched,
                      activeColor: Color(0xff19B48D),
                      onChanged: (value){
                    setState((){
                      this.isSwitched = value;
                      if(isSwitched){
                        _sqliteService.turnOnNotification();
                      }else{
                        _sqliteService.turnOffNotification();
                      }
                    });
                  }

               )

                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: screenWidth*0.05,
                        child: Image.asset('icons/bi_sunrise-black.png'),
                      ),
                        Text('  ช่วงเช้า',
                        style: TextStyle(fontSize: 16, fontFamily: 'PlexSansThaiMd', color:  Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 4,),
                  Container(
                    height: 55,
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 2, left: 15),
                        hintText: morning.text,
                        hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'PlexSansThaiRg',
                            color: Colors.black
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffD0D0D0)),
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffD0D0D0)),
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffD0D0D0)),
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                      ),
                      readOnly: !isEdit,
                      controller: morning,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: screenWidth*0.05,
                        child: Image.asset('icons/ph_sun-black.png'),
                      ),
                      Text('  ช่วงกลางวัน',
                        style: TextStyle(fontSize: 16, fontFamily: 'PlexSansThaiMd', color:  Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 4,),
                  Container(
                    height: 55,
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 2, left: 15),
                        hintText: noon.text,
                        hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'PlexSansThaiRg',
                            color: Colors.black
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffD0D0D0)),
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffD0D0D0)),
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffD0D0D0)),
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                      ),
                      readOnly: !isEdit,
                      controller: noon,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: screenWidth*0.05,
                        child: Image.asset('icons/bi_sunset-black.png'),
                      ),
                      Text('  ช่วงเย็น',
                        style: TextStyle(fontSize: 16, fontFamily: 'PlexSansThaiMd', color:  Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 4,),
                  Container(
                    height: 55,
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 2, left: 15),
                        hintText: evening.text,
                        hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'PlexSansThaiRg',
                            color: Colors.black
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffD0D0D0)),
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffD0D0D0)),
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffD0D0D0)),
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                      ),
                      readOnly: !isEdit,
                      controller: evening,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: screenWidth*0.05,
                        child: Image.asset('icons/solar_moon-black.png'),
                      ),
                      Text('  ก่อนนอน',
                        style: TextStyle(fontSize: 16, fontFamily: 'PlexSansThaiMd', color:  Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 4,),
                  Container(
                    height: 55,
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 2, left: 15),
                        hintText: night.text,
                        hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'PlexSansThaiRg',
                            color: Colors.black
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffD0D0D0)),
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffD0D0D0)),
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffD0D0D0)),
                            borderRadius: BorderRadius.circular(8.0)
                        ),
                      ),
                      readOnly: !isEdit,
                      controller: night,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
