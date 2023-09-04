import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/dashboard/views/dashboard_view.dart';

void main() {
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
