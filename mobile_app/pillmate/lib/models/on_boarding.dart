class OnBoardingModel{
  final int id;
  final int firstTime;

  OnBoardingModel(
      this.id,
      this.firstTime,
      );

  OnBoardingModel.fromMap(Map<String, dynamic> item)
  : id = item["id"],
    firstTime = item["first_time"];

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'first_time': firstTime
    };
  }
}


