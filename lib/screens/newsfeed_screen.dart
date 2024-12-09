import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsfeedScreen extends StatelessWidget {
  Future<List<dynamic>> fetchNews() async {
    final response = await http.get(Uri.parse(
        'https://finnhub.io/api/v1/news?category=general&token=ctbk6qpr01qvslquoa7gctbk6qpr01qvslquoa80'));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Newsfeed"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final news = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(15),
            itemCount: news.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.only(bottom: 15),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    news[index]['headline'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(news[index]['source']),
                  trailing: Icon(Icons.open_in_new, color: Colors.grey),
                  onTap: () {
                    // Placeholder for opening news in a browser or web view
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
