import 'rebite_route_tracker.dart';
import 'rebite_claimer_dashboard_map.dart';
import 'package:flutter/material.dart';

class FoodDetail extends StatelessWidget {
  final int? id;

  const FoodDetail({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.push(context, RebiteRouteTracker.createPageRoute(const RebiteClaimerDashboardMap()));
            }
          },
        ),
        title: Text('Detail Makanan #${id ?? 1}'),
        backgroundColor: const Color(0xFF2C5745),
        foregroundColor: const Color(0xFFEBE3A7),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant_rounded, size: 64, color: Color(0xFF2C5745)),
            const SizedBox(height: 16),
            Text(
              'Detail Makanan #${id ?? 1}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
