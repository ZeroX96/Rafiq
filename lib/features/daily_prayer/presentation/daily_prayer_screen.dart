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
  Map<String, String> _prayerStatus = {
    'Fajr': 'None',
    'Sunrise': 'None',
    'Dhuhr': 'None',
    'Asr': 'None',
    'Maghrib': 'None',
    'Isha': 'None',
    'Shafaa': 'None',
    'Witr': 'None',
  };

  // Gamification State
  int _dailyScore = 0;
  String _rank = 'Muslim';
  List<int> _weeklyProgress = [0, 0, 0, 0, 0, 0, 0];
  String _gender = 'Male'; // Default

  // Daily Verse State
  int _currentSurah = 1;
  int _currentVerse = 1;

  @override
  void initState() {
    super.initState();
    _initializeDailyVerse();
    _loadPrayerTimes();
    _loadPrayerStatus();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _gender = prefs.getString('profile_gender') ?? 'Male';
    });
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

    Map<String, String> status = {};
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
      // Migrate old bool to new string if needed
      final oldVal = prefs.getBool('prayer_${today}_$prayer');
      if (oldVal != null) {
        status[prayer] = oldVal ? 'Fard' : 'None'; // Default to Fard if true
      } else {
        status[prayer] =
            prefs.getString('prayer_status_${today}_$prayer') ?? 'None';
      }
    }

    setState(() => _prayerStatus = status);
    _calculateScore();
    _loadWeeklyProgress();
  }

  Future<void> _savePrayerStatus(String prayer, String status) async {
    HapticFeedback.lightImpact();
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await prefs.setString('prayer_status_${today}_$prayer', status);
    // Keep boolean for backward compatibility/charts for now
    await prefs.setBool(
      'prayer_${today}_$prayer',
      status != 'None' && status != 'Missed',
    );

    // Record timestamp if marked as done
    if (status != 'None' && status != 'Missed') {
      await prefs.setString(
        'prayer_time_${today}_$prayer',
        DateTime.now().toIso8601String(),
      );
    }

    setState(() {
      _prayerStatus[prayer] = status;
    });
    _calculateScore();
    _loadWeeklyProgress(); // Real-time chart update
  }

  void _calculateScore() {
    int score = 0;
    for (var status in _prayerStatus.values) {
      if (status == 'Jama\'a')
        score += 13;
      else if (status == 'Fard')
        score += 10;
      else if (status == 'Late')
        score += 8;
    }

    // Cap at 100
    if (score > 100) score = 100;

    setState(() {
      _dailyScore = score;
      _rank = _getRank(_dailyScore);
    });
  }

  Map<String, double> _prayerConsistency = {};

  Future<void> _loadWeeklyProgress() async {
    final prefs = await SharedPreferences.getInstance();
    List<int> progress = [];
    Map<String, int> counts = {
      'Fajr': 0,
      'Sunrise': 0,
      'Dhuhr': 0,
      'Asr': 0,
      'Maghrib': 0,
      'Isha': 0,
      'Shafaa': 0,
      'Witr': 0,
    };

    for (int i = 6; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      int count = 0;
      for (String prayer in counts.keys) {
        if (prefs.getBool('prayer_${dateKey}_$prayer') ?? false) {
          count++;
          counts[prayer] = counts[prayer]! + 1;
        }
      }
      progress.add(count);
    }
    setState(() {
      _weeklyProgress = progress;
      _prayerConsistency = counts.map((k, v) => MapEntry(k, v / 7.0));
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
    // Navigate to Quran tab with correct route
    context.go('/quran-hadith/surah/$_currentSurah?verse=$_currentVerse');
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              backgroundImage: AssetImage(
                (_gender.toLowerCase().contains('female') ||
                        _gender.toLowerCase().contains('girl') ||
                        _gender.toLowerCase().contains('woman'))
                    ? 'assets/images/avatar_woman.png'
                    : 'assets/images/avatar_man.png',
              ),
            ),
          ),
        ],
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
                  const SizedBox(height: 24),
                  const Text(
                    'Prayer Consistency (Last 7 Days)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children:
                        _prayerConsistency.entries
                            .map((e) => _buildConsistencyItem(e.key, e.value))
                            .toList(),
                  ),
                  const SizedBox(height: 32),
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

  // Prayer quotes for each prayer
  final Map<String, String> _prayerQuotes = {
    'Fajr': 'من صلي الفجر في جماعة فكأنما قام الليل كله',
    'Sunrise': 'اللهم أنت ربي لا إله إلا أنت',
    'Dhuhr': 'صلاة الظهر هي الصلاة الوسطى',
    'Asr': 'حافظوا على الصلوات والصلاة الوسطى',
    'Maghrib': 'من صلى المغرب في جماعة غفر له ما تقدم من ذنبه',
    'Isha': 'من صلى العشاء في جماعة فكأنما قام نصف الليل',
    'Shafaa': 'شفع ثم أوتر',
    'Witr': 'إن الله وتر يحب الوتر',
  };

  void _showPrayerTypeDialog(String name) {
    HapticFeedback.mediumImpact();
    final quote = _prayerQuotes[name] ?? '';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('How did you pray $name?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    quote,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontFamily: 'Amiri', fontSize: 18),
                  ),
                ),
                const SizedBox(height: 16),
                _buildPrayerOption(name, 'Jama\'a', Icons.groups, Colors.green),
                _buildPrayerOption(name, 'Fard', Icons.person, Colors.blue),
                _buildPrayerOption(
                  name,
                  'Late',
                  Icons.access_time,
                  Colors.orange,
                ),
                _buildPrayerOption(name, 'Missed', Icons.close, Colors.red),
              ],
            ),
          ),
    );
  }

  Widget _buildPrayerOption(
    String prayer,
    String type,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(type),
      onTap: () {
        _savePrayerStatus(prayer, type);
        Navigator.pop(context);
        if (type != 'Missed') {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$prayer marked as $type')));
        }
      },
    );
  }

  Widget _buildPrayerTile(String name, DateTime time) {
    final formattedTime = DateFormat.jm().format(time);
    final status = _prayerStatus[name] ?? 'None';
    final isPrayed = status != 'None' && status != 'Missed';

    Color? statusColor;
    if (status == 'Jama\'a')
      statusColor = Colors.green;
    else if (status == 'Fard')
      statusColor = Colors.blue;
    else if (status == 'Late')
      statusColor = Colors.orange;
    else if (status == 'Missed')
      statusColor = Colors.red;

    return InkWell(
      onTap: () => _showPrayerTypeDialog(name),
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: isPrayed ? statusColor?.withOpacity(0.1) : null,
        child: ListTile(
          leading: Icon(
            FlutterIslamicIcons.solidMosque,
            size: 32,
            color:
                isPrayed
                    ? statusColor
                    : (name == 'Sunrise'
                        ? Colors.orange
                        : Theme.of(context).colorScheme.primary),
          ),
          title: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isPrayed ? statusColor : null,
            ),
          ),
          subtitle: Text(
            '$formattedTime ${isPrayed ? "• $status" : ""}',
            style: TextStyle(
              fontSize: 14,
              color: isPrayed ? statusColor : null,
            ),
          ),
          trailing: Icon(
            isPrayed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isPrayed ? statusColor : Colors.grey,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildConsistencyItem(String label, double progress) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 6,
                  ),
                ),
              ),
              Center(
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
