import 'dart:io';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:gristum_notes_app/models/stump_model.dart';
import 'package:location/location.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gristum_notes_app/core/utils.dart';
import 'package:gristum_notes_app/models/project_model.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../../services/notification_services.dart';
import '../controllers/projects_controller.dart';
import 'add_or_edit_stump_view.dart';
import 'video_player_view.dart';

class AddorEditProjectView extends ConsumerStatefulWidget {
  final ProjectModel? editableProject;
  const AddorEditProjectView({super.key, this.editableProject});

  @override
  ConsumerState<AddorEditProjectView> createState() => _AddProjectViewState();
}

class _AddProjectViewState extends ConsumerState<AddorEditProjectView> {
  final _formKey = GlobalKey<FormState>();

  int selectedTabIndex = 0;

  String _nameController = '';
  String _phoneController = '';
  String _emailController = '';
  String _noteController = '';
  double _latitude = 0;
  double _longitude = 0;
  String _addressController = '';

  DateTime? _firstCallDate;
  DateTime? _nextCallDate;

  List<StumpModel> _stumps = [];

  Future<void> getCurrentLocation(BuildContext context, WidgetRef ref) async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    Location location = Location();

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    List<geo.Placemark> placeList = await geo.placemarkFromCoordinates(
        locationData.latitude!, locationData.longitude!);

