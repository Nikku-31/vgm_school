class TbModel {
  final int id;
  final int classId;
  final String className;
  final int sectionId;
  final String sectionName;
  final int subjectId;
  final String subjectName;
  final int employeeId;
  final String employeeName;
  final String fromTime;
  final String toTime;
  final String day;

  TbModel({
    required this.id,
    required this.classId,
    required this.className,
    required this.sectionId,
    required this.sectionName,
    required this.subjectId,
    required this.subjectName,
    required this.employeeId,
    required this.employeeName,
    required this.fromTime,
    required this.toTime,
    required this.day,
  });

  factory TbModel.fromJson(Map<String, dynamic> json) {
    return TbModel(
      id: json['id'] ?? 0,
      classId: json['classId'] ?? 0,
      className: json['className'] ?? "",
      sectionId: json['sectionId'] ?? 0,
      sectionName: json['sectionName'] ?? "",
      subjectId: json['subjectId'] ?? 0,
      subjectName: json['subjectName'] ?? "",
      employeeId: json['employeeId'] ?? 0,
      employeeName: json['employeeName'] ?? "",
      fromTime: json['fromTime'] ?? "",
      toTime: json['toTime'] ?? "",
      day: json['day'] ?? "",
    );
  }
}
