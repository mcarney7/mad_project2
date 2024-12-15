import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeDashboard extends StatefulWidget {
  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final ApiService apiService = ApiService();
  int _selectedIndex = 0;

  Future<Map<String, dynamic>> fetchMarketSummary() async {
    final appleData = await apiService.fetchStockData("AAPL");
    final googleData = await apiService.fetchStockData("GOOGL");
    return {"AAPL": appleData, "GOOGL": googleData};
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on selected index
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
        title: Text("Dashboard"),
        leading: TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
          child: Text(
            "Sign Out",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchMarketSummary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final marketSummary = snapshot.data!;
          return Container(
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
                            _StockWidget(
                                name: "AAPL",
                                change: marketSummary["AAPL"]["c"].toString(),
                                isPositive:
                                    marketSummary["AAPL"]["c"] >= marketSummary["AAPL"]["pc"]),
                            _StockWidget(
                                name: "GOOGL",
                                change: marketSummary["GOOGL"]["c"].toString(),
                                isPositive:
                                    marketSummary["GOOGL"]["c"] >= marketSummary["GOOGL"]["pc"]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
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
        items: [
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
  final String change;
  final bool isPositive;

  _StockWidget({required this.name, required this.change, required this.isPositive});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(
          "\$$change",
          style: TextStyle(
            fontSize: 14,
            color: isPositive ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}
