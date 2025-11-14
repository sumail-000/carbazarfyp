# CARBAZAR Flutter App

A modern automobile marketplace platform for buying and selling vehicles with live auction features.

## Features

### MVP Features (Implemented)
- ✅ **Authentication**
  - Google Sign-in
  - Phone OTP verification
  - Role selection (Buyer/Seller)
  - Verification status management

- ✅ **Home & Discovery**
  - Featured auctions carousel
  - Vehicle listings grid
  - Filter by brand, city, price
  - Search functionality
  - Pull-to-refresh

- ✅ **Vehicle Cards**
  - High-quality images
  - Verification badges
  - Live auction indicators
  - Favorite/wishlist button
  - Price formatting

- ✅ **Profile Management**
  - User profile with verification status
  - Edit profile
  - Settings & preferences
  - Logout functionality

- ✅ **Navigation**
  - Bottom navigation with 5 tabs
  - Smooth page transitions
  - Deep linking support

### Upcoming Features
- 🔄 **Auctions** (In Progress)
  - Live bidding room
  - Real-time countdown timer
  - Bid history
  - Winner announcements

- 🔄 **Listing Details** (In Progress)
  - Image gallery with zoom
  - Vehicle specifications
  - Seller information
  - Document verification
  - Contact seller buttons

- 🔄 **Wishlist** (In Progress)
  - Offline-first caching
  - Quick access to favorites
  - Sync across devices

- 🔄 **Chat** (In Progress)
  - Real-time messaging
  - Call/Map deep links
  - Message moderation

- 🔄 **Notifications** (In Progress)
  - Push notifications (FCM)
  - In-app notification center
  - Deep linking from notifications

## Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Backend**: Firebase (Auth, Firestore, Storage, FCM)
- **Local Storage**: Shared Preferences, Secure Storage, Hive
- **HTTP Client**: Dio
- **UI Components**: Material Design 3

## Getting Started

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Android Studio / VS Code
- Android SDK (minSdkVersion 24)
- Firebase project configured

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd carbazar_app
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
   - Download `google-services.json` from Firebase Console
   - Place it in `android/app/` directory
   - Update Firebase configuration in code

4. Run the app
```bash
flutter run
```

### Build for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release
```

## Project Structure

```
lib/
├── src/
│   ├── common/
│   │   └── models/          # Shared data models
│   ├── core/
│   │   ├── constants/       # App constants
│   │   ├── router/          # Navigation configuration
│   │   ├── services/        # Core services (Firebase, Storage)
│   │   ├── theme/           # Theme & styling
│   │   └── widgets/         # Reusable widgets
│   └── features/
│       ├── auth/            # Authentication
│       ├── home/            # Home feed
│       ├── listings/        # Vehicle listings
│       ├── auctions/        # Auction functionality
│       ├── wishlist/        # Favorites
│       ├── chat/            # Messaging
│       ├── notifications/   # Notifications
│       └── profile/         # User profile
└── main.dart
```

## Design System

### Colors
- **Primary**: Deep Blue (#0D47A1)
- **Accent**: Amber (#FFB300)
- **Success**: Green (#4CAF50)
- **Error**: Red (#EF5350)

### Spacing (8pt Grid)
- spacing1: 4px
- spacing2: 8px
- spacing3: 16px
- spacing4: 24px
- spacing5: 32px
- spacing6: 48px

### Typography
- Font Family: Inter (via Google Fonts)
- Contrast ratio: Minimum 4.5:1 for accessibility

## Development Guidelines

### Code Style
- Follow official Dart style guide
- Use `flutter_lints` for code quality
- Document public APIs
- Write widget tests for critical UI

### State Management
- Use Riverpod providers for business logic
- Keep UI logic separate from business logic
- Use ConsumerWidget/ConsumerStatefulWidget

### Naming Conventions
- Files: snake_case.dart
- Classes: PascalCase
- Variables/Functions: camelCase
- Constants: SCREAMING_SNAKE_CASE

## Firebase Configuration

### Required Services
1. **Authentication**
   - Google Sign-in
   - Phone Authentication

2. **Firestore Database**
   - Collections: users, listings, auctions, chats, notifications

3. **Cloud Storage**
   - Vehicle images
   - User documents
   - Chat attachments

4. **Cloud Messaging (FCM)**
   - Push notifications for auctions
   - Bid updates
   - Chat messages

### Security Rules
Ensure proper Firestore security rules are configured to restrict read/write access based on user authentication and roles.

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Widget tests
flutter test test/widget_test.dart
```

## Performance Targets

- Home feed render: < 1.5s on 4G
- Auction updates: < 2s latency
- Crash-free sessions: ≥ 99%
- Image upload limit: 10MB per file

## Contributing

1. Create a feature branch
2. Make your changes
3. Write tests
4. Submit a pull request

## License

Copyright © 2024 CARBAZAR. All rights reserved.

## Support

For issues and questions:
- Email: support@carbazar.com
- Documentation: [Link to docs]

---

**Version**: 1.0.0  
**Last Updated**: November 2024  
**Platform**: Android (iOS coming soon)
