# ProСвітло 🔌⚡

Mobile application for monitoring electricity outages in Khmelnytskyi region, Ukraine.


## About

ProСвітло is a Flutter application that helps users track electricity status based on their address. The app provides:

- 📍 Electricity status for specific addresses
- 📅 Weekly outage schedule
- 🔔 Notifications about schedule changes
- ⚡ Real-time power status
- 🌓 Light and dark theme support

## Tech Stack

- **Architecture**: MVVM (Model-View-ViewModel)
- **State Management**: Cubit (flutter_bloc)
- **Navigation**: GoRouter
- **Local Storage**: SharedPreferences
- **Language**: Dart
- **Framework**: Flutter 3.x

## Quick Start

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Build for production
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

## Features

- ✅ Onboarding screen
- ✅ Address selection and storage
- ✅ Current power status display
- ✅ Weekly outage schedule
- ✅ Notifications list
- ✅ Settings (theme, notifications)
- ✅ Light/Dark theme
- ✅ Bottom navigation

## Project Structure

```
lib/
├── core/           # Theme, router, widgets, utils
├── data/           # Models, repositories, services
├── domain/         # Entities, use cases
├── presentation/   # UI screens with MVVM
├── app.dart        # App configuration
└── main.dart       # Entry point
```

## Requirements

- Flutter SDK 3.9.2+
- Dart SDK 3.9.2+
- Android SDK 21+ (Android 5.0+)
- iOS 12.0+

## License

[Specify license]

## Support

For questions and suggestions, please create an issue in the repository.
