import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:App/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final taskListProvider = StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  return TaskListNotifier();
});

class TaskListNotifier extends StateNotifier<List<Task>> {
  TaskListNotifier() : super([]) {
    loadTasks(); 
  }

  void addTask(Task task) {
    state = [...state, task]; // Añade el task completo con descripción
    saveTasks();
  }

  void toggleTaskCompletion(int index) {
    var updatedTask = state[index].copyWith(isCompleted: !state[index].isCompleted);
    state = [...state]..[index] = updatedTask;
    saveTasks();
    print('Tarea actualizada: ${state[index].title}, completada: ${state[index].isCompleted}');
  }

  void deleteCompletedTasks() {
    state = state.where((task) => !task.isCompleted).toList();
    saveTasks(); 
    print('Tareas completadas eliminadas');
  }

  // Método para eliminar todas las tareas
  void deleteAllTasks() {
    state = []; // Elimina todas las tareas
    saveTasks();
    print('Todas las tareas han sido eliminadas');
  }

  void deleteTask(int index) {
    print('Tarea eliminada: ${state[index].title}');
    state = [...state]..removeAt(index);
    saveTasks();
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> tasks = state.map((task) => jsonEncode({
      'title': task.title,
      'description': task.description, // Guarda la descripción
      'isCompleted': task.isCompleted
    })).toList();
    await prefs.setStringList('tasks', tasks);
    print('Tareas guardadas: $tasks');  
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? tasks = prefs.getStringList('tasks');
    if (tasks != null) {
      state = tasks.map((task) {
        final Map<String, dynamic> taskMap = jsonDecode(task);
        return Task(
          title: taskMap['title'],
          description: taskMap['description'] ?? '', // Carga la descripción
          isCompleted: taskMap['isCompleted'],
        );
      }).toList();
      print('Tareas cargadas: $state');
    }
  }
}
