import 'package:flutter/material.dart';

class StackedProgressBar extends StatelessWidget {
  final List<ProgressSegment> segments;
  final double height;

  const StackedProgressBar({
    super.key,
    required this.segments,
    this.height = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stacked bar
        Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2),
            color: Colors.grey[200],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(height / 2),
            child: Row(
              children: segments.map((segment) {
                return Flexible(
                  flex: (segment.percentage * 100).toInt(),
                  child: Container(
                    color: segment.color,
                    alignment: Alignment.center,
                    child: segment.percentage > 0.1
                        ? Text(
                            '${segment.percentage.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: segments.map((segment) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: segment.color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${segment.label} (${segment.count})',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class ProgressSegment {
  final String label;
  final int count;
  final double percentage;
  final Color color;

  ProgressSegment({
    required this.label,
    required this.count,
    required this.percentage,
    required this.color,
  });
}
