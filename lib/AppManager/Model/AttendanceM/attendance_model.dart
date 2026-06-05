class AttendanceModel {
  final int studentId;
  final DateTime date;
  final String status;

  AttendanceModel({
    required this.studentId,
    required this.date,
    required this.status,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      studentId: json['studentId'],
      date: DateTime.parse(json['date']),
      status: json['status'],
    );
  }
}