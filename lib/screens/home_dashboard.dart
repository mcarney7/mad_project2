import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeDashboard extends StatefulWidget {
  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;

  Future<Map<String, dynamic>> fetchMarketSummary() async {
    const String apiKey = "KVNECXPCDNDOEBTE";
    const String baseUrl = "https://www.alphavantage.co/query";

    try {
      // Fetch AAPL data
      final responseAAPL = await http.get(Uri.parse(
          "$baseUrl?function=GLOBAL_QUOTE&symbol=AAPL&apikey=$apiKey"));

      // Fetch GOOGL data
      final responseGOOGL = await http.get(Uri.parse(
          "$baseUrl?function=GLOBAL_QUOTE&symbol=GOOGL&apikey=$apiKey"));

      // Parse responses
      final appleData = json.decode(responseAAPL.body);
      final googleData = json.decode(responseGOOGL.body);

      return {
        "AAPL": {
          "current": double.tryParse(
                  appleData["Global Quote"]?["05. price"] ?? "0.0") ??
              0.0,
          "previousClose": double.tryParse(
                  appleData["Global Quote"]?["08. previous close"] ?? "0.0") ??
              0.0,
        },
        "GOOGL": {
          "current": double.tryParse(
                  googleData["Global Quote"]?["05. price"] ?? "0.0") ??
              0.0,
          "previousClose": double.tryParse(
                  googleData["Global Quote"]?["08. previous close"] ?? "0.0") ??
              0.0,
        },
      };
    } catch (e) {
      print("Error fetching stock data: $e");

      // Return fallback values in case of failure
      return {
        "AAPL": {"current": 0.0, "previousClose": 0.0},
        "GOOGL": {"current": 0.0, "previousClose": 0.0},
      };
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/watchlist');
        break;
      case 1:
        Navigator.pushNamed(context, '/community');
        break;
      case 2:
        Navigator.pushNamed(context, '/newsfeed');
        break;
      case 3:
        Navigator.pushNamed(context, '/stockDetails', arguments: 'AAPL');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchMarketSummary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Error loading market data.",
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          }

          final marketSummary = snapshot.data!;
          return Container(
            padding: const EdgeInsets.all(20),
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
                const Text(
                  "Hello, Investor!",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Today's Market",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _StockWidget(
                                name: "AAPL",
                                currentPrice: marketSummary["AAPL"]["current"] ?? 0.0,
                                previousClose:
                                    marketSummary["AAPL"]["previousClose"] ?? 0.0),
                            _StockWidget(
                                name: "GOOGL",
                                currentPrice: marketSummary["GOOGL"]["current"] ?? 0.0,
                                previousClose:
                                    marketSummary["GOOGL"]["previousClose"] ?? 0.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Newsfeed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stock Details',
          ),
        ],
      ),
    );
  }
}

class _StockWidget extends StatelessWidget {
  final String name;
  final double currentPrice;
  final double previousClose;

  const _StockWidget({
    required this.name,
    required this.currentPrice,
    required this.previousClose,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = currentPrice >= previousClose;
    return Column(
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          "\$${currentPrice.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 14,
            color: isPositive ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Prev: \$${previousClose.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
