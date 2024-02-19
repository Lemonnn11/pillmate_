import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pillmate/models/medicine.dart';

import '../services/sqlite_service.dart';

class AddDrug extends StatefulWidget {
  final String info = '{"timePeriodForMed":"...","date":"2024-02-19T01:44:23.470Z","pharID":"Fy751CumG69MLZfZLvqe","additionalAdvice":"ยานี้อาจระคายเคืองกระเพาะอาหาร ให้รับประทานหลังอาหารทันที","quantity":250,"amountOfMeds":10,"genericName":"Paracetamol","expiredDate":"2023-11-04T00:00:00.000Z","adverseDrugReaction":"หากมีอาการผื่นแพ้ เยื่อบุผิวลอก ให้หยุดใช้ยาและหากมีอาการหนักควรปรึกษาแพทย์ทันที","timeOfMed":"หลังอาหาร","typeOfMedicine":"Tablet","tradeName":"Bakamol Tab. 500 mg","dosagePerTake":2,"takeMedWhen":"เช้า กลางวัน เย็น","QRCodeID":"8c5ea443-83e4-4d92-88d9-5d0e06a06db8","timePerDay":3,"conditionOfUse":"ลดคลื่นไส้อาเจียน"}';
  // final String info;
  const AddDrug({super.key});

  @override
  State<AddDrug> createState() => _AddDrugState();
}

class _AddDrugState extends State<AddDrug> {
  late Map<String, dynamic> data;
  List<String> tmp = [];
  late SqliteService _sqliteService;
  String formattedExpired = '';
  String formattedDispensing = '';
  bool isActived = true;
  final _firestore = FirebaseFirestore.instance;
  String storeName = '';


