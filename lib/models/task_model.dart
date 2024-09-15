class Task {
  String title;
  String description; // Añadir descripción
  bool isCompleted;

  Task({required this.title, this.description = '', this.isCompleted = false});

  Task copyWith({String? title, String? description, bool? isCompleted}) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description, // Copia la descripción
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // Actualiza los métodos toJson y fromJson para incluir la descripción
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description, // Incluye la descripción
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'] ?? '', // Incluye la descripción
      isCompleted: json['isCompleted'],
    );
  }
}
