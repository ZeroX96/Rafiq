import 'package:flutter/material.dart';
import 'package:rafiq/features/azkar/presentation/azkar_counter_widget.dart';

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> {
  // Mock data
  final List<Map<String, dynamic>> _azkarList = [
    {'id': 1, 'content': 'Subhan Allah', 'target': 33},
    {'id': 2, 'content': 'Alhamdulillah', 'target': 33},
    {'id': 3, 'content': 'Allahu Akbar', 'target': 34},
    {'id': 4, 'content': 'Astaghfirullah', 'target': 100},
  ];

  Map<String, dynamic>? _selectedAzkar;

  @override
  Widget build(BuildContext context) {
    if (_selectedAzkar != null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => setState(() => _selectedAzkar = null),
          ),
          title: Text(_selectedAzkar!['content']),
        ),
        body: Center(
          child: AzkarCounterWidget(
            target: _selectedAzkar!['target'],
            onTargetReached: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Target Reached! MashaAllah!')),
              );
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Azkar')),
      body: ListView.builder(
        itemCount: _azkarList.length,
        itemBuilder: (context, index) {
          final item = _azkarList[index];
          return ListTile(
            title: Text(item['content']),
            subtitle: Text('Target: ${item['target']}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              setState(() {
                _selectedAzkar = item;
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add custom Azkar logic
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
