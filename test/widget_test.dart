import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sas/app.dart';
import 'package:sas/core/network/api_client.dart';
import 'package:sas/core/network/api_providers.dart';

class FakeApiClient extends ApiClient {
  FakeApiClient();

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return {
      'access': 'test-access',
      'refresh': 'test-refresh',
      'user': {
        'email': email,
        'role': email.contains('faculty') ? 'faculty' : 'student',
      },
    };
  }
}

Widget _testApp() {
  return ProviderScope(
    overrides: [apiClientProvider.overrideWithValue(FakeApiClient())],
    child: const SmartSchedulingApp(),
  );
}

Future<void> _enterLoginCredentials(
  WidgetTester tester, {
  required String email,
}) async {
  await tester.enterText(find.byType(TextField).at(0), email);
  await tester.enterText(find.byType(TextField).at(1), 'password123');
}

void main() {
  testWidgets('landing page renders primary messaging', (tester) async {
    await tester.pumpWidget(_testApp());

    expect(find.text('Smart Sched'), findsWidgets);
    expect(
      find.text(
        'A clean timetable companion for students and faculty to view schedules, room changes, and academic alerts.',
      ),
      findsOneWidget,
    );
    expect(find.text('Get Started'), findsWidgets);
    expect(find.text('Login'), findsWidgets);
  });

  testWidgets('login page route renders auth form', (tester) async {
    await tester.pumpWidget(_testApp());

    await tester.tap(find.text('Login').first);
    await tester.pumpAndSettle();

    expect(find.text('Access your timetable'), findsOneWidget);
    expect(find.text('Student'), findsOneWidget);
    expect(find.text('Faculty'), findsOneWidget);
    expect(find.text('Admin'), findsNothing);
    expect(find.text('Forgot Password?'), findsOneWidget);
  });

  testWidgets('student login opens dashboard', (tester) async {
    await tester.pumpWidget(_testApp());

    await tester.tap(find.text('Login').first);
    await tester.pumpAndSettle();
    await _enterLoginCredentials(tester, email: 'student@university.edu');

    final loginButton = find.widgetWithText(FilledButton, 'Login');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('My Timetable'), findsOneWidget);
    expect(find.text("Today's Classes"), findsOneWidget);
    expect(find.text('Upcoming'), findsOneWidget);
    expect(find.text('Announcements'), findsOneWidget);
  });

  testWidgets('faculty login opens dashboard', (tester) async {
    await tester.pumpWidget(_testApp());

    await tester.tap(find.text('Login').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Faculty'));
    await tester.pumpAndSettle();
    await _enterLoginCredentials(tester, email: 'faculty@university.edu');

    final loginButton = find.widgetWithText(FilledButton, 'Login');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Teaching Timetable'), findsOneWidget);
    expect(find.text("Today's Classes"), findsOneWidget);
    expect(find.text('Upcoming Lectures'), findsOneWidget);
    expect(find.text('Requests Overview'), findsOneWidget);
  });

  testWidgets('student and faculty dashboards show logout action', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp());

    await tester.tap(find.text('Login').first);
    await tester.pumpAndSettle();
    await _enterLoginCredentials(tester, email: 'student@university.edu');
    var loginButton = find.widgetWithText(FilledButton, 'Login');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.byTooltip('Logout'), findsOneWidget);

    await tester.tap(find.byTooltip('Logout'));
    await tester.pumpAndSettle();
    expect(find.text('Smart Sched'), findsWidgets);

    await tester.tap(find.text('Login').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Faculty'));
    await tester.pumpAndSettle();
    await _enterLoginCredentials(tester, email: 'faculty@university.edu');
    loginButton = find.widgetWithText(FilledButton, 'Login');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.byTooltip('Logout'), findsOneWidget);
  });
}
