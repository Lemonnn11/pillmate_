

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pillmate/pages/sign_up_form/gender.dart';

import '../../constants/constants.dart';
import '../../services/sqlite_service.dart';

class DOBForm extends StatefulWidget {
  final Map<String, dynamic> info;
  const DOBForm({super.key, required this.info});

  @override
  State<DOBForm> createState() => _DOBFormState();
}

class _DOBFormState extends State<DOBForm> {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80,),
              Padding(
                padding: EdgeInsets.only(right: screenWidth*0.025),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(Ionicons.chevron_back_outline,  color: !darkMode? Color(0xff121212): Colors.white, size: 30,)),
                    Padding(
                      padding: EdgeInsets.only( right: screenWidth*0.015),
                      child: Container(
                        width: screenWidth*0.6,
                        height: 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0)
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: LinearProgressIndicator(
                            value: 0.3333333333333333,
                            backgroundColor: !darkMode? Color(0xffdddddd) : Colors.white,
                            valueColor: !darkMode? AlwaysStoppedAnimation<Color>(Color(0xff059E78)) : AlwaysStoppedAnimation<Color>(Color(0xff94DDB5)) ,
                          ),
                        ),
                      ),
                    ),
                    Text('2/6',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'PlexSansThaiRg',
                          color:  !darkMode? Color(0xff2c2c2c) : Colors.white
                      ),),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Text(
                'กรุณากรอกวันเกิดของคุณ',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'PlexSansThaiSm',
                    color: !darkMode? Color(0xff121212): Colors.white
                ),
              ),
              SizedBox(height: 10,),
              Text(
                'เพื่ออำนวยความสะดวกในการแจ้งข้อมูลส่วนตัว',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'PlexSansThaiRg',
                    color: !darkMode? Color(0xff3F3F3F): Colors.white
                ),
              ),
              SizedBox(height: 17,),
              Container(
                height: 60,
                child: TextField(
                  onChanged: (value){
                    widget.info["dob"] = value;
                  },
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'PlexSansThaiRg',
                    color: !darkMode? Color(0xff2c2c2c): Colors.white,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 22, left: 15),
                    hintText: 'วัน/เดือน/ปี',
                    hintStyle: TextStyle(
                        fontSize: 18,
                        fontFamily: 'PlexSansThaiRg',
                        color: !darkMode ? Color(0XFF717171):  Colors.white70
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
              SizedBox(height: 200,),
              Container(
                height: 54,
                width: screenWidth,
                child: ElevatedButton(
                  onPressed: ()  {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GenderForm(info: widget.info,)));
                  },
                  child:
                  Text('ไปต่อ', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: 18,  color: !darkMode?  Colors.white:Color(0xff2c2c2c)),
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
            ],
          ),
        ),
      ),
    );
  }
}
