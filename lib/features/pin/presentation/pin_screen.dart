import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class PinScreen extends StatefulWidget {
  final bool isSetup;
  final VoidCallback? onSuccess;

  const PinScreen({super.key, this.isSetup = false, this.onSuccess});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  String _message = 'Enter PIN';

  @override
  void initState() {
    super.initState();
    if (widget.isSetup) {
      _message = 'Create a PIN';
    } else {
      _message = 'Enter PIN to Unlock';
    }
  }

  void _onKeyPress(String key) {
    if (_pin.length < 4) {
      setState(() {
        _pin += key;
      });
      HapticFeedback.lightImpact();
      if (_pin.length == 4) {
        _onSubmit();
      }
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
      HapticFeedback.lightImpact();
    }
  }

  Future<void> _onSubmit() async {
    if (widget.isSetup) {
      if (_isConfirming) {
        if (_pin == _confirmPin) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('app_pin', _pin);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('PIN Set Successfully')),
            );
            if (widget.onSuccess != null) {
              widget.onSuccess!();
            } else {
              context.pop();
            }
          }
        } else {
          setState(() {
            _message = 'PINs do not match. Try again.';
            _pin = '';
            _confirmPin = '';
            _isConfirming = false;
          });
          HapticFeedback.heavyImpact();
        }
      } else {
        setState(() {
          _confirmPin = _pin;
          _pin = '';
          _isConfirming = true;
          _message = 'Confirm PIN';
        });
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      final storedPin = prefs.getString('app_pin');
      if (_pin == storedPin) {
        if (widget.onSuccess != null) {
          widget.onSuccess!();
        } else {
          // Default action if no callback
          context.go('/daily-prayer');
        }
      } else {
        setState(() {
          _message = 'Incorrect PIN';
          _pin = '';
        });
        HapticFeedback.heavyImpact();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isSetup ? AppBar(title: const Text('Setup PIN')) : null,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _message,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        index < _pin.length
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade300,
                  ),
                );
              }),
            ),
            const SizedBox(height: 48),
            _buildKeypad(),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        _buildRow(['1', '2', '3']),
        _buildRow(['4', '5', '6']),
        _buildRow(['7', '8', '9']),
        _buildRow(['', '0', 'del']),
      ],
    );
  }

  Widget _buildRow(List<String> keys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            keys.map((key) {
              if (key.isEmpty) return const SizedBox(width: 80, height: 80);
              if (key == 'del') {
                return SizedBox(
                  width: 80,
                  height: 80,
                  child: IconButton(
                    onPressed: _onDelete,
                    icon: const Icon(Icons.backspace_outlined),
                  ),
                );
              }
              return SizedBox(
                width: 80,
                height: 80,
                child: TextButton(
                  onPressed: () => _onKeyPress(key),
                  style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.grey.shade100,
                  ),
                  child: Text(
                    key,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
