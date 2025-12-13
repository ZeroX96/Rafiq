import 'package:flutter/material.dart';

class DailyPrayerScreen extends StatelessWidget {
  const DailyPrayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Prayers')),
      body: const Center(child: Text('Prayer Tracking UI')),
    );
  }
}
