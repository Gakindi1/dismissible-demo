import 'package:flutter/material.dart';

import '../models/email.dart';

/// One row in the inbox.
class EmailTile extends StatelessWidget {
  const EmailTile({super.key, required this.email});

  final Email email;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: ListTile(
        leading: CircleAvatar(child: Text(email.sender[0])),
        title: Text(email.sender, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${email.subject}\n${email.preview}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        isThreeLine: true,
      ),
    );
  }
}
