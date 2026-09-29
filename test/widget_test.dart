import 'package:flutter_test/flutter_test.dart';

import 'package:frontend_mobile/app/app.dart';

void main() {
  testWidgets('DevShow app loads', (tester) async {
    await tester.pumpWidget(const DevShowApp());

    expect(find.text('DevShow'), findsOneWidget);
  });
}
