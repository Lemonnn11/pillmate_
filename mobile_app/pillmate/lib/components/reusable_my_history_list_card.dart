import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pillmate/pages/delete_drug.dart';

import '../models/medicine.dart';

class ReusableMyHistoryListCard extends StatelessWidget {
  final MedicineModel med;
  final bool lastIndex;
  final bool editFontSize;
  final int change;

  ReusableMyHistoryListCard ({super.key, required this.lastIndex, required this.med, required this.editFontSize, required this.change});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteDrug(med: med)));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Color(0xffD0D0D0)),
            bottom: lastIndex ? BorderSide(width: 1.0, color: Color(0xffD0D0D0)): BorderSide(width: 0.0, color: Color(0xffD0D0D0))
          )
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight*0.015, horizontal: screenWidth*0.027 ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 6.0, right: screenWidth*0.023),
                        child: Container(
                            width: screenWidth*0.15,
                            child: Image.asset('images/para.png')),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '18 มกราคม 66, 09:00 น.',
                            style: TextStyle(
                                fontSize: editFontSize ?  14 + change.toDouble() : 14,
                                fontFamily: 'PlexSansThaiRg',
                                color: Color(0xff575757)
                            ),
                          ),
                          Text(
                            med.genericName,
                            style: TextStyle(
                                fontSize: editFontSize ?  16 + change.toDouble() : 16,
                                fontFamily: 'PlexSansThaiSm',
                                color: Color(0xff121212)
                            ),
                          ),

                          SizedBox(height: 2,),
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
                                    med.dosagePerTake.toString(),
                                    style: TextStyle(
                                        fontSize: editFontSize ?  14 + change.toDouble() : 14,
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
                                    med.takeMedWhen,
                                    style: TextStyle(
                                        fontSize: editFontSize ?  14 + change.toDouble() : 14,
                                        fontFamily: 'PlexSansThaiRg',
                                        color: Color(0xff121212)
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4,),
                        ],
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.only(right: screenWidth*0.017),
                    child: Text(
                      med.amountOfMeds.toString(),
                      style: TextStyle(
                          fontSize: editFontSize ?  14 + change.toDouble() : 14,
                          fontFamily: 'PlexSansThaiMd',
                          color: Colors.black
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
