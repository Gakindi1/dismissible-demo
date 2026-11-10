import 'package:flutter/widgets.dart';

/// The three Dismissible properties demoed in the app.
/// Defaults match Flutter's own defaults.
class DismissSettings {
  /// PROPERTY 1: which way the user is allowed to swipe.
  final DismissDirection direction;

  /// PROPERTY 2: whether to show a background behind a swiping item
  /// (Flutter's default is `null`, i.e. no background).
  final bool showBackground;

  /// PROPERTY 3: how far (0.0 - 1.0 of the width) you must drag before
  /// letting go dismisses the item. Flutter's default is 0.4 (40%).
  final double threshold;

  const DismissSettings({
    this.direction = DismissDirection.horizontal,
    this.showBackground = false,
    this.threshold = 0.4,
  });

  DismissSettings copyWith({
    DismissDirection? direction,
    bool? showBackground,
    double? threshold,
  }) {
    return DismissSettings(
      direction: direction ?? this.direction,
      showBackground: showBackground ?? this.showBackground,
      threshold: threshold ?? this.threshold,
    );
  }
}
