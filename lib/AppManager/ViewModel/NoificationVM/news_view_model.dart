import 'package:flutter/material.dart';
import '../../Model/NotificationM/news_model.dart';
import '../../Service/NotificationS/news_service.dart';

class NewsViewModel extends ChangeNotifier {
  final NewsService _newsService = NewsService();

  List<NewsModel> _newsList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<NewsModel> get newsList => _newsList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> getAllNews() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _newsList = await _newsService.fetchNews();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}