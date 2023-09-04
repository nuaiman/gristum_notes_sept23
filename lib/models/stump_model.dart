import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class StumpModel {
  final String id;
  final bool isBasic;
  final double width;
  final double height;
  final String note;
  final double price;
  final double cost;
  final List<String> imagesPath;

  StumpModel({
    String? id,
    this.isBasic = true,
    required this.width,
    required this.height,
    required this.note,
    required this.price,
    required this.cost,
    required this.imagesPath,
  }) : id = id ?? uuid.v4();

  StumpModel copyWith({
    String? id,
    bool? isBasic,
    double? width,
    double? height,
    String? note,
    double? price,
    double? cost,
    List<String>? imagesPath,
  }) {
    return StumpModel(
      id: id ?? this.id,
      isBasic: isBasic ?? this.isBasic,
      width: width ?? this.width,
      height: height ?? this.height,
      note: note ?? this.note,
      price: price ?? this.price,
      cost: cost ?? this.cost,
      imagesPath: imagesPath ?? this.imagesPath,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'isBasic': isBasic});
    result.addAll({'width': width});
    result.addAll({'height': height});
    result.addAll({'note': note});
    result.addAll({'price': price});
    result.addAll({'cost': cost});
    result.addAll({'imagesPath': imagesPath});

    return result;
  }

  factory StumpModel.fromMap(Map<String, dynamic> map) {
    return StumpModel(
      id: map['id'] ?? '',
      isBasic: map['isBasic'] ?? false,
      width: map['width']?.toDouble() ?? 0.0,
      height: map['height']?.toDouble() ?? 0.0,
      note: map['note'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      cost: map['cost']?.toDouble() ?? 0.0,
      imagesPath: List<String>.from(map['imagesPath']),
    );
  }

  String toJson() => json.encode(toMap());

  factory StumpModel.fromJson(String source) =>
      StumpModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StumpModel(id: $id, isBasic: $isBasic, width: $width, height: $height, note: $note, price: $price, cost: $cost, imagesPath: $imagesPath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StumpModel &&
        other.id == id &&
        other.isBasic == isBasic &&
        other.width == width &&
        other.height == height &&
        other.note == note &&
        other.price == price &&
        other.cost == cost &&
        listEquals(other.imagesPath, imagesPath);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        isBasic.hashCode ^
        width.hashCode ^
        height.hashCode ^
        note.hashCode ^
        price.hashCode ^
        cost.hashCode ^
        imagesPath.hashCode;
  }
}
