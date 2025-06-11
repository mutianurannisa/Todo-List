class Task {
  String id;
  String title;
  String description;
  DateTime? deadline; 
  bool isCompleted;
  String? category;
  String? userId;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.deadline,
    this.isCompleted = false,
    this.category,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline?.toIso8601String(), 
      'isCompleted': isCompleted,
      'category': category,
      'userId': userId,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String, 
      title: json['title'] as String, 
      description: json['description'] as String, 
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline'] as String) : null, 
      isCompleted: json['isCompleted'] as bool? ?? false, 
      category: json['category'] as String?, 
      userId: json['userId'] as String?,
    );
  }
}