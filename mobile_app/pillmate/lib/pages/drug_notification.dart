import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pillmate/pages/qr_code_scanner.dart';
import '../components/reusable_bottom_navigation_bar.dart';
import 'package:ionicons/ionicons.dart';

import '../models/daily_med.dart';
import '../services/sqlite_service.dart';

class DrugNotification extends StatefulWidget {
  const DrugNotification({super.key});

  @override
  State<DrugNotification> createState() => _DrugNotificationState();
}

class _DrugNotificationState extends State<DrugNotification> {
  bool isEdit = false;
  late SqliteService _sqliteService;
  List<DaileyMedModel> _dailyMedList = [];
  String morningHour = "0";
  String morningMinute = "0";
  String noonHour = "0";
  String noonMinute = "0";
  String eveningHour = "0";
  String eveningMinute = "0";
  String nightHour = "0";
  String nightMinute = "0";


  Future<void> getDailyMeds() async {
    final data = await _sqliteService.getDailyMedicines();
    setState(() {
      this._dailyMedList = data;
      print("noti: " + _dailyMedList[0].morningTimeHour.toString());
      if(_dailyMedList[0].morningTimeHour < 10){
        morningHour += _dailyMedList[0].morningTimeHour.toString();
      }else{
        morningHour = _dailyMedList[0].morningTimeHour.toString();
      }
      if(_dailyMedList[0].morningTimeMinute < 10){
        morningMinute += _dailyMedList[0].morningTimeMinute.toString();
      }else{
        morningMinute = _dailyMedList[0].morningTimeMinute.toString();
      }
      if(_dailyMedList[0].noonTimeHour < 10){
        noonHour += _dailyMedList[0].noonTimeHour.toString();
      }else{
        noonHour = _dailyMedList[0].noonTimeHour.toString();
      }
      if(_dailyMedList[0].noonTimeMinute < 10){
        noonMinute += _dailyMedList[0].noonTimeMinute.toString();
      }else{
        noonMinute = _dailyMedList[0].noonTimeMinute.toString();
      }
      if(_dailyMedList[0].eveningTimeHour < 10){
        eveningHour += _dailyMedList[0].eveningTimeHour.toString();
      }else{
        eveningHour = _dailyMedList[0].eveningTimeHour.toString();
      }
      if(_dailyMedList[0].noonTimeMinute < 10){
        eveningMinute += _dailyMedList[0].eveningTimeMinute.toString();
      }else{
        eveningMinute = _dailyMedList[0].eveningTimeMinute.toString();
      }
      if(_dailyMedList[0].eveningTimeHour < 10){
        nightHour += _dailyMedList[0].nightTimeHour.toString();
      }else{
        nightHour = _dailyMedList[0].nightTimeHour.toString();
      }
      if(_dailyMedList[0].noonTimeMinute < 10){
        nightMinute += _dailyMedList[0].nightTimeMinute.toString();
      }else{
        nightMinute = _dailyMedList[0].nightTimeMinute.toString();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this._sqliteService= SqliteService();
    this._sqliteService.initializeDB();
    getDailyMeds();
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
            onTap: (){
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
              Row(
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
                        hintText: '$morningHour:$morningMinute',
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
                        hintText: '$noonHour:$noonMinute',
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
                        hintText: '$eveningHour:$eveningMinute',
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
                        hintText: '$nightHour:$nightMinute',
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
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.add),
        backgroundColor: Color(0xff6CCAB7),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QRCodeScanner()
          ));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ReusableBottomNavigationBar(),
    );
  }
}
