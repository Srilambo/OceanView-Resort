class StaffTask {
  final String taskId;
  final String title;
  final String description;
  final String? assignedTo;
  final String status;
  final String priority;
  final String? dueDate;
  final String? createdAt;
  final String? updatedAt;

  StaffTask({
    required this.taskId,
    required this.title,
    required this.description,
    this.assignedTo,
    required this.status,
    required this.priority,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
  });

  factory StaffTask.fromJson(Map<String, dynamic> json) {
    return StaffTask(
      taskId: json['taskId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      assignedTo: json['assignedTo'],
      status: json['status'] ?? 'PENDING',
      priority: json['priority'] ?? 'MEDIUM',
      dueDate: json['dueDate'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'title': title,
      'description': description,
      'assignedTo': assignedTo,
      'status': status,
      'priority': priority,
      'dueDate': dueDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  StaffTask copyWith({
    String? taskId,
    String? title,
    String? description,
    String? assignedTo,
    String? status,
    String? priority,
    String? dueDate,
    String? createdAt,
    String? updatedAt,
  }) {
    return StaffTask(
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      description: description ?? this.description,
      assignedTo: assignedTo ?? this.assignedTo,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
