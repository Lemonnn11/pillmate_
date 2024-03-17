//create separated class for testing function in widget
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:pillmate/pages/add_drug.dart';

void main(){

  group('Test format type of medicine', (){
    test('Tablet should convert to เม็ด', (){
      expect(AddDrugTest.formattedType('Tablet'), 'เม็ด');
    });

    test('Capsule should convert to แคปซูล', (){
      expect(AddDrugTest.formattedType('Capsule'), 'แคปซูล');
    });
  });

  group('Test format date in Thai', (){
    test('date should convert both from 2024-02-19T01:44:23.470Z to 19 ก.พ. 2567', (){
      expect(AddDrugTest.formattedDate('2024-02-19T01:44:23.470Z', '2024-02-19T01:44:23.470Z'), ['19 ก.พ. 2567', '19 กุมภาพันธ์ 2567']);
    });
  });

  group('check whether day in medication schedule over a month', () {
    test('check valid day in Jan', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 1, 1)), 1);
    });

    test('check invalid day in Jan', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 1, 32)), 1);
    });

    test('check valid day in Feb', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2023, 2, 28)), 28);
    });

    test('check valid day in Feb leap year', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 2, 29)), 29);
    });

    test('check invalid day in Feb', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2023, 2, 29)), 1);
    });

    test('check invalid day in Feb leap year', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 2, 30)), 1);
    });

    test('check valid day in Mar', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 3, 1)), 1);
    });

    test('check invalid day in Mar', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 3, 32)), 1);
    });

    test('check valid day in Apr', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 4, 1)), 1);
    });

    test('check invalid day in Apr', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 4, 32)), 2);
    });

    test('check valid day in May', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 5, 1)), 1);
    });

    test('check invalid day in May', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 5, 32)), 1);
    });

    test('check valid day in Jun', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 6, 1)), 1);
    });

    test('check invalid day in Jun', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 6, 32)), 2);
    });

    test('check valid day in Jul', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 7, 1)), 1);
    });

    test('check invalid day in Jul', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 7, 32)), 1);
    });

    test('check valid day in Aug', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 8, 1)), 1);
    });

    test('check invalid day in Aug', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 8, 32)), 1);
    });

    test('check valid day in Sep', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 9, 1)), 1);
    });

    test('check invalid day in Sep', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 9, 32)), 2);
    });

    test('check valid day in Oct', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 10, 1)), 1);
    });

    test('check invalid day in Oct', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 10, 32)), 1);
    });

    test('check valid day in Nov', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 11, 1)), 1);
    });

    test('check invalid day in Nov', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 11, 32)), 2);
    });

    test('check valid day in Dec', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 12, 1)), 1);
    });

    test('check invalid day in Dec', () {
      expect(AddDrugTest.checkDayOverAmountOfdayInMonth(DateTime.utc(2024, 12, 32)), 1);
    });
  });
}

