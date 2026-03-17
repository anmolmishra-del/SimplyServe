class Task {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.createdAt,
  });

  // Convert from JSON (API response)
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      completed: json['completed'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  // Convert to JSON (API request)
  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'completed': completed};
  }

  // Copy with method for updates
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static listToJson(List<Task> tasks) {}

  static Future<List<Task>?> listFromJson(raw) async {}
}
