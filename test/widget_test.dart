
import 'package:flutter_test/flutter_test.dart';
import 'package:wonderspace/main.dart';

void main() {
  testWidgets('WonderSpace splash screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const WonderSpaceApp());

    // Check that the splash screen heading appears.
    expect(
      find.text('A WORLD OF LITTLE WONDERS'),
      findsOneWidget,
    );

    // Check that the tagline appears.
    expect(
      find.text('A little space for big imaginations.'),
      findsOneWidget,
    );

    // Check that the splash screen is displayed.
    expect(
      find.byType(WonderSpaceApp),
      findsOneWidget,
    );
  });
}
