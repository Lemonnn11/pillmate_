import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pillmate/services/map.dart';
import 'package:http/http.dart' as http;

import 'map_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MapService>(), MockSpec<http.Client>()])
void main(){
  // late MapService mapService;
  // setUpAll((){
  //   mapService = MockMapService();
  // });

  // group('test get current location', () {
  //   test('get current location on mobile phone', () async {
  //     when(mapService.getCurrentLocation()).thenAnswer((_) async => LatLng(13.77765254802144, 100.52532826905029) );
  //     final res = await mapService.getCurrentLocation();
  //     expect(res, LatLng(13.77765254802144, 100.52532826905029));
  //   });
  // });

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
}