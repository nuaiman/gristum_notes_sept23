import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'package:gristum_notes_app/models/stump_model.dart';

const uuid = Uuid();

class ProjectModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String note;
  final bool isActive;
  final bool isComplete;
  final bool isCancelled;
  final String address;
  final double latitude;
  final double longitude;
  DateTime? firstCallDate;
  DateTime? nextCallDate;
  final List<StumpModel> stumps;
  final int stumpsCount;
  final double totalCost;

  ProjectModel({
    String? id,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.note,
    this.isActive = true,
    this.isComplete = false,
    this.isCancelled = false,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.firstCallDate,
    required this.nextCallDate,
    required this.stumps,
    required this.stumpsCount,
    required this.totalCost,
  }) : id = id ?? uuid.v4();

  ProjectModel copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? note,
    bool? isActive,
    bool? isComplete,
    bool? isCancelled,
    String? address,
    double? latitude,
    double? longitude,
    DateTime? firstCallDate,
    DateTime? nextCallDate,
    List<StumpModel>? stumps,
    int? stumpsCount,
    double? totalCost,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      note: note ?? this.note,
      isActive: isActive ?? this.isActive,
      isComplete: isComplete ?? this.isComplete,
      isCancelled: isCancelled ?? this.isCancelled,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      firstCallDate: firstCallDate ?? this.firstCallDate,
      nextCallDate: nextCallDate ?? this.nextCallDate,
      stumps: stumps ?? this.stumps,
      stumpsCount: stumpsCount ?? this.stumpsCount,
      totalCost: totalCost ?? this.totalCost,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'customerName': customerName});
    result.addAll({'customerPhone': customerPhone});
    result.addAll({'customerEmail': customerEmail});
    result.addAll({'note': note});
    result.addAll({'isActive': isActive});
    result.addAll({'isComplete': isComplete});
    result.addAll({'isCancelled': isCancelled});
    result.addAll({'address': address});
    result.addAll({'latitude': latitude});
    result.addAll({'longitude': longitude});
    if (firstCallDate != null) {
      result.addAll({'firstCallDate': firstCallDate!.millisecondsSinceEpoch});
    }
    if (nextCallDate != null) {
      result.addAll({'nextCallDate': nextCallDate!.millisecondsSinceEpoch});
    }
    result.addAll({'stumps': stumps.map((x) => x.toMap()).toList()});
    result.addAll({'stumpsCount': stumpsCount});
    result.addAll({'totalCost': totalCost});

    return result;
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'] ?? '',
      customerName: map['customerName'] ?? '',
      customerPhone: map['customerPhone'] ?? '',
      customerEmail: map['customerEmail'] ?? '',
      note: map['note'] ?? '',
      isActive: map['isActive'] ?? false,
      isComplete: map['isComplete'] ?? false,
      isCancelled: map['isCancelled'] ?? false,
      address: map['address'] ?? '',
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      firstCallDate: map['firstCallDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['firstCallDate'])
          : null,
      nextCallDate: map['nextCallDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['nextCallDate'])
          : null,
      stumps: List<StumpModel>.from(
          map['stumps']?.map((x) => StumpModel.fromMap(x))),
      stumpsCount: map['stumpsCount']?.toInt() ?? 0,
      totalCost: map['totalCost']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectModel.fromJson(String source) =>
      ProjectModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProjectModel(id: $id, customerName: $customerName, customerPhone: $customerPhone, customerEmail: $customerEmail, note: $note, isActive: $isActive, isComplete: $isComplete, isCancelled: $isCancelled, address: $address, latitude: $latitude, longitude: $longitude, firstCallDate: $firstCallDate, nextCallDate: $nextCallDate, stumps: $stumps, stumpsCount: $stumpsCount, totalCost: $totalCost)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProjectModel &&
        other.id == id &&
        other.customerName == customerName &&
        other.customerPhone == customerPhone &&
        other.customerEmail == customerEmail &&
        other.note == note &&
        other.isActive == isActive &&
        other.isComplete == isComplete &&
        other.isCancelled == isCancelled &&
        other.address == address &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.firstCallDate == firstCallDate &&
        other.nextCallDate == nextCallDate &&
        listEquals(other.stumps, stumps) &&
        other.stumpsCount == stumpsCount &&
        other.totalCost == totalCost;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        customerName.hashCode ^
        customerPhone.hashCode ^
        customerEmail.hashCode ^
        note.hashCode ^
        isActive.hashCode ^
        isComplete.hashCode ^
        isCancelled.hashCode ^
        address.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        firstCallDate.hashCode ^
        nextCallDate.hashCode ^
        stumps.hashCode ^
        stumpsCount.hashCode ^
        totalCost.hashCode;
  }
}
