import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final settings = ref.read(settingsServiceProvider);
    final profile = await settings.getProfile();

    if (profile != null) {
      final calculator = QadaCalculator();
      final calculated = calculator.calculateDebtFromProfile(
        dob: profile['dob'],
        pubertyAge: profile['pubertyAge'],
        gender: profile['gender'],
        hasMenstruation: profile['gender'] == 'Female',
      );

      setState(() {
        _debt = calculated;
      });
    }
  }

  void _decrement(String prayer) {
    setState(() {
      if (_debt[prayer]! > 0) {
        _debt[prayer] = _debt[prayer]! - 1;
      }
    });
  }

  void _increment(String prayer) {
    setState(() {
      _debt[prayer] = _debt[prayer]! + 1;
    });
  }

  IconData _getIcon(String prayer) {
    // Using solidMosque as a generic icon for now to avoid build errors
    // Ideally we would use specific icons if available in the package
    return FlutterIslamicIcons.solidMosque;
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _getIcon(entry.key),
                      size: 28,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      entry.key,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                if (!_hideDebt)
                  Text(
                    entry.value.toString(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  Text(
                    'HIDDEN',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _decrement(entry.key),
                    icon: const Icon(Icons.check),
                    label: const Text('Prayed One'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      foregroundColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _increment(entry.key),
                  icon: const Icon(Icons.add),
                  tooltip: 'Add Debt',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
