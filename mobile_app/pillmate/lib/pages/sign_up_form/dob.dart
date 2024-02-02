

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pillmate/pages/sign_up_form/gender.dart';

class DOBForm extends StatefulWidget {
  final Map<String, dynamic> info;
  const DOBForm({super.key, required this.info});

  @override
  State<DOBForm> createState() => _DOBFormState();
}

class _DOBFormState extends State<DOBForm> {
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
                            value: 0.3333333333333333,
                            backgroundColor: Color(0xffdddddd),
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff059E78)),
                          ),
                        ),
                      ),
                    ),
                    Text('2/6',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'PlexSansThaiRg'
                      ),),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Text(
                'กรุณากรอกวันเกิดของคุณ',
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
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 22, left: 15),
                    hintText: 'วัน/เดือน/ปี',
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
              SizedBox(height: 200,),
              Container(
                height: 54,
                width: screenWidth,
                child: ElevatedButton(
                  onPressed: ()  {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GenderForm(info: widget.info,)));
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
            ],
          ),
        ),
      ),
    );
  }
}
