import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rafiq/core/services/settings_service.dart';
import 'package:rafiq/features/qada_debt/domain/qada_calculator.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form Data
  final TextEditingController _nameController = TextEditingController();
  String _gender = 'Male';
  String _madhab = 'Hanafi';
  DateTime _dob = DateTime(2000, 1, 1);
  int _pubertyAge = 13;
  Map<String, dynamic>? _selectedCity;

  // Calculation Result
  Map<String, int> _calculatedDebt = {};

  // Cities Data
  List<dynamic> _cities = [];
  bool _isLoadingCities = true;

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
        _isLoadingCities = false;
      });
    } catch (e) {
      setState(() => _isLoadingCities = false);
    }
  }

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage++);
    } else {
      _finishOnboarding();
    }
  }

  void _calculateDebt() {
    final calculator = QadaCalculator();
    final debt = calculator.calculateDebtFromProfile(
      dob: _dob,
      pubertyAge: _pubertyAge,
      gender: _gender,
      hasMenstruation: _gender == 'Female', // Simple assumption for now
    );
    setState(() {
      _calculatedDebt = debt;
    });
  }

  Future<void> _finishOnboarding() async {
    if (_selectedCity == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a city')));
      return;
    }

    final settings = ref.read(settingsServiceProvider);
    await settings.saveProfile(
      name: _nameController.text,
      gender: _gender,
      madhab: _madhab,
      pubertyAge: _pubertyAge,
      dob: _dob,
    );
    await settings.saveLocation(
      _selectedCity!['lat'],
      _selectedCity!['lng'],
      _selectedCity!['name'],
    );

    // TODO: Save calculated debt to DB here (mock for now)

    await settings.setOnboardingCompleted(true);
    if (mounted) context.go('/daily-prayer');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Rafiq (${_currentPage + 1}/5)'),
        leading:
            _currentPage > 0
                ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                    setState(() => _currentPage--);
                  },
                )
                : null,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildNameStep(),
          _buildGenderMadhabStep(),
          _buildAgeStep(),
          _buildLocationStep(),
          _buildSummaryStep(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _nextPage,
        label: Text(_currentPage == 4 ? 'Finish' : 'Next'),
        icon: Icon(_currentPage == 4 ? Icons.check : Icons.arrow_forward),
      ),
    );
  }

  Widget _buildNameStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Welcome to Rafiq',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('Let\'s start with your name.'),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Your Name',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _nextPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderMadhabStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Personal Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            value: _gender,
            decoration: const InputDecoration(
              labelText: 'Gender',
              border: OutlineInputBorder(),
            ),
            items:
                ['Male', 'Female']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: (v) => setState(() => _gender = v!),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _madhab,
            decoration: const InputDecoration(
              labelText: 'Madhab',
              border: OutlineInputBorder(),
            ),
            items:
                ['Hanafi', 'Shafi', 'Maliki', 'Hanbali']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: (v) => setState(() => _madhab = v!),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Age & Puberty',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('This is used to calculate your Qada debt.'),
          const SizedBox(height: 24),
          ListTile(
            title: const Text('Date of Birth'),
            subtitle: Text('${_dob.day}/${_dob.month}/${_dob.year}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _dob,
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );
              if (date != null) setState(() => _dob = date);
            },
          ),
          const SizedBox(height: 16),
          Text('Puberty Age: $_pubertyAge'),
          Slider(
            value: _pubertyAge.toDouble(),
            min: 9,
            max: 18,
            divisions: 9,
            label: _pubertyAge.toString(),
            onChanged: (v) => setState(() => _pubertyAge = v.toInt()),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStep() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Select Location',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child:
              _isLoadingCities
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                    itemCount: _cities.length,
                    itemBuilder: (context, index) {
                      final city = _cities[index];
                      final isSelected =
                          _selectedCity != null &&
                          _selectedCity!['name'] == city['name'];
                      return ListTile(
                        title: Text(city['name']),
                        subtitle: Text(city['country']),
                        selected: isSelected,
                        trailing:
                            isSelected
                                ? const Icon(Icons.check, color: Colors.green)
                                : null,
                        onTap: () {
                          setState(() => _selectedCity = city);
                          _calculateDebt(); // Pre-calculate debt when location is picked (just to trigger logic)
                        },
                      );
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildSummaryStep() {
    _calculateDebt(); // Ensure debt is calculated
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Summary',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Text('Name: ${_nameController.text}'),
          Text('Location: ${_selectedCity?['name'] ?? "Not Selected"}'),
          const Divider(),
          const Text(
            'Estimated Qada Debt:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children:
                  _calculatedDebt.entries
                      .map(
                        (e) => ListTile(
                          title: Text(e.key),
                          trailing: Text('${e.value} prayers'),
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
