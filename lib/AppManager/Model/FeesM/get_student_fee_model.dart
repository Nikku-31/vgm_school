class StudentFeeResponse {
  final bool success;
  final int feeYear;
  final List<FeeData> data;

  StudentFeeResponse({required this.success, required this.feeYear, required this.data});

  factory StudentFeeResponse.fromJson(Map<String, dynamic> json) {
    return StudentFeeResponse(
      success: json['success'] ?? false,
      feeYear: json['feeYear'] ?? 0,
      data: (json['data'] as List?)?.map((i) => FeeData.fromJson(i)).toList() ?? [],
    );
  }
}

class FeeData {
  final int studentId;
  final int admissionNo;
  final String studentName;
  final String fatherName;
  final String className;
  final String sectionName;
  final int feeHeadId;
  final String feeName;
  final double feeAmount;
  final String status;
  final double previousBalance;

  FeeData({
    required this.studentId,
    required this.admissionNo,
    required this.studentName,
    required this.fatherName,
    required this.className,
    required this.sectionName,
    required this.feeHeadId,
    required this.feeName,
    required this.feeAmount,
    required this.status,
    required this.previousBalance,
  });

  factory FeeData.fromJson(Map<String, dynamic> json) {
    return FeeData(
      studentId: json['studentId'] ?? 0,
      admissionNo: json['admissionNo'] ?? 0,
      studentName: json['studentName'] ?? '',
      fatherName: json['fatherName'] ?? '',
      className: json['className'] ?? '',
      sectionName: json['sectionName'] ?? '',
      feeHeadId: json['feeHeadId'] ?? 0,
      feeName: json['feeName'] ?? '',
      // Safely convert to double to prevent "type 'double' is not a subtype of type 'int'"
      feeAmount: (json['feeAmount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      previousBalance:
      (json['previousBalance'] as num?)?.toDouble() ?? 0.0 ,
    );
  }
}