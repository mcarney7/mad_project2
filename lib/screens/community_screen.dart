import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final List<Map<String, dynamic>> posts = [
    {
      "author": "Investor101",
      "content": "AAPL is soaring! Great time to buy.",
      "likes": 10,
      "comments": 3,
      "shared": false,
    },
    {
      "author": "TraderJane",
      "content": "Tesla's growth is impressive this quarter.",
      "likes": 20,
      "comments": 5,
      "shared": true,
    },
  ];

  void addPost(String author, String content) {
    setState(() {
      posts.insert(0, {
        "author": author,
        "content": content,
        "likes": 0,
        "comments": 0,
        "shared": false,
      });
    });
  }

  void toggleLike(int index) {
    setState(() {
      posts[index]["likes"] = (posts[index]["likes"] as int) + 1;
    });
  }

  void toggleShare(int index) {
    setState(() {
      posts[index]["shared"] = !(posts[index]["shared"] as bool);
    });
  }

  void showAddPostDialog() {
    final TextEditingController authorController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create New Post"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: authorController,
                decoration: InputDecoration(hintText: "Enter your name"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: contentController,
                decoration: InputDecoration(hintText: "What's on your mind?"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final author = authorController.text;
                final content = contentController.text;
                if (author.isNotEmpty && content.isNotEmpty) {
                  addPost(author, content);
                }
                Navigator.pop(context);
              },
              child: Text("Post"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Community Insights"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Placeholder for search functionality
            },
          ),
        ],
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
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(posts[index]['content']!),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.thumb_up_alt_outlined),
                        onPressed: () => toggleLike(index),
                      ),
                      Text("${posts[index]['likes']}"),
                      SizedBox(width: 15),
                      IconButton(
                        icon: Icon(posts[index]['shared']
                            ? Icons.share
                            : Icons.share_outlined),
                        onPressed: () => toggleShare(index),
                      ),
                      Text(posts[index]['shared'] ? "Shared" : "Share"),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddPostDialog,
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}
