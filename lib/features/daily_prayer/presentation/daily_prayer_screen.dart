import 'package:adhan/adhan.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:quran/quran.dart' as quran;
import 'package:rafiq/core/services/settings_service.dart';

class DailyPrayerScreen extends ConsumerStatefulWidget {
  const DailyPrayerScreen({super.key});

  @override
  ConsumerState<DailyPrayerScreen> createState() => _DailyPrayerScreenState();
}

class _DailyPrayerScreenState extends ConsumerState<DailyPrayerScreen> {
  PrayerTimes? _prayerTimes;
  bool _isLoading = true;
  String _cityName = 'Loading...';

  // Gamification State
  int _dailyScore = 0;
  String _rank = 'Muslim';
  // Mock data: Mon-Sun (0-5 prayers)
  final List<int> _weeklyProgress = [3, 4, 5, 2, 5, 4, 0];

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
    _calculateScore();
  }

  Future<void> _loadPrayerTimes() async {
    final settings = ref.read(settingsServiceProvider);
    final location = await settings.getLocation();

    if (location != null) {
      final myCoordinates = Coordinates(location['lat'], location['lng']);
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.madhab = Madhab.hanafi;

      final date = DateComponents.from(DateTime.now());

      setState(() {
        _prayerTimes = PrayerTimes(myCoordinates, date, params);
        _cityName = location['name'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _cityName = 'Location not set';
        _isLoading = false;
      });
    }
  }

  void _calculateScore() {
    // Mock logic: In a real app, this would calculate based on actual checked prayers from DB
    // For now, let's assume 3 prayers done today
    int prayersDone = 3;
    setState(() {
      _dailyScore = (prayersDone / 5 * 100).round();
      _rank = _getRank(_dailyScore);
    });
  }

  String _getRank(int score) {
    if (score >= 100) return 'Mumin';
    if (score >= 80) return 'Hafiz';
    if (score >= 60) return 'Imam';
    if (score >= 40) return 'Muadhin';
    return 'Muslim';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Daily Prayers'),
            Text(_cityName, style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _prayerTimes == null
              ? const Center(
                child: Text('Please select a location in settings.'),
              )
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildScoreCard(),
                  const SizedBox(height: 16),
                  _buildDailyVerse(),
                  const SizedBox(height: 16),
                  _buildPrayerTile(
                    'Fajr',
                    _prayerTimes!.fajr,
                    icon: FlutterIslamicIcons.solidMosque,
                  ),
                  _buildPrayerTile(
                    'Sunrise',
                    _prayerTimes!.sunrise,
                    isPrayer: false,
                    icon: Icons.wb_sunny,
                  ),
                  _buildPrayerTile(
                    'Dhuhr',
                    _prayerTimes!.dhuhr,
                    icon: FlutterIslamicIcons.solidMosque,
                  ),
                  _buildPrayerTile(
                    'Asr',
                    _prayerTimes!.asr,
                    icon: FlutterIslamicIcons.solidMosque,
                  ),
                  _buildPrayerTile(
                    'Maghrib',
                    _prayerTimes!.maghrib,
                    icon: FlutterIslamicIcons.solidMosque,
                  ),
                  _buildPrayerTile(
                    'Isha',
                    _prayerTimes!.isha,
                    icon: FlutterIslamicIcons.solidMosque,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Weekly Progress',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildWeeklyChart(),
                ],
              ),
    );
  }

  Widget _buildScoreCard() {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Score',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '$_dailyScore%',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Icon(
                  FlutterIslamicIcons.solidMosque,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 4),
                Text(
                  _rank,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyVerse() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FlutterIslamicIcons.quran,
                  size: 20,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Daily Verse',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              quran.getVerse(1, 1), // Al-Fatiha: 1
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              quran.getVerseTranslation(1, 1),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            Text(
              'Surah Al-Fatiha (1:1)',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
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
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        days[value.toInt()],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups:
              _weeklyProgress.asMap().entries.map((e) {
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value.toDouble(),
                      color:
                          e.value == 5
                              ? Colors.green
                              : Theme.of(context).colorScheme.primary,
                      width: 16,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: 5,
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

  Widget _buildPrayerTile(
    String name,
    DateTime time, {
    bool isPrayer = true,
    required IconData icon,
  }) {
    final formattedTime = DateFormat.jm().format(time);
    // Mock status for now - in real app, fetch from DB
    bool isPrayed = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(
              icon,
              size: 32,
              color:
                  isPrayer
                      ? Theme.of(context).colorScheme.primary
                      : Colors.orange,
            ),
            title: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(formattedTime, style: const TextStyle(fontSize: 16)),
            trailing:
                isPrayer
                    ? Checkbox(
                      value: isPrayed,
                      onChanged: (value) {
                        setState(() {
                          isPrayed = value ?? false;
                          // Update score logic would go here
                        });
                      },
                    )
                    : null,
          ),
        );
      },
    );
  }
}