class AddDrugTest{
  static String formattedType(String typeOfMedicine){
    switch(typeOfMedicine){
      case 'Tablet':
        typeOfMedicine = typeOfMedicine.replaceAll('Tablet', 'เม็ด');
        break;
      case 'Capsule':
        typeOfMedicine = typeOfMedicine.replaceAll('Capsule', 'แคปซูล');
        break;
    }
    return typeOfMedicine;
  }
  static List<String> formattedDate(String expiredDate, String dispensingDate){
    String formattedExpired = '';
    String formattedDispensing = '';

    DateTime exp = DateTime.parse(expiredDate);
    DateTime des = DateTime.parse(dispensingDate);
    final formatter = new DateFormat('d MMMM y');
    formattedExpired = formatter.format(exp);
    List<String> tmpExp = formattedExpired.split(' ');
    switch (tmpExp[1].toLowerCase()) {
      case 'january':
        formattedExpired = formattedExpired.replaceAll('January', 'ม.ค.');
        break;
      case 'february':
        formattedExpired = formattedExpired.replaceAll('February', 'ก.พ.');
        break;
      case 'march':
        formattedExpired = formattedExpired.replaceAll('March', 'มี.ค.');
        break;
      case 'april':
        formattedExpired = formattedExpired.replaceAll('April', 'เม.ย.');
        break;
      case 'may':
        formattedExpired = formattedExpired.replaceAll('May', 'พ.ค.');
        break;
      case 'june':
        formattedExpired = formattedExpired.replaceAll('June', 'มิ.ย.');
        break;
      case 'july':
        formattedExpired = formattedExpired.replaceAll('July', 'ก.ค.');
        break;
      case 'august':
        formattedExpired = formattedExpired.replaceAll('August', 'ส.ค.');
        break;
      case 'september':
        formattedExpired = formattedExpired.replaceAll('September', 'ก.ย.');
        break;
      case 'october':
        formattedExpired = formattedExpired.replaceAll('October', 'ต.ค.');
        break;
      case 'november':
        formattedExpired = formattedExpired.replaceAll('November', 'พ.ย.');
        break;
      case 'december':
        formattedExpired = formattedExpired.replaceAll('December', 'ธ.ค.');
        break;
    }
    List<String> tmpExp1 = formattedExpired.split(' ');
    formattedExpired = tmpExp1[0] + ' ' + tmpExp1[1] + ' ' + (int.parse(tmpExp1[2]) + 543).toString();
    formattedDispensing = formatter.format(des);
    List<String> tmpDes = formattedDispensing.split(' ');
    switch (tmpDes[1].toLowerCase()) {
      case 'january':
        formattedDispensing = formattedDispensing.replaceAll('January', 'มกราคม');
        break;
      case 'february':
        formattedDispensing = formattedDispensing.replaceAll('February', 'กุมภาพันธ์');
        break;
      case 'march':
        formattedDispensing = formattedDispensing.replaceAll('March', 'มีนาคม');
        break;
      case 'april':
        formattedDispensing = formattedDispensing.replaceAll('April', 'เมษายน');
        break;
      case 'may':
        formattedDispensing = formattedDispensing.replaceAll('May', 'พฤษภาคม');
        break;
      case 'june':
        formattedDispensing = formattedDispensing.replaceAll('June', 'มิถุนายน');
        break;
      case 'july':
        formattedDispensing = formattedDispensing.replaceAll('July', 'กรกฎาคม');
        break;
      case 'august':
        formattedDispensing = formattedDispensing.replaceAll('August', 'สิงหาคม');
        break;
      case 'september':
        formattedDispensing = formattedDispensing.replaceAll('September', 'กันยายน');
        break;
      case 'october':
        formattedDispensing = formattedDispensing.replaceAll('October', 'ตุลาคม');
        break;
      case 'november':
        formattedDispensing = formattedDispensing.replaceAll('November', 'พฤศจิกายน');
        break;
      case 'december':
        formattedDispensing = formattedDispensing.replaceAll('December', 'ธันวาคม');
        break;
    }
    List<String> tmpDes1 = formattedDispensing.split(' ');
    formattedDispensing = tmpDes1[0] + ' ' + tmpDes1[1] + ' ' + (int.parse(tmpDes1[2]) + 543).toString();

    return [formattedExpired, formattedDispensing];
  }
  static int checkDayOverAmountOfdayInMonth(DateTime dt){
    int day = dt.day;
    switch(dt.month.toString()){
      case '1': {
        if(day > 31){
          return day-31;
        }else{
          return day;
        }
      }

      case '2': {
        bool isLeapYear = false;
        if (dt.year % 4 == 0) {
          if (dt.year % 100 == 0) {
            if (dt.year % 400 == 0) {
              isLeapYear = true;
            } else {
              isLeapYear = false;
            }
          } else {
            isLeapYear = true;
          }
        } else {
          isLeapYear = false;
        }
        if(isLeapYear){
          if(day > 29){
            return day-29;
          }else{
            return day;
          }
        }else{
          if(day > 28){
            return day-28;
          }else{
            return day;
          }
        }

      }

      case '3': {
        if(day > 31){
          return day-31;
        }else{
          return day;
        }
      }

      case '4': {
        if(day > 30){
          return day-30;
        }else{
          return day;
        }
      }

      case '5': {
        if(day > 31){
          return day-31;
        }else{
          return day;
        }
      }

      case '6': {
        if(day > 30){
          return day-30;
        }else{
          return day;
        }
      }

      case '7': {
        if(day > 31){
          return day-31;
        }else{
          return day;
        }
      }

      case '8': {
        if(day > 31){
          return day-31;
        }else{
          return day;
        }
      }
      break;

      case '9': {
        if(day > 30){
          return day-30;
        }else{
          return day;
        }
      }

      case '10': {
        if(day > 31){
          return day-31;
        }else{
          return day;
        }
      }
      case '11': {
        if(day > 30){
          return day-30;
        }else{
          return day;
        }
      }

      case '12': {
        if(day > 31){
          return day-31;
        }else{
          return day;
        }
      }
    }
    return day;
  }
}
