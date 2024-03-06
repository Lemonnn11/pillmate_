import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../services/sqlite_service.dart';

class Appearance extends StatefulWidget {
  const Appearance({super.key});

  @override
  State<Appearance> createState() => _AppearanceState();
}

class _AppearanceState extends State<Appearance> {
  bool isSwitched = false;
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
    initSwitchStatus();
  }

  Future<void> initSwitchStatus() async {
    bool status = await _sqliteService.getDarkModeStatus();
    setState(() {
      isSwitched = status;
    });
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
                          Text('การตั้งค่าระบบ',style: TextStyle(fontSize: editFontsize ?  16 + change.toDouble() : 16, fontFamily: 'PlexSansThaiMd', color:  Colors.black),),
                          Text(isSwitched ? 'โหมด: มืด': 'โหมด: สว่าง' ,style: TextStyle(fontSize: editFontsize ?  13 + change.toDouble() : 13, fontFamily: 'PlexSansThaiRg', color:  Colors.black),),
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
                              _sqliteService.turnOnDarkMode();
                          }else{
                              _sqliteService.turnOffDarkMode();
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
