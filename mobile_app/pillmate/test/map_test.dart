import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pillmate/services/map.dart';
import 'package:http/http.dart' as http;

import 'map_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MapService>(), MockSpec<http.Client>()])
void main(){
  late MapService mapService;
  setUpAll((){
    mapService = MockMapService();
  });

  group('test get current location', () {
    test('get current location on mobile phone', (){

    });
  });
}