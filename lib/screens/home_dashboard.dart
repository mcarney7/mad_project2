import 'package:flutter/material.dart';

class HomeDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, Investor!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Market",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StockWidget(name: "AAPL", change: "+2.5%", isPositive: true),
                        _StockWidget(name: "GOOGL", change: "-1.2%", isPositive: false),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/watchlist'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                backgroundColor: Colors.blueAccent,
              ),
              child: Text("Go to Watchlist"),
            ),
          ],
        ),
      ),
    );
  }
}

class _StockWidget extends StatelessWidget {
  final String name;
  final String change;
  final bool isPositive;

  _StockWidget({required this.name, required this.change, required this.isPositive});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(
          change,
          style: TextStyle(
            fontSize: 14,
            color: isPositive ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}
