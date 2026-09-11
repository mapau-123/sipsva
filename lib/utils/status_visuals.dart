import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/risk_level.dart';
import '../models/road_condition.dart';
import '../models/timeline_event.dart';

extension RiskVisuals on RiskLevel {
  Color get color => switch (this) {
    RiskLevel.low => AppColors.safeGreen,
    RiskLevel.medium => AppColors.signalYellow,
    RiskLevel.high => AppColors.dangerRed,
  };

  IconData get icon => switch (this) {
    RiskLevel.low => Icons.verified_rounded,
    RiskLevel.medium => Icons.warning_amber_rounded,
    RiskLevel.high => Icons.crisis_alert_rounded,
  };
}

extension RoadConditionVisuals on RoadCondition {
  Color get color => switch (this) {
    RoadCondition.normal => AppColors.safeGreen,
    RoadCondition.congestion => AppColors.signalYellow,
    RoadCondition.obstruction => Colors.deepOrange,
    RoadCondition.smoke => AppColors.dangerRed,
  };

  IconData get icon => switch (this) {
    RoadCondition.normal => Icons.route_rounded,
    RoadCondition.congestion => Icons.traffic_rounded,
    RoadCondition.obstruction => Icons.block_rounded,
    RoadCondition.smoke => Icons.smoke_free_rounded,
  };
}

extension TimelineVisuals on TimelineEventType {
  Color get color => switch (this) {
    TimelineEventType.success => AppColors.safeGreen,
    TimelineEventType.rain => AppColors.blue,
    TimelineEventType.panel => AppColors.signalYellow,
    TimelineEventType.congestion => Colors.deepOrange,
    TimelineEventType.speed => AppColors.dangerRed,
    TimelineEventType.incident => Colors.deepPurple,
    TimelineEventType.smoke => AppColors.dangerRed,
    TimelineEventType.connection => AppColors.navy,
  };

  IconData get icon => switch (this) {
    TimelineEventType.success => Icons.check_circle_rounded,
    TimelineEventType.rain => Icons.water_drop_rounded,
    TimelineEventType.panel => Icons.signpost_rounded,
    TimelineEventType.congestion => Icons.traffic_rounded,
    TimelineEventType.speed => Icons.speed_rounded,
    TimelineEventType.incident => Icons.emergency_rounded,
    TimelineEventType.smoke => Icons.local_fire_department_rounded,
    TimelineEventType.connection => Icons.memory_rounded,
  };
}
