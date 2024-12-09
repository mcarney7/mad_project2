import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StockDetailsScreen extends StatelessWidget {
  final String symbol;

  StockDetailsScreen({required this.symbol});

  Future<Map<String, dynamic>> fetchStockData(String symbol) async {
    final response = await http.get(Uri.parse(
        'https://finnhub.io/api/v1/quote?symbol=$symbol&token=ctbk6qpr01qvslquoa7gctbk6qpr01qvslquoa80'));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details: $symbol"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchStockData(symbol),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final data = snapshot.data!;
          return Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Current Price: \$${data['c']}",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("High: \$${data['h']}", style: TextStyle(fontSize: 16)),
                Text("Low: \$${data['l']}", style: TextStyle(fontSize: 16)),
                Text("Previous Close: \$${data['pc']}",
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          );
        },
      ),
    );
  }
}
