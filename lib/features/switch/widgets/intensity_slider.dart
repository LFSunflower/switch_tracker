import 'package:flutter/material.dart';

class IntensitySlider extends StatelessWidget {
  final int value;
  final Function(int) onChanged;

  const IntensitySlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  String _getIntensityLabel(int intensity) {
    switch (intensity) {
      case 1:
        return 'Muito Leve';
      case 2:
        return 'Leve';
      case 3:
        return 'Moderado';
      case 4:
        return 'Intenso';
      case 5:
        return 'Muito Intenso';
      default:
        return '';
    }
  }

  Color _getIntensityColor(int intensity) {
    switch (intensity) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.deepOrange;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: value.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          onChanged: (newValue) => onChanged(newValue.toInt()),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: _getIntensityColor(value).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _getIntensityColor(value),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Nível: $value',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _getIntensityColor(value),
                ),
              ),
              Text(
                _getIntensityLabel(value),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _getIntensityColor(value),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}