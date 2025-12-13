import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AzkarCounterWidget extends StatefulWidget {
  final int initialCount;
  final int target;
  final VoidCallback? onTargetReached;
  final ValueChanged<int>? onCountChanged;

  const AzkarCounterWidget({
    super.key,
    this.initialCount = 0,
    this.target = 100,
    this.onTargetReached,
    this.onCountChanged,
  });

  @override
  State<AzkarCounterWidget> createState() => _AzkarCounterWidgetState();
}

class _AzkarCounterWidgetState extends State<AzkarCounterWidget> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.initialCount;
  }

  void _increment() {
    setState(() {
      _count++;
    });
    widget.onCountChanged?.call(_count);
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);

    if (_count == widget.target) {
      widget.onTargetReached?.call();
      HapticFeedback.heavyImpact();
    }
  }

  void _reset() {
    setState(() {
      _count = 0;
    });
    widget.onCountChanged?.call(0);
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$_count / ${widget.target}',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: _increment,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primaryContainer,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.touch_app,
              size: 80,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextButton.icon(
          onPressed: _reset,
          icon: const Icon(Icons.refresh),
          label: const Text('Reset'),
        ),
      ],
    );
  }
}
