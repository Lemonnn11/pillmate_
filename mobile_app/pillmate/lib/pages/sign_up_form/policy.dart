import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pillmate/models/personal_information.dart';
import 'package:pillmate/pages/homepage.dart';

import '../../services/sqlite_service.dart';

class PolicyForm extends StatefulWidget {
  final Map<String, dynamic> info;
  const PolicyForm({super.key, required this.info});

  @override
  State<PolicyForm> createState() => _PolicyFormState();
}

class _PolicyFormState extends State<PolicyForm> {
  late SqliteService _sqliteService;

  @override
  void initState() {
    super.initState();
    this._sqliteService= SqliteService();
    this._sqliteService.initializeDB();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
                            value: 1,
                            backgroundColor: Color(0xffdddddd),
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff059E78)),
                          ),
                        ),
                      ),
                    ),
                    Text('6/6',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'PlexSansThaiRg'
                      ),),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Text(
                'เงื่อนไขและข้อตกลง',
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
                          onPressed: () async {
                            PersonalInformationModel p1 = new PersonalInformationModel(1, widget.info['name'], widget.info['dob'], widget.info['gender'], 0, 0, widget.info['health_condition'], widget.info['drug_allergies'], "", "");
                            final res = await _sqliteService.createPersonalInfoItem(p1);
                            final data = await _sqliteService.getPersonalInfo();
                            print(data);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
                          },
                          child:
                          Text('ยอมรับ', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: 18, color: Colors.white),
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
