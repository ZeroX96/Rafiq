import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

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
  Map<String, int> _qadaDetails = {}; // Stores specific debt per prayer

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh stats whenever the screen is navigated to
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
    Map<String, int> details = {};
    for (String prayer in ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha', 'Witr']) {
      final debt = prefs.getInt('qada_debt_$prayer') ?? 0;
      qadaTotal += debt;
      details[prayer] = debt;
    }

    // Load user name
    final name = prefs.getString('profile_name') ?? 'Muslim';

    setState(() {
      _todayPrayersDone = prayerCount;
      _weeklyPrayers = weekly;
      _totalVersesRead = versesRead;
      _lifetimeAzkar = azkarLifetime;
      _totalQadaDebt = qadaTotal;
      _qadaDetails = details;
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
              context.push('/settings');
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
            'Monthly Progress',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: DateTime.now(),
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(formatButtonVisible: false),
            ),
          ),
          const SizedBox(height: 24),
          Text('Challenges', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _buildChallengeCard(
            'Daily',
            'Pray all 5 prayers',
            _todayPrayersDone / 5,
          ),
          _buildChallengeCard('Weekly', 'Read Surah Kahf', 0.0),
          _buildChallengeCard(
            'Monthly',
            'Complete Quran',
            _totalVersesRead / 6236,
          ),
          _buildChallengeCard('3-Month', 'Learn 10 Hadith', 0.2),
          _buildChallengeCard('6-Month', 'Fast 6 days of Shawwal', 0.0),
          _buildChallengeCard('9-Month', 'Memorize Juz Amma', 0.1),
          _buildChallengeCard('12-Month', 'Perform Umrah', 0.0),
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
    if (_totalQadaDebt == 0) {
      return Card(
        color: Colors.green.shade50,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text(
                'MashaAllah! You are debt free.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Pie Chart Logic
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections:
                      _qadaDetails.entries.map((e) {
                        final color = _getPrayerColor(e.key);
                        final value = e.value.toDouble();
                        final percent =
                            (_totalQadaDebt > 0)
                                ? (value / _totalQadaDebt * 100)
                                : 0;

                        return PieChartSectionData(
                          color: color,
                          value: value,
                          title: percent > 5 ? '${percent.toInt()}%' : '',
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children:
                  _qadaDetails.entries.where((e) => e.value > 0).map((e) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getPrayerColor(e.key),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text('${e.key}: ${e.value}'),
                      ],
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Total Remaining: $_totalQadaDebt',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPrayerColor(String prayer) {
    switch (prayer) {
      case 'Fajr':
        return Colors.orange.shade300;
      case 'Dhuhr':
        return Colors.yellow.shade700;
      case 'Asr':
        return Colors.orange.shade800;
      case 'Maghrib':
        return Colors.red.shade900;
      case 'Isha':
        return Colors.indigo.shade900;
      case 'Witr':
        return Colors.purple.shade900;
      default:
        return Colors.grey;
    }
  }

  Widget _buildAzkarChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Lifetime Total'),
                Text(
                  '$_lifetimeAzkar',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: _lifetimeAzkar > 0 ? (_lifetimeAzkar % 1000) / 1000 : 0,
              // Modulo 1000 to show cycle progress
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${1000 - (_lifetimeAzkar % 1000)} to next milestone',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeCard(String period, String title, double progress) {
    return FutureBuilder<bool>(
      future: _getChallengeStatus(title),
      builder: (context, snapshot) {
        final isCompleted = snapshot.data ?? false;
        final displayProgress = isCompleted ? 1.0 : progress;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: isCompleted ? Colors.green.shade50 : null,
          child: InkWell(
            onTap: () => _toggleChallenge(title, !isCompleted),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        period,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCompleted ? Colors.green : Colors.blue,
                        ),
                      ),
                      if (isCompleted)
                        const Icon(Icons.check_circle, color: Colors.green)
                      else
                        Text('${(displayProgress * 100).toInt()}%'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: displayProgress.clamp(0.0, 1.0),
                    color: isCompleted ? Colors.green : null,
                    backgroundColor: isCompleted ? Colors.green.shade100 : null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _getChallengeStatus(String title) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('challenge_completed_$title') ?? false;
  }

  Future<void> _toggleChallenge(String title, bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('challenge_completed_$title', completed);
    setState(() {}); // Rebuild to update UI

    if (completed) {
      // Play success sound (placeholder) and show feedback
      HapticFeedback.heavyImpact();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Congrats! You completed: $title'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
