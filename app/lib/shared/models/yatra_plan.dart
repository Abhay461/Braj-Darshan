class YatraPlan {
  final String id;
  final String templeId;
  final String templeName;
  final DateTime plannedDate;
  final String openingTime;
  final String closingTime;
  final String notes;
  final String reminderOption; // '30_mins' | '1_hour' | 'both' | 'none'
  final bool oneDayBeforeReminder;
  final bool isCompleted;
  final DateTime createdAt;

  YatraPlan({
    required this.id,
    required this.templeId,
    required this.templeName,
    required this.plannedDate,
    this.openingTime = '',
    this.closingTime = '',
    this.notes = '',
    this.reminderOption = '30_mins',
    this.oneDayBeforeReminder = true,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  YatraPlan copyWith({
    String? id,
    String? templeId,
    String? templeName,
    DateTime? plannedDate,
    String? openingTime,
    String? closingTime,
    String? notes,
    String? reminderOption,
    bool? oneDayBeforeReminder,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return YatraPlan(
      id: id ?? this.id,
      templeId: templeId ?? this.templeId,
      templeName: templeName ?? this.templeName,
      plannedDate: plannedDate ?? this.plannedDate,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
      notes: notes ?? this.notes,
      reminderOption: reminderOption ?? this.reminderOption,
      oneDayBeforeReminder: oneDayBeforeReminder ?? this.oneDayBeforeReminder,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'templeId': templeId,
      'templeName': templeName,
      'plannedDate': plannedDate.toIso8601String(),
      'openingTime': openingTime,
      'closingTime': closingTime,
      'notes': notes,
      'reminderOption': reminderOption,
      'oneDayBeforeReminder': oneDayBeforeReminder,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory YatraPlan.fromJson(Map<String, dynamic> json) {
    return YatraPlan(
      id: json['id'] ?? '',
      templeId: json['templeId'] ?? '',
      templeName: json['templeName'] ?? '',
      plannedDate: DateTime.tryParse(json['plannedDate']?.toString() ?? '') ?? DateTime.now(),
      openingTime: json['openingTime'] ?? '',
      closingTime: json['closingTime'] ?? '',
      notes: json['notes'] ?? '',
      reminderOption: json['reminderOption'] ?? '30_mins',
      oneDayBeforeReminder: json['oneDayBeforeReminder'] ?? true,
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}
