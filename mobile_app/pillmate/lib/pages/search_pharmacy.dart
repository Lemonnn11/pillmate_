import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pillmate/components/reusable_pharmacy_item.dart';
import 'package:location/location.dart' as location;
import 'package:http/http.dart' as http;
import 'package:pillmate/pages/qr_code_scanner.dart';

import '../components/reusable_bottom_navigation_bar.dart';
import '../services/sqlite_service.dart';
import 'add_drug.dart';

class SearchPharmacy extends StatefulWidget {
  const SearchPharmacy({super.key});

  @override
  State<SearchPharmacy> createState() => _SearchPharmacyState();
}


class _SearchPharmacyState extends State<SearchPharmacy> {
  final _firestore = FirebaseFirestore.instance;
  List<Map<String, String>> _pharList = [];
  List<Map<String, String>> _resultList = [];
  location.Location _locationController = new location.Location();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String address = '';
  bool? isLoggedIn = false;
  LatLng? _currLocation = null;
  bool editFontsize = false;
  int change = 0;
  late SqliteService _sqliteService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._sqliteService= SqliteService();
    this._sqliteService.initializeDB();
    _getPharmaciesInfo();
    getCurrentLocation();
    _resultList = _pharList;
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

  void convertLatLngToAddress(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        lat,
        lng,
        localeIdentifier: 'th',
      );
      if (placemarks != null && placemarks.isNotEmpty) {
        final placemark = placemarks.reversed.last;
        setState(() {
          address = '${placemark.street}';
        });
      } else {
        print('No placemarks found.');
      }
    } catch (e) {
      print('Error converting coordinates to address: $e');
    }
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

  void _getPharmaciesInfo() async {
    await for (var snapshot in _firestore.collection('pharmacies').snapshots()){
      for(var pharmacy in snapshot.docs){
        final pharmacyData = pharmacy.data();
         Map<String, String>? pharmaciesInfo = {};
         pharmaciesInfo['pharID'] = pharmacyData['pharID'].toString();
         pharmaciesInfo['storeName'] = pharmacyData['storeName'].toString();
         pharmaciesInfo['address'] = pharmacyData['address'].toString();
         pharmaciesInfo['province'] = pharmacyData['province'].toString();
         pharmaciesInfo['city'] = pharmacyData['city'].toString();
         pharmaciesInfo['latitude'] = pharmacyData['latitude'].toString();
         pharmaciesInfo['longitude'] = pharmacyData['longitude'].toString();
         pharmaciesInfo['phoneNumber'] = pharmacyData['phoneNumber'].toString();
         pharmaciesInfo['serviceTime'] = pharmacyData['serviceTime'].toString();
         pharmaciesInfo['serviceDate'] = pharmacyData['serviceDate'].toString();
         setState(() {
            _pharList.add(pharmaciesInfo);
         });
      }
    }
  }

  Future<void> getCurrentLocation() async {
    bool _serviceEnabled;
    location.PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if(_serviceEnabled){
      _serviceEnabled = await _locationController.requestService();
    }else{
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if(_permissionGranted == location.PermissionStatus.denied){
      _permissionGranted = await _locationController.requestPermission();
      if(_permissionGranted != location.PermissionStatus.granted){
        print('location permission denied');
        return;
      }
    }
    else{
      // initLocation = await _locationController.getLocation();
      _locationController.onLocationChanged.listen((location.LocationData currLocation) {
        if(currLocation.latitude != null && currLocation.longitude != null){
          convertLatLngToAddress(currLocation.latitude! , currLocation.longitude!);
        }
      });
    }
  }


  void searchPharmacy(String query){
    _resultList = [];
    if(query == null || query == ''){
      setState(() {
        _resultList = _pharList;
      });
    }
    else{
      _pharList.forEach((pharmacy) {
        if(pharmacy['storeName']!.contains(query)){
          setState(() {
            _resultList.add(pharmacy);
          });
        }else if(pharmacy['province']!.contains(query)){
          setState(() {
            _resultList.add(pharmacy);
          });
        }else if(pharmacy['city']!.contains(query)){
          setState(() {
            _resultList.add(pharmacy);
          });
        }
      });
      setState(() {
        _resultList;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 45,
        title: Padding(
          padding: EdgeInsets.only(top: 5),
          child: Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: Color(0xffE9E9E9),
                child: Image.asset('icons/location-green.png'),
              ),
              SizedBox(
                width: screenWidth*0.03,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ตำแหน่งของคุณ',
                    style: TextStyle(
                        fontSize: editFontsize ?  12 + change.toDouble() : 12,
                        fontFamily: 'PlexSansThaiRg',
                        color: Color(0xff2C2C2C)
                    ),
                  ),
                  Container(
                    width: screenWidth*0.6,
                    child: Text(
                      address,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: editFontsize ?  16 + change.toDouble() : 16,
                          fontFamily: 'PlexSansThaiMd',
                          color: Color(0xff047E60)
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: Icon(Ionicons.chevron_back_outline, color: Colors.black, size: 30,), onPressed: () {
          Navigator.pop(context);
        },

        ),
      ),
      body: Container(
        color: Colors.white,
        width: screenWidth,
        child: Column(
          children: [
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.06),
              child: Container(
                height: 40,
                child: TextField(

                  onChanged: (value){
                      print('q: ' + value);
                      searchPharmacy(value);
                  },
                  style: TextStyle(
                    fontSize: editFontsize ?  18 + change.toDouble() : 18,
                    fontFamily: 'PlexSansThaiRg',
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Ionicons.search, color: Color(0xff2C2C2C), size: 20,),
                    suffixIcon: Icon(Ionicons.mic_outline, color: Color(0xff2C2C2C), size: 20,),
                    contentPadding: EdgeInsets.only( left: 15),
                    hintText: 'ค้นหาร้านยาที่ให้บริการ',
                    hintStyle: TextStyle(
                        fontSize: editFontsize ?  14 + change.toDouble() : 14,
                        fontFamily: 'PlexSansThaiRg',
                        color: Color(0XFF2C2C2C)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffF1F1F1)),
                        borderRadius: BorderRadius.circular(26.0)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffF1F1F1)),
                        borderRadius: BorderRadius.circular(26.0)
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffF1F1F1)),
                        borderRadius: BorderRadius.circular(26.0)
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: screenWidth,
              height: 1,
              color: Color(0xffE3E3E3),
            ),
            Expanded(
              child: Container(
                width: screenWidth,
                child: ListView.builder(
                  itemCount: _resultList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return ReusablePharmacyItem(
                      pharmacy: _resultList[index],
                      editFontsize:editFontsize,
                      change: change,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
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
      bottomNavigationBar: ReusableBottomNavigationBar(isLoggedIn: isLoggedIn, page: 'searchPharmacy',),
    );
  }
}

