class AppConstants {
  // App Info
  static const String appName = 'CARBAZAR';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.carbazar.com'; // Replace with actual API URL
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Pagination
  static const int pageSize = 20;
  static const int maxPageSize = 50;
  
  // Image Configuration
  static const int maxImageSizeMB = 10;
  static const int imageQuality = 85;
  static const int thumbnailQuality = 60;
  
  // Auction Configuration
  static const Duration auctionRefreshInterval = Duration(seconds: 2);
  static const Duration auctionWarningThreshold = Duration(minutes: 5);
  static const double minimumBidIncrement = 1000.0; // PKR
  
  // Cache Configuration
  static const Duration cacheValidDuration = Duration(hours: 24);
  static const int maxCacheSize = 100; // Number of items
  
  // Verification
  static const List<String> allowedDocumentTypes = ['jpg', 'jpeg', 'png', 'pdf'];
  static const int maxDocumentSizeMB = 5;
  
  // Chat
  static const int maxMessageLength = 500;
  static const Duration typingIndicatorTimeout = Duration(seconds: 3);
  
  // Notification Channels
  static const String notificationChannelId = 'carbazar_notifications';
  static const String notificationChannelName = 'CARBAZAR Notifications';
  static const String notificationChannelDescription = 'Receive updates about auctions, bids, and messages';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userRoleKey = 'user_role';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String themeKey = 'theme_mode';
  
  // Validation
  static const int minPasswordLength = 8;
  static const int otpLength = 6;
  static const Duration otpTimeout = Duration(minutes: 5);
  
  // Error Messages
  static const String networkErrorMessage = 'Network connection error. Please check your internet connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String unknownErrorMessage = 'An unknown error occurred. Please try again.';
  static const String sessionExpiredMessage = 'Your session has expired. Please login again.';
}

