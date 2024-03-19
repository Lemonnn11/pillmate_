import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../constants/constants.dart';
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
    initSwitchStatus();
    initDarkMode();
  }

  Future<void> initSwitchStatus() async {
    bool status = await _sqliteService.getDarkModeStatus();
    setState(() {
      isSwitched = status;
    });
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
      backgroundColor:  !darkMode ? Colors.white: kBlackDarkModeBg,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor:  !darkMode ? Colors.white: kBlackDarkModeBg,
        automaticallyImplyLeading: false,
        toolbarHeight: 45,
        title: Padding(
          padding: EdgeInsets.only(top: 5, left: screenWidth*0.154),
          child: Text(
            'การตั้งค่าระบบ',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'PlexSansThaiSm',
                color: !darkMode ?   Colors.black:Colors.white
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Ionicons.chevron_back_outline, color: !darkMode ?   Colors.black:Colors.white,size: 30), onPressed: () {
          Navigator.pop(context, darkMode );
        },
        ),
      ),
      body: Container(
        width: screenWidth,
        color:  !darkMode ? Colors.white: kBlackDarkModeBg,
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
                          Text('การตั้งค่าระบบ',style: TextStyle(fontSize: editFontsize ?  16 + change.toDouble() : 16, fontFamily: 'PlexSansThaiMd', color: !darkMode ?   Colors.black:Colors.white),),
                          Text(isSwitched ? 'โหมด: มืด': 'โหมด: สว่าง' ,style: TextStyle(fontSize: editFontsize ?  13 + change.toDouble() : 13, fontFamily: 'PlexSansThaiRg',color: !darkMode ?   Colors.black:Colors.white),),
                        ],
                      ),
                    ),
                  ),
                  CupertinoSwitch(value: isSwitched,
                      activeColor: Color(0xff19B48D),
                      onChanged: (value){
                        setState((){
                          this.isSwitched = value;
                          darkMode = isSwitched;
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
