import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  // Stats
  int _todayPrayersDone = 0;
  int _totalVersesRead = 0;
  int _lifetimeAzkar = 0;
  int _totalQadaDebt = 0;
  String _userName = '...';
  List<int> _weeklyPrayers = [0, 0, 0, 0, 0, 0, 0];

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Load prayer count for today
    int prayerCount = 0;
    for (String prayer in [
      'Fajr',
      'Dhuhr',
      'Asr',
      'Maghrib',
      'Isha',
      'Shafaa',
      'Witr',
    ]) {
      if (prefs.getBool('prayer_${today}_$prayer') ?? false) prayerCount++;
    }

    // Load weekly prayers
    List<int> weekly = [];
    for (int i = 6; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      int count = 0;
      for (String prayer in [
        'Fajr',
        'Dhuhr',
        'Asr',
        'Maghrib',
        'Isha',
        'Shafaa',
        'Witr',
      ]) {
        if (prefs.getBool('prayer_${dateKey}_$prayer') ?? false) count++;
      }
      weekly.add(count);
    }

    // Load Quran verses read
    final versesRead = prefs.getInt('quran_total_verses_read') ?? 0;

    // Load Azkar lifetime count
    final azkarLifetime = prefs.getInt('azkar_lifetime_total') ?? 0;

    // Load Qada debt
    int qadaTotal = 0;
    for (String prayer in ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha', 'Witr']) {
      qadaTotal += prefs.getInt('qada_debt_$prayer') ?? 0;
    }

    // Load user name
    final name = prefs.getString('profile_name') ?? 'Muslim';

    setState(() {
      _todayPrayersDone = prayerCount;
      _weeklyPrayers = weekly;
      _totalVersesRead = versesRead;
      _lifetimeAzkar = azkarLifetime;
      _totalQadaDebt = qadaTotal;
      _userName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assalamu Alaikum, $_userName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings (placeholder)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Settings coming soon. Re-run onboarding to update.',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSummaryCard(context),
          const SizedBox(height: 24),
          Text(
            'Weekly Prayer Progress',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildWeeklyChart(),
          const SizedBox(height: 24),
          Text(
            'Qada Debt Distribution',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildDebtChart(),
          const SizedBox(height: 24),
          Text('Azkar Progress', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _buildAzkarChart(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          alignment: WrapAlignment.spaceAround,
          runSpacing: 16,
          spacing: 16,
          children: [
            _buildStatItem(
              context,
              'Today',
              '$_todayPrayersDone/7',
              FlutterIslamicIcons.solidMosque,
              Colors.green,
            ),
            _buildStatItem(
              context,
              'Verses',
              '$_totalVersesRead',
              Icons.menu_book,
              Colors.blue,
            ),
            _buildStatItem(
              context,
              'Azkar',
              '$_lifetimeAzkar',
              FlutterIslamicIcons.solidMosque,
              Colors.purple,
            ),
            _buildStatItem(
              context,
              'Qada',
              '$_totalQadaDebt',
              Icons.warning_amber,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildWeeklyChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                  if (value.toInt() < days.length) {
                    return Text(
                      days[value.toInt()],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups:
              _weeklyPrayers.asMap().entries.map((e) {
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value.toDouble(),
                      color:
                          e.value == 7
                              ? Colors.green
                              : Theme.of(context).colorScheme.primary,
                      width: 16,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: 7,
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildDebtChart() {
    // Placeholder for Pie Chart
    return SizedBox(
      height: 150,
      child: Center(
        child: Text(
          'Total Qada Debt: $_totalQadaDebt prayers remaining',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }

  Widget _buildAzkarChart() {
    return LinearProgressIndicator(
      value: _lifetimeAzkar > 0 ? (_lifetimeAzkar / 10000).clamp(0.0, 1.0) : 0,
      minHeight: 20,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
    );
  }
}
