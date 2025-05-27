import 'package:flutter/material.dart';

class NavigationService {
  bool showNotification = true;

  GlobalKey<NavigatorState>? _navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerStateKey =
      GlobalKey<ScaffoldMessengerState>();

  GlobalKey<ScaffoldMessengerState> get scaffoldMessengerState =>
      _scaffoldMessengerStateKey;

  ValueNotifier<String?> fcmTokenNotifier = ValueNotifier(null);

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey!;

  set navigatorKey(GlobalKey<NavigatorState> key) => _navigatorKey = key;
}
