import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gristum_notes_app/core/utils.dart';
import 'package:gristum_notes_app/features/dashboard/controllers/projects_controller.dart';
import 'package:gristum_notes_app/features/dashboard/controllers/single_project_controller.dart';
import 'package:gristum_notes_app/models/project_model.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'add_stump_view.dart';
import 'video_player_view.dart';

class AddProjectView extends ConsumerStatefulWidget {
  const AddProjectView({super.key});

  @override
  ConsumerState<AddProjectView> createState() => _AddProjectViewState();
}

class _AddProjectViewState extends ConsumerState<AddProjectView> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    ref.read(singleProjectControllerProvider.notifier).clearState();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    ref
        .read(singleProjectControllerProvider.notifier)
        .getCurrentLocation(context, ref);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void saveProject() {
    if (_nameController.text.isEmpty) {
      showSnackbar(context, 'Must add a customer name');
      return;
    }
    if (_phoneController.text.isEmpty) {
      showSnackbar(context, 'Must add a customer phone number');
      return;
    }
    if (ref.read(singleProjectControllerProvider).stumps.isEmpty) {
      showSnackbar(context, 'Must add at least 1 stump');
      return;
    }
    final project = ProjectModel(
      customerName: _nameController.text,
      customerPhone: _phoneController.text,
      customerEmail: _emailController.text,
      note: _noteController.text,
      firstCallDate: ref.read(singleProjectControllerProvider).firstCallDate,
      nextCallDate: ref.read(singleProjectControllerProvider).nextCallDate,
      latitude: ref.read(singleProjectControllerProvider).latitude,
      longitude: ref.read(singleProjectControllerProvider).longitude,
      address: ref.read(singleProjectControllerProvider).address,
      stumps: ref.read(singleProjectControllerProvider).stumps,
      stumpsCount: ref.read(singleProjectControllerProvider).stumps.length,
      totalCost:
          ref.read(singleProjectControllerProvider).stumps.length.toDouble(),
    );

    ref.read(projectsControllerProvider.notifier).addProject(project);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final project = ref.watch(singleProjectControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project'),
        actions: [
          IconButton(
            onPressed: saveProject,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              title: const Text('Name'),
              subtitle: TextField(
                controller: _nameController,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                minLines: 1,
                maxLines: 10,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    title: const Text('Phone'),
                    subtitle: TextField(
                      controller: _phoneController,
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus!.unfocus();
                      },
                      minLines: 1,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    title: const Text('Email'),
                    subtitle: TextField(
                      controller: _emailController,
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus!.unfocus();
                      },
                      minLines: 1,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: const Text('First Call Date'),
                      subtitle: GestureDetector(
                        onTap: () async {
                          final firstDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(3022),
                          );
                          if (firstDate != null) {
                            ref
                                .read(singleProjectControllerProvider.notifier)
                                .updateFirstDate(firstDate);
                          }
                        },
                        child: project.firstCallDate != null
                            ? Text(DateFormat('d-MMM yy').format(DateTime.parse(
                                project.firstCallDate.toString())))
                            : const Text('Choose date'),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: const Text('First Call Date'),
                      subtitle: GestureDetector(
                        onTap: () async {
                          final nextDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(3022),
                          );
                          if (nextDate != null) {
                            ref
                                .read(singleProjectControllerProvider.notifier)
                                .updateNextDate(nextDate);
                          }
                        },
                        child: project.nextCallDate != null
                            ? Text(DateFormat('d-MMM yy').format(DateTime.parse(
                                project.nextCallDate.toString())))
                            : const Text('Choose date'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              title: const Text('Note'),
              subtitle: TextField(
                controller: _noteController,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                minLines: 1,
                maxLines: 10,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Card(
              child: Stack(
                children: [
                  SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: project.address.isEmpty
                          ? Image.network(
                              'https://imgcap.capturetheatlas.com/wp-content/uploads/2020/03/philadelphia-high-resolution-map-1415x540.jpg',
                              fit: BoxFit.cover,
                            )
                          : FlutterMap(
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
                                      point: LatLng(
                                          project.latitude, project.longitude),
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
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Card(
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.sync),
                        label: const Text('Update'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (project.address.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(project.address),
                ),
              ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              title: const Text('Stumps'),
              trailing: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddStumpView(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ),
            SizedBox(
              height: 400,
              child: ListView.builder(
                itemCount: project.stumps.length,
                itemBuilder: (context, index) {
                  final stump = project.stumps[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 130,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(stump.imagesPath[0]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height: 130,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Width: ${stump.width} inch'),
                                      Text('Height: ${stump.height} inch'),
                                      Text('Cost: \$ ${stump.cost}'),
                                      TextButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(Icons.edit),
                                        label: const Text('Edit Stump'),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              if (stump.videoPath != '')
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  height: 60,
                                  width: 60,
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VideoPlayerView(
                                              videoFile: File(
                                                  stump.videoPath.toString()),
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.play_arrow)),
                                ),
                              Expanded(
                                child: SizedBox(
                                  height: 60,
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(width: 5),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: stump.imagesPath.length,
                                    itemBuilder: (context, index) => SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.file(
                                          File(stump.imagesPath[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
