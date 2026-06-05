class UpcomingClassesModel {
  final String? currentDate;
  final String? subjectName;
  final String? teacherName;
  final String? fromTime;
  final String? toTime;
  final String? day;

  UpcomingClassesModel({
    this.currentDate,
    this.subjectName,
    this.teacherName,
    this.fromTime,
    this.toTime,
    this.day,
  });

  factory UpcomingClassesModel.fromJson(
      Map<String, dynamic> json) {

    return UpcomingClassesModel(
      currentDate: json["currentDate"],
      subjectName: json["subjectName"],
      teacherName: json["teacherName"],
      fromTime: json["fromTime"],
      toTime: json["toTime"],
      day: json["day"],
    );
  }
}