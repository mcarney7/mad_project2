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
  bool isLoading = true;

  final String alphaVantageApiKey = "KVNECXPCDNDOEBTE";

  @override
  void initState() {
    super.initState();
    fetchGeneralNews();
  }

  Future<void> fetchGeneralNews() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch general news using Alpha Vantage API
      final response = await http.get(Uri.parse(
          'https://www.alphavantage.co/query?function=NEWS_SENTIMENT&apikey=$alphaVantageApiKey'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('feed')) {
          setState(() {
            news = data['feed'];
          });
        } else {
          throw Exception(data['Note'] ?? "Unexpected API response.");
        }
      } else {
        throw Exception("Failed to fetch news. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching news: $e");
      setState(() {
        news = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : news.isEmpty
              ? Center(child: Text("No news available."))
              : ListView.builder(
                  padding: EdgeInsets.all(15),
                  itemCount: news.length,
                  itemBuilder: (context, index) {
                    final newsItem = news[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 15),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          newsItem['title'] ?? "No Title",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(newsItem['source'] ?? "Unknown Source"),
                        trailing: Icon(Icons.open_in_new, color: Colors.grey),
                        onTap: () {
                          if (newsItem['url'] != null) {
                            _launchURL(newsItem['url']);
                          }
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
