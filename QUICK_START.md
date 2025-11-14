# CARBAZAR - Quick Start Guide

## 🚀 Get Up and Running in 5 Minutes!

### What You Have
A **production-ready Flutter app foundation** with:
- ✅ Complete UI/UX design system
- ✅ Authentication flows (Login, OTP, Role selection)
- ✅ Home feed with vehicle cards
- ✅ Navigation system (5 tabs)
- ✅ Profile management
- ✅ All major screens scaffolded
- ✅ State management (Riverpod)
- ✅ Routing (GoRouter)

### Run the App NOW (No Firebase Required)

```bash
# 1. Navigate to the app directory
cd carbazar_app

# 2. Dependencies are already installed, but if needed:
flutter pub get

# 3. Run on connected device/emulator
flutter run

# 4. Or build APK
flutter build apk --release
```

The app will launch with **mock data** and fully functional UI!

### What You'll See

1. **Login Screen** - Beautiful onboarding with Google Sign-in button
2. **Role Selection** - Choose between Buyer or Seller
3. **Home Feed** - Browse vehicles with filters
4. **Bottom Navigation** - Switch between Home, Auctions, Wishlist, Inbox, Profile
5. **Profile Management** - View/edit user profile

### File Structure Overview

```
carbazar_app/lib/src/
├── core/                     # Foundation
│   ├── theme/               # Colors, typography ✅
│   ├── widgets/             # Reusable UI ✅
│   ├── router/              # Navigation ✅
│   └── services/            # Firebase, Storage ✅
├── common/models/           # Data models ✅
└── features/                # Feature modules
    ├── auth/               # Login, OTP, Role ✅
    ├── home/               # Feed, Discovery ✅
    ├── listings/           # Vehicle details 🔧
    ├── auctions/           # Live bidding 🔧
    ├── wishlist/           # Favorites 🔧
    ├── chat/               # Messaging 🔧
    ├── notifications/      # Push alerts 🔧
    └── profile/            # User management ✅

Legend: ✅ Ready | 🔧 Needs Implementation
```

### Key Files to Know

| File | Purpose | Status |
|------|---------|--------|
| `main.dart` | App entry point | ✅ |
| `core/app.dart` | Root widget | ✅ |
| `core/theme/app_theme.dart` | Styling | ✅ |
| `core/theme/app_colors.dart` | Color palette | ✅ |
| `core/router/app_router.dart` | All routes | ✅ |
| `features/home/home_screen.dart` | Main feed | ✅ |
| `common/models/*.dart` | Data structures | ✅ |

### Customization Quick Wins

#### 1. Change Brand Colors (2 minutes)
Edit `lib/src/core/theme/app_colors.dart`:

```dart
static const Color primary = Color(0xFF0D47A1);  // Your color
static const Color accent = Color(0xFFFFB300);   // Your accent
```

#### 2. Update App Name (1 minute)
- Android: `android/app/src/main/AndroidManifest.xml`
- Change `android:label="carbazar_app"` to your name

#### 3. Add Your Logo (3 minutes)
- Replace: `android/app/src/main/res/mipmap-*/ic_launcher.png`
- Use [Android Asset Studio](https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html)

### Next: Add Firebase (Optional, 20 minutes)

Follow **FIREBASE_SETUP_GUIDE.md** for:
1. Create Firebase project
2. Download `google-services.json`
3. Enable Authentication, Firestore, Storage
4. Uncomment Firebase code
5. Test authentication

### Development Workflow

```bash
# Hot reload during development
flutter run
# Press 'r' to hot reload
# Press 'R' to hot restart
# Press 'q' to quit

# Check for issues
flutter analyze

# Format code
flutter format lib/

# Run tests
flutter test

# Build release APK
flutter build apk --release
```

### Common Tasks

#### Add a New Screen

1. Create file: `lib/src/features/my_feature/presentation/screens/my_screen.dart`
2. Add route in `lib/src/core/router/app_router.dart`
3. Add constant in `lib/src/core/constants/route_constants.dart`

#### Add a New Model

1. Create: `lib/src/common/models/my_model.dart`
2. Add JSON serialization methods
3. Use in your features

#### Modify Navigation

Edit: `lib/src/features/home/presentation/screens/main_navigation_screen.dart`

### Useful Commands

```bash
# Clean build
flutter clean && flutter pub get

# Check outdated packages
flutter pub outdated

# Update packages
flutter pub upgrade

# Generate code (for Riverpod, etc.)
flutter pub run build_runner build

# Device info
flutter devices

# Check installation
flutter doctor
```

### Troubleshooting

#### App Won't Build
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

#### Hot Reload Not Working
- Press 'R' for full restart
- Or stop and run again

#### Missing Dependencies
```bash
flutter pub get
```

### What's Mock Data?

The app currently shows fake vehicles for testing. Real data will come from Firebase once configured.

**Mock data locations:**
- `home_screen.dart` - `_getMockAuctions()` and `_getMockListings()`

### Extending Features

#### Want to add a feature?
1. Check `CARBAZAR_PROJECT_SUMMARY.md` for architecture
2. Follow existing patterns in `features/` folder
3. Use Riverpod for state management
4. Follow the design system in `core/theme/`

#### Example: Add Seller Analytics Screen

```dart
// 1. Create screen
class SellerAnalyticsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Analytics')),
      body: Center(child: Text('Analytics Dashboard')),
    );
  }
}

// 2. Add route
GoRoute(
  path: '/analytics',
  builder: (context, state) => SellerAnalyticsScreen(),
)

// 3. Navigate
context.push('/analytics');
```

### Performance Tips

- ✅ Images are cached automatically (using `cached_network_image`)
- ✅ Use `const` constructors where possible
- ✅ Avoid rebuilding entire widgets
- ✅ Use Riverpod providers for data

### Design System

#### Spacing
```dart
AppTheme.spacing1  // 4px
AppTheme.spacing2  // 8px
AppTheme.spacing3  // 16px (most common)
AppTheme.spacing4  // 24px
```

#### Colors
```dart
AppColors.primary       // Deep Blue
AppColors.accent        // Amber
AppColors.success       // Green
AppColors.error         // Red
AppColors.verified      // For badges
```

#### Common Widgets
```dart
CustomButton(text: 'Click Me', onPressed: () {})
CustomTextField(hintText: 'Enter text')
VehicleCard(listing: myListing)
```

### Testing Your Changes

```bash
# 1. Save your code
# 2. Press 'r' in terminal (hot reload)
# 3. See changes instantly!
```

### Need Help?

1. **Documentation**: Check `CARBAZAR_PROJECT_SUMMARY.md`
2. **Firebase Setup**: See `FIREBASE_SETUP_GUIDE.md`
3. **PRD**: Read `carbazar-flutter-mvp-prd.md`
4. **Architecture**: See `carbazar-flutter-dev-plan.md`

### Ready to Code? 🎯

```bash
# Open in your favorite editor
code carbazar_app        # VS Code
# or
idea carbazar_app        # Android Studio
```

### Project Status

✅ **FOUNDATION COMPLETE**  
🚀 **READY FOR FEATURE DEVELOPMENT**  
⏱️ **6-8 WEEKS TO MVP** (with backend)

---

**That's it! You're ready to build CARBAZAR! 🚗💨**

Start with `flutter run` and explore the app.  
Then follow `FIREBASE_SETUP_GUIDE.md` to add real backend functionality.

Happy coding! 🎉

