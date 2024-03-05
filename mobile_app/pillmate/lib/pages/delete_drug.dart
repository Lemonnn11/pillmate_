import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/constants.dart';
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
  String formattedExpired = '';
  String formattedDispensing = '';
  final _firestore = FirebaseFirestore.instance;
  String storeName = '';
  bool editFontsize = false;
  int change = 0;
  bool darkMode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._sqliteService= SqliteService();
    this._sqliteService.initializeDB();
    _getPharmacyName();
    initFontSize();
    initDarkMode();
    formattedDate();
  }

  Future<void> initDarkMode() async {
    bool status = await _sqliteService.getDarkModeStatus();
    setState(() {
      darkMode = status;
    });
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
      backgroundColor: !darkMode ? Colors.white: kBlackDarkModeBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: !darkMode ? Colors.white: kBlackDarkModeBg,
        automaticallyImplyLeading: false,
        toolbarHeight: 45,
        title: Padding(
          padding: EdgeInsets.only(top: 5, left: screenWidth*0.23),
          child: Text(
            'ข้อมูลยา',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'PlexSansThaiSm',
                color: !darkMode ? Colors.black: Colors.white,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Ionicons.chevron_back_outline, color: !darkMode ? Colors.black: Colors.white,size: 30), onPressed: () {
          Navigator.pop(context);
        },

        ),
      ),
      body: Container(
        width: screenWidth,
        color: !darkMode ? Colors.white: kBlackDarkModeBg,
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
                            fontFamily: 'PlexSansThaiSm',
                          color: !darkMode ? Colors.black: Colors.white,
                        ),),
                      Row(
                        children: [
                          Text('รูปแบบยา: ',
                            style: TextStyle(
                              fontSize: editFontsize ?  14 + change.toDouble() : 14,
                              fontFamily: 'PlexSansThaiRg',
                              color: !darkMode ? Colors.black: Colors.white,
                            ),),
                          Text(widget.med.typeOfMedicine,
                            style: TextStyle(
                              fontSize: editFontsize ?  14 + change.toDouble() : 14,
                              fontFamily: 'PlexSansThaiRg',
                              color: !darkMode ? Colors.black: Colors.white,
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
                              color: !darkMode ? Colors.black: Colors.white,
                            ),),
                          Text(widget.med.quantity.toString(),
                            style: TextStyle(
                              fontSize: editFontsize ?  14 + change.toDouble() : 14,
                              fontFamily: 'PlexSansThaiRg',
                              color: !darkMode ? Colors.black: Colors.white,
                            ),),
                        ],
                      ),
                      SizedBox(height: 3,),
                      Row(
                        children: [
                          Text('วันหมดอายุ: ',
                            style: TextStyle(
                              fontSize: editFontsize ?  14 + change.toDouble() : 14,
                              fontFamily: 'PlexSansThaiRg',
                              color: !darkMode ? Colors.black: Colors.white,
                            ),),
                          Text(formattedExpired,
                            style: TextStyle(
                              fontSize: editFontsize ?  14 + change.toDouble() : 14,
                              fontFamily: 'PlexSansThaiRg',
                              color: !darkMode ? Colors.black: Colors.white,
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
                            color: !darkMode ? Colors.black: Colors.white,
                          ),)
                      ],
                    ),
                    SizedBox(height: 4,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.med.amountOfMeds.toString() + ' '+ widget.med.typeOfMedicine,
                          style: TextStyle(
                              fontSize: editFontsize ?  16 + change.toDouble() : 16,
                              fontFamily: 'PlexSansThaiRg',
                            color: !darkMode ? Colors.black: Colors.white,
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
                              color: !darkMode ? Colors.black: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                  color: !darkMode ? Color(0xffD0D0D0): kBlackDarkMode,
                                  width: 1
                              ),
                            color: !darkMode ? Colors.white: kBlackDarkMode,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.08),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.med.dosagePerTake.toString(),
                                  style: TextStyle(
                                      fontSize: editFontsize ?  18 + change.toDouble() : 18,
                                      fontFamily: 'PlexSansThaiRg',
                                    color: !darkMode ? Colors.black: Colors.white,
                                  ),),
                                Text(widget.med.typeOfMedicine,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'PlexSansThaiRg',
                                      color: !darkMode ? Color(0xff8B8B8B): Colors.white,
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
                              color: !darkMode ? Colors.black: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                  color: !darkMode ? Color(0xffD0D0D0): kBlackDarkMode,
                                  width: 1
                              ),
                            color: !darkMode ? Colors.white: kBlackDarkMode,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.08),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.med.timePerDay.toString(),
                                  style: TextStyle(
                                      fontSize: editFontsize ?  18 + change.toDouble() : 18,
                                      fontFamily: 'PlexSansThaiRg',
                                    color: !darkMode ? Colors.black: Colors.white,
                                  ),),
                                Text('ครั้ง',
                                  style: TextStyle(
                                      fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                      fontFamily: 'PlexSansThaiRg',
                                      color: !darkMode ? Color(0xff8B8B8B): Colors.white,
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
                              color: !darkMode ? Colors.black: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                  color: !darkMode ? Color(0xffD0D0D0): kBlackDarkMode,
                                  width: 1
                              ),
                            color: !darkMode ? Colors.white: kBlackDarkMode,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.08),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(widget.med.timeOfMed,
                                  style: TextStyle(
                                      fontSize: editFontsize ?  18 + change.toDouble() : 18,
                                      fontFamily: 'PlexSansThaiRg',
                                    color: !darkMode ? Colors.black: Colors.white,
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
                              color: !darkMode ? Colors.black: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                  color: !darkMode ? Color(0xffD0D0D0): kBlackDarkMode,
                                  width: 1
                              ),
                            color: !darkMode ? Colors.white: kBlackDarkMode,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.08),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.med.timePeriodForMed.toString(),
                                  style: TextStyle(
                                      fontSize: editFontsize ?  18 + change.toDouble() : 18,
                                      fontFamily: 'PlexSansThaiRg',
                                    color: !darkMode ? Colors.black: Colors.white,
                                  ),),
                                Text('ชั่วโมง',
                                  style: TextStyle(
                                      fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                      fontFamily: 'PlexSansThaiRg',
                                      color: !darkMode ? Color(0xff8B8B8B): Colors.white,
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
                              color: !darkMode ? Colors.black: Colors.white,
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
                                    color: !darkMode ? Color(0xffD0D0D0): kBlackDarkMode,
                                    width: 1
                                ),
                              color: !darkMode ? Colors.white: kBlackDarkMode,
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
                                        fontFamily: 'PlexSansThaiRg',
                                      color: !darkMode ? Colors.black: Colors.white,
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
                                    color: !darkMode ? Color(0xffD0D0D0): kBlackDarkMode,
                                    width: 1
                                ),
                              color: !darkMode ? Colors.white: kBlackDarkMode,
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
                                        fontFamily: 'PlexSansThaiRg',
                                      color: !darkMode ? Colors.black: Colors.white,
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
                                    color: !darkMode ? Color(0xffD0D0D0): kBlackDarkMode,
                                    width: 1
                                ),
                              color: !darkMode ? Colors.white: kBlackDarkMode,
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
                                        fontFamily: 'PlexSansThaiRg',
                                      color: !darkMode ? Colors.black: Colors.white,
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
                                    color:!darkMode ? Color(0xffD0D0D0): kBlackDarkMode,
                                    width: 1
                                ),
                              color: !darkMode ? Colors.white: kBlackDarkMode,
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
                                        fontFamily: 'PlexSansThaiRg',
                                      color: !darkMode ? Colors.black: Colors.white,
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
                              color: !darkMode ? Colors.black: Colors.white,
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
                                    color: !darkMode ? Color(0xffD0D0D0): kBlackDarkMode,
                                    width: 1
                                ),
                              color: !darkMode ? Colors.white: kBlackDarkMode,
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
                                        fontFamily: 'PlexSansThaiRg',
                                      color: !darkMode ? Colors.black: Colors.white,
                                    ),),
                                  Text('น.',
                                    style: TextStyle(
                                        fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                        fontFamily: 'PlexSansThaiRg',
                                        color: !darkMode ? Color(0xff8B8B8B): Colors.white,
                                    ),),
                                ],
                              ),
                            ),
                          ),
                        ):Container(width: 0, height: 0,),
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
                                    color:!darkMode ? Color(0xffD0D0D0): kBlackDarkMode,
                                    width: 1
                                ),
                              color: !darkMode ? Colors.white: kBlackDarkMode,
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
                                        fontFamily: 'PlexSansThaiRg',
                                      color: !darkMode ? Colors.black: Colors.white,
                                    ),),
                                  Text('น.',
                                    style: TextStyle(
                                        fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                        fontFamily: 'PlexSansThaiRg',
                                        color: !darkMode ? Color(0xff8B8B8B): Colors.white,
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
                                    color: !darkMode ? Color(0xffD0D0D0): kBlackDarkMode,
                                    width: 1
                                ),
                              color: !darkMode ? Colors.white: kBlackDarkMode,
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
                                        fontFamily: 'PlexSansThaiRg',
                                      color: !darkMode ? Colors.black: Colors.white,
                                    ),),
                                  Text('น.',
                                    style: TextStyle(
                                        fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                        fontFamily: 'PlexSansThaiRg',
                                        color: !darkMode ? Color(0xff8B8B8B): Colors.white,
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
                                    color: !darkMode ? Color(0xffD0D0D0): kBlackDarkMode,
                                    width: 1
                                ),
                              color: !darkMode ? Colors.white: kBlackDarkMode,
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
                                        fontFamily: 'PlexSansThaiRg',
                                      color: !darkMode ? Colors.black: Colors.white,
                                    ),),
                                  Text('น.',
                                    style: TextStyle(
                                        fontSize: editFontsize ?  16 + change.toDouble() : 16,
                                        fontFamily: 'PlexSansThaiRg',
                                        color: !darkMode ? Color(0xff8B8B8B): Colors.white,
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
                            fontSize: editFontsize ?  16 + change.toDouble() : 16,
                          color: !darkMode ? Colors.black: Colors.white,
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
                                  child: Text('• ',
                                    style: TextStyle(
                                      color: !darkMode ? Colors.black: Colors.white,
                                    ),),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  widget.med.conditionOfUse,
                                  style: TextStyle(
                                      fontFamily: 'PlexSansThaiRg',
                                      fontSize:  editFontsize ?  14 + change.toDouble() : 14,
                                    color: !darkMode ? Colors.black: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 7,),
                                Text(
                                  'อ่านข้อมูลเพิ่มเติม',
                                  style: TextStyle(
                                      fontFamily: 'PlexSansThaiRg',
                                      fontSize:  editFontsize ?  14 + change.toDouble() : 14,
                                      color: !darkMode ? Colors.black: Colors.white,
                                      decoration: TextDecoration.underline,
                                    decorationColor: !darkMode ? Colors.black: Colors.white,
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
                          color: !darkMode ? Colors.black: Colors.white,
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
                                  child: Text('• ',
                        style: TextStyle(
                          color: !darkMode ? Colors.black: Colors.white,
                        ),),
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
                                      color: !darkMode ? Colors.black: Colors.white,
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
                          color: !darkMode ? Colors.black: Colors.white,
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
    child: Text('• ',
    style: TextStyle(
    color: !darkMode ? Colors.black: Colors.white,
    ),),
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
                                      color: !darkMode ? Colors.black: Colors.white,
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
                          color: !darkMode ? Colors.black: Colors.white,
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
                                      fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                    color: !darkMode ? Colors.black: Colors.white,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    storeName,
                                    style: TextStyle(
                                        fontFamily: 'PlexSansThaiRg',
                                        fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                      color: !darkMode ? Colors.black: Colors.white,
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
                                    color: !darkMode ? Colors.black: Colors.white,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    formattedDispensing,
                                    style: TextStyle(
                                        fontFamily: 'PlexSansThaiRg',
                                        fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                      color: !darkMode ? Colors.black: Colors.white,
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
