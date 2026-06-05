class StudentAttendanceModel {
  final DateTime date;
  final String status;

  StudentAttendanceModel({
    required this.date,
    required this.status,
  });

  factory StudentAttendanceModel.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceModel(
      date: DateTime.parse(json['date']),
      status: json['status'],
    );
  }
}
