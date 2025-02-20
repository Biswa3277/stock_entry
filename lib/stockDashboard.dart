import 'package:flutter/material.dart';
import 'package:stock_entry/stockentries_overview.dart';
import 'package:stock_entry/stockin.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(20),
        children: [
          _buildDashboardButton(context, 'Stock Entry', StockInputPage()),
          _buildDashboardButton(context, 'Stock Out', DashboardScreen()),
          _buildDashboardButton(context, 'Stock Transfer', DashboardScreen()),
          _buildDashboardButton(
              context, 'Stock Overview', StockEntriesOverviewPage()),
        ],
      ),
    );
  }

  Widget _buildDashboardButton(
      BuildContext context, String title, Widget screen) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen)),
        child: Center(child: Text(title, textAlign: TextAlign.center)),
      ),
    );
  }
}
