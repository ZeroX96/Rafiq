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
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _nameFormKey = GlobalKey<FormState>();

  String _gender = 'Male';
  String _madhab = 'Hanafi';
  DateTime _dob = DateTime(2000, 1, 1);
  int _pubertyAge = 13;
  int _menstruationDuration = 7; // Default 7 days
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
    if (_currentPage == 0) {
      if (!_nameFormKey.currentState!.validate()) return;
    }

    if (_currentPage < 5) {
      // Increased steps
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage++);
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage--);
    }
  }

  void _calculateDebt() {
    final calculator = QadaCalculator();
    final debt = calculator.calculateDebtFromProfile(
      dob: _dob,
      pubertyAge: _pubertyAge,
      gender: _gender,
      hasMenstruation: _gender == 'Female',
      menstruationDuration: _menstruationDuration,
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

    // Save email if needed (not in original profile but requested)
    // await settings.saveEmail(_emailController.text);

    await settings.setOnboardingCompleted(true);
    if (mounted) context.go('/daily-prayer');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentPage > 0) {
          _previousPage();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Setup Rafiq (${_currentPage + 1}/6)'),
          leading:
              _currentPage > 0
                  ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _previousPage,
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
            if (_gender == 'Female')
              _buildMenstruationStep()
            else
              const SizedBox(), // Placeholder to keep index sync
            _buildLocationStep(),
            _buildSummaryStep(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _nextPage,
          label: Text(_currentPage == 5 ? 'Finish' : 'Next'),
          icon: Icon(_currentPage == 5 ? Icons.check : Icons.arrow_forward),
        ),
      ),
    );
  }

  Widget _buildQuoteCard(String text, String source) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '- $source',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _nameFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildQuoteCard(
              "The first thing for which a person will be brought to account on the Day of Resurrection will be his prayer.",
              "Sunan an-Nasa'i 465",
            ),
            const Text(
              'Welcome to Rafiq',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Let\'s start with your details.'),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Please enter your name';
                if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value))
                  return 'Name must contain only alphabets';
                return null;
              },
              onFieldSubmitted: (_) => _nextPage(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Gmail Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Please enter your email';
                if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(value))
                  return 'Please enter a valid Gmail address';
                return null;
              },
              onFieldSubmitted: (_) => _nextPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderMadhabStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildQuoteCard(
            "Read the Quran, for it will come as an intercessor for its reciters on the Day of Resurrection.",
            "Sahih Muslim 804",
          ),
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
          _buildQuoteCard(
            "The Pen has been lifted from three: from the sleeping person until he wakes up, from the minor until he grows up, and from the insane person until he comes to his senses.",
            "Sunan Abi Dawud 4403",
          ),
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

  Widget _buildMenstruationStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildQuoteCard(
            "Allah does not burden a soul beyond that it can bear.",
            "Quran 2:286",
          ),
          const Text(
            'Cycle Duration',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('Average days per month to exclude from prayer debt.'),
          const SizedBox(height: 24),
          Text('Days: $_menstruationDuration'),
          Slider(
            value: _menstruationDuration.toDouble(),
            min: 3,
            max: 10,
            divisions: 7,
            label: _menstruationDuration.toString(),
            onChanged: (v) => setState(() => _menstruationDuration = v.toInt()),
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
                          _calculateDebt();
                        },
                      );
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildSummaryStep() {
    _calculateDebt();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Estimated Qada Debt:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Allow manual edit logic here if needed
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You can adjust debt in Qada tab later.'),
                    ),
                  );
                },
                tooltip: 'Edit Calculation',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children:
                  _calculatedDebt.entries
                      .map(
                        (e) => ListTile(
                          title: Text(e.key),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  size: 20,
                                ),
                                onPressed:
                                    () => setState(() {
                                      if (_calculatedDebt[e.key]! > 0)
                                        _calculatedDebt[e.key] =
                                            _calculatedDebt[e.key]! - 1;
                                    }),
                              ),
                              Text('${e.value}'),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  size: 20,
                                ),
                                onPressed:
                                    () => setState(() {
                                      _calculatedDebt[e.key] =
                                          _calculatedDebt[e.key]! + 1;
                                    }),
                              ),
                            ],
                          ),
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