  void _getPharmacyName() async {
    _firestore.collection("pharmacies").where("pharID", isEqualTo: data["pharID"]).get().then(
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = json.decode(widget.info);
    print(data);
    this._sqliteService= SqliteService();
    this._sqliteService.initializeDB();
    formattedDate();
    formattedType();
    _getPharmacyName();
  }
  
  void formattedType(){
    switch(data['typeOfMedicine'].toString()){
      case 'Tablet':
        data['typeOfMedicine'] = data['typeOfMedicine'].toString().replaceAll('Tablet', 'เม็ด');
        break;
      case 'Capsule':
        data['typeOfMedicine'] = data['typeOfMedicine'].toString().replaceAll('Capsule', 'แคปซูล');
        break;
    }
  }

  void formattedDate(){
    DateTime exp = DateTime.parse(data['expiredDate']);
    DateTime des = DateTime.parse(data['expiredDate']);
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
          icon: Icon(Ionicons.chevron_back_outline, color: Colors.black,size: 30,), onPressed: () {
          Navigator.pushNamed(context, "/homepage");
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
                      Text(data['genericName'],
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
                          Text(data['typeOfMedicine'],
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
                          Text(data['quantity'].toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'PlexSansThaiRg',
                            ),),
                        ],
                      ),
                      SizedBox(height: 3,),
                        Wrap(
                          children: [
                            Text('วันหมดอายุ: ',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'PlexSansThaiRg',
                              ),),
                            Text(formattedExpired,
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
                        Text(data['amountOfMeds'].toString() + ' '+ data['typeOfMedicine'],
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
                                Text(data['dosagePerTake'].toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'PlexSansThaiRg'
                                  ),),
                                Text(data['typeOfMedicine'],
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
                                Text(data['timePerDay'].toString(),
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
                                Text(data['timeOfMed'],
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
                  data['timeOfMed'].contains('เวลา') ?
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
                                Text(data['timePeriodForMed'].toString(),
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
              data['timeOfMed'].contains('เวลา') || data['timeOfMed'].contains('เมื่อ') ?
              Container():
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  data['takeMedWhen'].contains('เช้า') ?
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
                  data['takeMedWhen'].contains('กลางวัน') ?
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
                  data['takeMedWhen'].contains('เย็น') ?
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
                  data['takeMedWhen'].contains('ก่อนนอน') ?
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
                  data['takeMedWhen'].contains('เช้า') ? Container(
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
                  ): Container(width: 0, height: 0,),
                  SizedBox(width: 8,),
                  data['takeMedWhen'].contains('กลางวัน') ? Padding(
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
                  ): Container(width: 0, height: 0,),
                  SizedBox(width: 8,),
                  data['takeMedWhen'].contains('เย็น') ? Padding(
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
                  ): Container(width: 0, height: 0,),
                  data['takeMedWhen'].contains('ก่อนนอน') ? Padding(
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
                  ): Container(width: 0, height: 0,),
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
                                  data['conditionOfUse'],
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
                                    data['additionalAdvice'],
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
                                    data['adverseDrugReaction'],
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
                                    storeName,
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
                                    formattedDispensing,
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
              isActived ? Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        var dt = DateTime.now();
                        String tmp;
                        switch(dt.month.toString()){
                          case '1': {
                            tmp = 'มกราคม';
                          }
                          break;

                          case '2': {
                            tmp = 'กุมภาพันธ์';
                          }
                          break;

                          case '3': {
                            tmp = 'มีนาคม';
                          }
                          break;

                          case '4': {
                            tmp = 'เมษายน';
                          }
                          break;

                          case '5': {
                            tmp = 'พฤษภาคม';
                          }
                          break;

                          case '6': {
                            tmp = 'มิถุนายน';
                          }
                          break;

                          case '7': {
                            tmp = 'กรกฎาคม';
                          }
                          break;

                          case '8': {
                            tmp = 'สิงหาคม';
                          }
                          break;

                          case '9': {
                            tmp = 'กันยายน';
                          }
                          break;

                          case '10': {
                            tmp = 'ตุลาคม';
                          }
                          break;

                          case '11': {
                            tmp = 'พฤศจิกายน';
                          }
                          break;

                          case '12': {
                            tmp = 'ธันวาคม';
                          }
                          break;

                          default: {
                            tmp = 'ไม่ระบุ';
                          }
                          break;
                        }
                        String time = DateFormat("HH:mm").format(DateTime.now());
                        String tmpp = "";
                        int firstDailyMeds = 0;
                        final daileyMed = await _sqliteService.getDailyMedicines();
                        if(data['takeMedWhen'] != null || data['takeMedWhen'] != ""){
                          final list = data['takeMedWhen'].split(' ');
                          int round = (data['amountOfMeds'] / list.length).toInt();
                          print('${data['amountOfMeds']} ${list.length}');
                          String tm = '';
                          bool flag = false;
                          if (daileyMed.isNotEmpty && (dt.hour < daileyMed[0].nightTimeHour || (dt.hour == daileyMed[0].nightTimeHour && dt.minute < daileyMed[0].nightTimeMinute))){
                            tmpp += dt.day.toString();
                            tmpp += ' ';
                            for(int i = 0;i < list.length;i++){
                              if(list[i] == 'เช้า' && (dt.hour < daileyMed[0].morningTimeHour || (dt.hour == daileyMed[0].morningTimeHour && dt.minute < daileyMed[0].morningTimeMinute)) ){
                                flag = true;
                                tmpp += 'เช้า';
                                firstDailyMeds += 1;
                                if(i != list.length-1){
                                  tmpp += ' ';
                                }
                              }
                              else if(list[i] == 'กลางวัน' && (dt.hour < daileyMed[0].noonTimeHour || (dt.hour == daileyMed[0].noonTimeHour && dt.minute < daileyMed[0].noonTimeMinute)) ){
                                flag = true;
                                tmpp += 'กลางวัน';
                                firstDailyMeds += 1;
                                if(i != list.length-1){
                                  tmpp += ' ';
                                }
                              }
                              else if(list[i] == 'เย็น' && (dt.hour < daileyMed[0].eveningTimeHour || (dt.hour == daileyMed[0].eveningTimeHour && dt.minute < daileyMed[0].eveningTimeMinute))){
                                flag = true;
                                tmpp += 'เย็น';
                                firstDailyMeds += 1;
                                if(i != list.length-1){
                                  tmpp += ' ';
                                }
                              }
                              else if(list[i] == 'ก่อนนอน' && (dt.hour < daileyMed[0].nightTimeHour || (dt.hour == daileyMed[0].nightTimeHour && dt.minute < daileyMed[0].nightTimeMinute))){
                                flag = true;
                                tmpp += 'ก่อนนอน';
                                firstDailyMeds += 1;
                                if(i != list.length-1){
                                  tmpp += ' ';
                                }
                              }

                            }
                            if(flag){
                              tmpp+=',';
                              for(int i = 0; i < round - 1;i++){
                                if(i == round-2){
                                  tmpp += (dt.day + i + 1).toString();
                                  tmpp += " ";
                                  tmpp += data['takeMedWhen'];
                                }else{
                                  tmpp += (dt.day + 1 + i).toString();
                                  tmpp += " ";
                                  tmpp += data['takeMedWhen'];
                                  tmpp += ",";
                                }
                              }
                            }else{
                              tmpp = '';
                              for(int i = 0; i < round;i++){
                                if(i == round-1){
                                  tmpp += (dt.day + i + 1).toString();
                                  tmpp += " ";
                                  tmpp += data['takeMedWhen'];
                                }else{
                                  tmpp += (dt.day + 1 + i).toString();
                                  tmpp += " ";
                                  tmpp += data['takeMedWhen'];
                                  tmpp += ",";
                                }
                              }
                            }
                          }
                          else{
                            for(int i = 0; i < round;i++){
                              if(i == round-1){
                                tmpp += (dt.day + i + 1).toString();
                                tmpp += " ";
                                tmpp += data['takeMedWhen'];
                              }else{
                                tmpp += (dt.day + 1 + i).toString();
                                tmpp += " ";
                                tmpp += data['takeMedWhen'];
                                tmpp += ",";
                              }
                            }
                          }
                          print('tmplist: ' + tmpp);
                          if( data['amountOfMeds'] % list.length != 0){
                            final list = data['takeMedWhen'].split(' ');
                            for(int i = 0; i < data['amountOfMeds'] % list.length;i++){
                              if(i == 0){
                                final tmplist = tmpp.split(',');
                                final lastElement = tmplist[tmplist.length-1].split(' ');
                                tmpp += ',';
                                print(tmplist);
                                print(lastElement);
                                tmpp += (int.parse(lastElement[0]) + 1).toString();
                                tmpp += ' ';
                              }else{
                                tmpp += ' ';
                              }
                              tmpp += list[i];
                            }


                          }
                        }
                        final tempList = tmpp.split(',');
                        final firstTempList = tempList[0].split(' ');
                        final list = data['takeMedWhen'].split(' ');
                        if(firstTempList.length-1 != list.length){
                          final lastTempList = tempList[tempList.length-1].split(' ');
                          print(lastTempList.length-1);
                          print(firstTempList.length-1 );
                          print(list.length);
                          print(list);
                          for(int i = lastTempList.length-1;i <= list.length - (firstTempList.length - 1);i++ ){
                            tmpp += ' ';
                            tmpp += list[i];
                          }
                        }
                        print(tmpp);
                        MedicineModel med1 = new MedicineModel(data['QRCodeID'], data['pharID'], data['dosagePerTake'], data['timePerDay'],data['timeOfMed'] , data['timePeriodForMed'],  data['takeMedWhen'], data['expiredDate'], data['date'], data['conditionOfUse'], data['additionalAdvice'], data['amountOfMeds'], data['quantity'].toDouble(), data['adverseDrugReaction'], data['typeOfMedicine'], data['genericName'], data['tradeName'], dt.day.toString() + " " + tmp + ' ' + (dt.year + 543).toString() + ' เวลา ' + time + ' น', 0, 1, tmpp);
                        final res = await _sqliteService.createMedicineItem(med1);
                        await _sqliteService.increaseDailyMed(firstDailyMeds);
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
                                height: 315,
                                  child: Column(
                                    children: [
                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       children: [
                                         SizedBox(height: 30,),
                                         Text(
                                           'เพิ่มข้อมูลยาเรียบร้อย',
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
                                         ),
                                         SizedBox(
                                           height: 15,
                                         ),
                                         Container(
                                           width: screenWidth,
                                           height: 1.5,
                                           color: Color(0xffE2E2E2),
                                         ),
                                       ],
                                     ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.045),
                                        child: Column(
                                          children: [
                                            SizedBox(height: 15,),
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
                                            SizedBox(height: 10,),
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
                                                  'เบอร์โทรติดต่อ: ',
                                                  style: TextStyle(
                                                      fontFamily: 'PlexSansThaiSm',
                                                      fontSize: 14,
                                                      color: Colors.black
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '094-941-1828',
                                                    style: TextStyle(
                                                        fontFamily: 'PlexSansThaiRg',
                                                        fontSize: 14,
                                                        color: Colors.black
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: (){
                                                      Navigator.pop(context);
                                                      Navigator.pushNamed(context, '/homepage');
                                                    },
                                                    child:
                                                    Text('กลับหน้าหลัก', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: 17, color: Colors.black),
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
                                                    onPressed: (){
                                                      Navigator.pop(context);
                                                      Navigator.pushNamed(context, '/my-drug-list');
                                                    },
                                                    child:
                                                    Text('ยาของฉัน', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: 17, color: Colors.white),
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Color(0xff059E78),
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
                        setState(() {
                          isActived = false;
                        });
                      },
                      child:
                      Text('เพิ่มข้อมูลยา', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: 18, color: Colors.white),
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
              ): Row(
                children: [
                  Expanded(
                    child: ElevatedButton(

                      child:
                      Text('เพิ่มข้อมูลยาเรีบยร้อย', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff059E78),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Set your desired border radius
                        ),
                        minimumSize: Size(screenWidth, 52),), onPressed: null,
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



