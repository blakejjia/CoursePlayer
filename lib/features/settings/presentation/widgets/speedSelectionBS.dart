import 'package:flutter/material.dart';

class SpeedSelectionBS extends StatefulWidget {
  final double initialSpeed;
  final ValueChanged<double> onSpeedSelected;

  const SpeedSelectionBS({
    super.key,
    required this.initialSpeed,
    required this.onSpeedSelected,
  });

  @override
  State<SpeedSelectionBS> createState() => _SpeedSelectionBSState();
}

class _SpeedSelectionBSState extends State<SpeedSelectionBS> {
  // Allow fine-grained custom speed control with a slider.
  static const double _min = 0.5;
  static const double _max = 2.0;
  static const double _step = 0.25; // 0.25x increments

  late double _speed;

  @override
  void initState() {
    super.initState();
    _speed = widget.initialSpeed.clamp(_min, _max);
  }

  double _roundToStep(double value) {
    final steps = ((value - _min) / _step).round();
    final rounded = _min + steps * _step;
    return rounded.clamp(_min, _max);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Select default Playback Speed',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12.0),
          Text(
            'Current: ${_speed.toStringAsFixed(2)}x',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),

          // Custom speed slider
          Row(
            children: [
              Text('${_min.toStringAsFixed(2)}x'),
              Expanded(
                child: Slider(
                  value: _speed,
                  min: _min,
                  max: _max,
                  divisions: ((_max - _min) / _step).round(),
                  label: '${_speed.toStringAsFixed(2)}x',
                  onChanged: (val) =>
                      setState(() => _speed = _roundToStep(val)),
                ),
              ),
              Text('${_max.toStringAsFixed(2)}x'),
            ],
          ),

          const SizedBox(height: 8.0),

          // Apply custom speed button
          FilledButton.icon(
            icon: const Icon(Icons.check),
            label: const Text('Apply this speed'),
            onPressed: () {
              widget.onSpeedSelected(_speed);
              Navigator.of(context).pop();
            },
          ),

          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
