import 'package:flutter/material.dart';
import '../../Model/EventM/event_model.dart';
import '../../Service/EventS/event_service.dart';

class EventViewModel extends ChangeNotifier {
  final EventService _service = EventService();

  List<EventModel> events = [];
  bool isLoading = false;

  Future<void> fetchEvents() async {
    try {
      isLoading = true;
      notifyListeners();

      events = await _service.getEvents();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<EventModel> getEventsForDay(DateTime day) {
    return events.where((event) {
      return event.eventDate.year == day.year &&
          event.eventDate.month == day.month &&
          event.eventDate.day == day.day;
    }).toList();
  }
}