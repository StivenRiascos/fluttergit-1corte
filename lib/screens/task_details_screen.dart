import 'package:flutter/material.dart';
import 'package:App/models/task_model.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Título de la tarea:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(task.title, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text(
              'Nombre de la materia:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(task.description.isNotEmpty ? task.description : 'No hay descripción', 
              style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text(
              '¿Completada?:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(task.isCompleted ? 'Sí' : 'No', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
