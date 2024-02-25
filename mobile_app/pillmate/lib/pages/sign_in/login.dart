import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillmate/pages/sign_in/verify_otp.dart';

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
  }



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
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
                    child: Image.asset('images/pillmate1.png'),
                  ),
                  Row(
                    children: [
                      Text(
                        'เข้าสู่ระบบ',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'PlexSansThaiMd',
                          color: Colors.black,
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
                      color: Color(0xff3F3F3F),
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
                        color: Colors.black,
                      ),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 20, left: 15),
                        hintText: '0812345678',
                        hintStyle: TextStyle(
                            fontSize: editFontsize ?  18 + change.toDouble() : 18,
                            fontFamily: 'PlexSansThaiRg',
                            color: Color(0XFF717171)
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
                      color: Colors.red,
                    ),
                  ): _showInvalidPhoneNumber ? Text(
                    'กรุณากรอกเบอร์โทรศัพท์ให้ครบ 10 หลัก',
                    style: TextStyle(
                      fontSize: editFontsize ?  14 + change.toDouble() : 14,
                      fontFamily: 'PlexSansThaiRg',
                      color: Colors.red,
                    ),
                  ): Text(
                    'ระบุเบอร์โทรศัพท์แบบไม่ต้องเว้นช่อง',
                    style: TextStyle(
                      fontSize: editFontsize ?  14 + change.toDouble() : 14,
                      fontFamily: 'PlexSansThaiRg',
                      color: Color(0xff3F3F3F),
                    ),
                  ),
                  SizedBox(height: 70,),
                  Center(
                    child: TextButton(
                      onPressed: ()  {
                        Navigator.pop(context);
                      },
                      child:
                      Text('ภายหลัง', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: editFontsize ?  18 + change.toDouble() : 18, color: Colors.grey[800]),
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
                      Text('ไปต่อ', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: editFontsize ?  18 + change.toDouble() : 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff059E78),
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
