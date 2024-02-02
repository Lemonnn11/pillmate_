import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillmate/pages/sign_up_form/name.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 120,),
              Container(
                width: screenWidth * 0.5,
                child: Image.asset('images/pillmate1.png'),
              ),
              SizedBox(height: 5,),
              Text(
                'เข้าสู่ระบบสำเร็จ!',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'PlexSansThaiMd',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10,),
              Text(
                'มาเริ่มใส่ข้อมูลของคุณกันเลย!',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'PlexSansThaiMd',
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: screenWidth*0.06),
                child: Container(
                  width: screenWidth*0.7,
                  child: Image.asset('images/welcome1.png'),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                height: 54,
                width: screenWidth,
                child: ElevatedButton(
                  onPressed: ()  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NameForm())
                    );
                  },
                  child:
                  Text('เริ่มเลย', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff059E78),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Set your desired border radius
                    ),
                    minimumSize: Size(screenWidth, 52),),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: 54,
                width: screenWidth,
                child: ElevatedButton(
                  onPressed: ()  {
                    Navigator.pushNamed(context, '/homepage');
                  },
                  child:
                  Text('ไว้ทีหลัง', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffD0D0D0),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Set your desired border radius
                    ),
                    minimumSize: Size(screenWidth, 52),),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: screenWidth*0.02),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    width: screenWidth*0.85,
                    child: Image.asset('images/welcome2.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
