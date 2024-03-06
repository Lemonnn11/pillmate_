import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pillmate/pages/sign_up_form/health_condition.dart';

import '../../constants/constants.dart';
import '../../services/sqlite_service.dart';

class GenderForm extends StatefulWidget {
  final Map<String, dynamic> info;
  const GenderForm({super.key, required this.info});

  @override
  State<GenderForm> createState() => _GenderFormState();
}

class _GenderFormState extends State<GenderForm> {
  bool isMaleClicked = false;
  bool isFemaleClicked = false;
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
                        child: Icon(Ionicons.chevron_back_outline, color: !darkMode? Color(0xff121212): Colors.white, size: 30,)),
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
                            value: 0.5,
                            backgroundColor: !darkMode? Color(0xffdddddd) : Colors.white,
                            valueColor: !darkMode? AlwaysStoppedAnimation<Color>(Color(0xff059E78)) : AlwaysStoppedAnimation<Color>(Color(0xff94DDB5)),
                          ),
                        ),
                      ),
                    ),
                    Text('3/6',
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
                'เพศของคุณ',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'PlexSansThaiSm',
                    color:  !darkMode? Color(0xff2c2c2c) : Colors.white
                ),
              ),
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        this.isMaleClicked = true;
                        this.isFemaleClicked = false;
                      });
                    },
                    child: this.isMaleClicked ?
                    Container(
                      width: screenWidth*0.44,
                      decoration: BoxDecoration(
                          color: Color(0xffAAE4C4),
                          border: Border.all(
                              color: Color(0xff059E78)
                          ),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.1, vertical: 25),
                        child: Column(
                          children: [
                            Container(
                              child: Image.asset('images/male.png'),
                            ),
                            SizedBox(height: 15,),
                            Text(
                              'ชาย',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'PlexSansThaiRg'
                              ),
                            ),
                          ],
                        ),
                      ),
                    ):
                    Container(
                      width: screenWidth*0.44,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Color(0xffE7E7E7)
                          ),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.1, vertical: 25),
                        child: Column(
                          children: [
                            Container(
                              child: Image.asset('images/male.png'),
                            ),
                            SizedBox(height: 15,),
                            Text(
                              'ชาย',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'PlexSansThaiRg'
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        this.isFemaleClicked = true;
                        this.isMaleClicked = false;
                      });
                    },
                    child: this.isFemaleClicked ?
                    Container(
                      width: screenWidth*0.44,
                      decoration: BoxDecoration(
                          color: Color(0xffAAE4C4),
                          border: Border.all(
                              color: Color(0xff059E78)
                          ),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.1, vertical: 25),
                            child: Column(
                              children: [
                                Container(
                                  child: Image.asset('images/female.png'),
                                ),
                                SizedBox(height: 15,),
                                Text(
                                  'หญิง',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'PlexSansThaiRg'
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              top: 70,
                              left: screenWidth*0.07,
                              child: Container(
                                width: 10,
                                child: Image.asset('images/Star7.png'),
                              )),
                          Positioned(
                              top: 35,
                              left: screenWidth*0.32,
                              child: Container(
                                width: 10,
                                child: Image.asset('images/Star8.png'),
                              )),
                        ],
                      ),
                    ):Container(
                      width: screenWidth*0.44,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Color(0xffE7E7E7)
                          ),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.1, vertical: 25),
                            child: Column(
                              children: [
                                Container(
                                  child: Image.asset('images/female.png'),
                                ),
                                SizedBox(height: 15,),
                                Text(
                                  'หญิง',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'PlexSansThaiRg'
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              top: 70,
                              left: screenWidth*0.07,
                              child: Container(
                                width: 10,
                                child: Image.asset('images/Star7.png'),
                              )),
                          Positioned(
                              top: 35,
                              left: screenWidth*0.32,
                              child: Container(
                                width: 10,
                                child: Image.asset('images/Star8.png'),
                              )),
                        ],
                      ),
                    )
                  ),
                ],
              ),
              SizedBox(height: 200,),
              Container(
                height: 54,
                width: screenWidth,
                child: ElevatedButton(
                  onPressed: ()  {
                    if(this.isMaleClicked){
                      widget.info["gender"] = "ชาย";
                    }else{
                      widget.info["gender"] = "หญิง";
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HealthConditionForm(info: widget.info,)));
                  },
                  child:
                  Text('ไปต่อ', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: 18, color: !darkMode?  Colors.white:Color(0xff2c2c2c)),
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
