import 'dart:collection';

import 'package:pillmate/models/medicine.dart';
import 'package:pillmate/services/sqlite_service.dart';

class MedicineService{

  final SqliteService sqliteService ;
  MedicineService({required this.sqliteService});

  Future<Map<String, List<MedicineModel>>> getMedicines() async {
    final _activeDrugsList = await sqliteService.getActiveMedicine();
    final _inactiveDrugsList = await sqliteService.getInactiveMedicine();
    Map<String, List<MedicineModel>> res = {};
    List<MedicineModel> _capsuleDrugsList = [];
    List<MedicineModel> _tabDrugsList = [];
    List<MedicineModel> _inactiveCapsuleDrugsList = [];
    List<MedicineModel> _inactiveTabDrugsList = [];
    _activeDrugsList.forEach((element) {
      if(element.typeOfMedicine.toLowerCase() == 'capsule'){
        _capsuleDrugsList.add(element);
      }
      else if(element.typeOfMedicine.toLowerCase() == 'tablet'){
        _tabDrugsList.add(element);
      }
    });
    _inactiveDrugsList.forEach((element) {
      if(element.typeOfMedicine.toLowerCase() == 'capsule'){
        _inactiveCapsuleDrugsList.add(element);
      }
      else if(element.typeOfMedicine.toLowerCase() == 'tablet'){
        _inactiveTabDrugsList.add(element);
      }
    });
    res['capsuleDrugsList'] = _capsuleDrugsList;
    res['tabDrugsList'] = _tabDrugsList;
    res['inactiveCapsuleDrugsList'] = _inactiveCapsuleDrugsList;
    res['inactiveTabDrugsList'] = _inactiveTabDrugsList;
    return res;
    }

  Map<String, List<MedicineModel>> addToSperateList(List<MedicineModel> _drugsList){
    Map<String, List<MedicineModel>> res = {};
    List<MedicineModel> _morningDrugsList = [];
    List<MedicineModel> _noonDrugsList = [];
    List<MedicineModel> _eveningDrugsList = [];
    List<MedicineModel> _nightDrugsList = [];
    _drugsList.forEach((element) async {
      print(element.takeMedWhen);
      if(element.takeMedWhen != null || element.takeMedWhen != "" ){
        String tmp = '';
        var listOfMed = element.medicationSchedule.split(',');
        final dailyMed = listOfMed[0].split(' ');
        if(dailyMed[0] == (DateTime.now().day-1).toString()){
          tmp = element.medicationSchedule;
          print(tmp);
          if(
          dailyMed.length != 1
          ){
            final listWhen = element.takeMedWhen.split(' ');
            final diff = listWhen.length - dailyMed.length - 1;
            final last = listOfMed[listOfMed.length - 1].split(' ');
            if(last.length + dailyMed.length - 1 <= listWhen.length+1){
              for(int i = 1; i <= dailyMed.length-1;i++){
                for(int j = 0; j < listWhen.length;j++){
                  if(last[last.length-1] == listWhen[j] && j != listWhen.length-1){
                    tmp += ' ';
                    tmp += listWhen[j+1];
                  }
                }
              }
            }
          }
          final tempList = tmp.split(',');
          tmp = '';
          for(int i = 1;i < tempList.length;i++){
            if(i == tempList.length-1){
              tmp+=tempList[i];
            }else{
              tmp+=tempList[i];
              tmp+=',';
            }
          }
          await sqliteService.alterMedicationSchedule(element.qrcodeID, tmp);
        }
        if(dailyMed[0] == DateTime.now().day.toString()){
          for(int i = 0; i < dailyMed.length;i++){
            if(dailyMed[i] == 'เช้า'){
              _morningDrugsList.add(element);
            }
            else if(dailyMed[i] == 'กลางวัน'){
              _noonDrugsList.add(element);
            }
            else if(dailyMed[i] == 'เย็น'){
              _eveningDrugsList.add(element);
            }
            else if(dailyMed[i] == 'ก่อนนอน'){
              _nightDrugsList.add(element);
            }
          }
        }
      }
    });
    res['morning'] = _morningDrugsList;
    res['noon'] = _noonDrugsList;
    res['evening'] = _eveningDrugsList;
    res['night'] = _nightDrugsList;
    return res;
  }

}