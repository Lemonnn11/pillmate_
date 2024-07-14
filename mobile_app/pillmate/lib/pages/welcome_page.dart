import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillmate/pages/sign_up_form/name.dart';

import '../constants/constants.dart';
import '../services/sqlite_service.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool darkMode = false;
  late SqliteService _sqliteService;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._sqliteService= SqliteService();
    this._sqliteService.initializeDB();
    initDarkMode();
  }

  Future<void> initDarkMode() async {
    bool status = await _sqliteService.getDarkModeStatus();
    setState(() {
      darkMode = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: !darkMode ? Colors.white: kBlackDarkModeBg,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 120,),
              Container(
                width: screenWidth * 0.5,
                child: !darkMode ? Image.asset('images/pillmate1.png') :Image.asset('images/pillmate_darkmode.png') ,
              ),
              SizedBox(height: 5,),
              Text(
                'เข้าสู่ระบบสำเร็จ!',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'PlexSansThaiMd',
                    color: !darkMode? Color(0xff121212): Colors.white
                ),
              ),
              SizedBox(height: 10,),
              Text(
                'มาเริ่มใส่ข้อมูลของคุณกันเลย!',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'PlexSansThaiMd',
                    color: !darkMode? Color(0xff121212): Colors.white
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: screenWidth*0.06),
                child: Container(
                  width: screenWidth*0.7,
                  child: Image.asset('images/welcome1.png'),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                height: 54,
                width: screenWidth,
                child: ElevatedButton(
                  onPressed: ()  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NameForm())
                    );
                  },
                  child:
                  Text('เริ่มเลย', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: 18, color: !darkMode? Colors.white: Color(0xff121212)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !darkMode? Color(0xff059E78): Color(0xff94DDB5),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Set your desired border radius
                    ),
                    minimumSize: Size(screenWidth, 52),),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: 54,
                width: screenWidth,
                child: ElevatedButton(
                  onPressed: ()  {
                    Navigator.pushNamed(context, '/homepage');
                  },
                  child:
                  Text('ไว้ทีหลัง', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !darkMode? Color(0xffD0D0D0): Color(0xff575757),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Set your desired border radius
                    ),
                    minimumSize: Size(screenWidth, 52),),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: screenWidth*0.02),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    width: screenWidth*0.85,
                    child: Image.asset('images/welcome2.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
