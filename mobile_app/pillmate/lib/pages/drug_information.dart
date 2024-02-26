import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pillmate/models/medicine.dart';
import 'package:pillmate/services/sqlite_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

class DrugInformation extends StatefulWidget {
  final MedicineModel med;

  const DrugInformation({super.key, required this.med});


  @override
  State<DrugInformation> createState() => _DrugInformationState();
}

class _DrugInformationState extends State<DrugInformation> {
  late SqliteService _sqliteService;
  String formattedExpired = '';
  String formattedDispensing = '';
  final _firestore = FirebaseFirestore.instance;
  String storeName = '';
  bool editFontsize = false;
  int change = 0;

  @override
  void initState() {
    super.initState();
    _sqliteService = SqliteService();
    _sqliteService.initializeDB();
    formattedDate();
    _getPharmacyName();
    initFontSize();
  }

  Future<void> initFontSize() async {
    bool status = await _sqliteService.getEditFontSizeStatus();
    int change = await _sqliteService.getFontSizeChange();
    setState(() {
      editFontsize = status;
      this.change = change;
    });
  }

  void _getPharmacyName() async {
    _firestore.collection("pharmacies").where("pharID", isEqualTo: widget.med.pharID).get().then(
          (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          setState(() {
            storeName = docSnapshot.data()['storeName'];
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  void formattedDate(){
    DateTime exp = DateTime.parse(widget.med.expiredDate);
    DateTime des = DateTime.parse(widget.med.date);
    final formatter = new DateFormat('d MMMM y');
    formattedExpired = formatter.format(exp);
    List<String> tmpExp = formattedExpired.split(' ');
    switch (tmpExp[1].toLowerCase()) {
      case 'january':
        formattedExpired = formattedExpired.replaceAll('January', 'ม.ค.');
        break;
      case 'february':
        formattedExpired = formattedExpired.replaceAll('February', 'ก.พ.');
        break;
      case 'march':
        formattedExpired = formattedExpired.replaceAll('March', 'มี.ค.');
        break;
      case 'april':
        formattedExpired = formattedExpired.replaceAll('April', 'เม.ย.');
        break;
      case 'may':
        formattedExpired = formattedExpired.replaceAll('May', 'พ.ค.');
        break;
      case 'june':
        formattedExpired = formattedExpired.replaceAll('June', 'มิ.ย.');
        break;
      case 'july':
        formattedExpired = formattedExpired.replaceAll('July', 'ก.ค.');
        break;
      case 'august':
        formattedExpired = formattedExpired.replaceAll('August', 'ส.ค.');
        break;
      case 'september':
        formattedExpired = formattedExpired.replaceAll('September', 'ก.ย.');
        break;
      case 'october':
        formattedExpired = formattedExpired.replaceAll('October', 'ต.ค.');
        break;
      case 'november':
        formattedExpired = formattedExpired.replaceAll('November', 'พ.ย.');
        break;
      case 'december':
        formattedExpired = formattedExpired.replaceAll('December', 'ธ.ค.');
        break;
    }
    List<String> tmpExp1 = formattedExpired.split(' ');
    formattedExpired = tmpExp1[0] + ' ' + tmpExp1[1] + ' ' + (int.parse(tmpExp1[2]) + 543).toString();
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
              Column(
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
                                  fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                  fontFamily: 'PlexSansThaiRg',
                                ),),
                              Text(widget.med.typeOfMedicine,
                                style: TextStyle(
                                  fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                  fontFamily: 'PlexSansThaiRg',
                                ),),
                            ],
                          ),
                          SizedBox(height: 3,),
                          Row(
                            children: [
                              Text('ปริมาณ: ',
                                style: TextStyle(
                                  fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                  fontFamily: 'PlexSansThaiRg',
                                ),),
                              Text(widget.med.quantity.toString(),
                                style: TextStyle(
                                  fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                  fontFamily: 'PlexSansThaiRg',
                                ),),
                            ],
                          ),
                          SizedBox(height: 3,),
                          Text('วันหมดอายุ: ${formattedExpired}',
                            style: TextStyle(
                              fontSize: editFontsize ?  14 + change.toDouble() : 14,
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
                            fontSize: editFontsize ?  16 + change.toDouble() : 16,
                            fontFamily: 'PlexSansThaiMd',
                          ),)
                      ],
                    ),
                    SizedBox(height: 4,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.med.amountOfMeds.toString(),
                          style: TextStyle(
                              fontSize: editFontsize ?  16 + change.toDouble() : 16,
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
                              fontSize: editFontsize ?  16 + change.toDouble() : 16,
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
                                      fontSize: editFontsize ?  18 + change.toDouble() : 18,
                                      fontFamily: 'PlexSansThaiRg'
                                  ),),
                                Text(widget.med.typeOfMedicine,
                                  style: TextStyle(
                                      fontSize: editFontsize ?  16 + change.toDouble() : 16,
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
                              fontSize: editFontsize ?  16 + change.toDouble() : 16,
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
                                      fontSize: editFontsize ?  18 + change.toDouble() : 18,
                                      fontFamily: 'PlexSansThaiRg'
                                  ),),
                                Text('ครั้ง',
                                  style: TextStyle(
                                      fontSize: editFontsize ?  16 + change.toDouble() : 16,
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
                              fontSize: editFontsize ?  16 + change.toDouble() : 16,
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
                                      fontSize: editFontsize ?  18 + change.toDouble() : 18,
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
                              fontSize: editFontsize ?  16 + change.toDouble() : 16,
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
                                      fontSize: editFontsize ?  18 + change.toDouble() : 18,
                                      fontFamily: 'PlexSansThaiRg'
                                  ),),
                                Text('ชั่วโมง',
                                  style: TextStyle(
                                      fontSize: editFontsize ?  16 + change.toDouble() : 16,
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
                              fontSize: editFontsize ?  16 + change.toDouble() : 16,
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
                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.045),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Image.asset('icons/bi_sunrise.png'),
                                    width: screenWidth*0.05,
                                  ),
                                  Text('เช้า',
                                    style: TextStyle(
                                        fontSize: editFontsize ?  18 + change.toDouble() : 18,
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
                      width: screenWidth*0.337,
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
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Image.asset('icons/ph_sun.png'),
                                    width: screenWidth*0.05,
                                  ),
                                  Text('กลางวัน',
                                    style: TextStyle(
                                        fontSize: editFontsize ?  18 + change.toDouble() : 18,
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
                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.045),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Image.asset('icons/bi_sunset.png'),
                                    width: screenWidth*0.05,
                                  ),
                                  Text('เย็น',
                                    style: TextStyle(
                                        fontSize: editFontsize ?  18 + change.toDouble() : 18,
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
                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.045),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Image.asset('icons/bi_sunset.png'),
                                    width: screenWidth*0.05,
                                  ),
                                  Text('ก่อนนอน',
                                    style: TextStyle(
                                        fontSize: editFontsize ?  18 + change.toDouble() : 18,
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
                              fontSize: editFontsize ?  16 + change.toDouble() : 16,
                            ),
                          ),
                        ),
                        widget.med.takeMedWhen.contains('เช้า') ? Padding(
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
                                        fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                        fontFamily: 'PlexSansThaiRg'
                                    ),),
                                  Text('น.',
                                    style: TextStyle(
                                        fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                        fontFamily: 'PlexSansThaiRg',
                                        color: Color(0xff8B8B8B)
                                    ),),
                                ],
                              ),
                            ),
                          ),
                        ):Container(width: 0, height: 0,)
                      ],
                    ),
                  ),
                  SizedBox(width: 8,),
                  widget.med.takeMedWhen.contains('กลางวัน') ? Padding(
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
                                        fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                        fontFamily: 'PlexSansThaiRg'
                                    ),),
                                  Text('น.',
                                    style: TextStyle(
                                        fontSize: editFontsize ?  16 + change.toDouble() : 16,
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
                  ):Container(width: 0, height: 0,),
                  SizedBox(width: 8,),
                  widget.med.takeMedWhen.contains('เย็น') ? Padding(
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
                                        fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                        fontFamily: 'PlexSansThaiRg'
                                    ),),
                                  Text('น.',
                                    style: TextStyle(
                                        fontSize: editFontsize ?  16 + change.toDouble() : 16,
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
                  ):Container(width: 0, height: 0,),
                  widget.med.takeMedWhen.contains('ก่อนนอน') ? Padding(
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
                                        fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                        fontFamily: 'PlexSansThaiRg'
                                    ),),
                                  Text('น.',
                                    style: TextStyle(
                                        fontSize: editFontsize ?  16 + change.toDouble() : 16,
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
                  ):Container(width: 0, height: 0,),
                ],
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'เพิ่มการแจ้งเตือน +',
                    style: TextStyle(
                        fontFamily: 'PlexSansThaiMd',
                        fontSize: editFontsize ?  16 + change.toDouble() : 16,
                        color: Color(0xff717171)
                    ),
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
                        'ข้อบ่งใช้',
                        style: TextStyle(
                            fontFamily: 'PlexSansThaiSm',
                            fontSize: editFontsize ?  16 + change.toDouble() : 16,
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
                                  widget.med.conditionOfUse,
                                  style: TextStyle(
                                      fontFamily: 'PlexSansThaiRg',
                                      fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                      color: Colors.black
                                  ),
                                ),
                                SizedBox(height: 7,),
                                GestureDetector(
                                  onTap: () async {
                                    final Uri _url = Uri.parse('https://www.yaandyou.net/index_list.php?drugname=${widget.med.genericName}');
                                    if (!await launchUrl(_url)) {
                                    throw Exception('Could not launch $_url');
                                    }
                                  },
                                  child: Text(
                                    'อ่านข้อมูลเพิ่มเติม',
                                    style: TextStyle(
                                        fontFamily: 'PlexSansThaiRg',
                                        fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                        color: Colors.black,
                                        decoration: TextDecoration.underline
                                    ),
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
                            fontSize: editFontsize ?  16 + change.toDouble() : 16,
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
                                    widget.med.additionalAdvice,
                                    style: TextStyle(
                                        fontFamily: 'PlexSansThaiRg',
                                        fontSize: editFontsize ?  14 + change.toDouble() : 14,
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
                            fontSize: editFontsize ?  16 + change.toDouble() : 16,
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
                                    widget.med.adverseDrugReaction,
                                    style: TextStyle(
                                        fontFamily: 'PlexSansThaiRg',
                                        fontSize: editFontsize ?  14 + change.toDouble() : 14,
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
                            fontSize: editFontsize ?  16 + change.toDouble() : 16,
                            color: Colors.black
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth*0.0215),
                        child: Expanded(
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
                                        fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                        color: Colors.black
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      storeName,
                                      style: TextStyle(
                                          fontFamily: 'PlexSansThaiRg',
                                          fontSize: editFontsize ?  14 + change.toDouble() : 14,
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
                                        fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                        color: Colors.black
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      formattedDispensing,
                                      style: TextStyle(
                                          fontFamily: 'PlexSansThaiRg',
                                          fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                          color: Colors.black
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                      onPressed: ()async{
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context){
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)
                                  ),
                                ),
                                height: 200,
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 30,),
                                        Text(
                                          'คุณแน่ใจใช่ไหมที่จะลบข้อมูลยา?',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'PlexSansThaiMd',
                                            color: Color(0xff059E78),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          'คุณสามารถดูข้อมูลยาของคุณได้ที่หน้า “ยาของฉัน”',
                                          style: TextStyle(
                                            fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: screenWidth*0.045),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child:
                                                  Text('ยกเลิก', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: editFontsize ?  17 + change.toDouble() : 17, color: Colors.black),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Color(0xffECECEC),
                                                    elevation: 0.5,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8), // Set your desired border radius
                                                    ),
                                                    minimumSize: Size(screenWidth, 57),),
                                                ),
                                              ),
                                              SizedBox(
                                                width: screenWidth*0.04,
                                              ),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    DateTime dt = DateTime.now();
                                                    final tmp = widget.med.medicationSchedule.split(',');
                                                    print(widget.med.medicationSchedule);
                                                    print(tmp);
                                                    for(int i = 0; i < tmp.length;i++){
                                                      final eachDailyMed = tmp[i].split(' ');
                                                      print(eachDailyMed.length);
                                                      print(eachDailyMed[0]);
                                                      if(eachDailyMed[0] == dt.day.toString()){
                                                        if(eachDailyMed[eachDailyMed.length - 1] != ''){
                                                          _sqliteService.decreaseDailyMed(eachDailyMed.length-1);
                                                        }
                                                      }
                                                    }
                                                    await _sqliteService.deleteMedicineItem(widget.med.qrcodeID);
                                                    Navigator.pushNamed(context, '/my-drug-list');
                                                  },
                                                  child:
                                                  Text('ลบข้อมูล', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: editFontsize ?  17 + change.toDouble() : 17, color: Colors.white),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Color(0xffE2514F),
                                                    elevation: 0.5,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8), // Set your desired border radius
                                                    ),
                                                    minimumSize: Size(screenWidth, 57),),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                        );
                      },
                      child:
                      Text('ลบข้อมูล', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: editFontsize ?  18 + change.toDouble() : 18, color: Colors.white),
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
                  SizedBox(width: screenWidth*0.03,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        DateTime dt = DateTime.now();
                        final tmp = widget.med.medicationSchedule.split(',');
                        print(widget.med.medicationSchedule);
                        print(tmp);
                        for(int i = 0; i < tmp.length;i++){
                          final eachDailyMed = tmp[i].split(' ');
                          print(eachDailyMed.length);
                          print(eachDailyMed[0]);
                          if(eachDailyMed[0] == dt.day.toString()){
                            if(eachDailyMed[eachDailyMed.length - 1] != ''){
                              _sqliteService.decreaseDailyMed(eachDailyMed.length-1);
                            }
                          }
                        }
                        MedicineModel med1 = new MedicineModel(widget.med.qrcodeID, widget.med.pharID, widget.med.dosagePerTake, widget.med.timePerDay,widget.med.timeOfMed, widget.med.timePeriodForMed,  widget.med.takeMedWhen, widget.med.expiredDate, widget.med.date, widget.med.conditionOfUse, widget.med.additionalAdvice, widget.med.amountOfMeds, widget.med.quantity, widget.med.adverseDrugReaction, widget.med.typeOfMedicine, widget.med.genericName, widget.med.tradeName,widget.med.savedDate, widget.med.amountTaken, 0, widget.med.medicationSchedule);
                        final res = await _sqliteService.inactivateStatus(med1);
                        Navigator.pushNamed(context, '/my-drug-list');
                      },
                      child:
                      Text('ทานครบแล้ว', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: editFontsize ?  18 + change.toDouble() : 18, color: Colors.white),
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
                ],
              ),
              SizedBox(height: 15,),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1.5,
                      color: Color(0xffD0D0D0),
                    ),
                  ),
                  Text('บันทึกเมื่อ: ${widget.med.savedDate}',
                    style: TextStyle(
                      fontSize: editFontsize ?  14 + change.toDouble() : 14,
                      fontFamily: 'PlexSansThaiRg',
                      color: Colors.black38,
                    ),),
                  Expanded(
                    child: Container(
                      height: 1.5,
                      color: Color(0xffD0D0D0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
