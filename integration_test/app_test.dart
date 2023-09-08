import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../lib/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
        (tester) async {
      // Load app widget.
      await tester.pumpWidget(const MyApp());

      // Verify the counter starts at 0.
      expect(find.text('0'), findsOneWidget);

      // Finds the floating action button Login to tap on.
      final Finder fab = find.byTooltip('Login');

      // Emulate a tap on the button login.
      await tester.tap(fab);

      // Finds the floating action button Get started to tap on.
      final Finder fab1 = find.byTooltip('Get started');

      // Emulate a tap on the button Get started.
      await tester.tap(fab1);

      // Trigger a frame.
      await tester.pumpAndSettle();

      // Verify the counter increments by 1.
      expect(find.text('1'), findsOneWidget);
    });
  });
}
