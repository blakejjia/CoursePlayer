import 'package:flutter/material.dart';

class SpeedSelectionBottomSheet extends StatelessWidget {
  final double initialSpeed;
  final ValueChanged<double> onSpeedSelected;

  const SpeedSelectionBottomSheet({
    super.key,
    required this.initialSpeed,
    required this.onSpeedSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<double> speeds = [0.6, 1.0, 1.3, 1.5, 1.7, 2.0];

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select default Playback Speed',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16.0),
          Text(
            'Current Speed: ${initialSpeed}x',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 16.0),
          ...speeds.map((speed) {
            return ListTile(
              title: Text('${speed}x${speed == 1.0 ? " (Normal)" : ""}'),
              onTap: () {
                onSpeedSelected(speed);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
