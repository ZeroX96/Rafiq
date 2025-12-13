import 'package:adhan/adhan.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:quran/quran.dart' as quran;
import 'package:rafiq/core/services/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyPrayerScreen extends ConsumerStatefulWidget {
  const DailyPrayerScreen({super.key});

  @override
  ConsumerState<DailyPrayerScreen> createState() => _DailyPrayerScreenState();
}

class _DailyPrayerScreenState extends ConsumerState<DailyPrayerScreen> {
  PrayerTimes? _prayerTimes;
  bool _isLoading = true;
  String _cityName = 'Loading...';

  // Prayer states (track which prayers have been marked as done today)
  Map<String, bool> _prayerStatus = {
    'Fajr': false,
    'Dhuhr': false,
    'Asr': false,
    'Maghrib': false,
    'Isha': false,
    'Shafaa': false, // Added
    'Witr': false, // Added
  };

  // Gamification State
  int _dailyScore = 0;
  String _rank = 'Muslim';
  // Weekly progress from SharedPreferences (or mock for now)
  List<int> _weeklyProgress = [0, 0, 0, 0, 0, 0, 0];

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
    _loadPrayerStatus();
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

  Future<void> _loadPrayerStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    setState(() {
      _prayerStatus = {
        'Fajr': prefs.getBool('prayer_${today}_Fajr') ?? false,
        'Dhuhr': prefs.getBool('prayer_${today}_Dhuhr') ?? false,
        'Asr': prefs.getBool('prayer_${today}_Asr') ?? false,
        'Maghrib': prefs.getBool('prayer_${today}_Maghrib') ?? false,
        'Isha': prefs.getBool('prayer_${today}_Isha') ?? false,
        'Shafaa': prefs.getBool('prayer_${today}_Shafaa') ?? false,
        'Witr': prefs.getBool('prayer_${today}_Witr') ?? false,
      };
    });
    _calculateScore();
    _loadWeeklyProgress();
  }

  Future<void> _savePrayerStatus(String prayer, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await prefs.setBool('prayer_${today}_$prayer', value);

    setState(() {
      _prayerStatus[prayer] = value;
    });
    _calculateScore();
  }

  void _calculateScore() {
    // Count completed prayers (out of 7: Fajr, Dhuhr, Asr, Maghrib, Isha, Shafaa, Witr)
    int prayersDone = _prayerStatus.values.where((v) => v).length;
    setState(() {
      _dailyScore = (prayersDone / 7 * 100).round();
      _rank = _getRank(_dailyScore);
    });
  }

  Future<void> _loadWeeklyProgress() async {
    final prefs = await SharedPreferences.getInstance();
    List<int> progress = [];
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
      progress.add(count);
    }
    setState(() {
      _weeklyProgress = progress;
    });
  }

  String _getRank(int score) {
    if (score >= 100) return 'Muhsin';
    if (score >= 85) return 'Mumin';
    if (score >= 70) return 'Hafiz';
    if (score >= 50) return 'Imam';
    if (score >= 30) return 'Muadhin';
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
                  // Shafaa and Witr (time is after Isha, no specific calculation)
                  _buildPrayerTile(
                    'Shafaa',
                    _prayerTimes!.isha.add(const Duration(minutes: 30)),
                    icon: FlutterIslamicIcons.solidMosque,
                  ),
                  _buildPrayerTile(
                    'Witr',
                    _prayerTimes!.isha.add(const Duration(minutes: 45)),
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
    // Random verse based on day of year
    final dayOfYear = int.parse(DateFormat('D').format(DateTime.now()));
    final surah = (dayOfYear % 114) + 1;
    final verseCount = quran.getVerseCount(surah);
    final verse = (dayOfYear % verseCount) + 1;

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
              quran.getVerse(surah, verse),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              quran.getVerseTranslation(surah, verse),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            Text(
              'Surah ${quran.getSurahName(surah)} ($surah:$verse)',
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
                          e.value == 7
                              ? Colors.green
                              : Theme.of(context).colorScheme.primary,
                      width: 16,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: 7, // Max is 7 prayers now
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
    final isPrayed = _prayerStatus[name] ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          icon,
          size: 32,
          color:
              isPrayer ? Theme.of(context).colorScheme.primary : Colors.orange,
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(formattedTime, style: const TextStyle(fontSize: 16)),
        trailing:
            isPrayer
                ? Checkbox(
                  value: isPrayed,
                  onChanged: (value) {
                    _savePrayerStatus(name, value ?? false);
                  },
                )
                : null,
      ),
    );
  }
}
