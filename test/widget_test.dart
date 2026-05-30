import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sas/app.dart';

void main() {
  testWidgets('landing page renders primary messaging', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SmartSchedulingApp(),
      ),
    );

    expect(find.text('Smart Academic Scheduling Platform'), findsOneWidget);
    expect(
      find.text('AI-Powered Timetable Management for Students, Faculty and Administrators'),
      findsOneWidget,
    );
    expect(find.text('Get Started'), findsWidgets);
    expect(find.text('Login'), findsWidgets);
  });

  testWidgets('login page route renders auth form', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SmartSchedulingApp(),
      ),
    );

    await tester.tap(find.text('Login').first);
    await tester.pumpAndSettle();

    expect(find.text('Welcome back to smarter campus scheduling'), findsOneWidget);
    expect(find.text('Student'), findsOneWidget);
    expect(find.text('Faculty'), findsOneWidget);
    expect(find.text('Admin'), findsNothing);
    expect(find.text('Forgot Password?'), findsOneWidget);
  });
}
