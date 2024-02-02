// PERSONAL_INFO(id INTEGER PRIMARY KEY AUTOINCREMENT, dob TEXT, blood_type TEXT, gender TEXT, weight REAL, height REAL, health_condition TEXT, drug_allergies TEXT, personal_medicine TEXT)
import 'package:sqflite/sqflite.dart';

class PersonalInformationModel{
  final int id;
  final String name;
  final String dob;
  final String bloodType;
  final String gender;
  final double weight;
  final double height;
  final String healthCondition;
  final String drugAllergies;
  final String personalMedicine;

  PersonalInformationModel(this.id,  this.name, this.dob, this.gender, this.weight, this.height, this.healthCondition, this.drugAllergies, this.personalMedicine, this.bloodType);

  PersonalInformationModel.fromMap(Map<String, dynamic> item):
      id=item["id"], name=item["name"], dob=item["dob"], bloodType=item["blood_type"] ?? "", gender=item["gender"], weight=item["weight"], height=item["height"], healthCondition=item["health_condition"],
      drugAllergies=item["drug_allergies"], personalMedicine=item["personal_medicine"] ?? "";

  Map<String, Object> toMap(){
    return {
      'id': id,
      'name': name,
      'dob': dob,
      'blood_type': bloodType,
      'gender': gender,
      'weight': weight,
      'height': height,
      'health_condition': healthCondition,
      'drug_allergies': drugAllergies,
      'personal_medicine': personalMedicine,
    };
  }


}