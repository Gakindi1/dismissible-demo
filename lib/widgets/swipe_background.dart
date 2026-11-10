import 'package:flutter/material.dart';

/// Coloured strip with an icon + label shown behind a swiping item.
class SwipeBackground extends StatelessWidget {
  const SwipeBackground({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
    required this.alignment,
  });

  final Color color;
  final IconData icon;
  final String label;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final isLeft = alignment == Alignment.centerLeft;
    final text = Text(label, style: const TextStyle(color: Colors.white));

    return Container(
      color: color,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isLeft) ...[text, const SizedBox(width: 8)],
          Icon(icon, color: Colors.white),
          if (isLeft) ...[const SizedBox(width: 8), text],
        ],
      ),
    );
  }
}
