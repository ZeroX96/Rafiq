import 'package:flutter/material.dart';
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
  bool _hideDebt = false;

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

    // If debt is empty (first run), calculate from profile
    if (loadedDebt.values.every((v) => v == 0) && profile != null) {
      final calculator = QadaCalculator();
      final calculated = calculator.calculateDebtFromProfile(
        dob: profile['dob'],
        pubertyAge: profile['pubertyAge'],
        gender: profile['gender'],
        hasMenstruation: profile['gender'] == 'Female',
      );
      loadedDebt = calculated;
      // Save initial calculated debt
      for (var entry in loadedDebt.entries) {
        await prefs.setInt('qada_debt_${entry.key}', entry.value);
      }
    }

    setState(() {
      _debt = loadedDebt;
    });
  }

  Future<void> _saveDebt() async {
    final prefs = await SharedPreferences.getInstance();
    for (var entry in _debt.entries) {
      await prefs.setInt('qada_debt_${entry.key}', entry.value);
    }
  }

  void _decrement(String prayer) {
    setState(() {
      if (_debt[prayer]! > 0) {
        _debt[prayer] = _debt[prayer]! - 1;
      }
    });
    _saveDebt();
  }

  void _increment(String prayer) {
    setState(() {
      _debt[prayer] = _debt[prayer]! + 1;
    });
    _saveDebt();
  }

  @override
  Widget build(BuildContext context) {
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
          _buildMotivationalCard(),
          const SizedBox(height: 16),
          ..._debt.entries.map((entry) => _buildDebtTile(entry)).toList(),
        ],
      ),
    );
  }

  Widget _buildMotivationalCard() {
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Reminder: The first thing we are asked about on the Day of Judgment is our Salah.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Make up your missed prayers to purify your soul.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebtTile(MapEntry<String, int> entry) {
    return InkWell(
      onTap: () => _decrement(entry.key), // Entire card is tappable
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
                        'Tap anywhere to mark one done',
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
