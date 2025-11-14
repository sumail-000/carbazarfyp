# Firebase Setup Guide for CARBAZAR

This guide will help you configure Firebase for the CARBAZAR Flutter app.

## Prerequisites
- Google account
- Flutter project (already created)
- Android development environment

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click **"Add project"**
3. Enter project name: **CARBAZAR**
4. Enable/Disable Google Analytics (recommended: Enable)
5. Click **"Create project"**

## Step 2: Add Android App to Firebase

1. In Firebase Console, click **Android icon** or **"Add app"**
2. Enter Android package name: `com.carbazar.carbazar_app`
   - Find in: `android/app/build.gradle` → `applicationId`
3. Enter app nickname (optional): **CARBAZAR Android**
4. Enter SHA-1 certificate (required for Google Sign-in):
   ```bash
   # Get debug SHA-1
   cd android
   ./gradlew signingReport
   ```
   Copy the SHA-1 from the output
5. Click **"Register app"**

## Step 3: Download Configuration File

1. Download `google-services.json`
2. Place it in: `android/app/google-services.json`
3. **Important**: Add to `.gitignore` if not already there:
   ```
   **/android/app/google-services.json
   ```

## Step 4: Configure Android Project

### 4.1 Project-level build.gradle
File: `android/build.gradle`

```gradle
buildscript {
    dependencies {
        // Add this line
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

### 4.2 App-level build.gradle
File: `android/app/build.gradle`

Add at the bottom of the file:
```gradle
apply plugin: 'com.google.gms.google-services'
```

## Step 5: Enable Firebase Services

### 5.1 Authentication
1. In Firebase Console → **Authentication**
2. Click **"Get started"**
3. Enable sign-in methods:
   - ✅ **Google** (Enable)
   - ✅ **Phone** (Enable, configure test phone numbers if needed)
4. Add authorized domains if needed

### 5.2 Firestore Database
1. Go to **Firestore Database**
2. Click **"Create database"**
3. Choose **Start in test mode** (for development)
4. Select location: **asia-south1** (India) or nearest
5. Click **"Enable"**

### 5.3 Storage
1. Go to **Storage**
2. Click **"Get started"**
3. Start in **test mode**
4. Choose same location as Firestore
5. Click **"Done"**

### 5.4 Cloud Messaging (FCM)
1. Go to **Cloud Messaging**
2. Note your **Server key** for backend use
3. No additional configuration needed for client

### 5.5 Analytics (Optional but Recommended)
- Already enabled if you chose it during project creation
- No additional setup needed

## Step 6: Configure Flutter Dependencies

### 6.1 Update pubspec.yaml
Uncomment Firebase dependencies:

```yaml
dependencies:
  # Firebase
  firebase_core: ^2.24.0
  firebase_auth: ^4.16.0
  firebase_firestore: ^4.14.0
  firebase_storage: ^11.6.0
  firebase_messaging: ^14.7.10
  firebase_analytics: ^10.8.0
  google_sign_in: ^6.2.1
```

### 6.2 Install Dependencies
```bash
flutter pub get
```

## Step 7: Initialize Firebase in App

Update `lib/main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize other services
  await FirebaseService.initialize();
  await StorageService().initialize();
  
  runApp(const ProviderScope(child: CarbazarApp()));
}
```

Uncomment Firebase initialization in:
- `lib/src/core/services/firebase_service.dart`

## Step 8: Configure Firestore Security Rules

### 8.1 Development Rules (Test Mode)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.time < timestamp.date(2024, 12, 31);
    }
  }
}
```

### 8.2 Production Rules (Secure)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    
    // Listings collection
    match /listings/{listingId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null 
        && request.resource.data.sellerId == request.auth.uid;
      allow update, delete: if request.auth != null 
        && resource.data.sellerId == request.auth.uid;
    }
    
    // Auctions collection
    match /auctions/{auctionId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null 
        && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'seller';
    }
    
    // Bids collection
    match /bids/{bidId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null 
        && request.resource.data.bidderId == request.auth.uid;
    }
    
    // Chats collection
    match /chats/{chatId} {
      allow read, write: if request.auth != null 
        && request.auth.uid in resource.data.participants;
    }
    
    // Messages subcollection
    match /chats/{chatId}/messages/{messageId} {
      allow read: if request.auth != null 
        && request.auth.uid in get(/databases/$(database)/documents/chats/$(chatId)).data.participants;
      allow create: if request.auth != null;
    }
  }
}
```

## Step 9: Configure Storage Security Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    // Vehicle images
    match /vehicles/{userId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null 
        && request.auth.uid == userId
        && request.resource.size < 10 * 1024 * 1024  // 10MB limit
        && request.resource.contentType.matches('image/.*');
    }
    
    // User documents
    match /documents/{userId}/{allPaths=**} {
      allow read: if request.auth != null 
        && (request.auth.uid == userId || request.auth.token.admin == true);
      allow write: if request.auth != null 
        && request.auth.uid == userId
        && request.resource.size < 5 * 1024 * 1024;  // 5MB limit
    }
    
    // Chat attachments
    match /chat-attachments/{chatId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null 
        && request.resource.size < 10 * 1024 * 1024;
    }
  }
}
```

