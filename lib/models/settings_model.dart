import 'dart:convert';

class SettingsModel {
  final double height;
  final double percent;
  SettingsModel({
    required this.height,
    required this.percent,
  });

  SettingsModel copyWith({
    double? height,
    double? percent,
  }) {
    return SettingsModel(
      height: height ?? this.height,
      percent: percent ?? this.percent,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'height': height});
    result.addAll({'percent': percent});

    return result;
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      height: map['height']?.toDouble() ?? 0.0,
      percent: map['percent']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SettingsModel.fromJson(String source) =>
      SettingsModel.fromMap(json.decode(source));

  @override
  String toString() => 'SettingsModel(height: $height, percent: $percent)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SettingsModel &&
        other.height == height &&
        other.percent == percent;
  }

  @override
  int get hashCode => height.hashCode ^ percent.hashCode;
}
