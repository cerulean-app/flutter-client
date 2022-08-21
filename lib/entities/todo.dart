class Todo {
  final String id;
  final String name;
  final String? description;
  final bool done;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Todo({
    required this.id,
    required this.name,
    this.description,
    this.done = false,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  Todo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        done = json['done'],
        dueDate = DateTime.parse(json['dueDate']),
        createdAt = DateTime.parse(json['createdAt']),
        updatedAt = DateTime.parse(json['updatedAt']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'done': done,
        'dueDate': dueDate?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
