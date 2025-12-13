import 'package:adhan/adhan.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

  // Prayer states (including Sunrise now)
  Map<String, bool> _prayerStatus = {
    'Fajr': false,
    'Sunrise': false, // Added
    'Dhuhr': false,
    'Asr': false,
    'Maghrib': false,
    'Isha': false,
    'Shafaa': false,
    'Witr': false,
  };

  // Gamification State
  int _dailyScore = 0;
  String _rank = 'Muslim';
  List<int> _weeklyProgress = [0, 0, 0, 0, 0, 0, 0];

  // Daily Verse State
  int _currentSurah = 1;
  int _currentVerse = 1;

  @override
  void initState() {
    super.initState();
    _initializeDailyVerse();
    _loadPrayerTimes();
    _loadPrayerStatus();
  }

  void _initializeDailyVerse() {
    final dayOfYear = int.parse(DateFormat('D').format(DateTime.now()));
    _currentSurah = (dayOfYear % 114) + 1;
    final verseCount = quran.getVerseCount(_currentSurah);
    _currentVerse = (dayOfYear % verseCount) + 1;
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

    Map<String, bool> status = {};
    for (String prayer in [
      'Fajr',
      'Sunrise',
      'Dhuhr',
      'Asr',
      'Maghrib',
      'Isha',
      'Shafaa',
      'Witr',
    ]) {
      status[prayer] = prefs.getBool('prayer_${today}_$prayer') ?? false;
    }

    setState(() => _prayerStatus = status);
    _calculateScore();
    _loadWeeklyProgress();
  }

  Future<void> _savePrayerStatus(String prayer, bool value) async {
    HapticFeedback.lightImpact();
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await prefs.setBool('prayer_${today}_$prayer', value);

    setState(() {
      _prayerStatus[prayer] = value;
    });
    _calculateScore();
    _loadWeeklyProgress(); // Real-time chart update
  }

  void _calculateScore() {
    // Count completed prayers (out of 8 now: Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha, Shafaa, Witr)
    int prayersDone = _prayerStatus.values.where((v) => v).length;
    setState(() {
      _dailyScore = (prayersDone / 8 * 100).round();
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
        'Sunrise',
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
    setState(() => _weeklyProgress = progress);
  }

  String _getRank(int score) {
    if (score >= 100) return 'Muhsin';
    if (score >= 85) return 'Mumin';
    if (score >= 70) return 'Hafiz';
    if (score >= 50) return 'Imam';
    if (score >= 30) return 'Muadhin';
    return 'Muslim';
  }

  int _getStarCount() {
    if (_dailyScore >= 100) return 5;
    if (_dailyScore >= 80) return 4;
    if (_dailyScore >= 60) return 3;
    if (_dailyScore >= 40) return 2;
    if (_dailyScore >= 20) return 1;
    return 0;
  }

  void _nextVerse() {
    HapticFeedback.selectionClick();
    setState(() {
      if (_currentVerse < quran.getVerseCount(_currentSurah)) {
        _currentVerse++;
      } else if (_currentSurah < 114) {
        _currentSurah++;
        _currentVerse = 1;
      }
    });
  }

  void _previousVerse() {
    HapticFeedback.selectionClick();
    setState(() {
      if (_currentVerse > 1) {
        _currentVerse--;
      } else if (_currentSurah > 1) {
        _currentSurah--;
        _currentVerse = quran.getVerseCount(_currentSurah);
      }
    });
  }

  void _navigateToQuran() {
    // Navigate to Quran tab with specific surah/verse
    context.go('/quran');
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
                  _buildPrayerTile('Fajr', _prayerTimes!.fajr),
                  _buildPrayerTile('Sunrise', _prayerTimes!.sunrise),
                  _buildPrayerTile('Dhuhr', _prayerTimes!.dhuhr),
                  _buildPrayerTile('Asr', _prayerTimes!.asr),
                  _buildPrayerTile('Maghrib', _prayerTimes!.maghrib),
                  _buildPrayerTile('Isha', _prayerTimes!.isha),
                  _buildPrayerTile(
                    'Shafaa',
                    _prayerTimes!.isha.add(const Duration(minutes: 30)),
                  ),
                  _buildPrayerTile(
                    'Witr',
                    _prayerTimes!.isha.add(const Duration(minutes: 45)),
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
    final stars = _getStarCount();
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
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < stars ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Icon(
                  _dailyScore >= 100
                      ? Icons.emoji_events
                      : _dailyScore >= 50
                      ? FlutterIslamicIcons.solidMosque
                      : Icons.access_time,
                  size: 48,
                  color:
                      _dailyScore >= 100
                          ? Colors.amber
                          : Theme.of(context).colorScheme.primary,
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
    return GestureDetector(
      onTap: _navigateToQuran,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: _previousVerse,
                  ),
                  Row(
                    children: [
                      Icon(
                        FlutterIslamicIcons.quran,
                        size: 20,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Surah ${quran.getSurahName(_currentSurah)} ($_currentSurah:$_currentVerse)',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: _nextVerse,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                quran.getVerse(_currentSurah, _currentVerse),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                quran.getVerseTranslation(_currentSurah, _currentVerse),
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap to open in Quran',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
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
              _weeklyProgress.asMap().entries.map((e) {
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value.toDouble(),
                      color:
                          e.value == 8
                              ? Colors.green
                              : Theme.of(context).colorScheme.primary,
                      width: 16,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: 8, // Max is 8 prayers now
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

  Widget _buildPrayerTile(String name, DateTime time) {
    final formattedTime = DateFormat.jm().format(time);
    final isPrayed = _prayerStatus[name] ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          FlutterIslamicIcons.solidMosque,
          size: 32,
          color:
              name == 'Sunrise'
                  ? Colors.orange
                  : Theme.of(context).colorScheme.primary,
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(formattedTime, style: const TextStyle(fontSize: 16)),
        trailing: Checkbox(
          value: isPrayed,
          onChanged: (value) {
            _savePrayerStatus(name, value ?? false);
          },
        ),
      ),
    );
  }
}
