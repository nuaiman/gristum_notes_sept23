import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/dashboard/views/dashboard_view.dart';
import 'features/services/notification_services.dart';

import 'package:timezone/data/latest.dart' as tz;

void main() {
  // inside image_painter change address to package name (when changing)
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();
  runApp(const ProviderScope(child: GristumNotesApp()));
}

class GristumNotesApp extends StatelessWidget {
  const GristumNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gristum Notes',
      theme: ThemeData(useMaterial3: true),
      home: const DashboardView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
