# Dismissible Demo

A small Flutter app that demonstrates the
[`Dismissible`](https://api.flutter.dev/flutter/widgets/Dismissible-class.html) widget
using a mock email inbox.

- **Swipe right** to archive an email, **swipe left** to delete it.
- Tap **UNDO** in the snackbar to restore it.
- Tap the **tune** icon in the app bar to change three `Dismissible` properties live:
  1. `direction`: which way you're allowed to swipe
  2. `background` / `secondaryBackground`: what shows behind the item while swiping
  3. `dismissThresholds`: how far you must drag before the item is dismissed
- Tap the **refresh** icon to reset the inbox.

## Project structure

```
lib/
├── main.dart                        # Entry point
├── app.dart                         # MaterialApp + theme
├── data/
│   └── sample_emails.dart           # Mock inbox data
├── models/
│   ├── email.dart                   # Email model
│   └── dismiss_settings.dart        # The 3 demoed Dismissible properties
├── screens/
│   └── inbox_screen.dart            # Inbox list + the Dismissible widget
└── widgets/
    ├── email_tile.dart              # One inbox row
    ├── swipe_background.dart        # Green/red strip shown while swiping
    └── dismiss_controls_sheet.dart  # Bottom sheet to tweak properties live
test/
└── widget_test.dart                 # Swipe-to-dismiss + undo test
```

## Running

```bash
flutter pub get
flutter run
```

## Testing

```bash
flutter test
```

## References

- [Dismissible class (API docs)](https://api.flutter.dev/flutter/widgets/Dismissible-class.html)
- [Implement swipe to dismiss (Flutter cookbook)](https://docs.flutter.dev/cookbook/gestures/dismissible)
