import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rafiq/core/services/settings_service.dart';
import 'package:rafiq/features/qada_debt/domain/qada_calculator.dart';

class QadaDebtScreen extends ConsumerStatefulWidget {
  const QadaDebtScreen({super.key});

  @override
  ConsumerState<QadaDebtScreen> createState() => _QadaDebtScreenState();
}

class _QadaDebtScreenState extends ConsumerState<QadaDebtScreen> {
  // Fard prayers (obligatory)
  Map<String, int> _fardDebt = {
    'Fajr': 0,
    'Dhuhr': 0,
    'Asr': 0,
    'Maghrib': 0,
    'Isha': 0,
  };

  // Sunnah prayers (optional)
  Map<String, int> _sunnahDebt = {'Sunrise': 0, 'Shafaa': 0, 'Witr': 0};

  Map<String, int> _originalFardDebt = {};
  Map<String, int> _originalSunnahDebt = {};
  bool _hideDebt = false;
  bool _trackSunnah = false;

  final List<Map<String, String>> _quotes = [
    {
      'text':
          'The first thing for which a person will be brought to account on the Day of Resurrection will be his prayer.',
      'source': 'Sunan an-Nasa\'i 465',
    },
    {
      'text': 'Between a man and shirk and kufr is neglecting the prayer.',
      'source': 'Sahih Muslim 82',
    },
    {
      'text': 'Whoever misses a prayer, let him make it up when he remembers.',
      'source': 'Bukhari & Muslim',
    },
    {
      'text':
          'The covenant between us and them is the prayer; whoever leaves it has disbelieved.',
      'source': 'Tirmidhi 2621',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadDebt();
  }

  Future<void> _loadDebt() async {
    final prefs = await SharedPreferences.getInstance();
    final settings = ref.read(settingsServiceProvider);
    final profile = await settings.getProfile();

    // Load user preference for Sunnah tracking
    final trackSunnah = prefs.getBool('track_sunnah_debt') ?? false;

    // Load Fard prayers
    Map<String, int> loadedFard = {};
    for (String prayer in ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha']) {
      loadedFard[prayer] = prefs.getInt('qada_debt_$prayer') ?? 0;
    }

    // Load Sunnah prayers
    Map<String, int> loadedSunnah = {};
    for (String prayer in ['Sunrise', 'Shafaa', 'Witr']) {
      loadedSunnah[prayer] = prefs.getInt('qada_debt_$prayer') ?? 0;
    }

    // Calculate from profile if all debts are zero
    if (loadedFard.values.every((v) => v == 0) && profile != null) {
      final calculator = QadaCalculator();
      final calculated = calculator.calculateDebtFromProfile(
        dob: profile['dob'],
        pubertyAge: profile['pubertyAge'],
        gender: profile['gender'],
        hasMenstruation:
            profile['gender'] == 'Girl' || profile['gender'] == 'Woman',
      );
      // Only take Fard prayers from calculated
      loadedFard = {
        'Fajr': calculated['Fajr'] ?? 0,
        'Dhuhr': calculated['Dhuhr'] ?? 0,
        'Asr': calculated['Asr'] ?? 0,
        'Maghrib': calculated['Maghrib'] ?? 0,
        'Isha': calculated['Isha'] ?? 0,
      };
      for (var entry in loadedFard.entries) {
        await prefs.setInt('qada_debt_${entry.key}', entry.value);
      }
    }

    setState(() {
      _fardDebt = loadedFard;
      _sunnahDebt = loadedSunnah;
      _originalFardDebt = Map.from(loadedFard);
      _originalSunnahDebt = Map.from(loadedSunnah);
      _trackSunnah = trackSunnah;
    });
  }

  Future<void> _saveDebt() async {
    final prefs = await SharedPreferences.getInstance();
    for (var entry in _fardDebt.entries) {
      await prefs.setInt('qada_debt_${entry.key}', entry.value);
    }
    for (var entry in _sunnahDebt.entries) {
      await prefs.setInt('qada_debt_${entry.key}', entry.value);
    }
  }

  void _decrementFard(String prayer) async {
    HapticFeedback.lightImpact();
    setState(() {
      if (_fardDebt[prayer]! > 0) _fardDebt[prayer] = _fardDebt[prayer]! - 1;
    });
    _saveDebt();

    // Record timestamp
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().toIso8601String();
    await prefs.setString('last_qada_payment_$prayer', now);
    await prefs.setString('last_qada_payment_any', now);
  }

  void _incrementFard(String prayer) {
    HapticFeedback.lightImpact();
    setState(() => _fardDebt[prayer] = _fardDebt[prayer]! + 1);
    _saveDebt();
  }

  void _decrementSunnah(String prayer) async {
    HapticFeedback.lightImpact();
    setState(() {
      if (_sunnahDebt[prayer]! > 0)
        _sunnahDebt[prayer] = _sunnahDebt[prayer]! - 1;
    });
    _saveDebt();

    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().toIso8601String();
    await prefs.setString('last_qada_payment_$prayer', now);
    await prefs.setString('last_qada_payment_any', now);
  }

  void _incrementSunnah(String prayer) {
    HapticFeedback.lightImpact();
    setState(() => _sunnahDebt[prayer] = _sunnahDebt[prayer]! + 1);
    _saveDebt();
  }

  int get _totalFardDebt => _fardDebt.values.fold(0, (a, b) => a + b);
  int get _totalSunnahDebt => _sunnahDebt.values.fold(0, (a, b) => a + b);
  int get _totalDebt => _totalFardDebt + (_trackSunnah ? _totalSunnahDebt : 0);

  int get _totalOriginalFard =>
      _originalFardDebt.values.fold(0, (a, b) => a + b);
  int get _totalOriginalSunnah =>
      _originalSunnahDebt.values.fold(0, (a, b) => a + b);
  int get _totalOriginal =>
      _totalOriginalFard + (_trackSunnah ? _totalOriginalSunnah : 0);

  double get _paidPercentage =>
      _totalOriginal > 0
          ? ((_totalOriginal - _totalDebt) / _totalOriginal * 100).clamp(0, 100)
          : 0;

  @override
  Widget build(BuildContext context) {
    final quote = _quotes[DateTime.now().day % _quotes.length];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qada Debt'),
        actions: [
          IconButton(
            icon: Icon(_hideDebt ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _hideDebt = !_hideDebt),
            tooltip: _hideDebt ? 'Show Debt' : 'Hide Debt',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildQuoteCard(quote),
          const SizedBox(height: 16),
          _buildProgressChart(),
          const SizedBox(height: 24),
          const Text(
            'Fard Prayers (Obligatory)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ..._fardDebt.entries
              .map((entry) => _buildFardDebtTile(entry))
              .toList(),
          if (_trackSunnah) ...[
            const SizedBox(height: 24),
            const Text(
              'Sunnah Prayers (Optional)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._sunnahDebt.entries
                .map((entry) => _buildSunnahDebtTile(entry))
                .toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildQuoteCard(Map<String, String> quote) {
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.format_quote,
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    quote['text']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '- ${quote['source']}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Overall Progress',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      value: _paidPercentage,
                      color: Colors.green,
                      title: '${_paidPercentage.toStringAsFixed(0)}%',
                      radius: 40,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: 100 - _paidPercentage,
                      color: Colors.grey.shade300,
                      title: '',
                      radius: 40,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Remaining: $_totalDebt prayers',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFardDebtTile(MapEntry<String, int> entry) {
    return InkWell(
      onTap: () => _decrementFard(entry.key),
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    FlutterIslamicIcons.solidMosque,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Tap to mark one done',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  if (!_hideDebt)
                    Text(
                      entry.value.toString(),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else
                    Text(
                      '---',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                    ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _incrementFard(entry.key),
                    icon: const Icon(Icons.add_circle_outline),
                    tooltip: 'Add Debt (Correction)',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSunnahDebtTile(MapEntry<String, int> entry) {
    return InkWell(
      onTap: () => _decrementSunnah(entry.key),
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star_outline,
                    size: 32,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Tap to mark one done',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  if (!_hideDebt)
                    Text(
                      entry.value.toString(),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else
                    Text(
                      '---',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                    ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _incrementSunnah(entry.key),
                    icon: const Icon(Icons.add_circle_outline),
                    tooltip: 'Add Debt (Correction)',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
