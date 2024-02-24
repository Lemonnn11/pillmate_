
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pillmate/models/medicine.dart';

import '../pages/drug_information.dart';

class ReusableNotificationCard extends StatelessWidget {
  final Widget image;
  final MedicineModel medicineModel;
  final String when;
  final Function(bool, String, int, String, String) callback;

  const ReusableNotificationCard({super.key, required this.image, required this.medicineModel, required this.callback, required this.when, });


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Card(
        elevation:1.5,
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 12.0),
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight*0.015, horizontal: screenWidth*0.013 ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth* 0.008),
                        child: Container(
                            width: screenWidth*0.1,
                            child: image),
                      ),
                      SizedBox(width: screenWidth*0.01,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            medicineModel.genericName,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'PlexSansThaiMd',
                                color: Color(0xff121212)
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color(0xffFBEC84)
                                ),
                                child:  Padding(
                                  padding: EdgeInsets.symmetric(vertical: screenHeight*0.0005, horizontal: screenWidth*0.025),
                                  child: Text(
                                    medicineModel.dosagePerTake.toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'PlexSansThaiRg',
                                        color: Color(0xff121212)
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: screenWidth*0.02,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color(0xffB8E7FB)
                                ),
                                child:  Padding(
                                  padding: EdgeInsets.symmetric(vertical: screenHeight*0.0005, horizontal: screenWidth*0.025),
                                  child: Text(
                                    medicineModel.takeMedWhen,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'PlexSansThaiRg',
                                        color: Color(0xff121212)
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),

                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => DrugInformation(med: medicineModel)));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: screenWidth*0.013),
                      child: Column(
                        children: [
                          Icon(
                            Ionicons.chevron_forward_outline,
                            color: Color(0xff059E78),
                          ),
                          SizedBox(height: 2,),
                          Text(
                            'เพิ่มเติม',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'PlexSansThaiRg',
                                color: Color(0xff059E78)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                showDialog(
                  context: context, // You need to pass the context here
                  builder: (BuildContext context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Container(
                        width: screenWidth*0.5,
                        height: screenHeight*0.5,
                        child: Column(
                          children: [
                            Image.asset(
                              'images/pic_modal.png',
                              fit: BoxFit.cover,
                            ),
                            Container(
                              width: screenWidth*0.55,
                              child: Center(
                                child: Text('ทานยาเรียบร้อยแล้ว อย่าลืมรักษาสุขภาพนะ!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'PlexSansThaiSm',
                                  fontSize: 20,
                                  color: Colors.white
                                ),),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
                callback(true, medicineModel.qrcodeID, medicineModel.amountTaken, medicineModel.medicationSchedule, when);
                },
              child: Container(
                width: screenWidth,
                height: screenHeight*0.05,
                decoration: BoxDecoration(
                    color:  Color(0xff059E78),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6.0), bottomRight:Radius.circular(6.0))
                ),
                child: Center(
                  child: Text(
                    'ทานแล้ว',
                    style: TextStyle(
                        fontFamily: 'PlexSansThaiMd',
                        fontSize: 18,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
