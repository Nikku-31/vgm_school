class ChangePasswordRequest {
  final int studentId;
  final String oldPassword;
  final String newPassword;

  ChangePasswordRequest({
    required this.studentId,
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    "studentId": studentId,
    "oldPassword": oldPassword,
    "newPassword": newPassword,
  };
}

class ChangePasswordResponse {
  final String message;

  ChangePasswordResponse({required this.message});

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      message: json["message"] ?? "Operation completed",
    );
  }
}