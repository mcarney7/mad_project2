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

  Future<List<dynamic>> fetchHistoricalData(String symbol) async {
    final response = await http.get(Uri.parse(
        'https://finnhub.io/api/v1/stock/candle?symbol=$symbol&resolution=D&from=1609459200&to=1672444800&token=ctbk6qpr01qvslquoa7gctbk6qpr01qvslquoa80'));
    final data = json.decode(response.body);
    if (data['s'] == 'ok') {
      return List.generate(data['c'].length, (index) => {
            "time": DateTime.fromMillisecondsSinceEpoch(data['t'][index] * 1000),
            "close": data['c'][index],
          });
    } else {
      throw Exception("Failed to fetch historical data.");
    }
  }

  Future<Map<String, dynamic>> fetchStockMetrics(String symbol) async {
    final response = await http.get(Uri.parse(
        'https://finnhub.io/api/v1/stock/metric?symbol=$symbol&metric=all&token=ctbk6qpr01qvslquoa7gctbk6qpr01qvslquoa80'));
    return json.decode(response.body)['metric'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details: $symbol"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
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
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("High: \$${data['h']}", style: TextStyle(fontSize: 16)),
                  Text("Low: \$${data['l']}", style: TextStyle(fontSize: 16)),
                  Text("Previous Close: \$${data['pc']}",
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                  Divider(),
                  Text("Key Metrics",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  FutureBuilder<Map<String, dynamic>>(
                    future: fetchStockMetrics(symbol),
                    builder: (context, metricsSnapshot) {
                      if (metricsSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (metricsSnapshot.hasError) {
                        return Text("Failed to load metrics.");
                      }
                      final metrics = metricsSnapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Market Cap: \$${metrics['marketCapitalization']}",
                              style: TextStyle(fontSize: 16)),
                          Text("P/E Ratio: ${metrics['peBasicExclExtraTTM']}",
                              style: TextStyle(fontSize: 16)),
                          Text("Dividend Yield: ${metrics['dividendYieldIndicatedAnnual']}%",
                              style: TextStyle(fontSize: 16)),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  Text("Historical Data",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  FutureBuilder<List<dynamic>>(
                    future: fetchHistoricalData(symbol),
                    builder: (context, historicalSnapshot) {
                      if (historicalSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (historicalSnapshot.hasError) {
                        return Text("Failed to load historical data.");
                      }
                      final historicalData = historicalSnapshot.data!;
                      return SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: historicalData.length,
                          itemBuilder: (context, index) {
                            final item = historicalData[index];
                            return ListTile(
                              title: Text(
                                  "${item['time'].toLocal()}".split(' ')[0]),
                              subtitle:
                                  Text("Close: \$${item['close'].toString()}"),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
