class StudentDetailModel {
  final int studentId;
  final String studentName;
  final int classId;
  final int sectionId;
  final String pickupTime;
  final String dropTime;
  final String schoolName;
  final String className;
  final String sectionName;
  final String sessionName;
  final String address;
  final String fatherName;
  final String motherName;
  final String mobile;
  final int admissionNo;
  final String email;
  final String studentPhoto;

  StudentDetailModel({
    required this.studentId,
    required this.studentName,
    required this.classId,
    required this.sectionId,
    required this.pickupTime,
    required this.dropTime,
    required this.schoolName,
    required this.className,
    required this.sectionName,
    required this.sessionName,
    required this.address,
    required this.fatherName,
    required this.motherName,
    required this.mobile,
    required this.admissionNo,
    required this.email,
    required this.studentPhoto,
  });

  factory StudentDetailModel.fromJson(Map<String, dynamic> json) {
    return StudentDetailModel(
      studentId: json['studentId'] ?? 0,
      studentName: json['studentName'] ?? '',
      classId: json['classId'] ?? 0,
      sectionId: json['sectionId'] ?? 0,
      pickupTime: json['pickupTime'] ?? '',
      dropTime: json['dropTime'] ?? '',
      schoolName: json['schoolName'] ?? '',
      className: json['className'] ?? '',
      sectionName: json['sectionName'] ?? '',
      sessionName: json['sessionName'] ?? '',
      address: json['address'] ?? '',
      fatherName: json['fatherName'] ?? '',
      motherName: json['motherName'] ?? '',
      mobile: json['mobile'] ?? '',
      admissionNo: json['admissionNo'] ?? 0,
      email: json['email'] ?? '',
      studentPhoto: json['studentPhoto'] ?? '',
    );
  }
}