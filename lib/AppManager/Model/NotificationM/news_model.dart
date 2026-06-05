import 'dart:convert';

List<NewsModel> newsModelFromJson(String str) =>
    List<NewsModel>.from(json.decode(str).map((x) => NewsModel.fromJson(x)));

class NewsModel {
  final int id;
  final DateTime date;
  final String title;
  final String description;

  NewsModel({
    required this.id,
    required this.date,
    required this.title,
    required this.description,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
    id: json["id"] ?? 0,
    date: DateTime.parse(json["date"]),
    title: json["title"] ?? "No Title",
    description: json["description"] ?? "No Description",
  );
}