import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:high_q_notifications/high_q_notifications.dart';
import 'firebase_options.dart';
import 'notification_service/exports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    if (kDebugMode) {
      print(error);
    }
  }
  runApp(
    HighQNotifications(
      requestPermissionsOnInitialize: true,
      localNotificationsConfiguration: HighQConfigurationModel(
        androidConfig: androidConfig,
        iosConfig: iosConfig,
      ),
      shouldHandleNotification: (_) => true,
      onOpenNotificationArrive: (_) {},
      onTap: HandleNotificationsNavigation.handleNotificationTap,
      onAction: HandleNotificationsActions.handleAction,
      onFcmTokenInitialize: (token) {
        NavigationService().fcmTokenNotifier.value = token;
      },
      onFcmTokenUpdate: (token) {
        NavigationService().fcmTokenNotifier.value = token;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService().navigatorKey,
        scaffoldMessengerKey: NavigationService().scaffoldMessengerState,
        home: HomePage(),
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String _topic = 'First';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('High Q Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildButton(
              label: 'Subscribe to Topic',
              onPressed: () {
                HighQNotifications.subscribeToTopic(topic: _topic);
              },
            ),
            _buildButton(
              label: 'Unsubscribe from Topic',
              onPressed: () {
                HighQNotifications.unsubscribeFromTopic(topic: _topic);
              },
            ),
            _buildButton(
              label: 'Subscribe to Topics',
              onPressed: () {
                HighQNotifications.subscribeToTopics(topics: [_topic]);
              },
            ),
            _buildButton(
              label: 'Unsubscribe from Topics',
              onPressed: () {
                HighQNotifications.unsubscribeFromTopics(topics: [_topic]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return MaterialButton(
      color: Colors.black,
      minWidth: double.infinity,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}

