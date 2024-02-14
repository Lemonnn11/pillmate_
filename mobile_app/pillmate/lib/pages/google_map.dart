import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:pillmate/constants/constants.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';

class GoogleMapPage extends StatefulWidget {
  final Map<String, String> pharmacy;
  const GoogleMapPage({super.key, required this.pharmacy});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}



class _GoogleMapPageState extends State<GoogleMapPage> {
  late LatLng phar;
  LatLng? _currLocation = null;
  Location _locationController = new Location();
  final Completer<GoogleMapController> _mapController = Completer<
      GoogleMapController>();
  Map<PolylineId, Polyline> polylines = {};
  late LocationData initLocation;
  String distance = "";

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    phar = LatLng(double.parse(widget.pharmacy['latitude']!), double.parse(widget.pharmacy['longitude']!));
    // getCurrentLocation().then((_) =>
    //     getPolyPoints().then((coordinates) =>
    //     print("test: " + coordinates.toString())
    //     // generatePolyLineFromPoints(coordinates)
    // ));
  }

  Future<void> getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('location permission denied');
        return;
      }
    }
    else {
      // initLocation = await _locationController.getLocation();
      _locationController.onLocationChanged.listen((LocationData currLocation) {
        if (currLocation.latitude != null && currLocation.longitude != null) {
          setState(() {
            _currLocation =
                LatLng(currLocation.latitude!, currLocation.longitude!);
            // _adjustCameraWithPosition(_currLocation!);
            getDistanceFromLatLng(currLocation.latitude!.toString() + ',' +
                currLocation.longitude!.toString(),
                widget.pharmacy['latitude']! + ',' +
                    widget.pharmacy['longitude']!);
            Future<List<LatLng>> polylineCoordinates = getPolyPoints();
            print("test: " + polylineCoordinates.toString());
          });
        }
      });
    }
  }

  Future<void> _adjustCameraWithPosition(LatLng position) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
        target: position, zoom: 15);
    await controller.animateCamera(
        CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  Future<List<LatLng>> getPolyPoints() async {
    List<LatLng> polylineCoordinates = [];
    if (_currLocation == null) {
      return polylineCoordinates;
    }
    PolylinePoints points = PolylinePoints();
    PolylineResult result = await points.getRouteBetweenCoordinates(
        GOOGLE_MAPS_API_KEY,
        PointLatLng(_currLocation!.latitude, _currLocation!.longitude),
        PointLatLng(double.parse(widget.pharmacy['latitude']!), double.parse(widget.pharmacy['longitude']!)));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 15);
    setState(() {
      polylines[id] = polyline;
    });
  }

  getDistanceFromLatLng(String origins, String destinations) async {
    String _host = 'https://maps.google.com/maps/api/distancematrix/json';
    final url = '$_host?key=AIzaSyDBq1_J47STSxQY5RsV9X4sWHS6R2NC7gM&language=en&destinations=$destinations&origins=$origins';
    if (origins != null && destinations != null) {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        print(data);
        setState(() {
          distance = data["rows"][0]["elements"][0]["distance"]["text"];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            _currLocation == null ? Center(child: Text('Loading...'),):GoogleMap(
              onMapCreated:  ((GoogleMapController controller) => _mapController.complete(controller)),
              initialCameraPosition: CameraPosition(target: LatLng(double.parse(widget.pharmacy['latitude']!), double.parse(widget.pharmacy['longitude']!)), zoom: 10),
              markers: {
                Marker(markerId: MarkerId("_currLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _currLocation!
                ),
                Marker(markerId: MarkerId("_targetLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: LatLng(double.parse(widget.pharmacy['latitude']!), double.parse(widget.pharmacy['longitude']!))
                ),
              },
              polylines: Set<Polyline>.of(polylines.values),
            ),
            Container(
              width: screenWidth,
              height: 103,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0))
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Ionicons.chevron_back_outline, color: Colors.black,size: 30), onPressed: () {
                      Navigator.pop(context);
                    },
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0, left: screenWidth*0.22),
                      child: Text(
                        'แผนที่ร้านยา',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'PlexSansThaiSm'
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: screenWidth,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0))
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.pharmacy['storeName']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'PlexSansThaiMd',
                              ),

                            ),
                          ),
                          SizedBox(
                            width: screenWidth*0.1,
                          ),
                          Text(
                            distance,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'PlexSansThaiMd',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7,),
                      Text(
                        '${widget.pharmacy['province']} ${widget.pharmacy['city']!}',
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'PlexSansThaiRg',
                            color: Color(0xff8B8B8B)
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text(
                        'เบอร์โทร: ' + widget.pharmacy['phoneNumber']!,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'PlexSansThaiRg',
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'เปิดอยู่',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'PlexSansThaiMd',
                                color: Color(0xff059E78)
                            ),
                          ),
                          SizedBox(width: 4,),
                          Text(
                            widget.pharmacy['serviceTime']!,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'PlexSansThaiRg',
                                color: Color(0xff121212)
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                MapsLauncher.launchCoordinates(double.parse(widget.pharmacy['latitude']!), double.parse(widget.pharmacy['longitude']!));
                              },
                              child:
                              Text('เปิดใน Google Map', style: TextStyle(fontFamily: 'PlexSansThaiSm', fontSize: 20, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff059E78),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6), // Set your desired border radius
                                ),
                                minimumSize: Size(screenWidth, 60),),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
