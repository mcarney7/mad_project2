import 'package:flutter/material.dart';

class StockCard extends StatelessWidget {
  final String symbol;
  final String change;
  final bool isPositive;
  final VoidCallback onTap;

  StockCard({
    required this.symbol,
    required this.change,
    required this.isPositive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPositive ? Colors.green : Colors.red,
          child: Text(symbol[0], style: TextStyle(color: Colors.white)),
        ),
        title: Text(
          symbol,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          change,
          style: TextStyle(color: isPositive ? Colors.green : Colors.red),
        ),
        trailing: Icon(Icons.arrow_forward, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
