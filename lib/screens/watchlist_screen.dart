import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Replace with your API service file

class WatchlistScreen extends StatefulWidget {
  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final ApiService apiService = ApiService();
  List<String> watchlist = ["AAPL", "GOOGL", "AMZN"]; // Replace with dynamic watchlist source
  Map<String, Map<String, dynamic>> stockData = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchWatchlistData();
  }

  Future<void> fetchWatchlistData() async {
    setState(() {
      isLoading = true;
    });

    try {
      for (var stock in watchlist) {
        final data = await apiService.fetchStockData(stock); // Replace with your API fetch method
        stockData[stock] = data;
      }
    } catch (e) {
      print("Error fetching stock data: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  void addStock(String stockSymbol) {
    setState(() {
      watchlist.add(stockSymbol.toUpperCase());
    });
    fetchWatchlistData();
  }

  void removeStock(String stockSymbol) {
    setState(() {
      watchlist.remove(stockSymbol);
      stockData.remove(stockSymbol);
    });
  }

  void showAddStockDialog() {
    final TextEditingController stockController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Stock"),
          content: TextField(
            controller: stockController,
            decoration: InputDecoration(hintText: "Enter Stock Symbol (e.g., AAPL)"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final stockSymbol = stockController.text.toUpperCase();
                if (stockSymbol.isNotEmpty) {
                  addStock(stockSymbol);
                }
                Navigator.pop(context);
              },
              child: Text("Add"),
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
        title: Text("Watchlist"),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : watchlist.isEmpty
              ? Center(child: Text("Your watchlist is empty!"))
              : ListView.builder(
                  padding: EdgeInsets.all(15),
                  itemCount: watchlist.length,
                  itemBuilder: (context, index) {
                    final stockSymbol = watchlist[index];
                    final data = stockData[stockSymbol];

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
                            stockSymbol[0],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          stockSymbol,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: data == null
                            ? Text("Loading...")
                            : Text(
                                "Price: \$${data['c']} (High: \$${data['h']}, Low: \$${data['l']})",
                              ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeStock(stockSymbol),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/stockDetails', arguments: stockSymbol);
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddStockDialog,
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}
