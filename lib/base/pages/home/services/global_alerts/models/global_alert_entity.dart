import 'package:equatable/equatable.dart';
import 'package:stadtnavi_core/base/custom_layers/services/models_otp/enums/alert_cause_type.dart';
import 'package:stadtnavi_core/base/custom_layers/services/models_otp/enums/alert_effect_type.dart';
import 'package:stadtnavi_core/base/custom_layers/services/models_otp/enums/alert_severity_level_type.dart';

class GlobalAlertEntity extends Equatable {
  final AlertCauseType? alertCause;
  final String alertDescriptionText;
  final AlertEffectType? alertEffect;
  final int? alertHash;
  final String? alertHeaderText;
  final AlertSeverityLevelType? alertSeverityLevel;
  final String? alertUrl;
  final DateTime? effectiveEndDate;
  final DateTime? effectiveStartDate;
  final String? feed;
  final String id;

  const GlobalAlertEntity({
    this.alertCause,
    required this.alertDescriptionText,
    this.alertEffect,
    this.alertHash,
    this.alertHeaderText,
    this.alertSeverityLevel,
    this.alertUrl,
    this.effectiveEndDate,
    this.effectiveStartDate,
    this.feed,
    required this.id,
  });

  factory GlobalAlertEntity.fromJson(Map<String, dynamic> json) {
    return GlobalAlertEntity(
      alertCause: getAlertCauseTypeByString(json['alertCause']),
      alertDescriptionText: json['alertDescriptionText'],
      alertEffect: getAlertEffectTypeByString(json['alertEffect']),
      alertHash: json['alertHash'],
      alertHeaderText: json['alertHeaderText'],
      alertSeverityLevel:
          getAlertSeverityLevelTypeByString(json['alertSeverityLevel']),
      alertUrl: json['alertUrl'],
      effectiveEndDate: json['effectiveEndDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              json['effectiveEndDate'] * 1000,
              isUtc: true,
            )
          : null,
      effectiveStartDate: json['effectiveStartDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              json['effectiveStartDate'] * 1000,
              isUtc: true,
            )
          : null,
      feed: json['feed'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alertCause': alertCause,
      'alertDescriptionText': alertDescriptionText,
      'alertEffect': alertEffect,
      'alertHash': alertHash,
      'alertHeaderText': alertHeaderText,
      'alertSeverityLevel': alertSeverityLevel,
      'alertUrl': alertUrl,
      'effectiveEndDate': effectiveEndDate,
      'effectiveStartDate': effectiveStartDate,
      'feed': feed,
      'id': id,
    };
  }

  @override
  List<Object?> get props => [alertHash];
}
