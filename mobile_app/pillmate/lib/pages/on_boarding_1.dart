import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnBoarding1 extends StatefulWidget {
  const OnBoarding1({super.key});

  @override
  State<OnBoarding1> createState() => _OnBoarding1State();
}

class _OnBoarding1State extends State<OnBoarding1> {
  int secondss = 2;
  Timer? timer;
  Duration duration = Duration();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer(){
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        secondss--;
        if(secondss == 0){
          timer?.cancel();
          Navigator.pushNamed(context, '/homepage');
        }
        duration = Duration(seconds: secondss);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Color(0xff059E78)
        ),
        height: screenHeight,
        width: screenWidth,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                child: Image.asset("images/on_boarding1.png"),
              ),
            ),
            Positioned(
              bottom: 550,
              left: 0,
              right: 0,
              child:
              Container(
                width: screenWidth,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  width: 20,
                                  height: 20,
                                  child: Image.asset("images/Star16.png")),
                            ],
                          ),
                          SizedBox(width: 6,),
                          Row(
                            children: [
                              Text('Hi Mate!', style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'LineSeedSansBd',
                              ),),
                              Container(
                                  width: 50,
                                  height: 50,
                                  child: Image.asset("images/pillmate_logo_boarding.png")),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  width: 20,
                                  height: 20,
                                  child: Image.asset("images/Star15.png")),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('I’m  ', style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'LineSeedSansBd',
                        ),),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)
                            ),
                            width: 130,
                            child: Padding(
                              padding: EdgeInsets.only(top: 6.0, bottom: 4,left: 10,right: 10 ),
                              child: Image.asset("images/pillmateBlack.png"),
                            )),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('เพื่อนคู่ใจ ไว้ใจเรื่องยา', style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'LineSeedSansRg',
                        ),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

