import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pillmate/pages/sign_up_form/dob.dart';

class NameForm extends StatefulWidget {
  const NameForm({super.key});

  @override
  State<NameForm> createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {
  Map<String, dynamic> info = new Map();
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
                          child: Icon(Ionicons.chevron_back_outline, color: Colors.black,size: 30)),
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
                              value: 0.1666666667,
                              backgroundColor: Color(0xffdddddd),
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff059E78)),
                            ),
                          ),
                        ),
                      ),
                      Text('1/6',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'PlexSansThaiRg'
                      ),),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                Text(
                    'คุณชื่ออะไร?',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'PlexSansThaiSm'
                  ),
                ),
              SizedBox(height: 10,),
              Text(
                'กรอกชื่อ-นามสกุล',
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
                    this.info["name"] = value;
                  },
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'PlexSansThaiRg',
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 22, left: 15),
                    hintText: 'สมจิต มีชัย',
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DOBForm(info: this.info,)));
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
