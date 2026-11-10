import 'package:flutter/material.dart';

import '../data/sample_emails.dart';
import '../models/dismiss_settings.dart';
import '../models/email.dart';
import '../widgets/dismiss_controls_sheet.dart';
import '../widgets/email_tile.dart';
import '../widgets/swipe_background.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final List<Email> _emails = List.of(sampleEmails);

  // The three properties we demo (start at Flutter's defaults).
  DismissSettings _settings = const DismissSettings();

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
            // Put the email back where it was (clamped in case the list changed).
            onPressed: () => setState(
              () => _emails.insert(index.clamp(0, _emails.length), email),
            ),
          ),
        ),
      );
  }

  void _resetInbox() {
    setState(() {
      _emails
        ..clear()
        ..addAll(sampleEmails);
    });
  }

  void _openControls() {
    showDismissControls(
      context,
      settings: _settings,
      onChanged: (s) => setState(() => _settings = s),
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
            onPressed: _resetInbox,
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
              itemBuilder: (context, index) => _buildDismissible(_emails[index], index),
            ),
    );
  }

  // ================= THE WIDGET =================
  Widget _buildDismissible(Email email, int index) {
    return Dismissible(
      // A unique key so Flutter knows which item was removed.
      key: ValueKey(email.id),

      // PROPERTY 1: which way the user is allowed to swipe.
      direction: _settings.direction,

      // PROPERTY 2: what is revealed behind the item while swiping.
      // background = swipe right, secondaryBackground = swipe left.
      background: _settings.showBackground
          ? const SwipeBackground(
              color: Colors.green,
              icon: Icons.archive,
              label: 'Archive',
              alignment: Alignment.centerLeft,
            )
          : null,
      secondaryBackground: _settings.showBackground
          ? const SwipeBackground(
              color: Colors.red,
              icon: Icons.delete,
              label: 'Delete',
              alignment: Alignment.centerRight,
            )
          : null,

      // PROPERTY 3: how far (0.0 - 1.0 of the width) you must drag
      // before letting go dismisses the item.
      dismissThresholds: {
        DismissDirection.startToEnd: _settings.threshold,
        DismissDirection.endToStart: _settings.threshold,
      },

      // Called after the item has slid away.
      onDismissed: (dir) => _handleDismiss(email, index, dir),

      child: EmailTile(email: email),
    );
  }
  // ==============================================
}
