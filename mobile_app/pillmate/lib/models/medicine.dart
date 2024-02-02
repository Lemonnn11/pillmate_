class MedicineModel{
  final String qrcodeID;
  final String pharID;
  final int dosagePerTake;
  final int timePerDay;
  final String timeOfMed;
  final String timePeriodForMed;
  final String takeMedWhen;
  final String expiredDate;
  final String date;
  final String conditionOfUse;
  final String additionalAdvice;
  final int amountOfMeds;
  final double quantity;
  final String adverseDrugReaction;
  final String typeOfMedicine;
  final String genericName;
  final String tradeName;
  final String savedDate;
  final int amountTaken;
  final int status;
  final String medicationSchedule;

  MedicineModel(this.qrcodeID, this.pharID, this.dosagePerTake, this.timePerDay, this.timeOfMed, this.timePeriodForMed, this.takeMedWhen, this.expiredDate, this.date, this.conditionOfUse, this.additionalAdvice, this.amountOfMeds, this.quantity, this.adverseDrugReaction, this.typeOfMedicine, this.genericName, this.tradeName, this.savedDate, this.amountTaken, this.status, this.medicationSchedule);

  MedicineModel.fromMap(Map<String, dynamic> item):
        qrcodeID=item["qrcode_id"], pharID=item["phar_id"], dosagePerTake=item["dosage_per_take"],
        timePerDay=item["time_per_day"] ?? "", timeOfMed=item["time_of_med"], timePeriodForMed=item["time_period_for_med"] ?? "",
        takeMedWhen=item["take_med_when"] ?? "", expiredDate=item["expired_date"],
        date=item["dispensing_date"], conditionOfUse=item["condition_of_use"], additionalAdvice=item["additional_advice"],
        amountOfMeds=item["amount"], quantity=item["quantity"],adverseDrugReaction=item["adverse_drug_reaction"],
        typeOfMedicine=item["type_of_medicine"],genericName=item["generic_name"],tradeName=item["trade_name"], savedDate=item["saved_date"], amountTaken=item["amount_taken"], status=item["status"],
        medicationSchedule=item["medication_schedule"];

  Map<String, Object> toMap(){
    return {
      'qrcode_id': qrcodeID,
      'phar_id': pharID,
      'dosage_per_take': dosagePerTake,
      'time_per_day': timePerDay,
      'time_of_med': timeOfMed,
      'time_period_for_med': timePeriodForMed,
      'take_med_when': takeMedWhen,
      'expired_date': expiredDate,
      'dispensing_date': date,
      'condition_of_use': conditionOfUse,
      'additional_advice': additionalAdvice,
      'amount': amountOfMeds,
      'quantity': quantity,
      'adverse_drug_reaction': adverseDrugReaction,
      'type_of_medicine': typeOfMedicine,
      'generic_name': genericName,
      'trade_name': tradeName,
      'saved_date': savedDate,
      'amount_taken': amountTaken,
      'status': status,
      'medication_schedule': medicationSchedule
    };
  }


}