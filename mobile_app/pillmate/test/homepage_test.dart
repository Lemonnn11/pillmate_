import 'package:flutter_test/flutter_test.dart';

void main(){
  group('set date format in thai based on given date time', () {
    test('test formate in thai on mon jan', () {
      expect(HomepageTest.setHeader(DateTime.utc(2024, 1, 1)), 'วันจันทร์ที่ 1 มกราคม');
    });
    test('test formate in thai on tue feb', () {
      expect(HomepageTest.setHeader(DateTime.utc(2024, 2, 6)), 'วันอังคารที่ 6 กุมภาพันธ์');
    });
    test('test formate in thai on wed mar', () {
      expect(HomepageTest.setHeader(DateTime.utc(2024, 3, 6)), 'วันพุธที่ 6 มีนาคม');
    });
    test('test formate in thai on thu apr', () {
      expect(HomepageTest.setHeader(DateTime.utc(2024, 4, 4)), 'วันพฤหัสบดีที่ 4 เมษายน');
    });
    test('test formate in thai on fri may', () {
      expect(HomepageTest.setHeader(DateTime.utc(2024, 5, 3)),'วันศุกร์ที่ 3 พฤษภาคม');
    });
    test('test formate in thai on sat jun', () {
      expect(HomepageTest.setHeader(DateTime.utc(2024,6, 1)), 'วันเสาร์ที่ 1 มิถุนายน');
    });
    test('test formate in thai on sun july', () {
      expect(HomepageTest.setHeader(DateTime.utc(2024, 7, 7)), 'วันอาทิตย์ที่ 7 กรกฎาคม');
    });
    test('test formate in thai on aug', () {
      expect(HomepageTest.setHeader(DateTime.utc(2024, 8, 6)), 'วันอังคารที่ 6 สิงหาคม');
    });
    test('test formate in thai on sep', () {
      expect(HomepageTest.setHeader(DateTime.utc(2024, 9, 6)), 'วันศุกร์ที่ 6 กันยายน');
    });
    test('test formate in thai on oct', () {
      expect(HomepageTest.setHeader(DateTime.utc(2024, 10, 6)), 'วันอาทิตย์ที่ 6 ตุลาคม');
    });
    test('test formate in thai on nov', () {
      expect(HomepageTest.setHeader(DateTime.utc(2024, 11, 6)), 'วันพุธที่ 6 พฤศจิกายน');
    });
    test('test formate in thai on dec', () {
      expect(HomepageTest.setHeader(DateTime.utc(2024, 12, 6)), 'วันศุกร์ที่ 6 ธันวาคม');
    });
  });
}

class HomepageTest{
  static String setHeader(DateTime dt){
    String date = '';
    date += 'วัน';
    switch (dt.weekday) {
      case 1:
        date += 'จันทร์';
        break;
      case 2:
        date += 'อังคาร';
        break;
      case 3:
        date += 'พุธ';
        break;
      case 4:
        date += 'พฤหัสบดี';
        break;
      case 5:
        date += 'ศุกร์';
        break;
      case 6:
        date += 'เสาร์';
        break;
      case 7:
        date += 'อาทิตย์';
        break;
      default:
        date += 'ไม่ทราบ';
    }
    date += 'ที่ ';
    date += dt.day.toString();
    switch (dt.month) {
      case 1:
        date += ' มกราคม';
        break;
      case 2:
        date += ' กุมภาพันธ์';
        break;
      case 3:
        date += ' มีนาคม';
        break;
      case 4:
        date += ' เมษายน';
        break;
      case 5:
        date += ' พฤษภาคม';
        break;
      case 6:
        date += ' มิถุนายน';
        break;
      case 7:
        date += ' กรกฎาคม';
        break;
      case 8:
        date += ' สิงหาคม';
        break;
      case 9:
        date += ' กันยายน';
        break;
      case 10:
        date += ' ตุลาคม';
        break;
      case 11:
        date += ' พฤศจิกายน';
        break;
      case 12:
        date += ' ธันวาคม';
        break;
      default:
        date += ' ไม่ทราบ';
    }
    return date;
  }
}