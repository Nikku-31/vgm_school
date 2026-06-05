import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../Model/NotificationM/news_model.dart';

class NewsService {

  Future<List<NewsModel>> fetchNews() async {
    try {
      final uri = Uri.parse(ApiConstants.GetAllLatestNews);

      print("REQUEST URL: $uri");

      final response = await http.get(uri);

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        return newsModelFromJson(response.body);
      } else {
        throw Exception("Failed to load news");
      }
    } catch (e) {
      print("ERROR: $e");
      throw Exception("Error fetching news: $e");
    }
  }
}