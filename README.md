# high_q_notifications

A Flutter package that handles push notifications efficiently using Firebase Messaging
and local notifications. Supports background message handling, scheduling notifications,
and offers utilities for timezone management and dependency injection.

---

## Installation

Quickest way to add the package and enable CLI:

```bash
flutter pub add high_q_notifications
dart pub global activate high_q_notifications
dart run high_q_notifications:create
```

---

## Using the CLI tool

This package provides a **command line interface (CLI)** tool for setup and management.

You can run the CLI command directly in your project without global activation using:

```bash
dart run high_q_notifications:create
```

This will execute the notification setup process.

---

### (Optional) Using CLI globally

If you want to activate the CLI globally on your machine for easier access:

```bash
dart pub global activate high_q_notifications
```

Then you can run the CLI command as:

```bash
high_q_notifications:create
```

---

## Summary

| Use case                   | Command                                         |
|----------------------------|-------------------------------------------------|
| Add package to Flutter app | `flutter pub add high_q_notifications`          |
| Run CLI tool in project    | `dart run high_q_notifications:create`          |
| Activate CLI globally      | `dart pub global activate high_q_notifications` |

---
