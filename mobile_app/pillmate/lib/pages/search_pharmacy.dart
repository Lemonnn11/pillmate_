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
import '../constants/constants.dart';
import '../services/firestore.dart';
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
  late FirestoreService firestoreService;
  bool darkMode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._sqliteService= SqliteService();
    this.firestoreService = FirestoreService(firestore: _firestore);
    this._sqliteService.initializeDB();
    _getPharmaciesInfo();
    getCurrentLocation();
    authChangesListener();
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

  void convertLatLngToAddress(double lat, double lng) async {
    try {
      GeocodingPlatform.instance!.setLocaleIdentifier('th');
      List<Placemark> placemarks = await GeocodingPlatform.instance!.placemarkFromCoordinates(
        lat,
        lng,
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
    await firestoreService.getPharmaciesInfo().then((value) {
      setState(() {
        _pharList = value!;
        _resultList = value!;
      });
    });
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


  Future<void> searchPharmacy(String query) async {
    await firestoreService.searchPharmacy(query).then((value) {
      setState(() {
        _resultList = value!;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:  !darkMode ? Colors.white: kBlackDarkModeBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: !darkMode ? Colors.white: kBlackDarkModeBg,
        automaticallyImplyLeading: false,
        toolbarHeight: 45,
        title: Padding(
          padding: EdgeInsets.only(top: 5),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor:  !darkMode ? Color(0xffE9E9E9): Color(0xff8B8B8B),
                child: !darkMode ? Image.asset('icons/location-green.png') : Image.asset('icons/location_dark.png') ,
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
                      color: !darkMode ? Colors.black: Colors.white
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
                          color: !darkMode ? Colors.black: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

      ),
      body: Container(
        color: !darkMode ? Colors.white: kBlackDarkModeBg,
        width: screenWidth,

        child: Column(
          children: [
            SizedBox(height: 12,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04),
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
                      color: !darkMode ? Color(0XFF2C2C2C): Colors.white
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Ionicons.search, color: !darkMode ?  Color(0xff2C2C2C): Color(0xff8B8B8B), size: 20,),

                    contentPadding: EdgeInsets.only( left: 15),
                    hintText: 'ค้นหาร้านยาที่ให้บริการ',
                    hintStyle: TextStyle(
                        fontSize: editFontsize ?  14 + change.toDouble() : 14,
                        fontFamily: 'PlexSansThaiRg',
                        color: !darkMode ? Color(0XFF2C2C2C): Colors.white
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide( color: !darkMode ? Color(0xffF1F1F1): Color(0xff8B8B8B) ),
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: !darkMode ? Color(0xffF1F1F1): Color(0xff8B8B8B)),
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: !darkMode ? Color(0xffF1F1F1): Color(0xff8B8B8B)),
                        borderRadius: BorderRadius.circular(20.0)
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
               color:  !darkMode ? Color(0xffE7E7E7): Color(0xff8B8B8B),
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
                      change: change, darkMode: darkMode,
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
                Image.asset(! darkMode ? 'icons/qrcode-scan.png': 'icons/qrcode-scan-black.png', width: 22, height: 22,) ,
                Text('สแกน', style: TextStyle(
                    color: !darkMode ? Colors.white: Colors.black,
                    fontSize: editFontsize ?  10 + change.toDouble() : 10
                ),)
              ],
            ),
            shape: CircleBorder(),
            backgroundColor: !darkMode ? Color(0xff059E78): Color(0xff94DDB5),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => QRCodeScanner()
              ));
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => AddDrug()
              // ));
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ReusableBottomNavigationBar(isLoggedIn: isLoggedIn, darkMode: darkMode,page: 'searchPharmacy',),
    );
  }
}

