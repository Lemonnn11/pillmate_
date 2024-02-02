import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/medicine.dart';
import '../services/sqlite_service.dart';
import 'package:ionicons/ionicons.dart';

class DeleteDrug extends StatefulWidget {
  final MedicineModel med;
  const DeleteDrug({super.key, required this.med});

  @override
  State<DeleteDrug> createState() => _DeleteDrugState();
}

class _DeleteDrugState extends State<DeleteDrug> {
  late SqliteService _sqliteService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._sqliteService= SqliteService();
    this._sqliteService.initializeDB();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 45,
        title: Padding(
          padding: EdgeInsets.only(top: 5, left: screenWidth*0.23),
          child: Text(
            'ข้อมูลยา',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'PlexSansThaiSm',
                color: Colors.black
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Ionicons.chevron_back_outline, color: Colors.black,size: 30), onPressed: () {
          Navigator.pop(context);
        },

        ),
      ),
      body: Container(
        width: screenWidth,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(top: 10.0, left: screenWidth*0.04, right: screenWidth*0.04),
          child: ListView(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Container(
                      width: screenWidth*0.25,
                      child: Image.asset('images/amox.png'),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth*0.09,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.med.genericName,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'PlexSansThaiSm'
                        ),),
                      Row(
                        children: [
                          Text('รูปแบบยา: ',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'PlexSansThaiRg',
                            ),),
                          Text(widget.med.typeOfMedicine,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'PlexSansThaiRg',
                            ),),
                        ],
                      ),
                      SizedBox(height: 3,),
                      Row(
                        children: [
                          Text('ปริมาณ: ',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'PlexSansThaiRg',
                            ),),
                          Text(widget.med.quantity.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'PlexSansThaiRg',
                            ),),
                        ],
                      ),
                      SizedBox(height: 3,),
                      Row(
                        children: [
                          Text('วันหมดอายุ: ',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'PlexSansThaiRg',
                            ),),
                          Text('25/06/67',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'PlexSansThaiRg',
                            ),),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5,),
              Padding(
                padding:  EdgeInsets.only(left: screenWidth*0.05),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('จำนวนยาที่ต้องทาน',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'PlexSansThaiMd',
                          ),)
                      ],
                    ),
                    SizedBox(height: 4,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.med.amountOfMeds.toString() + ' '+ widget.med.typeOfMedicine,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'PlexSansThaiRg'
                          ),)
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8,),
              Container(
                width: screenWidth,
                height: 1,
                color: Color(0xffE7E7E7),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            'รับประทานครั้งละ',
                            style: TextStyle(
                              fontFamily: 'PlexSansThaiMd',
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                  color: Color(0xffD0D0D0),
                                  width: 1
                              )
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.08),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.med.dosagePerTake.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'PlexSansThaiRg'
                                  ),),
                                Text(widget.med.typeOfMedicine,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'PlexSansThaiRg',
                                      color: Color(0xff8B8B8B)
                                  ),),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            'วันละ',
                            style: TextStyle(
                              fontFamily: 'PlexSansThaiMd',
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                  color: Color(0xffD0D0D0),
                                  width: 1
                              )
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.08),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.med.timePerDay.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'PlexSansThaiRg'
                                  ),),
                                Text('ครั้ง',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'PlexSansThaiRg',
                                      color: Color(0xff8B8B8B)
                                  ),),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4,),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            'รับประทาน',
                            style: TextStyle(
                              fontFamily: 'PlexSansThaiMd',
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                  color: Color(0xffD0D0D0),
                                  width: 1
                              )
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.08),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(widget.med.timeOfMed,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'PlexSansThaiRg'
                                  ),),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16,),
                  widget.med.timeOfMed.contains('เวลา') ?
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            'ทุกๆ',
                            style: TextStyle(
                              fontFamily: 'PlexSansThaiMd',
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                  color: Color(0xffD0D0D0),
                                  width: 1
                              )
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.08),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.med.timePeriodForMed.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'PlexSansThaiRg'
                                  ),),
                                Text('ชั่วโมง',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'PlexSansThaiRg',
                                      color: Color(0xff8B8B8B)
                                  ),),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ):
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.08),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4,),
              widget.med.timeOfMed.contains('เวลา') || widget.med.timeOfMed.contains('เมื่อ') ?
              Container():
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  widget.med.takeMedWhen.contains('เช้า') ?
                  Container(
                    width: screenWidth*0.269,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'ช่วงเวลา',
                            style: TextStyle(
                              fontFamily: 'PlexSansThaiMd',
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                    color: Color(0xffD0D0D0),
                                    width: 1
                                )
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.06),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Image.asset('icons/bi_sunrise.png'),
                                    width: screenWidth*0.05,
                                  ),
                                  Text('เช้า',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'PlexSansThaiRg'
                                    ),),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ):Container(width: 0, height: 0,),
                  SizedBox(width: 8,),
                  widget.med.takeMedWhen.contains('กลางวัน') ?
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Container(
                      width: screenWidth*0.334,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                    color: Color(0xffD0D0D0),
                                    width: 1
                                )
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.05),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Image.asset('icons/ph_sun.png'),
                                    width: screenWidth*0.05,
                                  ),
                                  Text('กลางวัน',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'PlexSansThaiRg'
                                    ),),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ): Container(width: 0, height: 0,),
                  SizedBox(width: 8,),
                  widget.med.takeMedWhen.contains('เย็น') ?
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Container(
                      width: screenWidth*0.269,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                    color: Color(0xffD0D0D0),
                                    width: 1
                                )
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.06),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Image.asset('icons/bi_sunset.png'),
                                    width: screenWidth*0.05,
                                  ),
                                  Text('เย็น',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'PlexSansThaiRg'
                                    ),),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ): Container(width: 0, height: 0,),
                  widget.med.takeMedWhen.contains('ก่อนนอน') ?
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: screenWidth*0.381,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                    color: Color(0xffD0D0D0),
                                    width: 1
                                )
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.06),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Image.asset('icons/bi_sunset.png'),
                                    width: screenWidth*0.05,
                                  ),
                                  Text('ก่อนนอน',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'PlexSansThaiRg'
                                    ),),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ): Container(width: 0, height: 0,),
                ],
              ),
              SizedBox(height: 4,),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  Container(
                    width: screenWidth*0.29,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'การแจ้งเตือน',
                            style: TextStyle(
                              fontFamily: 'PlexSansThaiMd',
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                    color: Color(0xffD0D0D0),
                                    width: 1
                                )
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Container(
                                      child: Image.asset('icons/bell.png'),
                                      width: screenWidth*0.04,
                                    ),
                                  ),
                                  Text('09:00',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'PlexSansThaiRg'
                                    ),),
                                  Text('น.',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'PlexSansThaiRg',
                                        color: Color(0xff8B8B8B)
                                    ),),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8,),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Container(
                      width: screenWidth*0.29,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                    color: Color(0xffD0D0D0),
                                    width: 1
                                )
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Container(
                                      child: Image.asset('icons/bell.png'),
                                      width: screenWidth*0.04,
                                    ),
                                  ),
                                  Text('12:00',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'PlexSansThaiRg'
                                    ),),
                                  Text('น.',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'PlexSansThaiRg',
                                        color: Color(0xff8B8B8B)
                                    ),),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Container(
                      width: screenWidth*0.29,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                    color: Color(0xffD0D0D0),
                                    width: 1
                                )
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Container(
                                      child: Image.asset('icons/bell.png'),
                                      width: screenWidth*0.04,
                                    ),
                                  ),
                                  Text('17:00',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'PlexSansThaiRg'
                                    ),),
                                  Text('น.',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'PlexSansThaiRg',
                                        color: Color(0xff8B8B8B)
                                    ),),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: screenWidth*0.2935,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                    color: Color(0xffD0D0D0),
                                    width: 1
                                )
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Container(
                                      child: Image.asset('icons/bell.png'),
                                      width: screenWidth*0.04,
                                    ),
                                  ),
                                  Text('21:00',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'PlexSansThaiRg'
                                    ),),
                                  Text('น.',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'PlexSansThaiRg',
                                        color: Color(0xff8B8B8B)
                                    ),),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                width: screenWidth,
                height: 1,
                color: Color(0xffE7E7E7),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ข้อบ่งใช้',
                        style: TextStyle(
                            fontFamily: 'PlexSansThaiSm',
                            fontSize: 16,
                            color: Colors.black
                        ),
                      ),
                      SizedBox(height: 7,),
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth*0.0215),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text('• '),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'ลดคลื่นไส้อาเจียน',
                                  style: TextStyle(
                                      fontFamily: 'PlexSansThaiRg',
                                      fontSize: 14,
                                      color: Colors.black
                                  ),
                                ),
                                SizedBox(height: 7,),
                                Text(
                                  'อ่านข้อมูลเพิ่มเติม',
                                  style: TextStyle(
                                      fontFamily: 'PlexSansThaiRg',
                                      fontSize: 14,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline
                                  ),
                                ),
                                SizedBox(height: 5,),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                width: screenWidth,
                height: 1,
                color: Color(0xffE7E7E7),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'คำแนะนำเพิ่มเติม',
                        style: TextStyle(
                            fontFamily: 'PlexSansThaiSm',
                            fontSize: 16,
                            color: Colors.black
                        ),
                      ),
                      SizedBox(height: 7,),
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth*0.0215),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text('• '),
                                )
                              ],
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'ยานี้อาจระคายเคืองกระเพาะอาหาร ให้รับประทานหลังอาหารทันที',
                                    style: TextStyle(
                                        fontFamily: 'PlexSansThaiRg',
                                        fontSize: 14,
                                        color: Colors.black
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: screenWidth,
                height: 1,
                color: Color(0xffE7E7E7),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'อาการไม่พึงประสงค์',
                        style: TextStyle(
                            fontFamily: 'PlexSansThaiSm',
                            fontSize: 16,
                            color: Colors.black
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth*0.0215),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text('• '),
                                )
                              ],
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'หากมีอาการผื่นแพ้ เยื่อบุผิวลอก ให้หยุดใช้ยา และหากมีอาการหนักควรปรึกษาแพทย์ทันที',
                                    style: TextStyle(
                                        fontFamily: 'PlexSansThaiRg',
                                        fontSize: 14,
                                        color: Colors.black
                                    ),
                                  ),

                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Container(
                width: screenWidth,
                height: 1,
                color: Color(0xffE7E7E7),
              ),
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ข้อมูลการจ่ายยา',
                        style: TextStyle(
                            fontFamily: 'PlexSansThaiSm',
                            fontSize: 16,
                            color: Colors.black
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth*0.0215),
                        child: Column(
                          children: [
                            SizedBox(height: 7,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ร้านยา: ',
                                  style: TextStyle(
                                      fontFamily: 'PlexSansThaiSm',
                                      fontSize: 14,
                                      color: Colors.black
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน',
                                    style: TextStyle(
                                        fontFamily: 'PlexSansThaiRg',
                                        fontSize: 14,
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'วันที่จ่าย: ',
                                  style: TextStyle(
                                      fontFamily: 'PlexSansThaiSm',
                                      fontSize: 14,
                                      color: Colors.black
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '12 มกราคม 2566',
                                    style: TextStyle(
                                        fontFamily: 'PlexSansThaiRg',
                                        fontSize: 14,
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _sqliteService.deleteMedicineItem(widget.med.qrcodeID);
                        Navigator.pushNamed(context, '/my-drug-list');
                      },
                      child:
                      Text('ลบข้อมูล', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffE2514F),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Set your desired border radius
                        ),
                        minimumSize: Size(screenWidth, 52),),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),

              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
