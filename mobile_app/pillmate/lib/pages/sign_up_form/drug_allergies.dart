import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pillmate/pages/sign_up_form/policy.dart';

class DrugAllergies extends StatefulWidget {
  final Map<String, dynamic> info;
  DrugAllergies({super.key, required this.info});

  @override
  State<DrugAllergies> createState() => _DrugAllergiesState();
}

class _DrugAllergiesState extends State<DrugAllergies> {
  bool isButton1Clicked = false;
  bool isButton2Clicked = false;
  bool isButton3Clicked = false;
  bool isButton4Clicked = false;
  bool isButton5Clicked = false;
  bool isButton6Clicked = false;
  bool isButton7Clicked = false;
  bool isButton8Clicked = false;
  bool isButton9Clicked = false;
  String others = "";
  String tmp = "";

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
                            value: 0.833333333333,
                            backgroundColor: Color(0xffdddddd),
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff059E78)),
                          ),
                        ),
                      ),
                    ),
                    Text('5/6',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'PlexSansThaiRg'
                      ),),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Text(
                'ยาที่คุณแพ้',
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
                                  'ฉันไม่มียาที่แพ้'
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
                                  'ฉันไม่มียาที่แพ้'
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
                                  'เพนิซิลลิน (Penicillin)'
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
                                  'เพนิซิลลิน (Penicillin)'
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
                                  'อะมอกซี่ซิลลิน (Amoxycillin)'
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
                                  'อะมอกซี่ซิลลิน (Amoxycillin)'
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
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
                                  'แอสไพริน (Aspirin)'
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
                                  'แอสไพริน (Aspirin)'
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
                                  'ไอโอดีน (Iodine)'
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
                                  'ไอโอดีน (Iodine)'
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
                                  'อินซูลิน (Insulin)'
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
                                  'อินซูลิน (Insulin)'
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
                                  'ไอบูโพรเฟน (Ibuprofen)'
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
                                  'ไอบูโพรเฟน (Ibuprofen)'
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
                                  'อัลโลพูรินอล (Allopurinol)'
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
                                  'อัลโลพูรินอล (Allopurinol)'
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
                    others = value;
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
                              tmp = tmp + 'ฉันไม่มียาที่แพ้ ';
                            }
                            if(this.isButton2Clicked){
                              tmp = tmp + 'เพนิซิลลิน (Penicillin) ';
                            }
                            if(this.isButton3Clicked){
                              tmp = tmp + 'อะมอกซี่ซิลลิน (Amoxycillin) ';
                            }
                            if(this.isButton4Clicked){
                              tmp = tmp + 'แอสไพริน (Aspirin) ';
                            }
                            if(this.isButton5Clicked){
                              tmp = tmp + 'ไอโอดีน (Iodine) ';
                            }
                            if(this.isButton6Clicked){
                              tmp = tmp + 'อินซูลิน (Insulin) ';
                            }
                            if(this.isButton7Clicked){
                              tmp = tmp + 'ไอบูโพรเฟน (Ibuprofen) ';
                            }
                            if(this.isButton8Clicked){
                              tmp = tmp + 'อัลโลพูรินอล (Allopurinol) ';
                            }
                            if(this.isButton9Clicked){
                              tmp = tmp + others;
                            }
                            widget.info['drug_allergies'] = tmp;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PolicyForm(info: widget.info,)));
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
