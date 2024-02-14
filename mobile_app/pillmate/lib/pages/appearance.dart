import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Appearance extends StatefulWidget {
  const Appearance({super.key});

  @override
  State<Appearance> createState() => _AppearanceState();
}

class _AppearanceState extends State<Appearance> {
  bool isSwitched = false;

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
            'การตั้งค่าระบบ',
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
        },
        ),
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
                          Text('การตั้งค่าระบบ',style: TextStyle(fontSize: 16, fontFamily: 'PlexSansThaiMd', color:  Colors.black),),
                          Text('โหมด: สว่าง',style: TextStyle(fontSize: 13, fontFamily: 'PlexSansThaiRg', color:  Colors.black),),
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

                          }else{

                          }
                        });
                      }

                  )

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
