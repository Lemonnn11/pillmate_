import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillmate/pages/sign_in/verify_otp.dart';

import '../../constants/constants.dart';
import '../../services/sqlite_service.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  late String verificationId;
  String phoneNumber = '';
  bool _showInvalidPhoneNumber = false;
  bool _showEmptyPhoneNumber = false;
  final RegExp phoneNumberFormat = RegExp(r'^[0-9]{10}$');
  bool editFontsize = false;
  int change = 0;
  bool darkMode = false;

  late SqliteService _sqliteService;

  Future<void> initFontSize() async {
    bool status = await _sqliteService.getEditFontSizeStatus();
    int change = await _sqliteService.getFontSizeChange();
    setState(() {
      editFontsize = status;
      this.change = change;
    });
  }

  @override
  void initState() {
    super.initState();
    this._sqliteService= SqliteService();
    this._sqliteService.initializeDB();
    initFontSize();
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
        backgroundColor: !darkMode ? Colors.white: kBlackDarkModeBg,
        resizeToAvoidBottomInset: false,
      body: Container(
        color: !darkMode ? Colors.white: kBlackDarkModeBg,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 150,),
                  Container(
                    width: screenWidth * 0.5,
                    child: !darkMode ? Image.asset('images/pillmate1.png') :Image.asset('images/pillmate_darkmode.png')  ,
                  ),
                  Row(
                    children: [
                      Text(
                        'เข้าสู่ระบบ',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'PlexSansThaiMd',
                          color: !darkMode ? Colors.black: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3,),
                  Text(
                    'กรอกเบอร์โทรศัพท์ 10 หลัก เพื่อเข้าสู่ระบบ',
                    style: TextStyle(
                      fontSize: editFontsize ?  16 + change.toDouble() : 16,
                      fontFamily: 'PlexSansThaiMd',
                      color: !darkMode ? Colors.black: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 60,
                    child: TextField(
                      onChanged: (value){
                          phoneNumber = value!;
                          print(phoneNumber);
                      },
                      style: TextStyle(
                        fontSize: editFontsize ?  18 + change.toDouble() : 18,
                        fontFamily: 'PlexSansThaiRg',
                        color: !darkMode ? Colors.black: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 20, left: 15),
                        hintText: '0812345678',
                        hintStyle: TextStyle(
                            fontSize: editFontsize ?  18 + change.toDouble() : 18,
                            fontFamily: 'PlexSansThaiRg',
                          color: !darkMode ? Color(0xff717171): Colors.white70,
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
                    ),
                  ),
                  _showEmptyPhoneNumber ? Text(
                    'กรุณากรอกเบอร์โทรศัพท์',
                    style: TextStyle(
                      fontSize: editFontsize ?  14 + change.toDouble() : 14,
                      fontFamily: 'PlexSansThaiRg',
                      color:  !darkMode ? Colors.red : Color(0xffED6B81),
                    ),
                  ): _showInvalidPhoneNumber ? Text(
                    'กรุณากรอกเบอร์โทรศัพท์ให้ครบ 10 หลัก',
                    style: TextStyle(
                      fontSize: editFontsize ?  14 + change.toDouble() : 14,
                      fontFamily: 'PlexSansThaiRg',
                      color:  !darkMode ? Colors.red : Color(0xffED6B81),
                    ),
                  ): Text(
                    'ระบุเบอร์โทรศัพท์แบบไม่ต้องเว้นช่อง',
                    style: TextStyle(
                      fontSize: editFontsize ?  14 + change.toDouble() : 14,
                      fontFamily: 'PlexSansThaiRg',
                      color: !darkMode ? Colors.black: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 70,),
                  Center(
                    child: TextButton(
                      onPressed: ()  {
                        Navigator.pop(context);
                      },
                      child:
                      Text('ภายหลัง', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: editFontsize ?  18 + change.toDouble() : 18, color: !darkMode ? Colors.black: Colors.white70,),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 54,
                    width: screenWidth,
                    child: ElevatedButton(
                      onPressed: () async {
                        if(phoneNumber == ''){
                            setState(() {
                              _showEmptyPhoneNumber = true;
                              _showInvalidPhoneNumber = false;
                            });
                        }
                        else if(!phoneNumberFormat.hasMatch(phoneNumber)){
                          setState(() {
                            _showInvalidPhoneNumber = true;
                            _showEmptyPhoneNumber = false;
                          });
                        }else{
                          await _auth.verifyPhoneNumber(
                            phoneNumber: '+66 ' + phoneNumber,
                            timeout: const Duration(seconds: 120),
                            verificationCompleted: (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {
                              if (e.code == 'invalid-phone-number') {
                                print('The provided phone number is not valid.');
                              }
                            },
                            codeSent: (verificationId, [forceResendingToken]) {
                              this.verificationId = verificationId;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VerifyOTP(verificationId: this.verificationId, phoneNumber: phoneNumber),
                                ),
                              );
                            },
                            codeAutoRetrievalTimeout: (verificationId) {},
                          );
                        }
                      },
                      child:
                      Text('ไปต่อ', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: editFontsize ?  18 + change.toDouble() : 18, color: !darkMode ? Colors.white: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !darkMode ? Color(0xff059E78): Color(0xff94DDB5),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Set your desired border radius
                        ),
                        minimumSize: Size(screenWidth, 52),),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 200,
                left: screenWidth * 0.24,
                child: Container(
                  width: screenWidth * 0.05,
                  child: Image.asset('images/Star5.png'),
                ),
              ),
              Positioned(
                top: 200,
                left: screenWidth * 0.29,
                child: Container(
                  width: screenWidth * 0.025,
                  child: Image.asset('images/Star6.png'),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
