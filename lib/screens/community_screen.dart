import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  final List<Map<String, String>> posts = [
    {"author": "Investor101", "content": "AAPL is soaring! Great time to buy."},
    {"author": "TraderJane", "content": "Tesla's growth is impressive this quarter."},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Community Insights"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(15),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: 15),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(posts[index]['author']![0]),
              ),
              title: Text(posts[index]['author']!,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(posts[index]['content']!),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Placeholder for adding a new post
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}
