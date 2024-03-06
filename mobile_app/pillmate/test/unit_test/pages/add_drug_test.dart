//create separated class for testing function in widget
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main(){
  group('Test format type of medicine', (){
    test('Tablet should convert to เม็ด', (){
      expect(AddDrug.formattedType('Tablet'), 'เม็ด');
    });

    test('Capsule should convert to แคปซูล', (){
      expect(AddDrug.formattedType('Capsule'), 'แคปซูล');
    });
  });

  group('Test format date in Thai', (){
    test('date should convert both from 2024-02-19T01:44:23.470Z to 19 ก.พ. 2567', (){
      expect(AddDrug.formattedDate('2024-02-19T01:44:23.470Z', '2024-02-19T01:44:23.470Z'), ['19 ก.พ. 2567', '19 ก.พ. 2567']);
    });
  });
}

class AddDrug{
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
}
