import 'dart:convert';

class NotificationModel {
  bool allowed;
  bool twoDays;
  bool oneDay;
  bool oneHour;
  NotificationModel({
    required this.allowed,
    required this.twoDays,
    required this.oneDay,
    required this.oneHour,
  });

  NotificationModel copyWith({
    bool? allowed,
    bool? twoDays,
    bool? oneDay,
    bool? oneHour,
  }) {
    return NotificationModel(
      allowed: allowed ?? this.allowed,
      twoDays: twoDays ?? this.twoDays,
      oneDay: oneDay ?? this.oneDay,
      oneHour: oneHour ?? this.oneHour,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'allowed': allowed});
    result.addAll({'twoDays': twoDays});
    result.addAll({'oneDay': oneDay});
    result.addAll({'oneHour': oneHour});

    return result;
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      allowed: map['allowed'] ?? false,
      twoDays: map['twoDays'] ?? false,
      oneDay: map['oneDay'] ?? false,
      oneHour: map['oneHour'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NotificationModel(allowed: $allowed, twoDays: $twoDays, oneDay: $oneDay, oneHour: $oneHour)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationModel &&
        other.allowed == allowed &&
        other.twoDays == twoDays &&
        other.oneDay == oneDay &&
        other.oneHour == oneHour;
  }

  @override
  int get hashCode {
    return allowed.hashCode ^
        twoDays.hashCode ^
        oneDay.hashCode ^
        oneHour.hashCode;
  }
}
