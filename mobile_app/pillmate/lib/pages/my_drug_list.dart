

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pillmate/components/reusable_my_drug_list_card.dart';
import 'package:pillmate/components/reusable_my_history_list_card.dart';
import 'package:pillmate/models/medicine.dart';
import 'package:pillmate/pages/qr_code_scanner.dart';

import '../components/reusable_bottom_navigation_bar.dart';
import '../services/sqlite_service.dart';
import 'add_drug.dart';

class MyDrugList extends StatefulWidget {
  const MyDrugList({super.key});

  @override
  State<MyDrugList> createState() => _MyDrugListState();
}

class _MyDrugListState extends State<MyDrugList> {
  List<MedicineModel> _activeDrugsList = [];
  List<MedicineModel> _inactiveDrugsList = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool? isLoggedIn = false;
  String cat = '';
  String incat = '';
  late SqliteService _sqliteService;
  List<MedicineModel> _capsuleDrugsList = [];
  List<MedicineModel> _tabDrugsList = [];
  List<MedicineModel> _inactiveCapsuleDrugsList = [];
  List<MedicineModel> _inactiveTabDrugsList = [];
  bool editFontsize = false;
  int change = 0;

    // {
    //   'name': 'Amoxicilin',
    //   'dosage': '1 เม็ด',
    //   'takeMedWhen': 'เช้า, กลางวัน, เย็น',
    //   'date': '12 มกราคม 2566',
    //   'pharmacy': 'ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน',
    //   'amount': '10 แคปซูล'
    // },
    // {
    //   'name': 'Amoxicilin',
    //   'dosage': '1 เม็ด',
    //   'takeMedWhen': 'เช้า, กลางวัน, เย็น',
    //   'date': '12 มกราคม 2566',
    //   'pharmacy': 'ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน',
    //   'amount': '10 แคปซูล'
    // },
    // {
    //   'name': 'Amoxicilin',
    //   'dosage': '1 เม็ด',
    //   'takeMedWhen': 'เช้า, กลางวัน, เย็น',
    //   'date': '12 มกราคม 2566',
    //   'pharmacy': 'ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน',
    //   'amount': '10 แคปซูล'
    // },
    // {
    //   'name': 'Amoxicilin',
    //   'dosage': '1 เม็ด',
    //   'takeMedWhen': 'เช้า, กลางวัน, เย็น',
    //   'date': '12 มกราคม 2566',
    //   'pharmacy': 'ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน',
    //   'amount': '10 แคปซูล'
    // },
    // {
    //   'name': 'Amoxicilin',
    //   'dosage': '1 เม็ด',
    //   'takeMedWhen': 'เช้า, กลางวัน, เย็น',
    //   'date': '12 มกราคม 2566',
    //   'pharmacy': 'ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน',
    //   'amount': '10 แคปซูล'
    // },
    // {
    //   'name': 'Paracetamol',
    //   'dosage': '1 แคปซูล',
    //   'takeMedWhen': 'เช้า, กลางวัน, เย็น,\n ก่อนนอน',
    //   'date': '12 มกราคม 2566',
    //   'pharmacy': 'ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน',
    //   'amount': '6 แคปซูล'
    // },

