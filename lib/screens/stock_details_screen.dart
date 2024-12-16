import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class StockDetailsScreen extends StatelessWidget {
  final String symbol;

  // Constructor with default symbol
  const StockDetailsScreen({Key? key, this.symbol = 'AAPL'}) : super(key: key);

  // Fetch real-time stock data
  Future<Map<String, dynamic>> fetchStockData(String symbol) async {
    final response = await http.get(Uri.parse(
        'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbol&apikey=KVNECXPCDNDOEBTE'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final quote = data['Global Quote'];
      if (quote != null) {
        return {
          "current": double.parse(quote["05. price"]),
          "high": double.parse(quote["03. high"]),
          "low": double.parse(quote["04. low"]),
          "previousClose": double.parse(quote["08. previous close"]),
        };
      } else {
        throw Exception("Invalid stock data.");
      }
    } else {
      throw Exception("Failed to fetch stock data.");
    }
  }

  // Fetch historical stock data
  Future<List<Map<String, dynamic>>> fetchHistoricalData(String symbol) async {
    final response = await http.get(Uri.parse(
        'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$symbol&apikey=KVNECXPCDNDOEBTE'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['Time Series (Daily)'] != null) {
        final timeSeries = data['Time Series (Daily)'] as Map<String, dynamic>;

        return timeSeries.entries.map((entry) {
          return {
            "time": DateTime.parse(entry.key), // Date
            "close": double.parse(entry.value["4. close"]), // Closing price
          };
        }).toList();
      } else {
        throw Exception("Invalid historical data format.");
      }
    } else {
      throw Exception("Failed to fetch historical data.");
    }
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Current Price: \$${data['current']}",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("High: \$${data['high']}",
                      style: const TextStyle(fontSize: 16)),
                  Text("Low: \$${data['low']}",
                      style: const TextStyle(fontSize: 16)),
                  Text("Previous Close: \$${data['previousClose']}",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  const Divider(),
                  const Text("Historical Data and Trends",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: fetchHistoricalData(symbol),
                    builder: (context, historicalSnapshot) {
                      if (historicalSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (historicalSnapshot.hasError) {
                        return Center(
                          child: Text(
                              "Error loading historical data: ${historicalSnapshot.error}",
                              style: const TextStyle(color: Colors.red)),
                        );
                      }
                      if (historicalSnapshot.data == null ||
                          historicalSnapshot.data!.isEmpty) {
                        return const Center(
                          child: Text("No historical data available.",
                              style: TextStyle(color: Colors.red)),
                        );
                      }

                      final historicalData = historicalSnapshot.data!;
                      return Column(
                        children: [
                          SizedBox(
                            height: 300,
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(show: true),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          "\$${value.toStringAsFixed(0)}",
                                          style: const TextStyle(fontSize: 12),
                                        );
                                      },
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      getTitlesWidget: (value, meta) {
                                        int index = value.toInt();
                                        if (index >= 0 &&
                                            index < historicalData.length) {
                                          final date =
                                              historicalData[index]['time']
                                                  as DateTime;
                                          return Text(
                                            "${date.day}/${date.month}",
                                            style: const TextStyle(fontSize: 10),
                                          );
                                        }
                                        return const Text("");
                                      },
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(
                                      color: Colors.black, width: 1),
                                ),
                                minX: 0,
                                maxX: (historicalData.length - 1).toDouble(),
                                minY: historicalData
                                    .map((item) => item['close'])
                                    .reduce((a, b) => a < b ? a : b),
                                maxY: historicalData
                                    .map((item) => item['close'])
                                    .reduce((a, b) => a > b ? a : b),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: historicalData
                                        .asMap()
                                        .entries
                                        .map((entry) => FlSpot(
                                            entry.key.toDouble(),
                                            entry.value['close']))
                                        .toList(),
                                    isCurved: true,
                                    gradient: const LinearGradient(
                                      colors: [Colors.blue, Colors.green],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    barWidth: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Recent Data:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: historicalData.length,
                            itemBuilder: (context, index) {
                              final item = historicalData[index];
                              return ListTile(
                                title: Text(
                                    "${item['time'].toLocal()}".split(' ')[0]),
                                subtitle: Text(
                                    "Close: \$${item['close'].toString()}"),
                              );
                            },
                          ),
                        ],
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
