import 'package:flutter/material.dart';

class WatchlistScreen extends StatelessWidget {
  final List<String> watchlist = ["AAPL", "GOOGL", "AMZN"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Watchlist"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(15),
        itemCount: watchlist.length,
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
                child: Text(
                  watchlist[index][0],
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                watchlist[index],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward, color: Colors.grey),
              onTap: () {
                Navigator.pushNamed(context, '/stockDetails', arguments: watchlist[index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add stock logic placeholder
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}
