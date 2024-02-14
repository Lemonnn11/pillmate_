import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pillmate/models/personal_information.dart';

import '../../services/sqlite_service.dart';

class VerifyOTP extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  const VerifyOTP({super.key, required this.verificationId, required this.phoneNumber});


  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  final _auth = FirebaseAuth.instance;
  late SqliteService _sqliteService;
  List<PersonalInformationModel> _personList = [];
  late String verificationId;
  late String pin1;
  late String pin2;
  late String pin3;
  late String pin4;
  late String pin5;
  late String pin6;
  Duration duration = Duration();
  Timer? timer;
  int secondss = 120;

  void startTimer(){
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        secondss--;
        if(secondss == 0){
          timer?.cancel();
          // secondss = 120;
          // startTimer();
        }
        duration = Duration(seconds: secondss);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    this.verificationId = widget.verificationId;
    startTimer();
    this._sqliteService= SqliteService();
    this._sqliteService.initializeDB();
    getPersons();
  }

  Future<void> getPersons() async {
    final data = await _sqliteService.getPersonalInfo();
    this._personList = data;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04),
          child: Column(
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
              'กรุณากรอกรหัส OTP 6 หลักที่ส่งไปยัง ${widget.phoneNumber}',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'PlexSansThaiMd',
                color: Color(0xff3F3F3F),
              ),
            ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                Container(
              width: screenWidth*0.13,
              height:62,
              child: TextField(
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
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
                onChanged: (text){
                  if(text.length == 1){
                    pin1 = text;
                    FocusScope.of(context).nextFocus();
                  }
                  if(text.length == 0){
                    FocusScope.of(context).previousFocus();
                  }
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
                textAlign: TextAlign.center,
              ),
                ),
                  Container(
                    width: screenWidth*0.13,
                    height:62,
                    child: TextField(
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
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
                      onChanged: (text){
                        if(text.length == 1){
                          pin2 = text;
                          FocusScope.of(context).nextFocus();
                        }
                        if(text.length == 0){
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: screenWidth*0.13,
                    height:62,
                    child: TextField(
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
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
                      onChanged: (text){
                        if(text.length == 1){
                          pin3 = text;
                          FocusScope.of(context).nextFocus();
                        }
                        if(text.length == 0){
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: screenWidth*0.13,
                    height:62,
                    child: TextField(
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
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
                      onChanged: (text){
                        if(text.length == 1){
                          pin4 = text;
                          FocusScope.of(context).nextFocus();
                        }
                        if(text.length == 0){
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: screenWidth*0.13,
                    height:62,
                    child: TextField(
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
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
                      onChanged: (text){
                        if(text.length == 1){
                          pin5 = text;
                          FocusScope.of(context).nextFocus();
                        }
                        if(text.length == 0){
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: screenWidth*0.13,
                    height:62,
                    child: TextField(
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
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
                      onChanged: (text){
                        if(text.length == 1){
                          pin6 = text;
                          FocusScope.of(context).nextFocus();
                        }
                        if(text.length == 0){
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],),
              SizedBox(
                height: 15,
              ),
              Container(
                width: screenWidth,
                child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    Text(
                      'รหัสมีอายุ $minutes:$seconds',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'PlexSansThaiRg',
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          secondss = 120;
                          startTimer();
                        });
                        await _auth.verifyPhoneNumber(
                          phoneNumber: '+66 ' + widget.phoneNumber,
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
                                builder: (context) => VerifyOTP(verificationId: this.verificationId, phoneNumber: widget.phoneNumber),
                              ),
                            );
                          },
                          codeAutoRetrievalTimeout: (verificationId) {},
                        );
                      },
                      child: Text(
                        'ขอรหัสใหม่',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'PlexSansThaiMd',
                          color: Color(0xff059E78),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 90,),
              Container(
                height: 54,
                width: screenWidth,
                child: ElevatedButton(
                  onPressed: () async {
                    try{
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: pin1+pin2+pin3+pin4+pin5+pin6);
                      final user = await _auth.signInWithCredential(credential);
                      if (user != null) {
                        print(_personList.length);
                        if(_personList.length > 0){
                          Navigator.pushNamed(context, '/homepage');
                        }else{
                          Navigator.pushNamed(context, '/welcome');
                        }
                      }
                    }catch (e) {
                      print(e);
                    }
                  },
                  child:
                  Text('ยืนยัน', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: 18, color: Colors.white),
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
        ),
      ),
    );
  }
}
