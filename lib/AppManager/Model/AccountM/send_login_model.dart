class SendLoginRequest {
  final String username;
  final String password;
  final String deviceToken;

  SendLoginRequest({required this.username, required this.password, required this.deviceToken,});

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "deviceType":"Android",
      "deviceToken":deviceToken,
    };
  }
}

class SendLoginResponse {
  final String message;
  final Student? student;

  SendLoginResponse({required this.message, this.student});

  factory SendLoginResponse.fromJson(Map<String, dynamic> json) {
    return SendLoginResponse(
      message: json['message'] ?? '',
      student: json['student'] != null ? Student.fromJson(json['student']) : null,
    );
  }
}

class Student {
  final int studentId;
  final String studentName;
  final String fatherName;
  final String motherName;
  final String email;
  final String mobile;
  final String className;
  final String sectionName;
  final int admissionNo;
  final String schoolName;

  Student({
    required this.studentId,
    required this.studentName,
    required this.fatherName,
    required this.motherName,
    required this.email,
    required this.mobile,
    required this.className,
    required this.sectionName,
    required this.admissionNo,
    required this.schoolName,
  });
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['studentId'] ?? 0,
      studentName: json['studentName'] ?? '',
      fatherName: json['fatherName'] ?? '',
      motherName: json['motherName'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      className: json['className'] ?? '',
      sectionName: json['sectionName'] ?? '',
      admissionNo: json['admissionNo'] ??0,
      schoolName: json['schoolName'] ?? '',
    );
  }

  // ✅ Added this to support SharedPreferences storage
  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'fatherName': fatherName,
      'motherName': motherName,
      'email': email,
      'mobile': mobile,
      'className': className,
      'sectionName': sectionName,
      'admissionNo': admissionNo,
      'schoolName': schoolName,
    };
  }
}