  @override
  void initState() {
    super.initState();
    this._sqliteService= SqliteService();
    this._sqliteService.initializeDB();
    getMedicines();
    authChangesListener();
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

  void authChangesListener(){
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        setState(() {
          isLoggedIn = false;
          print("isLoggedIn: " + isLoggedIn.toString());
        });
      } else {
        setState(() {
          isLoggedIn = true;
          print("isLoggedIn: " + isLoggedIn.toString());

        });
      }
    });
  }

  Future<void> getMedicines() async {
    final data1 = await _sqliteService.getActiveMedicine();
    final data2 = await _sqliteService.getInactiveMedicine();
    setState(() {
      this._activeDrugsList = data1;
      this._inactiveDrugsList = data2;
    });
    _capsuleDrugsList.clear();
    _tabDrugsList.clear();
    _inactiveCapsuleDrugsList.clear();
    _inactiveTabDrugsList.clear();
    _activeDrugsList.forEach((element) {
      if(element.typeOfMedicine == 'แคปซูล'){
        setState(() {
          _capsuleDrugsList.add(element);
        });
      }
      else if(element.typeOfMedicine == 'เม็ด'){
        setState(() {
          _tabDrugsList.add(element);
        });
      }
    });
    _inactiveDrugsList.forEach((element) {
      if(element.typeOfMedicine == 'แคปซูล'){
        setState(() {
          _inactiveCapsuleDrugsList.add(element);
        });
      }
      else if(element.typeOfMedicine == 'เม็ด'){
        setState(() {
          _inactiveTabDrugsList.add(element);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          toolbarHeight: 45,
          bottom: TabBar(
            indicatorColor: Color(0xff059E78),
            labelColor: Color(0xff047E60),
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(child: Text('ยาของฉัน', style: TextStyle(fontFamily: 'PlexSansThaiRg', fontSize: editFontsize ?  18 + change.toDouble() : 18),),),
              Tab(child: Text('ประวัติการกินยา', style: TextStyle(fontFamily: 'PlexSansThaiRg', fontSize: editFontsize ?  18 + change.toDouble() : 18),),)
            ],
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 13),
            child: Center(
              child: Text(
                'ยา',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'PlexSansThaiSm',
                    color: Colors.black
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              width: screenWidth,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth*0.04, top: 9),
                    child: Container(
                      width: screenWidth,
                      height: 31,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  cat = '';
                                });
                              },
                              child: cat == '' ? Container(
                                width: 76,
                                height: 29,
                                decoration: BoxDecoration(
                                  color: Color(0xff94DDB5),
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                      color: Color(0xff059E78),
                                      width: 1
                                  ),
                                ),
                                child: Center(child: Text('ทั้งหมด', style: TextStyle(fontSize: editFontsize ?  14 + change.toDouble() : 14, fontFamily: 'PlexSansThaiRg'),)),
                              ): Container(
                                width: 76,
                                height: 29,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                      color:Color(0xffD0D0D0),
                                      width: 1
                                  ),
                                ),
                                child: Center(child: Text('ทั้งหมด', style: TextStyle(fontSize: editFontsize ?  14 + change.toDouble() : 14, fontFamily: 'PlexSansThaiRg'),)),
                              ),
                            ),
                            SizedBox(width: 8,),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  cat = 'ยาเม็ด';
                                });
                              },
                              child: cat == 'ยาเม็ด' ? Container(
                                width: 76,
                                height: 29,
                                decoration: BoxDecoration(
                                  color: Color(0xff94DDB5),
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                      color: Color(0xff059E78),
                                      width: 1
                                  ),
                                ),
                                child: Center(child: Text('ยาเม็ด', style: TextStyle(fontSize: editFontsize ?  14 + change.toDouble() : 14, fontFamily: 'PlexSansThaiRg'),)),
                              ): Container(
                                width: 76,
                                height: 29,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                      color:Color(0xffD0D0D0),
                                      width: 1
                                  ),
                                ),
                                child: Center(child: Text('ยาเม็ด', style: TextStyle(fontSize: editFontsize ?  14 + change.toDouble() : 14, fontFamily: 'PlexSansThaiRg'),)),
                              ),
                            ),
                            SizedBox(width: 8,),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  cat = 'แคปซูล';
                                });
                              },
                              child: cat == 'แคปซูล' ? Container(
                                width: 76,
                                height: 29,
                                decoration: BoxDecoration(
                                  color: Color(0xff94DDB5),
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                      color: Color(0xff059E78),
                                      width: 1
                                  ),
                                ),
                                child: Center(child: Text('แคปซูล', style: TextStyle(fontSize: editFontsize ?  14 + change.toDouble() : 14, fontFamily: 'PlexSansThaiRg'),)),
                              ): Container(
                                width: 76,
                                height: 29,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                      color:Color(0xffD0D0D0),
                                      width: 1
                                  ),
                                ),
                                child: Center(child: Text('แคปซูล', style: TextStyle(fontSize: editFontsize ?  14 + change.toDouble() : 14, fontFamily: 'PlexSansThaiRg'),)),
                              ),
                            ),
                            SizedBox(width: 8,),
                            Container(
                              width: 76,
                              height: 29,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                    color: Color(0xffD0D0D0),
                                    width: 1
                                ),
                              ),
                              child: Center(
                                child: Text('ยาน้ำ', style: TextStyle(fontSize: editFontsize ?  14 + change.toDouble() : 14, fontFamily: 'PlexSansThaiRg'),),
                              ),
                            ),
                            SizedBox(width: 8,),
                            Container(
                              width: 93,
                              height: 29,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                    color: Color(0xffD0D0D0),
                                    width: 1
                                ),
                              ),
                              child: Center(
                                child: Text('ยาภายนอก', style: TextStyle(fontSize: editFontsize ?  14 + change.toDouble() : 14, fontFamily: 'PlexSansThaiRg'),),
                              ),
                            ),
                            SizedBox(width: 8,),
                            Container(
                              width: 93,
                              height: 29,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                    color: Color(0xffD0D0D0),
                                    width: 1
                                ),
                              ),
                              child: Center(
                                child: Text('ยาหยอดตา', style: TextStyle(fontSize: editFontsize ?  14 + change.toDouble() : 14, fontFamily: 'PlexSansThaiRg'),),
                              ),
                            ),
                            SizedBox(width: 8,),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 9,),
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04),
                        child: cat == '' ? ListView.builder(
                          itemCount: _activeDrugsList.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return ReusableMyDrugListCard(
                              editFontSize: editFontsize,
                                change: change,
                                med: _activeDrugsList[index]);
                          },
                        ): cat == 'ยาเม็ด' ? ListView.builder(
                          itemCount: _tabDrugsList.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return ReusableMyDrugListCard(
                                editFontSize: editFontsize,
                                change: change,
                                med: _tabDrugsList[index]);
                          },
                        ): cat == 'แคปซูล' ? ListView.builder(
                          itemCount: _capsuleDrugsList.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return ReusableMyDrugListCard(
                                editFontSize: editFontsize,
                                change: change,
                                med: _capsuleDrugsList[index]);
                          },
                        ): Container(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: screenWidth,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth*0.04, top: 9),
                    child: Container(
                      width: screenWidth,
                      height: 31,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  incat = '';
                                });
                              },
                              child: incat == '' ? Container(
                                width: 76,
                                height: 29,
                                decoration: BoxDecoration(
                                  color: Color(0xff94DDB5),
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                      color: Color(0xff059E78),
                                      width: 1
                                  ),
                                ),
                                child: Center(child: Text('ทั้งหมด', style: TextStyle(fontSize: editFontsize ?  14 + change.toDouble() : 14, fontFamily: 'PlexSansThaiRg'),)),
                              ): Container(
                                width: 76,
                                height: 29,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                      color:Color(0xffD0D0D0),
                                      width: 1
                                  ),
                                ),
                                child: Center(child: Text('ทั้งหมด', style: TextStyle(fontSize: editFontsize ?  14 + change.toDouble() : 14, fontFamily: 'PlexSansThaiRg'),)),
                              ),
                            ),
                            SizedBox(width: 8,),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  incat = 'ยาเม็ด';
                                });
                              },
                              child: incat == 'ยาเม็ด' ? Container(
                                width: 76,
                                height: 29,
                                decoration: BoxDecoration(
                                  color: Color(0xff94DDB5),
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                      color: Color(0xff059E78),
                                      width: 1
                                  ),
                                ),
                                child: Center(child: Text('ยาเม็ด', style: TextStyle(fontSize: editFontsize ?  14 + change.toDouble() : 14, fontFamily: 'PlexSansThaiRg'),)),
                              ): Container(
                                width: 76,
                                height: 29,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                      color:Color(0xffD0D0D0),
                                      width: 1
                                  ),
                                ),
                                child: Center(child: Text('ยาเม็ด', style: TextStyle(fontSize: editFontsize ?  14 + change.toDouble() : 14, fontFamily: 'PlexSansThaiRg'),)),
                              ),
                            ),
                            SizedBox(width: 8,),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  incat = 'แคปซูล';
                                });
                              },
                              child: incat == 'แคปซูล' ? Container(
                                width: 76,
                                height: 29,
                                decoration: BoxDecoration(
                                  color: Color(0xff94DDB5),
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                      color: Color(0xff059E78),
                                      width: 1
                                  ),
                                ),
                                child: Center(child: Text('แคปซูล', style: TextStyle(fontSize: editFontsize ?  14 + change.toDouble() : 14, fontFamily: 'PlexSansThaiRg'),)),
                              ): Container(
                                width: 76,
                                height: 29,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                      color:Color(0xffD0D0D0),
                                      width: 1
                                  ),
                                ),
                                child: Center(child: Text('แคปซูล', style: TextStyle(fontSize: editFontsize ?  14 + change.toDouble() : 14, fontFamily: 'PlexSansThaiRg'),)),
                              ),
                            ),
                            SizedBox(width: 8,),
                            Container(
                              width: 76,
                              height: 29,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                    color: Color(0xffD0D0D0),
                                    width: 1
                                ),
                              ),
                              child: Center(
                                child: Text('ยาน้ำ', style: TextStyle(fontSize: editFontsize ?  14 + change.toDouble() : 14, fontFamily: 'PlexSansThaiRg'),),
                              ),
                            ),
                            SizedBox(width: 8,),
                            Container(
                              width: 93,
                              height: 29,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                    color: Color(0xffD0D0D0),
                                    width: 1
                                ),
                              ),
                              child: Center(
                                child: Text('ยาภายนอก', style: TextStyle(fontSize: editFontsize ?  14 + change.toDouble() : 14, fontFamily: 'PlexSansThaiRg'),),
                              ),
                            ),
                            SizedBox(width: 8,),
                            Container(
                              width: 93,
                              height: 29,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                    color: Color(0xffD0D0D0),
                                    width: 1
                                ),
                              ),
                              child: Center(
                                child: Text('ยาหยอดตา', style: TextStyle(fontSize: editFontsize ?  14 + change.toDouble() : 14, fontFamily: 'PlexSansThaiRg'),),
                              ),
                            ),
                            SizedBox(width: 8,),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 9,),
                  Expanded(
                    child: Container(
                      child: incat == '' ? ListView.builder(
                        itemCount: _inactiveDrugsList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return ReusableMyHistoryListCard(
                            editFontSize: editFontsize,
                            change: change,
                            med: _inactiveDrugsList[index], lastIndex: index ==  _inactiveDrugsList.length-1 ? true:false,);
                        },
                      ): incat == 'ยาเม็ด' ? ListView.builder(
                        itemCount: _inactiveTabDrugsList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return ReusableMyHistoryListCard(
                            editFontSize: editFontsize,
                            change: change,
                            med: _inactiveTabDrugsList[index], lastIndex: index ==  _inactiveTabDrugsList.length-1 ? true:false,);
                        },
                      ): incat == 'แคปซูล' ? ListView.builder(
                        itemCount: _inactiveCapsuleDrugsList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return ReusableMyHistoryListCard(
                            editFontSize: editFontsize,
                            change: change,
                            med: _inactiveCapsuleDrugsList[index], lastIndex: index ==  _inactiveCapsuleDrugsList.length-1 ? true:false,);
                        },
                      ): Container(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          height: 70,
          width: 70,
          child: FittedBox(
            child: FloatingActionButton(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('icons/qrcode-scan.png', width: 22, height: 22,) ,
                  Text('สแกน', style: TextStyle(
                      color: Colors.white,
                      fontSize: editFontsize ?  10 + change.toDouble() : 10
                  ),)
                ],
              ),
              shape: CircleBorder(),
              backgroundColor: Color(0xff059E78),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => QRCodeScanner()
                ));
              },
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: ReusableBottomNavigationBar(isLoggedIn: isLoggedIn, page: 'drugList',),
      ),
    );
  }
}
