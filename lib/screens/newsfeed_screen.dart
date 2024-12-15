import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NewsfeedScreen extends StatefulWidget {
  @override
  _NewsfeedScreenState createState() => _NewsfeedScreenState();
}

class _NewsfeedScreenState extends State<NewsfeedScreen> {
  List<dynamic> news = [];
  String selectedCategory = "general";
  bool isLoading = true;

  final Map<String, String> categories = {
    "general": "General",
    "company": "Company News",
    "market": "Market Trends",
    "technology": "Technology",
    "energy": "Energy",
  };

  @override
  void initState() {
    super.initState();
    fetchNews(selectedCategory);
  }

  Future<void> fetchNews(String category) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://finnhub.io/api/v1/news?category=$category&token=ctbk6qpr01qvslquoa7gctbk6qpr01qvslquoa80'));
      setState(() {
        news = json.decode(response.body);
      });
    } catch (e) {
      print("Error fetching news: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void changeCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
    fetchNews(category);
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Newsfeed"),
        backgroundColor: Colors.blueAccent,
        actions: [
          PopupMenuButton<String>(
            onSelected: changeCategory,
            itemBuilder: (context) {
              return categories.entries.map((entry) {
                return PopupMenuItem(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList();
            },
            icon: Icon(Icons.filter_list),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : news.isEmpty
              ? Center(child: Text("No news available for this category."))
              : ListView.builder(
                  padding: EdgeInsets.all(15),
                  itemCount: news.length,
                  itemBuilder: (context, index) {
                    final newsItem = news[index];
                    final url = newsItem['url'];

                    return Card(
                      margin: EdgeInsets.only(bottom: 15),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          newsItem['headline'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(newsItem['source']),
                        trailing: Icon(Icons.open_in_new, color: Colors.grey),
                        onTap: () {
                          if (url != null) {
                            _launchURL(url);
                          }
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
