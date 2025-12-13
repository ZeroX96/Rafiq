import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rafiq/core/services/settings_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  List<dynamic> _cities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  Future<void> _loadCities() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/json/cities.json',
      );
      final data = await json.decode(response);
      setState(() {
        _cities = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Handle error
    }
  }

  Future<void> _selectCity(dynamic city) async {
    final settings = ref.read(settingsServiceProvider);
    await settings.saveLocation(city['lat'], city['lng'], city['name']);
    await settings.setOnboardingCompleted(true);

    if (mounted) {
      context.go('/daily-prayer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to Rafiq')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Select your city to calculate prayer times:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _cities.length,
                      itemBuilder: (context, index) {
                        final city = _cities[index];
                        return ListTile(
                          title: Text(city['name']),
                          subtitle: Text(city['country']),
                          onTap: () => _selectCity(city),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
