import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:the_movie_app/core/di/dependencies.dart';
import 'package:the_movie_app/data/datasources/local/cache_management/local_media_tracking_service.dart';
import 'package:the_movie_app/firebase_options.dart';

import 'presentation/my_app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalMediaTrackingService.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  setupDependencies();

  const app = MyApp();
  runApp(app);
}