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
  Map<String, int> _debt = {
    'Fajr': 0,
    'Dhuhr': 0,
    'Asr': 0,
    'Maghrib': 0,
    'Isha': 0,
    'Witr': 0,
  };
  Map<String, int> _originalDebt = {
    'Fajr': 0,
    'Dhuhr': 0,
    'Asr': 0,
    'Maghrib': 0,
    'Isha': 0,
    'Witr': 0,
  };
  bool _hideDebt = false;

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

    Map<String, int> loadedDebt = {};
    for (String prayer in ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha', 'Witr']) {
      loadedDebt[prayer] = prefs.getInt('qada_debt_$prayer') ?? 0;
    }

    if (loadedDebt.values.every((v) => v == 0) && profile != null) {
      final calculator = QadaCalculator();
      final calculated = calculator.calculateDebtFromProfile(
        dob: profile['dob'],
        pubertyAge: profile['pubertyAge'],
        gender: profile['gender'],
        hasMenstruation: profile['gender'] == 'Female',
      );
      loadedDebt = calculated;
      for (var entry in loadedDebt.entries) {
        await prefs.setInt('qada_debt_${entry.key}', entry.value);
      }
    }

    setState(() {
      _debt = loadedDebt;
      _originalDebt = Map.from(loadedDebt);
    });
  }

  Future<void> _saveDebt() async {
    final prefs = await SharedPreferences.getInstance();
    for (var entry in _debt.entries) {
      await prefs.setInt('qada_debt_${entry.key}', entry.value);
    }
  }

  void _decrement(String prayer) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_debt[prayer]! > 0) _debt[prayer] = _debt[prayer]! - 1;
    });
    _saveDebt();
  }

  void _increment(String prayer) {
    HapticFeedback.lightImpact();
    setState(() => _debt[prayer] = _debt[prayer]! + 1);
    _saveDebt();
  }

  int get _totalDebt => _debt.values.fold(0, (a, b) => a + b);
  int get _totalOriginal => _originalDebt.values.fold(0, (a, b) => a + b);
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
          const SizedBox(height: 16),
          ..._debt.entries.map((entry) => _buildDebtTile(entry)).toList(),
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

  Widget _buildDebtTile(MapEntry<String, int> entry) {
    return InkWell(
      onTap: () => _decrement(entry.key),
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
                    onPressed: () => _increment(entry.key),
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
