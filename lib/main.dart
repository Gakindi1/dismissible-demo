// Dismissible demo: a tiny email inbox where you swipe a message
// to archive it (swipe right) or delete it (swipe left).
//
// The "tune" button in the AppBar opens a panel that changes three
// Dismissible properties live: direction, background, dismissThresholds.
//
// Reference: https://api.flutter.dev/flutter/widgets/Dismissible-class.html
// Cookbook: https://docs.flutter.dev/cookbook/gestures/dismissible

import 'package:flutter/material.dart';

void main() => runApp(const InboxApp());

class InboxApp extends StatelessWidget {
  const InboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dismissible Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const InboxScreen(),
    );
  }
}

/// A simple email model.
class Email {
  final int id;
  final String sender;
  final String subject;
  final String preview;
  const Email(this.id, this.sender, this.subject, this.preview);
}

const _sampleEmails = [
  Email(1, 'Canvas', 'New assignment posted', 'Widget Presentation is due Oct 30...'),
  Email(2, 'GitHub', 'Your repo is public', 'dismissible_demo is now visible to...'),
  Email(3, 'Mom', 'Dinner on Sunday?', 'Let me know if you are coming home...'),
  Email(4, 'Spotify', 'Your weekly mix', 'New songs picked just for you...'),
  Email(5, 'Lecturer', 'Class moved to Room 4', 'Please note that tomorrow we...'),
  Email(6, 'Bank', 'Statement ready', 'Your monthly statement is available...'),
  Email(7, 'Study Group', 'Flutter practice', 'Shall we meet at the library at 3?'),
];

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final List<Email> _emails = List.of(_sampleEmails);

  // ---- The three properties we demo (start at Flutter's defaults) ----
  DismissDirection _direction = DismissDirection.horizontal; // default
  bool _showBackground = false; // default: background is null
  double _threshold = 0.4; // default dismissThreshold is 0.4 (40%)

  void _handleDismiss(Email email, int index, DismissDirection dir) {
    setState(() => _emails.removeAt(index));

    final archived = dir == DismissDirection.startToEnd;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${archived ? 'Archived' : 'Deleted'} "${email.subject}"'),
          action: SnackBarAction(
            label: 'UNDO',
            // Put the email back where it was.
            onPressed: () => setState(() => _emails.insert(index, email)),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        actions: [
          IconButton(
            tooltip: 'Reset inbox',
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {
              _emails
                ..clear()
                ..addAll(_sampleEmails);
            }),
          ),
          IconButton(
            tooltip: 'Tune Dismissible',
            icon: const Icon(Icons.tune),
            onPressed: _openControls,
          ),
        ],
      ),
      body: _emails.isEmpty
          ? const Center(child: Text('Inbox zero!', style: TextStyle(fontSize: 20)))
          : ListView.builder(
              itemCount: _emails.length,
              itemBuilder: (context, index) {
                final email = _emails[index];

                // ================= THE WIDGET =================
                return Dismissible(
                  // A unique key so Flutter knows which item was removed.
                  key: ValueKey(email.id),

                  // PROPERTY 1: which way the user is allowed to swipe.
                  direction: _direction,

                  // PROPERTY 2: what is revealed behind the item while swiping.
                  // background = swipe right, secondaryBackground = swipe left.
                  background: _showBackground
                      ? _swipeBackground(Colors.green, Icons.archive, 'Archive',
                          Alignment.centerLeft)
                      : null,
                  secondaryBackground: _showBackground
                      ? _swipeBackground(Colors.red, Icons.delete, 'Delete',
                          Alignment.centerRight)
                      : null,

                  // PROPERTY 3: how far (0.0 - 1.0 of the width) you must drag
                  // before letting go dismisses the item.
                  dismissThresholds: {
                    DismissDirection.startToEnd: _threshold,
                    DismissDirection.endToStart: _threshold,
                  },

                  // Called after the item has slid away.
                  onDismissed: (dir) => _handleDismiss(email, index, dir),

                  child: _EmailTile(email: email),
                );
                // ==============================================
              },
            ),
    );
  }

  /// Coloured strip with an icon + label shown behind a swiping item.
  Widget _swipeBackground(
      Color color, IconData icon, String label, Alignment align) {
    final isLeft = align == Alignment.centerLeft;
    return Container(
      color: color,
      alignment: align,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isLeft) Text(label, style: const TextStyle(color: Colors.white)),
          if (!isLeft) const SizedBox(width: 8),
          Icon(icon, color: Colors.white),
          if (isLeft) const SizedBox(width: 8),
          if (isLeft) Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  /// Bottom sheet used during the presentation to change properties live.
  void _openControls() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => StatefulBuilder(
        builder: (context, setSheet) {
          // Update both the sheet and the inbox behind it.
          void update(VoidCallback fn) {
            setSheet(fn);
            setState(() {});
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('1. direction',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SegmentedButton<DismissDirection>(
                  segments: const [
                    ButtonSegment(
                        value: DismissDirection.horizontal, label: Text('Both')),
                    ButtonSegment(
                        value: DismissDirection.startToEnd, label: Text('Right')),
                    ButtonSegment(
                        value: DismissDirection.endToStart, label: Text('Left')),
                    ButtonSegment(
                        value: DismissDirection.none, label: Text('None')),
                  ],
                  selected: {_direction},
                  onSelectionChanged: (s) => update(() => _direction = s.first),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('2. background / secondaryBackground',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(_showBackground ? 'Green / Red' : 'null (default)'),
                  value: _showBackground,
                  onChanged: (v) => update(() => _showBackground = v),
                ),
                const SizedBox(height: 8),
                Text('3. dismissThresholds: ${(_threshold * 100).round()}%',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Slider(
                  value: _threshold,
                  min: 0.1,
                  max: 0.9,
                  divisions: 8,
                  label: '${(_threshold * 100).round()}%',
                  onChanged: (v) => update(() => _threshold = v),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// One row in the inbox.
class _EmailTile extends StatelessWidget {
  const _EmailTile({required this.email});
  final Email email;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: ListTile(
        leading: CircleAvatar(child: Text(email.sender[0])),
        title: Text(email.sender, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${email.subject}\n${email.preview}',
            maxLines: 2, overflow: TextOverflow.ellipsis),
        isThreeLine: true,
      ),
    );
  }
}
