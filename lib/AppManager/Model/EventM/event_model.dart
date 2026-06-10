class EventModel {
  final int id;
  final String eventTitle;
  final DateTime eventDate;
  final DateTime endDate;
  final bool isActive;

  EventModel({
    required this.id,
    required this.eventTitle,
    required this.eventDate,
    required this.endDate,
    required this.isActive,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      eventTitle: json['eventTitle'] ?? '',
      eventDate: DateTime.parse(json['eventDate']),
      endDate: DateTime.parse(json['endDate']),
      isActive: json['isActive'] ?? false,
    );
  }
}