    setState(() {
      _latitude = locationData.latitude!;
      _longitude = locationData.longitude!;
      _addressController =
          '${placeList[0].street},${placeList[0].locality},${placeList[0].administrativeArea}-${placeList[0].postalCode}-${placeList[0].isoCountryCode}';
    });
  }

  @override
  void initState() {
    if (widget.editableProject != null) {
      if (widget.editableProject!.isCancelled == true) {
        setState(() {
          selectedTabIndex = 2;
        });
      } else if (widget.editableProject!.isCancelled == true &&
          widget.editableProject!.isComplete == true) {
        setState(() {
          selectedTabIndex = 2;
        });
      } else if (widget.editableProject!.isCancelled == false &&
          widget.editableProject!.isComplete == true) {
        setState(() {
          selectedTabIndex = 1;
        });
      } else {
        setState(() {
          selectedTabIndex = 0;
        });
      }

      _nameController = widget.editableProject!.customerName;
      _phoneController = widget.editableProject!.customerPhone;
      _emailController = widget.editableProject!.customerEmail;
      _noteController = widget.editableProject!.note;
      _firstCallDate =
          DateTime.parse(widget.editableProject!.firstCallDate.toString());
      _nextCallDate =
          DateTime.parse(widget.editableProject!.nextCallDate.toString());
      _latitude = widget.editableProject!.latitude;
      _longitude = widget.editableProject!.longitude;
      _addressController = widget.editableProject!.address;
      _stumps = widget.editableProject!.stumps;
    } else {
      getCurrentLocation(context, ref);
    }

    super.initState();
  }

  void addStumpToProject(StumpModel stump) {
    final stumpIsEdited = _stumps.any((element) => element.id == stump.id);
    if (stumpIsEdited == true) {
      setState(() {
        final stumpIndex =
            _stumps.indexWhere((element) => element.id == stump.id);
        _stumps.removeAt(stumpIndex);
        _stumps.insert(stumpIndex, stump);
      });
    } else {
      setState(() {
        _stumps.add(stump);
      });
    }
  }

  void saveProject() {
    if (_nameController.isEmpty) {
      showSnackbar(context, 'Must add a customer name');
      return;
    }
    if (_phoneController.isEmpty) {
      showSnackbar(context, 'Must add a customer phone number');
      return;
    }
    if (_stumps.isEmpty) {
      showSnackbar(context, 'Must add at least 1 stump');
      return;
    }

    double calculateTotalCost(List<StumpModel> stumpList) {
      double total = 0.0;
      for (StumpModel stump in stumpList) {
        total += stump.cost;
      }
      return total;
    }

    final project = widget.editableProject != null
        ? widget.editableProject!.copyWith(
            id: widget.editableProject!.id,
            customerName: _nameController,
            customerPhone: _phoneController,
            customerEmail: _emailController,
            note: _noteController,
            firstCallDate: _firstCallDate,
            nextCallDate: _nextCallDate,
            latitude: _latitude,
            longitude: _longitude,
            address: _addressController,
            stumps: _stumps,
            stumpsCount: _stumps.length,
            totalCost: calculateTotalCost(_stumps),
            isActive: selectedTabIndex == 0 ? true : false,
            isComplete: selectedTabIndex == 1 ? true : false,
            isCancelled: selectedTabIndex == 2 ? true : false,
          )
        : ProjectModel(
            customerName: _nameController,
            customerPhone: _phoneController,
            customerEmail: _emailController,
            note: _noteController,
            firstCallDate: _firstCallDate,
            nextCallDate: _nextCallDate,
            latitude: _latitude,
            longitude: _longitude,
            address: _addressController,
            stumps: _stumps,
            stumpsCount: _stumps.length,
            totalCost: calculateTotalCost(_stumps),
          );

    widget.editableProject != null
        ? ref.read(projectsControllerProvider.notifier).editProjects(project)
        : ref.read(projectsControllerProvider.notifier).addProject(project);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.editableProject != null ? 'Edit Project' : 'Add Project'),
        actions: [
          IconButton(
            onPressed: saveProject,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.editableProject != null)
                FlutterToggleTab(
                  marginSelected: const EdgeInsets.all(8),
                  borderRadius: 10,
                  selectedIndex: selectedTabIndex,
                  selectedTextStyle: const TextStyle(color: Colors.white),
                  unSelectedTextStyle: const TextStyle(color: Colors.black),
                  selectedBackgroundColors: [
                    selectedTabIndex == 0
                        ? Colors.blue
                        : selectedTabIndex == 1
                            ? Colors.green
                            : Colors.red
                  ],
                  unSelectedBackgroundColors: [Colors.grey[200]!],
                  labels: const ["Active", "Complete", "Cancelled"],
                  selectedLabelIndex: (index) {
                    setState(() {
                      setState(() {
                        selectedTabIndex = index;
                      });
                      // widget.onChanged(selectedTabIndex);
                    });
                  },
                ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                title: const Text('Name'),
                subtitle: TextFormField(
                  initialValue: _nameController,
                  onChanged: (value) {
                    setState(() {
                      _nameController = value;
                    });
                  },
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
                      subtitle: TextFormField(
                        initialValue: _phoneController,
                        onChanged: (value) {
                          setState(() {
                            _phoneController = value;
                          });
                        },
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
                      subtitle: TextFormField(
                        initialValue: _emailController,
                        onChanged: (value) {
                          setState(() {
                            _emailController = value;
                          });
                        },
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
                            final firstDate =
                                await DatePicker.showDateTimePicker(
                              context,
                              showTitleActions: true,
                              onChanged: (date) => _firstCallDate = date,
                              onConfirm: (date) {},
                            );
                            if (firstDate != null) {
                              setState(() {
                                _firstCallDate = firstDate;
                              });
                              NotificationService().scheduleNotification(
                                  title: 'Scheduled Notification',
                                  body: _nameController,
                                  scheduledNotificationDateTime: firstDate);
                            }
                          },
                          child: _firstCallDate != null
                              ? Text(DateFormat('d-MMM yy').format(
                                  DateTime.parse(_firstCallDate.toString())))
                              : const Text('Choose date'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: ListTile(
                        title: const Text('Next Call Date'),
                        subtitle: GestureDetector(
                          onTap: () async {
                            final nextDate =
                                await DatePicker.showDateTimePicker(
                              context,
                              showTitleActions: true,
                              onChanged: (date) => _nextCallDate = date,
                              onConfirm: (date) {},
                            );
                            if (nextDate != null) {
                              setState(() {
                                _nextCallDate = nextDate;
                              });
                              NotificationService().scheduleNotification(
                                  title: 'Scheduled Notification',
                                  body: _nameController,
                                  scheduledNotificationDateTime: nextDate);
                            }
                          },
                          child: _nextCallDate != null
                              ? Text(DateFormat('d-MMM yy').format(
                                  DateTime.parse(_nextCallDate.toString())))
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
                subtitle: TextFormField(
                  initialValue: _noteController,
                  onChanged: (value) {
                    setState(() {
                      _noteController = value;
                    });
                  },
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
                        child: _addressController.isEmpty
                            ? Image.network(
                                'https://imgcap.capturetheatlas.com/wp-content/uploads/2020/03/philadelphia-high-resolution-map-1415x540.jpg',
                                fit: BoxFit.cover,
                              )
                            : FlutterMap(
                                options: MapOptions(
                                  interactiveFlags: InteractiveFlag.none,
                                  center: LatLng(_latitude,
                                      _longitude), // Center of the map (San Francisco, CA)
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
                                        point: LatLng(_latitude, _longitude),
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
                          onPressed: () => getCurrentLocation(context, ref),
                          icon: const Icon(Icons.sync),
                          label: const Text('Update'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_addressController.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_addressController),
                  ),
                ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                title: const Text('Stumps'),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddorEditStumpView(
                          addStumpToProject: addStumpToProject,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                ),
              ),
              if (_stumps.isNotEmpty)
                SizedBox(
                  height: 400,
                  child: ListView.builder(
                    itemCount: _stumps.length,
                    itemBuilder: (context, index) {
                      final stump = _stumps[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height: 130,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('Width: ${stump.width} inch'),
                                          Text('Height: ${stump.height} inch'),
                                          Text('Cost: \$ ${stump.cost}'),
                                          widget.editableProject == null
                                              ? const SizedBox()
                                              : TextButton.icon(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddorEditStumpView(
                                                        addStumpToProject:
                                                            addStumpToProject,
                                                        editableStump: stump,
                                                      ),
                                                    ));
                                                  },
                                                  icon: const Icon(Icons.edit),
                                                  label:
                                                      const Text('Edit Stump'),
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
                                                  videoFile: File(stump
                                                      .videoPath
                                                      .toString()),
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
                                        itemBuilder: (context, index) =>
                                            GestureDetector(
                                          onTap: () {
                                            List<ImageProvider> listOfFiles =
                                                [];
                                            for (String i in stump.imagesPath) {
                                              listOfFiles.add(
                                                  Image.file(File(i)).image);
                                            }

                                            MultiImageProvider
                                                multiImageProvider =
                                                MultiImageProvider(listOfFiles);

                                            showImageViewerPager(
                                                context, multiImageProvider,
                                                swipeDismissible: true,
                                                doubleTapZoomable: true);
                                          },
                                          child: SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Image.file(
                                                File(stump.imagesPath[index]),
                                                fit: BoxFit.cover,
                                              ),
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
      ),
    );
  }
}
