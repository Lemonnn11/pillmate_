import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class MapService{


  Future<LatLng?> getCurrentLocation() async {
    Location _locationController = new Location();
    LatLng? _currLocation = null;
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return _currLocation;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('location permission denied');
        return _currLocation;
      }
    }
    else {
      // initLocation = await _locationController.getLocation();
      _locationController.onLocationChanged.listen((LocationData currLocation) {
        if (currLocation.latitude != null && currLocation.longitude != null) {
          _currLocation = LatLng(currLocation.latitude!, currLocation.longitude!);
          // _adjustCameraWithPosition(_currLocation!);
        }
      });
    }
    return _currLocation;
  }

  Future<String> getDistanceFromLatLng(String origins, String destinations, http.Client client) async {
    String distance = "";
    String _host = 'https://maps.google.com/maps/api/distancematrix/json';
    final url = '$_host?key=AIzaSyDBq1_J47STSxQY5RsV9X4sWHS6R2NC7gM&language=en&destinations=$destinations&origins=$origins';
    if (origins != null && destinations != null) {
      print(': ${url}');
      var response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        print(data);
        distance = data["rows"][0]["elements"][0]["distance"]["text"];
      }
    }
    return distance;
  }
}