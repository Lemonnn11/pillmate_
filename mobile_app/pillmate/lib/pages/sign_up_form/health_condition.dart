import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pillmate/pages/sign_up_form/dob.dart';
import 'package:pillmate/pages/sign_up_form/drug_allergies.dart';

import '../../services/sqlite_service.dart';


class HealthConditionForm extends StatefulWidget {
  final Map<String, dynamic> info;
  const HealthConditionForm({super.key, required this.info});


  @override
  State<HealthConditionForm> createState() => _HealthConditionFormState();
}

class _HealthConditionFormState extends State<HealthConditionForm> {
  bool isButton1Clicked = false;
  bool isButton2Clicked = false;
  bool isButton3Clicked = false;
  bool isButton4Clicked = false;
  bool isButton5Clicked = false;
  bool isButton6Clicked = false;
  bool isButton7Clicked = false;
  bool isButton8Clicked = false;
  bool isButton9Clicked = false;
  bool isButton10Clicked = false;
  bool isButton11Clicked = false;
  String others = "";
  String tmp = "";
  bool darkMode = false;
  late SqliteService _sqliteService;

  Future<void> initDarkMode() async {
    bool status = await _sqliteService.getDarkModeStatus();
    setState(() {
      darkMode = status;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._sqliteService= SqliteService();
    this._sqliteService.initializeDB();
    initDarkMode();
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
                        child: Icon(Ionicons.chevron_back_outline, color: Colors.black, size: 30,)),
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
                            value: 0.6666666667,
                            backgroundColor: Color(0xffdddddd),
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff059E78)),
                          ),
                        ),
                      ),
                    ),
                    Text('4/6',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'PlexSansThaiRg'
                      ),),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Text(
                'เลือกโรคประจำตัวที่คุณมี',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'PlexSansThaiSm'
                ),
              ),
              SizedBox(height: 10,),
              Text(
                'เพื่ออำนวยความสะดวกในการแจ้งข้อมูลส่วนตัว',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'PlexSansThaiRg',
                    color: Color(0xff3F3F3F)
                ),
              ),
              SizedBox(height: 13,),
              Wrap(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          this.isButton1Clicked = !this.isButton1Clicked;
                        });
                      },
                      child: this.isButton1Clicked ?
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xffAAE4C4),
                            border: Border.all(
                                width: 1,
                                color: Color(0xff059E78)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'ฉันไม่มีโรคประจำตัว'
                              ),
                            ],
                          ),
                        ),
                      ):
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Color(0xffD0D0D0)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'ฉันไม่มีโรคประจำตัว'
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          this.isButton2Clicked = !this.isButton2Clicked;
                        });
                      },
                      child: this.isButton2Clicked ?
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xffAAE4C4),
                            border: Border.all(
                                width: 1,
                                color: Color(0xff059E78)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'ความดันโลหิตสูง'
                              ),
                            ],
                          ),
                        ),
                      ):
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Color(0xffD0D0D0)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'ความดันโลหิตสูง'
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          this.isButton3Clicked = !this.isButton3Clicked;
                        });
                      },
                      child: this.isButton3Clicked ?
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xffAAE4C4),
                            border: Border.all(
                                width: 1,
                                color: Color(0xff059E78)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'ปอดอักเสบ'
                              ),
                            ],
                          ),
                        ),
                      ):
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Color(0xffD0D0D0)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'ปอดอักเสบ'
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          this.isButton4Clicked = !this.isButton4Clicked;
                        });
                      },
                      child: this.isButton4Clicked ?
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xffAAE4C4),
                            border: Border.all(
                                width: 1,
                                color: Color(0xff059E78)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'หลอดเลือดในสมอง'
                              ),
                            ],
                          ),
                        ),
                      ):
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Color(0xffD0D0D0)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'หลอดเลือดในสมอง'
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          this.isButton5Clicked = !this.isButton5Clicked;
                        });
                      },
                      child: this.isButton5Clicked ?
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xffAAE4C4),
                            border: Border.all(
                                width: 1,
                                color: Color(0xff059E78)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'กระเพาะอาหาร'
                              ),
                            ],
                          ),
                        ),
                      ):
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Color(0xffD0D0D0)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'กระเพาะอาหาร'
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          this.isButton6Clicked = !this.isButton6Clicked;
                        });
                      },
                      child: this.isButton6Clicked ?
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xffAAE4C4),
                            border: Border.all(
                                width: 1,
                                color: Color(0xff059E78)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'เบาหวาน'
                              ),
                            ],
                          ),
                        ),
                      ):
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Color(0xffD0D0D0)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'เบาหวาน'
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          this.isButton7Clicked = !this.isButton7Clicked;
                        });
                      },
                      child: this.isButton7Clicked ?
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xffAAE4C4),
                            border: Border.all(
                                width: 1,
                                color: Color(0xff059E78)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'ถุงลมโป่งพอง'
                              ),
                            ],
                          ),
                        ),
                      ):
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Color(0xffD0D0D0)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'ถุงลมโป่งพอง'
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          this.isButton8Clicked = !this.isButton8Clicked;
                        });
                      },
                      child: this.isButton8Clicked ?
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xffAAE4C4),
                            border: Border.all(
                                width: 1,
                                color: Color(0xff059E78)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'โรคไต'
                              ),
                            ],
                          ),
                        ),
                      ):
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Color(0xffD0D0D0)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'โรคไต'
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          this.isButton9Clicked = !this.isButton9Clicked;
                        });
                      },
                      child: this.isButton9Clicked ?
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xffAAE4C4),
                            border: Border.all(
                                width: 1,
                                color: Color(0xff059E78)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'โรคหัวใจ'
                              ),
                            ],
                          ),
                        ),
                      ):
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Color(0xffD0D0D0)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'โรคหัวใจ'
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          this.isButton10Clicked = !this.isButton10Clicked;
                        });
                      },
                      child: this.isButton10Clicked ?
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xffAAE4C4),
                            border: Border.all(
                                width: 1,
                                color: Color(0xff059E78)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'โรคตับ'
                              ),
                            ],
                          ),
                        ),
                      ):
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Color(0xffD0D0D0)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'โรคตับ'
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Padding(
                    padding: EdgeInsets.only(bottom: 18.0),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          this.isButton11Clicked = !this.isButton11Clicked;
                        });
                      },
                      child: this.isButton11Clicked ?
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xffAAE4C4),
                            border: Border.all(
                                width: 1,
                                color: Color(0xff059E78)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'อื่นๆ'
                              ),
                            ],
                          ),
                        ),
                      ):
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Color(0xffD0D0D0)
                            ),
                            borderRadius: BorderRadius.circular(24)
                        ),
                        height: 31,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'อื่นๆ'
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 150,
                child: TextField(
                  minLines: 5,
                  maxLines: 5,
                  onChanged: (value){
                    this.others = value;
                  },
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'PlexSansThaiRg',
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 22, left: 15),
                    hintText: 'โรคประจำตัวอื่นๆ',
                    hintStyle: TextStyle(
                        fontSize: 18,
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
              SizedBox(height: 100,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Container(
                        height: 54,
                        width: screenWidth,
                        child: ElevatedButton(
                          onPressed: ()  {
                            if(this.isButton1Clicked){
                              tmp = tmp + 'ฉันไม่มีโรคประจำตัว ';
                            }
                            if(this.isButton2Clicked){
                              tmp = tmp + 'ความดันโลหิตสูง ';
                            }
                            if(this.isButton3Clicked){
                              tmp = tmp + 'ปอดอักเสบ ';
                            }
                            if(this.isButton4Clicked){
                              tmp = tmp + 'หลอดเลือดในสมอง ';
                            }
                            if(this.isButton5Clicked){
                              tmp = tmp + 'กระเพาะอาหาร ';
                            }
                            if(this.isButton6Clicked){
                              tmp = tmp + 'เบาหวาน ';
                            }
                            if(this.isButton7Clicked){
                              tmp = tmp + 'ถุงลมโป่งพอง ';
                            }
                            if(this.isButton8Clicked){
                              tmp = tmp + 'โรคไต ';
                            }
                            if(this.isButton9Clicked){
                              tmp = tmp + 'โรคหัวใจ ';
                            }
                            if(this.isButton10Clicked){
                              tmp = tmp + 'โรคตับ ';
                            }
                            if(this.isButton11Clicked){
                              tmp = tmp + others;
                            }
                            widget.info['health_condition'] = tmp;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DrugAllergies(info: widget.info,)));
                          },
                          child:
                          Text('ไปต่อ', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: 18, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff059e78),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Set your desired border radius
                            ),
                            minimumSize: Size(screenWidth, 52),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
