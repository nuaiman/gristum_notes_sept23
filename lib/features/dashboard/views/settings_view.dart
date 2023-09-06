import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gristum_notes_app/features/dashboard/controllers/projects_controller.dart';
import 'package:gristum_notes_app/features/dashboard/controllers/settings_controller.dart';
import 'package:gristum_notes_app/models/project_model.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final project = ref.watch(projectsControllerProvider);
    final activeProjects =
        project.where((element) => element.isActive).toList();
    final completeProjects =
        project.where((element) => element.isComplete).toList();
    final cancelledProjects =
        project.where((element) => element.isCancelled).toList();
    // -------------------------------------------------------------------------
    int getTotalStumpCount(List<ProjectModel> projects) {
      int count = 0;
      for (ProjectModel project in projects) {
        count += project.stumpsCount;
      }
      return count;
    }

    double getTotalCostCount(List<ProjectModel> projects) {
      double total = 0;
      for (ProjectModel project in projects) {
        total += project.totalCost;
      }
      return total;
    }

    // -------------------------------------------------------------------------
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          Column(
            children: [
              const Text('Statistics'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(''),
                      Text('Active'),
                      Text('Completed'),
                      Text('Cancelled'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Notes'),
                      Text(activeProjects.length.toString()),
                      Text(completeProjects.length.toString()),
                      Text(cancelledProjects.length.toString()),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Stumps'),
                      Text(getTotalStumpCount(activeProjects).toString()),
                      Text(getTotalStumpCount(completeProjects).toString()),
                      Text(getTotalStumpCount(cancelledProjects).toString()),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Total \$'),
                      Text(
                          '\$ ${getTotalCostCount(activeProjects).toString()}'),
                      Text(
                          '\$ ${getTotalCostCount(completeProjects).toString()}'),
                      Text(
                          '\$ ${getTotalCostCount(cancelledProjects).toString()}'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                const Text('Calculation Factors'),
                ListTile(
                  title: const Text('Hight limit before percentage increase'),
                  trailing: SizedBox(
                    width: 80,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: ref
                                .watch(settingsControllerProvider)
                                .height
                                .toString(),
                            onChanged: (value) {
                              ref
                                  .watch(settingsControllerProvider.notifier)
                                  .updateHeightLimit(double.parse(value));
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              filled: true,
                            ),
                          ),
                        ),
                        const Text('  inch'),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Percentage increase beyond hight limit'),
                  trailing: SizedBox(
                    width: 80,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: ref
                                .watch(settingsControllerProvider)
                                .percent
                                .toString(),
                            onChanged: (value) {
                              ref
                                  .watch(settingsControllerProvider.notifier)
                                  .updatePercentLimit(double.parse(value));
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              filled: true,
                            ),
                          ),
                        ),
                        const Text('  %    '),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