## Step 10: Create Firestore Collections

Create these collections in Firestore:

### Users Collection
```
users/
  {userId}/
    - id: string
    - email: string
    - displayName: string
    - phoneNumber: string
    - role: string (buyer/seller)
    - verificationStatus: string
    - createdAt: timestamp
```

### Listings Collection
```
listings/
  {listingId}/
    - id: string
    - title: string
    - description: string
    - price: number
    - images: array
    - sellerId: string
    - isAuction: boolean
    - createdAt: timestamp
```

### Auctions Collection
```
auctions/
  {auctionId}/
    - id: string
    - listingId: string
    - basePrice: number
    - currentBid: number
    - startTime: timestamp
    - endTime: timestamp
    - status: string
```

## Step 11: Test Firebase Connection

Create a test file: `lib/test_firebase.dart`

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_firestore/firebase_firestore.dart';

Future<void> testFirebase() async {
  await Firebase.initializeApp();
  
  // Test Firestore connection
  final db = FirebaseFirestore.instance;
  await db.collection('test').add({
    'message': 'Hello from CARBAZAR!',
    'timestamp': FieldValue.serverTimestamp(),
  });
  
  print('Firebase connection successful!');
}
```

Run:
```bash
flutter run
```

## Step 12: Configure Google Sign-In

### Android Configuration
1. In Firebase Console → **Authentication → Sign-in method**
2. Enable **Google**
3. Add SHA-1 certificate (already done in Step 2)
4. Download updated `google-services.json` if needed

### Get Web Client ID
1. Go to Firebase Console → **Project Settings**
2. Scroll to **Your apps** → Android app
3. Copy **Web client ID**
4. Use in Google Sign-In configuration:

```dart
final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
);
```

## Step 13: Environment-Specific Configuration

### Development vs Production
Create separate Firebase projects:
- `carbazar-dev` (Development)
- `carbazar-prod` (Production)

Use build flavors or environment files to switch between them.

## Step 14: Test All Services

### Test Authentication
```dart
// Test Google Sign-in
await GoogleAuthProvider().signInWithPopup();

// Test Phone Auth
await FirebaseAuth.instance.verifyPhoneNumber(
  phoneNumber: '+923001234567',
  // ... callbacks
);
```

### Test Firestore
```dart
// Write test
await FirebaseFirestore.instance.collection('test').add({
  'data': 'test',
});

// Read test
final snapshot = await FirebaseFirestore.instance
    .collection('test')
    .limit(1)
    .get();
```

### Test Storage
```dart
// Upload test
final ref = FirebaseStorage.instance.ref().child('test/image.jpg');
await ref.putFile(File('path/to/image.jpg'));

// Download URL
final url = await ref.getDownloadURL();
```

### Test FCM
Send a test notification from Firebase Console → Cloud Messaging

## Common Issues & Solutions

### Issue 1: Google Sign-In Fails
**Solution**: Ensure SHA-1 certificate is added and `google-services.json` is up to date

### Issue 2: Firestore Permission Denied
**Solution**: Check security rules, ensure user is authenticated

### Issue 3: FCM Not Receiving Notifications
**Solution**: 
- Check if FCM token is being generated
- Verify notification permissions
- Test with Firebase Console first

### Issue 4: Build Fails After Adding Firebase
**Solution**:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

## Production Checklist

Before going to production:

- [ ] Replace test security rules with production rules
- [ ] Set up Cloud Functions for backend logic
- [ ] Configure email/phone authentication properly
- [ ] Set up Firebase App Distribution for beta testing
- [ ] Enable crash reporting (Crashlytics)
- [ ] Set up backup strategy for Firestore
- [ ] Configure rate limiting and quotas
- [ ] Add monitoring and alerts
- [ ] Review and optimize security rules
- [ ] Test with production-like data

## Next Steps

1. Complete authentication flow implementation
2. Set up real-time listeners for auctions
3. Implement chat with Firestore
4. Configure push notifications
5. Test all flows end-to-end

## Resources

- [Firebase Flutter Documentation](https://firebase.google.com/docs/flutter/setup)
- [FlutterFire Plugins](https://firebase.flutter.dev)
- [Firebase Console](https://console.firebase.google.com)
- [Firebase YouTube Channel](https://www.youtube.com/c/Firebase)

---

**Need Help?**  
Contact: dev@carbazar.com  
Last Updated: November 2024

