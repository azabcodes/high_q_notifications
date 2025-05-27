# high_q_notifications

A Flutter package that handles push notifications efficiently using Firebase Messaging
and local notifications. Supports background message handling, scheduling notifications,
and offers utilities for timezone management and dependency injection.

<img src="https://github.com/user-attachments/assets/8ab2c12d-fb93-4a23-87a4-12ba9d6a4a9d" width="400" height="400"/>



---

## 🚀 Installation

Quickest way to add the package and enable the CLI:

```bash
flutter pub add high_q_notifications
dart pub global activate high_q_notifications
dart run high_q_notifications:setup_notifications
````

---

## 🛠️ What the CLI does

When you run the CLI tool:

```bash
dart run high_q_notifications:setup_notifications
```

It performs the following actions automatically:

* Creates essential notification-related files inside `lib/notification_service/`:

    * `configs/android_config.dart`
    * `configs/ios_config.dart`
    * `utils/navigation_service.dart`
    * `utils/handle_navigation.dart`
    * `utils/notifications_type.dart`
    * `exports.dart`
* Sets up a `main_copy.dart` file to demonstrate how to integrate `HighQNotifications` into your
  app.
* Ensures your project is ready to handle:

    * Firebase messages
    * Background taps
    * Local notifications

---

## 🔊 Custom Sound Support (Important)

To use custom notification sounds, you **must manually** add the sound files to the correct platform
folders:

### ✅ Android

* Place your `.mp3` sound file inside:

  ```
  android/app/src/main/res/raw/
  ```
* Example:

  ```
  android/app/src/main/res/raw/notification_sound.mp3
  ```

### ✅ iOS

* Place your `.caf` sound file inside:

  ```
  ios/Runner/Resources/
  ```


* Example:

  ```
  ios/Runner/Resources/notification_sound.caf
  ```

---

## 📦 Using the CLI tool

This package provides a **command line interface (CLI)** tool for setup and management.

Run the CLI command directly in your project:

```bash
dart run high_q_notifications:setup_notifications
```

---

### (Optional) Using CLI globally

To activate the CLI globally on your machine:

```bash
dart pub global activate high_q_notifications
```

Then use the command like this:

```bash
high_q_notifications:setup_notifications
```

---

## 📋 Summary

| Use case                   | Command                                             |
|----------------------------|-----------------------------------------------------|
| Add package to Flutter app | `flutter pub add high_q_notifications`              |
| Run CLI tool in project    | `dart run high_q_notifications:setup_notifications` |
| Activate CLI globally      | `dart pub global activate high_q_notifications`     |

---


