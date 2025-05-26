# high_q_notifications

A Flutter package that handles push notifications efficiently using Firebase Messaging
and local notifications. Supports background message handling, scheduling notifications,
and offers utilities for timezone management and dependency injection.

---

## Installation
Quickest way to add the package and enable cli  

```bash
flutter pub add high_q_notifications
dart pub global activate high_q_notifications
setup_notifications
```

### Add to your Flutter project

To add the package to your Flutter project, run:

```bash
flutter pub add high_q_notifications
```

Then import it in your Dart code and use it as needed.

---

### Using the CLI tool

This package also provides a **command line interface (CLI)** tool for setup and management.

To use the CLI globally on your machine, you need to activate it by running:

```bash
dart pub global activate high_q_notifications
```

After activation, you can run the CLI command:

```bash
setup_notifications
```

or simply:

```bash
setup_notifications
```

depending on your shell configuration.

---

## Summary

| Use case                   | Command                                         |
|----------------------------|-------------------------------------------------|
| Add package to Flutter app | `flutter pub add high_q_notifications`          |
| Use CLI tool globally      | `dart pub global activate high_q_notifications` |

---


dart pub publish --dry-run
dart pub publish
dart run ../bin/setup_notifications.dart
