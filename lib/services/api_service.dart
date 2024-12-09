import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  // Fetch stock data
  Future<Map<String, dynamic>> fetchStockData(String symbol) async {
    final url = "$finnhubBaseUrl/quote?symbol=$symbol&token=$finnhubApiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load stock data");
    }
  }

  // Fetch news
  Future<List<dynamic>> fetchNews() async {
    final url = "$finnhubBaseUrl/news?category=general&token=$finnhubApiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load news");
    }
  }
}
