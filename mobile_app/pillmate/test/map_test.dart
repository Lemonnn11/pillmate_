import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pillmate/services/map.dart';
import 'package:http/http.dart' as http;

import 'map_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MapService>(), MockSpec<http.Client>(), MockSpec<GeocodingPlatform>()])
void main(){
  late MapService mapService;
  setUpAll((){
    mapService = MockMapService();
  });

  group('test get current location', () {
    test('get current location on mobile phone', () async {
      when(mapService.getCurrentLocation()).thenAnswer((_) async => LatLng(13.77765254802144, 100.52532826905029) );
      final res = await mapService.getCurrentLocation();
      expect(res, LatLng(13.77765254802144, 100.52532826905029));
    });
  });

  group('test get distance between latlng', () {
    test('test get distance from point to point by latlng', () async {
        final client = MockClient();
        MapService mapService1 = MapService();
        when(client
            .get(Uri.parse('https://maps.google.com/maps/api/distancematrix/json?key=AIzaSyDBq1_J47STSxQY5RsV9X4sWHS6R2NC7gM&language=en&destinations=13.77765254802144,100.52532826905029&origins=13.79454288710954,100.32560593801011')))
            .thenAnswer((_) async =>
            http.Response('{"destination_addresses": ["Haridwar, Uttarakhand, India"], "origin_addresses": ["Dehradun, Uttarakhand, India"], "rows":[{"elements": [{"distance": {"text": "56.3 km", "value": 56288},"duration": {"text": "1 hour 40 mins", "value": 5993},"status": "OK"}]}], "status": "OK"}', 200));
        expect(await mapService1.getDistanceFromLatLng('13.79454288710954,100.32560593801011', '13.77765254802144,100.52532826905029', client),"56.3 km" );
    });

  });

  group('test convert latlng to address', () {
    test('convert given latlng to address in string', () async {
      MapService mapService1 = MapService();
      MockGeocodingPlatform geocodingPlatform = MockGeocodingPlatform();
      List<Placemark> placemarks = [Placemark(
        name: '58',
        street: '58 58/4 หมู่ 4 ซอย บ้านตั้งสิน ตำบล ศาลายา อำเภอพุทธมณฑล นครปฐม 73170 ประเทศไทย',
        isoCountryCode: 'TH',
        country: 'ประเทศไทย',
        postalCode:'73170',
        administrativeArea:'นครปฐม',
        subAdministrativeArea:'อำเภอพุทธมณฑล',
        locality:'ตำบล ศาลายา',
        subLocality:'',
        thoroughfare:'ซอย บ้านตั้งสิน',
        subThoroughfare:'58/4 หมู่ 4',
      )];
      when(geocodingPlatform.placemarkFromCoordinates(13.794563725876568, 100.3255952091743)).thenAnswer((_) async => placemarks);
      final res = await mapService1.convertLatLngToAddress(13.794563725876568, 100.3255952091743, geocodingPlatform);
      expect(res, '58 58/4 หมู่ 4 ซอย บ้านตั้งสิน ตำบล ศาลายา อำเภอพุทธมณฑล นครปฐม 73170 ประเทศไทย');
    });
  });
}