import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafiq/core/services/settings_service.dart';
import 'package:rafiq/features/qada_debt/domain/qada_calculator.dart';

class QadaDebtScreen extends ConsumerStatefulWidget {
  const QadaDebtScreen({super.key});

  @override
  ConsumerState<QadaDebtScreen> createState() => _QadaDebtScreenState();
}

class _QadaDebtScreenState extends ConsumerState<QadaDebtScreen> {
  // Mock data for MVP - In real app, this comes from Drift DB
  Map<String, int> _debt = {
    'Fajr': 0,
    'Dhuhr': 0,
    'Asr': 0,
    'Maghrib': 0,
    'Isha': 0,
    'Witr': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadDebt();
  }

  Future<void> _loadDebt() async {
    // In a real app, this would come from the DB.
    // For now, we'll recalculate it from settings to simulate persistence
    // or just show the manual values if we had a DB.
    // Let's try to calculate it from profile if it's zero.

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qada Debt')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children:
            _debt.entries.map((entry) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => _decrement(entry.key),
                          ),
                          SizedBox(
                            width: 40,
                            child: Text(
                              entry.value.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => _increment(entry.key),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Show calculator dialog
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Calculate Qada'),
                  content: const Text('Calculator feature coming soon!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
          );
        },
        label: const Text('Calculate'),
        icon: const Icon(Icons.calculate),
      ),
    );
  }
}
