import 'package:flutter/material.dart';

import '../models/dismiss_settings.dart';

/// Opens the bottom sheet used during the presentation to change
/// the Dismissible properties live.
void showDismissControls(
  BuildContext context, {
  required DismissSettings settings,
  required ValueChanged<DismissSettings> onChanged,
}) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (_) => _DismissControlsSheet(initial: settings, onChanged: onChanged),
  );
}

class _DismissControlsSheet extends StatefulWidget {
  const _DismissControlsSheet({required this.initial, required this.onChanged});

  final DismissSettings initial;
  final ValueChanged<DismissSettings> onChanged;

  @override
  State<_DismissControlsSheet> createState() => _DismissControlsSheetState();
}

class _DismissControlsSheetState extends State<_DismissControlsSheet> {
  late DismissSettings _settings = widget.initial;

  // Update both the sheet and the inbox behind it.
  void _update(DismissSettings next) {
    setState(() => _settings = next);
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    const bold = TextStyle(fontWeight: FontWeight.bold);
    final percent = '${(_settings.threshold * 100).round()}%';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('1. direction', style: bold),
          const SizedBox(height: 8),
          SegmentedButton<DismissDirection>(
            segments: const [
              ButtonSegment(value: DismissDirection.horizontal, label: Text('Both')),
              ButtonSegment(value: DismissDirection.startToEnd, label: Text('Right')),
              ButtonSegment(value: DismissDirection.endToStart, label: Text('Left')),
              ButtonSegment(value: DismissDirection.none, label: Text('None')),
            ],
            selected: {_settings.direction},
            onSelectionChanged: (s) => _update(_settings.copyWith(direction: s.first)),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('2. background / secondaryBackground', style: bold),
            subtitle: Text(_settings.showBackground ? 'Green / Red' : 'null (default)'),
            value: _settings.showBackground,
            onChanged: (v) => _update(_settings.copyWith(showBackground: v)),
          ),
          const SizedBox(height: 8),
          Text('3. dismissThresholds: $percent', style: bold),
          Slider(
            value: _settings.threshold,
            min: 0.1,
            max: 0.9,
            divisions: 8,
            label: percent,
            onChanged: (v) => _update(_settings.copyWith(threshold: v)),
          ),
        ],
      ),
    );
  }
}
