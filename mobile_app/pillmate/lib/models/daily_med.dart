class DaileyMedModel{
  final int id;
  final int day;
  final int amountTaken;
  final int dailyMed;
  final int morningTimeHour;
  final int morningTimeMinute;
  final int noonTimeHour;
  final int noonTimeMinute;
  final int eveningTimeHour;
  final int eveningTimeMinute;
  final int nightTimeHour;
  final int nightTimeMinute;

  DaileyMedModel(
      this.id,
      this.day,
      this.amountTaken,
      this.dailyMed,
      this.morningTimeHour,
      this.morningTimeMinute,
      this.noonTimeHour,
      this.noonTimeMinute,
      this.eveningTimeHour,
      this.eveningTimeMinute,
      this.nightTimeHour,
      this.nightTimeMinute,
      );

  DaileyMedModel.fromMap(Map<String, dynamic> item)
      : id = item["id"],
        day = item["day"],
        amountTaken = item["amount_taken"],
        dailyMed = item["daily_med"],
        morningTimeHour = item["morning_time_hour"],
        morningTimeMinute = item["morning_time_minute"],
        noonTimeHour = item["noon_time_hour"],
        noonTimeMinute = item["noon_time_minute"],
        eveningTimeHour = item["evening_time_hour"],
        eveningTimeMinute = item["evening_time_minute"],
        nightTimeHour = item["night_time_hour"],
        nightTimeMinute = item["night_time_minute"];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'day': day,
      'amount_taken': amountTaken,
      'daily_med': dailyMed,
      'morning_time_hour': morningTimeHour,
      'morning_time_minute': morningTimeMinute,
      'noon_time_hour': noonTimeHour,
      'noon_time_minute': noonTimeMinute,
      'evening_time_hour': eveningTimeHour,
      'evening_time_minute': eveningTimeMinute,
      'night_time_hour': nightTimeHour,
      'night_time_minute': nightTimeMinute,
    };
  }


}