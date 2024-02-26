import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pillmate/models/medicine.dart';
import 'package:pillmate/pages/drug_information.dart';

class ReusableMyDrugListCard extends StatefulWidget {
  final MedicineModel med;
  final bool editFontSize;
  final int change;
  const ReusableMyDrugListCard({super.key, required this.med, required this.editFontSize, required this.change});

  @override
  State<ReusableMyDrugListCard> createState() => _ReusableMyDrugListCardState();
}

class _ReusableMyDrugListCardState extends State<ReusableMyDrugListCard> {
  String formattedDispensing = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formattedDate();
  }

  void formattedDate(){
    DateTime des = DateTime.parse(widget.med.date);
    final formatter = new DateFormat('d MMMM y');
    formattedDispensing = formatter.format(des);
    List<String> tmpDes = formattedDispensing.split(' ');
    switch (tmpDes[1].toLowerCase()) {
      case 'january':
        formattedDispensing = formattedDispensing.replaceAll('January', 'มกราคม');
        break;
      case 'february':
        formattedDispensing = formattedDispensing.replaceAll('February', 'กุมภาพันธ์');
        break;
      case 'march':
        formattedDispensing = formattedDispensing.replaceAll('March', 'มีนาคม');
        break;
      case 'april':
        formattedDispensing = formattedDispensing.replaceAll('April', 'เมษายน');
        break;
      case 'may':
        formattedDispensing = formattedDispensing.replaceAll('May', 'พฤษภาคม');
        break;
      case 'june':
        formattedDispensing = formattedDispensing.replaceAll('June', 'มิถุนายน');
        break;
      case 'july':
        formattedDispensing = formattedDispensing.replaceAll('July', 'กรกฎาคม');
        break;
      case 'august':
        formattedDispensing = formattedDispensing.replaceAll('August', 'สิงหาคม');
        break;
      case 'september':
        formattedDispensing = formattedDispensing.replaceAll('September', 'กันยายน');
        break;
      case 'october':
        formattedDispensing = formattedDispensing.replaceAll('October', 'ตุลาคม');
        break;
      case 'november':
        formattedDispensing = formattedDispensing.replaceAll('November', 'พฤศจิกายน');
        break;
      case 'december':
        formattedDispensing = formattedDispensing.replaceAll('December', 'ธันวาคม');
        break;
    }
    List<String> tmpDes1 = formattedDispensing.split(' ');
    formattedDispensing = tmpDes1[0] + ' ' + tmpDes1[1] + ' ' + (int.parse(tmpDes1[2]) + 543).toString();
  }

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
            borderRadius: BorderRadius.circular(12.0)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight*0.015, horizontal: screenWidth*0.013 ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 6.0, right: screenWidth*0.007),
                        child: Container(
                            width: screenWidth*0.15,
                            child: Image.asset('images/para.png')),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.med.genericName,
                            style: TextStyle(
                                fontSize: widget.editFontSize ?  16 + widget.change.toDouble() : 16,
                                fontFamily: 'PlexSansThaiMd',
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
                                    widget.med.dosagePerTake.toString(),
                                    style: TextStyle(
                                        fontSize: widget.editFontSize ?  14 + widget.change.toDouble() : 14,
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
                                    widget.med.takeMedWhen,
                                    style: TextStyle(
                                        fontSize: widget.editFontSize ?  14 + widget.change.toDouble() : 14,
                                        fontFamily: 'PlexSansThaiRg',
                                        color: Color(0xff121212)
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12,),
                          Row(
                            children: [
                              Container(
                                width: screenWidth*0.45,
                                height: 6,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.0)
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: LinearProgressIndicator(
                                    value: widget.med.amountTaken/widget.med.amountOfMeds,
                                    backgroundColor: Color(0xffdddddd),
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xffED6B81)),
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth*0.015,),
                              Text(widget.med.amountTaken.toString() + '/' + widget.med.amountOfMeds.toString(),
                                style: TextStyle(
                                  fontSize: widget.editFontSize ?  14 + widget.change.toDouble() : 14,
                                  fontWeight: FontWeight.w700,
                                ),)
                            ],
                          )
                        ],
                      ),
                    ],
                  ),

                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => DrugInformation(med: widget.med)));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: screenWidth*0.017),
                      child: Column(
                        children: [
                          Icon(
                            Ionicons.chevron_forward_outline,
                            color: Colors.black,
                          ),
                          SizedBox(height: 2,),
                          Text(
                            'เพิ่มเติม',
                            style: TextStyle(
                                fontSize: widget.editFontSize ?  12 + widget.change.toDouble() : 12,
                                fontFamily: 'PlexSansThaiRg',
                                color: Colors.black
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: screenWidth,
              decoration: BoxDecoration(
                  color:  Color(0xff059E78),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(6.0), bottomRight:Radius.circular(6.0))
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'วันที่จ่าย: ',
                          style: TextStyle(
                              fontFamily: 'PlexSansThaiSm',
                              fontSize: widget.editFontSize ?  14 + widget.change.toDouble() : 14,
                              color: Colors.white
                          ),
                        ),
                        Text(
                          formattedDispensing,
                          style: TextStyle(
                              fontFamily: 'PlexSansThaiRg',
                              fontSize: widget.editFontSize ?  14 + widget.change.toDouble() : 14,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ร้านยา: ',
                          style: TextStyle(
                              fontFamily: 'PlexSansThaiSm',
                              fontSize: widget.editFontSize ?  14 + widget.change.toDouble() : 14,
                              color: Colors.white
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน',
                            style: TextStyle(
                                fontFamily: 'PlexSansThaiRg',
                                fontSize: widget.editFontSize ?  14 + widget.change.toDouble() : 14,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

