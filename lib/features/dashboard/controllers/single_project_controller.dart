import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gristum_notes_app/models/project_model.dart';
import 'package:gristum_notes_app/models/stump_model.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';

class SingleProjectController extends StateNotifier<ProjectModel> {
  SingleProjectController()
      : super(
          ProjectModel(
            customerName: '',
            customerPhone: '',
            customerEmail: '',
            note: '',
            latitude: 0,
            longitude: 0,
            firstCallDate: null,
            nextCallDate: null,
            address: '',
            stumps: [],
            stumpsCount: 0,
            totalCost: 0,
          ),
        );

  void clearState() {
    Future.delayed(const Duration(milliseconds: 1), () {
      state = ProjectModel(
        customerName: '',
        customerPhone: '',
        customerEmail: '',
        firstCallDate: null,
        nextCallDate: null,
        note: '',
        latitude: 0,
        longitude: 0,
        address: '',
        stumps: [],
        stumpsCount: 0,
        totalCost: 0,
      );
    });
  }

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

    state = state.copyWith(
        latitude: locationData.latitude,
        longitude: locationData.longitude,
        address:
            '${placeList[0].street},${placeList[0].locality},${placeList[0].administrativeArea}-${placeList[0].postalCode}-${placeList[0].isoCountryCode}');
  }

  void updateFirstDate(DateTime date) {
    state = state.copyWith(firstCallDate: date);
  }

  void updateNextDate(DateTime date) {
    state = state.copyWith(nextCallDate: date);
  }

  // void updateNextDate(DateTime date) {
  //   final newState = state.copyWith(nextCallDate: date);
  //   state = newState;
  // }

  void addStump(StumpModel stump) {
    state = state.copyWith(
      stumps: [...state.stumps, stump],
    );
  }
}
// -----------------------------------------------------------------------------

final singleProjectControllerProvider =
    StateNotifierProvider<SingleProjectController, ProjectModel>((ref) {
  return SingleProjectController();
});
