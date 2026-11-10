import 'package:flutter_test/flutter_test.dart';
import 'package:dismissible_demo/app.dart';

void main() {
  testWidgets('Swiping an email removes it and UNDO restores it',
      (tester) async {
    await tester.pumpWidget(const InboxApp());
    expect(find.text('Canvas'), findsOneWidget);

    await tester.drag(find.text('Canvas'), const Offset(-600, 0));
    await tester.pumpAndSettle();
    expect(find.text('Canvas'), findsNothing);

    await tester.tap(find.text('UNDO'));
    await tester.pumpAndSettle();
    expect(find.text('Canvas'), findsOneWidget);
  });
}
