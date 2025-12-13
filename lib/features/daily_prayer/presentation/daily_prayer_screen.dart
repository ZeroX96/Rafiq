import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
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
                  _buildPrayerTile('Fajr', _prayerTimes!.fajr),
                  _buildPrayerTile(
                    'Sunrise',
                    _prayerTimes!.sunrise,
                    isPrayer: false,
                  ),
                  _buildPrayerTile('Dhuhr', _prayerTimes!.dhuhr),
                  _buildPrayerTile('Asr', _prayerTimes!.asr),
                  _buildPrayerTile('Maghrib', _prayerTimes!.maghrib),
                  _buildPrayerTile('Isha', _prayerTimes!.isha),
                ],
              ),
    );
  }

  Widget _buildPrayerTile(String name, DateTime time, {bool isPrayer = true}) {
    final formattedTime = DateFormat.jm().format(time);
    // Mock status for now - in real app, fetch from DB
    bool isPrayed = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(
              isPrayer ? Icons.access_time_filled : Icons.wb_sunny,
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
