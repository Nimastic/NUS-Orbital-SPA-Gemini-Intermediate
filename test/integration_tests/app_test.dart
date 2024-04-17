import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:orbital_spa/main.dart' as app;
import 'package:orbital_spa/services/notifications/notifications_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // Initialize the plugin
    NotifyHelper notifyHelper = NotifyHelper();

    await notifyHelper.initializeNotification();
  });

  group('Application Test', () {

    
    testWidgets('test', (tester) async {
      // Execute app main function
      await tester.pumpWidget(const app.HomePage());
      NotifyHelper notifyHelper = NotifyHelper();
      notifyHelper.requestIOSPermissions();

      // Wait until the app has settled
      await tester.pumpAndSettle();

      // Create finders
      final logInEmailFormField = find.byKey(const Key("Log In Email"));
      final logInPasswordFormField = find.byKey(const Key("Log In Password"));
      final forgotPasswordButton = find.byKey(const Key('Forgot Password Button'));
      final logInButton = find.byKey(const Key("Log In"));

      // Enter text or email address
      await tester.enterText(logInEmailFormField, "wong.jayee@gmail.com");
      await tester.enterText(logInPasswordFormField, "Test123");
      // Pump and settle if there are any changes in the ui
      await tester.pumpAndSettle();
      await tester.tap(logInButton);
      await tester.pumpAndSettle();
    });
  });
}