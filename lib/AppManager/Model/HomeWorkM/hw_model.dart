class HwModel {
  final int hwId;
  final DateTime date;
  final int classId;
  final String className;
  final int sectionId;
  final String sectionName;
  final int subjectId;
  final String subjectName;
  final String title;
  final String remarks;
  final String attachmentFile;

  HwModel({
    required this.hwId,
    required this.date,
    required this.classId,
    required this.className,
    required this.sectionId,
    required this.sectionName,
    required this.subjectId,
    required this.subjectName,
    required this.title,
    required this.remarks,
    required this.attachmentFile,
  });

  factory HwModel.fromJson(Map<String, dynamic> json) {
    return HwModel(
      hwId: json['hwId'] ?? 0,
      date: DateTime.parse(json['date']),
      classId: json['class_id'] ?? 0,
      className: json['className'] ?? '',
      sectionId: json['section_id'] ?? 0,
      sectionName: json['sectionName'] ?? '',
      subjectId: json['subject_id'] ?? 0,
      subjectName: json['subjectName'] ?? '',
      title: json['title'] ?? '',
      remarks: json['remarks'] ?? '',
      attachmentFile: json['attachmentFile'] ?? '',
    );
  }
}
