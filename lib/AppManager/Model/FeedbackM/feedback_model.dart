class FeedbackModel {
  final int studentId;
  final String title;
  final String description;
  final String createdDate;

  FeedbackModel({
    required this.studentId,
    required this.title,
    required this.description,
    required this.createdDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "studentId": studentId,
      "title": title,
      "description": description,
      "createdDate": createdDate,
    };
  }
}