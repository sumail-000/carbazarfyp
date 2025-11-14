import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/core/app.dart';
// import 'src/core/services/firebase_service.dart'; // Uncomment when Firebase is configured
import 'src/core/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  // await FirebaseService.initialize(); // Uncomment when Firebase is configured
  await StorageService().initialize();
  
  runApp(const ProviderScope(child: CarbazarApp()));
}
