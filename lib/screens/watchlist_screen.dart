import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WatchlistScreen extends StatefulWidget {
  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final String alphaVantageApiKey = "KVNECXPCDNDOEBTE";
  final List<String> watchlist = ["AAPL", "GOOGL", "AMZN"];
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
        final response = await http.get(Uri.parse(
            "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$stock&apikey=$alphaVantageApiKey"));

        if (response.statusCode == 200) {
          final decodedData = json.decode(response.body);
          final quote = decodedData["Global Quote"] ?? {};

          setState(() {
            stockData[stock] = {
              "price": double.tryParse(quote["05. price"] ?? "0.0") ?? 0.0,
              "high": double.tryParse(quote["03. high"] ?? "0.0") ?? 0.0,
              "low": double.tryParse(quote["04. low"] ?? "0.0") ?? 0.0,
            };
          });
        } else {
          print("Error fetching data for $stock: ${response.statusCode}");
          stockData[stock] = {"price": 0.0, "high": 0.0, "low": 0.0};
        }
      }
    } catch (e) {
      print("Error fetching stock data: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  void addStock(String stockSymbol) {
    if (!watchlist.contains(stockSymbol)) {
      setState(() {
        watchlist.add(stockSymbol.toUpperCase());
        fetchWatchlistData();
      });
    }
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
          title: const Text("Add Stock"),
          content: TextField(
            controller: stockController,
            decoration: const InputDecoration(hintText: "Enter Stock Symbol (e.g., AAPL)"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final stockSymbol = stockController.text.toUpperCase();
                if (stockSymbol.isNotEmpty) {
                  addStock(stockSymbol);
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
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
        title: const Text("Watchlist"),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : watchlist.isEmpty
              ? const Center(child: Text("Your watchlist is empty!"))
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: watchlist.length,
                  itemBuilder: (context, index) {
                    final stockSymbol = watchlist[index];
                    final data = stockData[stockSymbol];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            stockSymbol[0],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          stockSymbol,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: data == null
                            ? const Text("Loading...")
                            : Text(
                                "Price: \$${data['price'].toStringAsFixed(2)} "
                                "(High: \$${data['high'].toStringAsFixed(2)}, Low: \$${data['low'].toStringAsFixed(2)})",
                              ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
