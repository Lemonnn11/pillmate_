import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillmate/constants/constants.dart';
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

  @override
  void initState() {
    super.initState();
    this._sqliteService= SqliteService();
    this._sqliteService.initializeDB();
    getPersons();
    authChangesListener();
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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 181,
              width: screenWidth,
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
              child: Padding(
                padding: EdgeInsets.only(top: 35.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      // backgroundImage: AssetImage('images/profile-pic.png'),
                    ),
                    Text(name,style: TextStyle(fontSize: 18, fontFamily: 'PlexSansThaiMd', color:  Colors.white),)
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
                                fontSize: 18,
                                fontFamily: 'PlexSansThaiMd',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: 1.2,
                        color: Color(0xffE7E7E7),
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
                                  child: Image.asset('icons/user-green.png'),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ข้อมูลส่วนตัว',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'PlexSansThaiMd',
                                    ),
                                  ),
                                  Text(
                                    'แก้ไขและเปลี่ยนแปลงข้อมูลของคุณได้ที่นี่',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'PlexSansThaiRg',
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
                        color: Color(0xffE7E7E7),
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
                                  child: Image.asset('icons/clock-alarm.png'),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ตั้งค่าเวลาและการแจ้งเตือน',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'PlexSansThaiMd',
                                      ),
                                    ),
                                    Text(
                                      'เปลี่ยนเวลาการแจ้งเตือนให้เข้ากับชีวิตประจำวันของคุณ',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'PlexSansThaiRg',
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
                        color: Color(0xffE7E7E7),
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
                                child: Image.asset('icons/location.png'),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ที่ตั้งและสถานที่',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'PlexSansThaiMd',
                                  ),
                                ),
                                Text(
                                  'ตั้งค่าสถานที่เพื่อเข้าถึงร้านยาที่ให้บริการ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'PlexSansThaiRg',
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
                        color: Color(0xffE7E7E7),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: 9),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'การตั้งค่าทั่วไป',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'PlexSansThaiMd',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: 1.2,
                        color: Color(0xffE7E7E7),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, '/appearance');
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
                                  child: Image.asset('icons/color-mode.png'),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'การตั้งค่าระบบ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'PlexSansThaiMd',
                                    ),
                                  ),
                                  Text(
                                    'โหมด: สว่าง',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'PlexSansThaiRg',
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
                        color: Color(0xffE7E7E7),
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
                                child: Image.asset('icons/ci_font.png'),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'การตั้งค่าขนาดของตัวอักษร',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'PlexSansThaiMd',
                                  ),
                                ),
                                Text(
                                  'ปรับเปลี่ยนขนาดตัวอักษรให้เข้ากับคุณ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'PlexSansThaiRg',
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
                        color: Color(0xffE7E7E7),
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
                                child: Image.asset('icons/note.png'),
                              ),
                            ),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'การยินยอมเก็บรวบรวมข้อมูลส่วนบุคคล (PDPA)',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'PlexSansThaiMd',
                                  ),
                                ),
                                Text(
                                  'เพื่อให้เราเก็บข้อมูลเพื่ออำนวยความสะดวกของตัวคุณ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'PlexSansThaiRg',
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
                        color: Color(0xffE7E7E7),
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
                                child: Image.asset('icons/message.png'),
                              ),
                            ),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'เงื่อนไขและข้อตกลง',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'PlexSansThaiMd',
                                  ),
                                ),
                                Text(
                                  'เพื่อให้เราเก็บข้อมูลเพื่ออำนวยความสะดวกของตัวคุณ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'PlexSansThaiRg',
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
                        color: Color(0xffE7E7E7),
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
                                  child: Image.asset('icons/logout.png'),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ออกจากระบบ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'PlexSansThaiMd',
                                      ),
                                    ),
                                    Text(
                                      'คุณสามารถเข้าสู่ระบบได้อีกครั้ง ด้วยเบอร์โทรศัพท์ของคุณ',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'PlexSansThaiRg',
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
                        color: Color(0xffE7E7E7),
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
      bottomNavigationBar: ReusableBottomNavigationBar(isLoggedIn: isLoggedIn, page: 'profile'),
    );
  }
}
