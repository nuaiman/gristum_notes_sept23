import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gristum_notes_app/features/dashboard/controllers/notification_controller.dart';
import 'package:gristum_notes_app/features/dashboard/controllers/projects_controller.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/settings_controller.dart';
import 'add_or_edit_project_view.dart';

class ProjectsView extends ConsumerStatefulWidget {
  const ProjectsView({super.key});

  @override
  ConsumerState<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends ConsumerState<ProjectsView> {
  @override
  void initState() {
    ref.read(projectsControllerProvider.notifier).loadProjects();
    ref.read(settingsControllerProvider.notifier).loadSettings();
    ref.read(notificationControllerProvider.notifier).loadNotificationStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Active')),
      // -----------------------------------------------------------------------
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // NotificationService()
          //     .showNotification(title: 'Sample title', body: 'It works!');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddorEditProjectView(),
            ),
          );
        },
        label: const Text('Add Project'),
        icon: const Icon(Icons.add),
      ),
      // -----------------------------------------------------------------------
      body: ListView.builder(
        itemCount: ref
            .watch(projectsControllerProvider)
            .where((element) => element.isActive)
            .length,
        itemBuilder: (context, index) {
          final project = ref
              .watch(projectsControllerProvider)
              .where((element) => element.isActive)
              .toList()[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddorEditProjectView(
                  editableProject: project,
                ),
              ));
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(project.customerName),
                                Text(project.customerPhone),
                                const Divider(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    project.firstCallDate == null
                                        ? const Text('First Call : N/A')
                                        : Text(
                                            'First Call : ${DateFormat('d-MMM yy').format(DateTime.parse(project.firstCallDate.toString()))}'),
                                    project.firstCallDate == null
                                        ? const Text('')
                                        : Text(
                                            '(${DateTime.now().difference(project.firstCallDate!).inDays} Day)'),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    project.nextCallDate == null
                                        ? const Text('Next Call : N/A')
                                        : Text(
                                            'Next Call : ${DateFormat('d-MMM yy').format(DateTime.parse(project.nextCallDate.toString()))}'),
                                    project.firstCallDate == null
                                        ? const Text('')
                                        : Text(
                                            '(${DateTime.now().difference(project.nextCallDate!).inDays} Day)'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 132,
                              child: Image.file(
                                File(project.stumps[0].imagesPath[0]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 132,
                              child: FlutterMap(
                                options: MapOptions(
                                  interactiveFlags: InteractiveFlag.none,
                                  center: LatLng(
                                      project.latitude,
                                      project
                                          .longitude), // Center of the map (San Francisco, CA)
                                  zoom: 13.0, // Initial zoom level
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://{s}.google.com/vt/lyrs=m&h1={h1}&x={x}&y={y}&z={z}',
                                    additionalOptions: const {'h1': 'en'},
                                    subdomains: const [
                                      'mt0',
                                      'mt1',
                                      'mt2',
                                      'mt3',
                                    ],
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: LatLng(project.latitude,
                                            project.longitude),
                                        builder: (context) => const Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Text(
                      project.address,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${project.stumpsCount} Stumps'),
                        Text('\$ ${project.totalCost}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
