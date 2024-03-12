import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../constants/constants.dart';
import '../services/sqlite_service.dart';
import 'package:pillmate/models/personal_information.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  bool isEdit = false;
  bool editFontsize = false;
  int change = 0;
  bool darkMode = false;
  late SqliteService _sqliteService;
  List<PersonalInformationModel>? p1 = null;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _dobController = new TextEditingController();
  TextEditingController _bloodTypeController = new TextEditingController();
  TextEditingController _genderController = new TextEditingController();
  TextEditingController _weightController = new TextEditingController();
  TextEditingController _heightController = new TextEditingController();
  TextEditingController _healthConditionController = new TextEditingController();
  TextEditingController _drugAllergiesController = new TextEditingController();
  TextEditingController _personalMedicineController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    this._sqliteService= SqliteService();
    this._sqliteService.initializeDB();
    getPersonalInformation();
    initFontSize();
    initDarkMode();
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

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _bloodTypeController.dispose();
    _genderController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _healthConditionController.dispose();
    _drugAllergiesController.dispose();
    _personalMedicineController.dispose();
  }

  void setDefaultText(){
      _nameController.text = p1!.first.name;
      _dobController.text = p1!.first.dob;
      _bloodTypeController.text= p1!.first.bloodType;
      _genderController.text= p1!.first.gender;
      _weightController.text= p1!.first.weight.toString();
      _heightController.text= p1!.first.height.toString();
      _healthConditionController.text= p1!.first.healthCondition;
      _drugAllergiesController.text= p1!.first.drugAllergies;
      _personalMedicineController.text= p1!.first.personalMedicine;
  }

  Future<void> getPersonalInformation() async {
    final data = await _sqliteService.getPersonalInfo();
    setState(() {
      p1 = data;
      setDefaultText();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: !darkMode ? Colors.white: kBlackDarkModeBg,
        automaticallyImplyLeading: false,
        toolbarHeight: 45,
        title: Padding(
          padding: EdgeInsets.only(top: 5, left: screenWidth*0.17),
          child: Text(
            'ข้อมูลส่วนตัว',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'PlexSansThaiSm',
              color: !darkMode ? Colors.black: Colors.white,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Ionicons.chevron_back_outline,     color: !darkMode ? Colors.black: Colors.white,size: 30), onPressed: () {
          Navigator.pop(context);
          this.isEdit = false;
        },
        ),
        actions: [
            this.isEdit ? GestureDetector(
            onTap: () async {
              PersonalInformationModel p2 = new PersonalInformationModel(1, _nameController.text, _dobController.text, _genderController.text, _weightController.text == '' ? 0.0: double.parse(_weightController.text), _heightController.text == '' ? 0.0 : double.parse(_heightController.text), _healthConditionController.text, _drugAllergiesController.text, _personalMedicineController.text, _bloodTypeController.text);
              final res = await _sqliteService.createPersonalInfoItem(p2);
              setState(() {
                this.isEdit = !isEdit;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(top: 11, right: 9),
              child:  Text( 'บันทึก', style: TextStyle(
                  fontSize: editFontsize ?  16 + change.toDouble() : 16,
                  fontFamily: 'PlexSansThaiRg',
                color: !darkMode ? Colors.black: Colors.white,
              ),)
            ),
          ):
          GestureDetector(
          onTap: () async {
          setState(() {
          this.isEdit = !isEdit;
          });
          },
          child: Padding(
          padding: EdgeInsets.only(top: 11, right: 9),
          child:  Text( 'แก้ไข', style: TextStyle(
          fontSize: editFontsize ?  16 + change.toDouble() : 16,
          fontFamily: 'PlexSansThaiRg',
            color: !darkMode ? Colors.black: Colors.white,
          ),)
          ),
          )
        ],
      ),
      body: Container(
        color: !darkMode ? Colors.white: kBlackDarkModeBg,
        width: screenWidth,

        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: 15),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('images/profile-pic.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 8),
                    child: Text(
                      p1 == null || p1!.isEmpty ? '' : p1!.first.name,
                      style: TextStyle(fontSize: editFontsize ?  18 + change.toDouble() : 18, fontFamily: 'PlexSansThaiMd', color:  Colors.black),
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('วัน/เดือน/ปี เกิด',
                    style: TextStyle(fontSize: editFontsize ?  16 + change.toDouble() : 16, fontFamily: 'PlexSansThaiMd',  color: !darkMode ? Colors.black: Colors.white,),
                  ),
                  SizedBox(height: 4,),
                  Container(
                    height: 55,
                    child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 2, left: 15),
                          hintText: p1 == null || p1!.isEmpty ? '': p1!.first.dob ,
                          hintStyle: TextStyle(
                            fontSize: editFontsize ?  14 + change.toDouble() : 14,
                            fontFamily: 'PlexSansThaiRg',
                            color: !darkMode ? Colors.black: Colors.white,
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
                        readOnly: !isEdit,
                      controller: _dobController,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('กรุ๊ปเลือด',
                          style: TextStyle(fontSize: editFontsize ?  16 + change.toDouble() : 16, fontFamily: 'PlexSansThaiMd', color: !darkMode ? Colors.black: Colors.white,),
                        ),
                        SizedBox(height: 4,),
                        Container(
                          height: 55,
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 2, left: 15),
                              hintText: p1 == null|| p1!.isEmpty ? '': p1!.first.bloodType,
                              hintStyle: TextStyle(
                                  fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                  fontFamily: 'PlexSansThaiRg',
                                color: !darkMode ? Colors.black: Colors.white,
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
                            readOnly: !isEdit,
                            controller: _bloodTypeController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('เพศ',
                        style: TextStyle(fontSize: editFontsize ?  16 + change.toDouble() : 16, fontFamily: 'PlexSansThaiMd',  color: !darkMode ? Colors.black: Colors.white,),
                      ),
                      SizedBox(height: 4,),
                      Container(
                        height: 55,
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 2, left: 15),
                            hintText: p1 == null|| p1!.isEmpty ? '': p1!.first.gender,
                            hintStyle: TextStyle(
                                fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                fontFamily: 'PlexSansThaiRg',
                              color: !darkMode ? Colors.black: Colors.white,
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
                          readOnly: !isEdit,
                          controller: _genderController,
                        ),
                      ),
                    ],
                  ),)
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('น้ำหนัก (กก.)',
                          style: TextStyle(fontSize: editFontsize ?  16 + change.toDouble() : 16, fontFamily: 'PlexSansThaiMd', color: !darkMode ? Colors.black: Colors.white,),
                        ),
                        SizedBox(height: 4,),
                        Container(
                          height: 55,
                          child: TextField(
                            decoration: InputDecoration(
                              suffix: Container(
                                padding: EdgeInsets.only(right: 15),
                                child: Text(
                                  'กิโลกรัม',
                                  style: TextStyle(
                                    fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                    fontFamily: 'PlexSansThaiRg',
                                    color: !darkMode ?Color(0xff575757): Colors.white70,
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(top: 2, left: 15),
                              hintText: p1 == null|| p1!.isEmpty ? '': p1!.first.weight.toString(),
                              hintStyle: TextStyle(
                                  fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                  fontFamily: 'PlexSansThaiRg',
                                  color: !darkMode ?Colors.black: Colors.white
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
                            readOnly: !isEdit,
                            controller: _weightController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ส่วนสูง (ซม.)',
                        style: TextStyle(fontSize: editFontsize ?  16 + change.toDouble() : 16, fontFamily: 'PlexSansThaiMd',      color: !darkMode ?Colors.black: Colors.white),
                      ),
                      SizedBox(height: 4,),
                      Container(
                        height: 55,
                        child: TextField(
                          decoration: InputDecoration(
                            suffix: Container(
                              padding: EdgeInsets.only(right: 15),
                              child: Text(
                                'เซนติเมตร',
                                style: TextStyle(
                                  fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                  fontFamily: 'PlexSansThaiRg',
                                  color: !darkMode ?Color(0xff575757): Colors.white70,
                                ),
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top: 2, left: 15),
                            hintText: p1 == null || p1!.isEmpty? '': p1!.first.height.toString(),
                            hintStyle: TextStyle(
                                fontSize: editFontsize ?  14 + change.toDouble() : 14,
                                fontFamily: 'PlexSansThaiRg',
                                color: !darkMode ?Colors.black: Colors.white
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
                          readOnly: !isEdit,
                          controller: _heightController,
                        ),
                      ),
                    ],
                  ),)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('โรคประจำตัว',
                    style: TextStyle(fontSize: editFontsize ?  16 + change.toDouble() : 16, fontFamily: 'PlexSansThaiMd',   color: !darkMode ?Colors.black: Colors.white),
                  ),
                  SizedBox(height: 4,),
                  Container(
                    height: 55,
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 2, left: 15),
                        hintText: p1 == null || p1!.isEmpty? '': p1!.first.healthCondition,
                        hintStyle: TextStyle(
                            fontSize: editFontsize ?  14 + change.toDouble() : 14,
                            fontFamily: 'PlexSansThaiRg',
                            color: !darkMode ?Colors.black: Colors.white
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
                      readOnly: !isEdit,
                      controller: _healthConditionController,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ยาที่แพ้',
                    style: TextStyle(fontSize: editFontsize ?  16 + change.toDouble() : 16, fontFamily: 'PlexSansThaiMd',   color: !darkMode ?Colors.black: Colors.white),
                  ),
                  SizedBox(height: 4,),
                  Container(
                    height: 55,
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 2, left: 15),
                        hintText: p1 == null || p1!.isEmpty? '': p1!.first.drugAllergies,
                        hintStyle: TextStyle(
                            fontSize: editFontsize ?  14 + change.toDouble() : 14,
                            fontFamily: 'PlexSansThaiRg',
                            color: !darkMode ?Colors.black: Colors.white
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
                      readOnly: !isEdit,
                      controller: _drugAllergiesController,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ยาที่ใช้ประจำ',
                    style: TextStyle(fontSize: editFontsize ?  16 + change.toDouble() : 16, fontFamily: 'PlexSansThaiMd',   color: !darkMode ?Colors.black: Colors.white),
                  ),
                  SizedBox(height: 4,),
                  Container(
                    height: 55,
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 2, left: 15),
                        hintText: p1 == null || p1!.isEmpty? '': p1!.first.personalMedicine,
                        hintStyle: TextStyle(
                            fontSize: editFontsize ?  14 + change.toDouble() : 14,
                            fontFamily: 'PlexSansThaiRg',
                            color: !darkMode ?Colors.black: Colors.white
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
                      readOnly: !isEdit,
                      controller: _personalMedicineController,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
