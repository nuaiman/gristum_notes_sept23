import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class StumpModel {
  final String id;
  final double width;
  final double height;
  final String note;
  final double price;
  final double cost;
  final List<String> imagesPath;
  final String? videoPath;

  StumpModel({
    String? id,
    required this.width,
    required this.height,
    required this.note,
    required this.price,
    required this.cost,
    required this.imagesPath,
    this.videoPath,
  }) : id = id ?? uuid.v4();

  StumpModel copyWith({
    String? id,
    double? width,
    double? height,
    String? note,
    double? price,
    double? cost,
    List<String>? imagesPath,
    String? videoPath,
  }) {
    return StumpModel(
      id: id ?? this.id,
      width: width ?? this.width,
      height: height ?? this.height,
      note: note ?? this.note,
      price: price ?? this.price,
      cost: cost ?? this.cost,
      imagesPath: imagesPath ?? this.imagesPath,
      videoPath: videoPath ?? this.videoPath,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'width': width});
    result.addAll({'height': height});
    result.addAll({'note': note});
    result.addAll({'price': price});
    result.addAll({'cost': cost});
    result.addAll({'imagesPath': imagesPath});
    if (videoPath != null) {
      result.addAll({'videoPath': videoPath});
    }

    return result;
  }

  factory StumpModel.fromMap(Map<String, dynamic> map) {
    return StumpModel(
      id: map['id'] ?? '',
      width: map['width']?.toDouble() ?? 0.0,
      height: map['height']?.toDouble() ?? 0.0,
      note: map['note'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      cost: map['cost']?.toDouble() ?? 0.0,
      imagesPath: List<String>.from(map['imagesPath']),
      videoPath: map['videoPath'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StumpModel.fromJson(String source) =>
      StumpModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StumpModel(id: $id, width: $width, height: $height, note: $note, price: $price, cost: $cost, imagesPath: $imagesPath, videoPath: $videoPath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StumpModel &&
        other.id == id &&
        other.width == width &&
        other.height == height &&
        other.note == note &&
        other.price == price &&
        other.cost == cost &&
        listEquals(other.imagesPath, imagesPath) &&
        other.videoPath == videoPath;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        width.hashCode ^
        height.hashCode ^
        note.hashCode ^
        price.hashCode ^
        cost.hashCode ^
        imagesPath.hashCode ^
        videoPath.hashCode;
  }
}
