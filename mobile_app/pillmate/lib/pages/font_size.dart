import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pillmate/models/app_config.dart';

import '../constants/constants.dart';
import '../services/sqlite_service.dart';

class FontSize extends StatefulWidget {
  const FontSize({super.key});

  @override
  State<FontSize> createState() => _FontSizeState();
}

class _FontSizeState extends State<FontSize> {
  bool isSwitched = false;
  double fontSize = 0;
  late SqliteService _sqliteService;
  bool editFontsize = false;
  int change = 0;
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    this._sqliteService= SqliteService();
    this._sqliteService.initializeDB();
    initSwitchStatus();
    initFontSize();
    initDarkMode();
  }

  Future<void> initDarkMode() async {
    bool status = await _sqliteService.getDarkModeStatus();
    setState(() {
      darkMode = status;
    });
  }

  Future<void> initSwitchStatus() async {
    bool status = await _sqliteService.getEditFontSizeStatus();
    int change = await _sqliteService.getFontSizeChange();
    setState(() {
      isSwitched = status;
      fontSize = change.toDouble();
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: !darkMode ? Colors.white : kBlackDarkModeBg,
        automaticallyImplyLeading: false,
        toolbarHeight: 45,
        title: Padding(
          padding: EdgeInsets.only(top: 5, left: screenWidth*0.154),
          child: Text(
            'การตั้งค่าตัวอักษร',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'PlexSansThaiSm',
                color: !darkMode ? Colors.black:Colors.white
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Ionicons.chevron_back_outline, color: !darkMode ? Colors.black:Colors.white,size: 30), onPressed: () {
          Navigator.pop(context);
        },
        ),
      ),
      body: Container(
        height: screenHeight,
        color: !darkMode ? Colors.white : kBlackDarkModeBg,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: 15),
              child: Container(
                width: screenWidth,
                height: 123,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: Container(
                        width: screenWidth*0.65,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('การตั้งค่าขนาดของตัวอักษร',style: TextStyle(fontSize: editFontsize ?  16 + change.toDouble(): 16, fontFamily: 'PlexSansThaiMd', color: !darkMode ? Colors.black:Colors.white),),
                            Text('เปลี่ยนขนาดตัวอักษรด้านล่างให้เข้ากับการใช้งานของคุณ',style: TextStyle(fontSize: editFontsize ?  13 + change.toDouble(): 13, fontFamily: 'PlexSansThaiRg', color: !darkMode ? Colors.black:Colors.white),),
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
                              _sqliteService.turnOnChangeFontSize();
                            }else{
                              _sqliteService.turnOffChangeFontSize();
                            }
                          });
                        }

                    )

                  ],
                ),
              ),
            ),
              Positioned(
                bottom: 30.0,

                child: Container(
                  height: 72,
                  width: screenWidth,
                  color:Color(0xffE7E7E7) ,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text(
                       'ก',
                       style: TextStyle(
                         fontFamily: 'PlexSansThaiSm',
                         fontSize: 18,
                       ),
                     ),
                     Container(
                       width: screenWidth* 0.8,
                       decoration: BoxDecoration(
                           border: Border.symmetric(horizontal: BorderSide(
                               color: Color(0xffD0D0D0),
                               width: 1
                           ))
                       ),
                       child: SliderTheme(
                         data: SliderTheme.of(context).copyWith(
                           thumbShape: RoundSliderThumbShape(enabledThumbRadius: 13),
                           thumbColor: Color(0xffD0D0D0),
                           activeTrackColor: Color(0xff8B8B8B),
                           inactiveTrackColor: Color(0xff8B8B8B),
                           inactiveTickMarkColor: Color(0xff8B8B8B),
                           activeTickMarkColor: Color(0xff8B8B8B),
                           trackHeight: 3,
                           trackShape: RectangularSliderTrackShape(),
                           tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 4),
                         ),
                         child: Slider(
                             value: fontSize.toDouble(),
                             min: -3,
                             max: 3,
                             divisions: 6,
                             onChanged: (double value) async {
                               await _sqliteService.alterFontSize(value.toInt());
                               setState(() {
                                 if(isSwitched){
                                   fontSize = value;
                                 }
                               });
                             }
                             ),
                       ),
                     ),
                     Text(
                       'ก',
                       style: TextStyle(
                         fontFamily: 'PlexSansThaiSm',
                         fontSize: 26,
                       ),
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
