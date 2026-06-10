import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Model/EventM/event_model.dart';

class EventService {
  Future<List<EventModel>> getEvents() async {
    try {
      final response = await http.get(
        Uri.parse("https://dbs.online-tech.in/GetEventCalendar"),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        return data.map((e) => EventModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load events");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}