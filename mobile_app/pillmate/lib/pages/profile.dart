import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillmate/constants/constants.dart';
import 'package:pillmate/pages/appearance.dart';
import 'package:pillmate/pages/qr_code_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../components/reusable_bottom_navigation_bar.dart';
import '../models/personal_information.dart';
import '../services/sqlite_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late SqliteService _sqliteService;
  List<PersonalInformationModel> _personsList = [];
  String name = '';
  bool? isLoggedIn = false;
  bool editFontsize = false;
  int change = 0;
  bool darkMode = false;


  @override
  void initState() {
    super.initState();
    this._sqliteService= SqliteService();
    this._sqliteService.initializeDB();
    getPersons();
    authChangesListener();
    initFontSize();
    initSwitchStatus();
  }
  Future<void> initSwitchStatus() async {
    bool status = await _sqliteService.getDarkModeStatus();
    setState(() {
      darkMode = status;
    });
  }

  Future<void> initFontSize() async {
    bool status = await _sqliteService.getEditFontSizeStatus();
    int change = await _sqliteService.getFontSizeChange();
    setState(() {
      editFontsize = status;
      this.change = change;
    });
  }

  Future<void> getPersons() async {
    final data = await _sqliteService.getPersonalInfo();
    this._personsList = data;
    setState(() {
      name = _personsList[0].name;
    });
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: !darkMode ? Colors.white: kBlackDarkModeBg,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 181,
              width: screenWidth,
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
              child: Padding(
                padding: EdgeInsets.only(top: 35.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      // backgroundImage: AssetImage('images/profile-pic.png'),
                    ),
                    Text(name,style: TextStyle(fontSize: editFontsize ?  18 + change.toDouble() : 18, fontFamily: 'PlexSansThaiMd',
                        color: !darkMode ? Colors.white: Colors.black),)
                  ],
                ),
              ),
            ),
                Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Column(
                    children: [
                      SizedBox(height: 180,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: 9),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'การตั้งค่าข้อมูล',
                              style: TextStyle(
                                fontSize: editFontsize ?  18 + change.toDouble() : 18,
                                fontFamily: 'PlexSansThaiMd',
                                color: !darkMode ? Colors.black: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: 1.2,
                          color:  !darkMode ? Color(0xffE7E7E7): Color(0xff8B8B8B)
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, '/personal-info');
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: 9),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:EdgeInsets.only(top: 2.0, right: screenWidth*0.025),
                                child: Container(
                                  width: 24,
                                  child:  !darkMode ? Image.asset('icons/user-green.png') : Image.asset('icons/user-light-green.png') ,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ข้อมูลส่วนตัว',
                                    style: TextStyle(
                                      fontSize: editFontsize ?  15 + change.toDouble() : 15,
                                      fontFamily: 'PlexSansThaiMd',
                                      color: !darkMode ? Colors.black: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'แก้ไขและเปลี่ยนแปลงข้อมูลของคุณได้ที่นี่',
                                    style: TextStyle(
                                      fontSize: editFontsize ?  13 + change.toDouble() : 13,
                                      fontFamily: 'PlexSansThaiRg',
                                      color: !darkMode ? Colors.black: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: 1.2,
                          color:  !darkMode ? Color(0xffE7E7E7): Color(0xff8B8B8B)
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/drug-notification');
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: 9),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:EdgeInsets.only(top: 2.0, right: screenWidth*0.025),
                                child: Container(
                                  width: 24,
                                  child:  !darkMode ?  Image.asset('icons/clock-alarm.png') : Image.asset('icons/fluent_clock-alarm-24-regular_dark.png') ,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ตั้งค่าเวลาและการแจ้งเตือน',
                                      style: TextStyle(
                                        fontSize: editFontsize ?  15 + change.toDouble() : 15,
                                        fontFamily: 'PlexSansThaiMd',
                                        color: !darkMode ? Colors.black: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'เปลี่ยนเวลาการแจ้งเตือนให้เข้ากับชีวิตประจำวันของคุณ',
                                      style: TextStyle(
                                        fontSize: editFontsize ?  13 + change.toDouble() : 13,
                                        fontFamily: 'PlexSansThaiRg',
                                        color: !darkMode ? Colors.black: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: 1.2,
                          color:  !darkMode ? Color(0xffE7E7E7): Color(0xff8B8B8B)
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: 9),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:EdgeInsets.only(top: 2.0, right: screenWidth*0.025),
                              child: Container(
                                width: 24,
                                child: !darkMode ?  Image.asset('icons/location.png'): Image.asset('icons/location_dark.png') ,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ที่ตั้งและสถานที่',
                                  style: TextStyle(
                                    fontSize: editFontsize ?  15 + change.toDouble() : 15,
                                    fontFamily: 'PlexSansThaiMd',
                                    color: !darkMode ? Colors.black: Colors.white,
                                  ),
                                ),
                                Text(
                                  'ตั้งค่าสถานที่เพื่อเข้าถึงร้านยาที่ให้บริการ',
                                  style: TextStyle(
                                    fontSize: editFontsize ?  13 + change.toDouble() : 13,
                                    fontFamily: 'PlexSansThaiRg',
                                    color: !darkMode ? Colors.black: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: 1.2,
                          color:  !darkMode ? Color(0xffE7E7E7): Color(0xff8B8B8B)
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: 9),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'การตั้งค่าทั่วไป',
                              style: TextStyle(
                                fontSize: editFontsize ?  18 + change.toDouble() : 18,
                                fontFamily: 'PlexSansThaiMd',
                                color: !darkMode ? Colors.black: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: 1.2,
                          color:  !darkMode ? Color(0xffE7E7E7): Color(0xff8B8B8B)
                      ),
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Appearance()));
                          setState(() {
                            darkMode = result;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: 9),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:EdgeInsets.only(top: 2.0, right: screenWidth*0.025),
                                child: Container(
                                  width: 24,
                                  child: !darkMode ? Image.asset('icons/color-mode.png') :  Image.asset('icons/codicon_color-mode_dark.png'),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'การตั้งค่าระบบ',
                                    style: TextStyle(
                                      fontSize: editFontsize ?  15 + change.toDouble() : 15,
                                      fontFamily: 'PlexSansThaiMd',
                                      color: !darkMode ? Colors.black: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    darkMode ? 'โหมด: มืด': 'โหมด: สว่าง',
                                    style: TextStyle(
                                      fontSize: editFontsize ?  13 + change.toDouble() : 13,
                                      fontFamily: 'PlexSansThaiRg',
                                      color: !darkMode ? Colors.black: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: 1.2,
                        color:  !darkMode ? Color(0xffE7E7E7): Color(0xff8B8B8B) ,
                      ),
                      GestureDetector(
                        onTap: (){
                            Navigator.pushNamed(context, '/font-size');
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: 9),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:EdgeInsets.only(top: 2.0, right: screenWidth*0.025),
                                child: Container(
                                  width: 24,
                                  child: !darkMode ? Image.asset('icons/ci_font.png'): Image.asset('icons/ci_font_dark.png'),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'การตั้งค่าขนาดของตัวอักษร',
                                    style: TextStyle(
                                      fontSize: editFontsize ?  15 + change.toDouble() : 15,
                                      fontFamily: 'PlexSansThaiMd',
                                      color: !darkMode ? Colors.black: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'ปรับเปลี่ยนขนาดตัวอักษรให้เข้ากับคุณ',
                                    style: TextStyle(
                                      fontSize: editFontsize ?  13 + change.toDouble() : 13,
                                      fontFamily: 'PlexSansThaiRg',
                                      color: !darkMode ? Colors.black: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: 1.2,
                          color:  !darkMode ? Color(0xffE7E7E7): Color(0xff8B8B8B)
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: 9),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:EdgeInsets.only(top: 3.0, left: 2 ,right: screenWidth*0.03),
                              child: Container(
                                width: 20,
                                child: !darkMode ?  Image.asset('icons/note.png'): Image.asset('icons/radix-icons_reader_dark.png'),
                              ),
                            ),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'การยินยอมเก็บรวบรวมข้อมูลส่วนบุคคล (PDPA)',
                                  style: TextStyle(
                                    fontSize: editFontsize ?  15 + change.toDouble() : 15,
                                    fontFamily: 'PlexSansThaiMd',
                                    color: !darkMode ? Colors.black: Colors.white,
                                  ),
                                ),
                                Text(
                                  'เพื่อให้เราเก็บข้อมูลเพื่ออำนวยความสะดวกของตัวคุณ',
                                  style: TextStyle(
                                    fontSize: editFontsize ?  13 + change.toDouble() : 13,
                                    fontFamily: 'PlexSansThaiRg',
                                    color: !darkMode ? Colors.black: Colors.white,
                                  ),
                                ),
                              ],
                            ),)
                          ],
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: 1.2,
                          color:  !darkMode ? Color(0xffE7E7E7): Color(0xff8B8B8B)
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: 9),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:EdgeInsets.only(top: 2.0, right: screenWidth*0.025),
                              child: Container(
                                width: 24,
                                child: !darkMode ? Image.asset('icons/message.png'): Image.asset('icons/solar_chat-round-dots-outline_dark.png'),
                              ),
                            ),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'เงื่อนไขและข้อตกลง',
                                  style: TextStyle(
                                    fontSize: editFontsize ?  15 + change.toDouble() : 15,
                                    fontFamily: 'PlexSansThaiMd',
                                    color: !darkMode ? Colors.black: Colors.white,
                                  ),
                                ),
                                Text(
                                  'เพื่อให้เราเก็บข้อมูลเพื่ออำนวยความสะดวกของตัวคุณ',
                                  style: TextStyle(
                                    fontSize: editFontsize ?  13 + change.toDouble() : 13,
                                    fontFamily: 'PlexSansThaiRg',
                                    color: !darkMode ? Colors.black: Colors.white,
                                  ),
                                ),
                              ],
                            ),)
                          ],
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: 1.2,
                          color:  !darkMode ? Color(0xffE7E7E7): Color(0xff8B8B8B)
                      ),
                      GestureDetector(
                        onTap: () async {
                          await _auth.signOut();
                          Navigator.pushNamed(context, '/homepage');
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: 9),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:EdgeInsets.only(top: 2.0, right: screenWidth*0.025),
                                child: Container(
                                  width: 24,
                                  child: !darkMode ? Image.asset('icons/logout.png'): Image.asset('icons/solar_logout-outline_dark.png'),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ออกจากระบบ',
                                      style: TextStyle(
                                        fontSize: editFontsize ?  15 + change.toDouble() : 15,
                                        fontFamily: 'PlexSansThaiMd',
                                        color: !darkMode ? Colors.black: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'คุณสามารถเข้าสู่ระบบได้อีกครั้ง ด้วยเบอร์โทรศัพท์ของคุณ',
                                      style: TextStyle(
                                        fontSize: editFontsize ?  13 + change.toDouble() : 13,
                                        fontFamily: 'PlexSansThaiRg',
                                        color: !darkMode ? Colors.black: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: 1.2,
                          color:  !darkMode ? Color(0xffE7E7E7): Color(0xff8B8B8B)
                      ),
                      SizedBox(height: 20,),
                    ],
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
      bottomNavigationBar: ReusableBottomNavigationBar(isLoggedIn: isLoggedIn, darkMode: darkMode,page: 'profile'),
    );
  }
}
