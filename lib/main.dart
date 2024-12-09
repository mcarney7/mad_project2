import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_dashboard.dart';
import 'screens/watchlist_screen.dart';
import 'screens/stock_details_screen.dart';
import 'screens/newsfeed_screen.dart';
import 'screens/community_screen.dart';

void main() {
  runApp(StockTrackerApp());
}

class StockTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Tracker',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeDashboard(),
        '/watchlist': (context) => WatchlistScreen(),
        '/stockDetails': (context) => StockDetailsScreen(symbol: 'AAPL'),
        '/newsfeed': (context) => NewsfeedScreen(),
        '/community': (context) => CommunityScreen(),
      },
    );
  }
}
