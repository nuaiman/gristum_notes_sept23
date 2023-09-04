import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cancelled_view.dart';
import 'completed_view.dart';
import 'projects_view.dart';
import 'settings_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final _views = const [
    ProjectsView(),
    CompletedView(),
    CancelledView(),
    SettingsView(),
  ];

  int _currentIndex = 0;

  void _onViewChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _views[_currentIndex],
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _onViewChange(index);
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(_currentIndex == 0
                  ? Icons.assignment
                  : Icons.assignment_outlined)),
          BottomNavigationBarItem(
              icon: Icon(_currentIndex == 1
                  ? Icons.assignment_turned_in
                  : Icons.assignment_turned_in_outlined)),
          BottomNavigationBarItem(
              icon: Icon(_currentIndex == 2
                  ? Icons.assignment_late
                  : Icons.assignment_late_outlined)),
          BottomNavigationBarItem(
              icon: Icon(_currentIndex == 3
                  ? Icons.settings
                  : Icons.settings_outlined)),
        ],
      ),
    );
  }
}
