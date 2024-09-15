import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../screens/task_details_screen.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final taskList = ref.watch(taskListProvider); // Observa el estado de la lista de tareas

    // Verificamos el estado de la lista
    ref.listen<List<Task>>(taskListProvider, (previous, next) {
      print('Tareas actualizadas: $next');
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tareas'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20), // Mover el botón hacia la izquierda
            child: IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.white),
              onPressed: () {
                ref.read(taskListProvider.notifier).deleteAllTasks(); // Llama a deleteAllTasks
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Todas las tareas han sido eliminadas')),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 95, 219, 199), // Fondo sólido
      body: ListView.builder(
        itemCount: taskList.length,
        itemBuilder: (context, index) {
          final Task task = taskList[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                task.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (value) {
                  ref.read(taskListProvider.notifier).toggleTaskCompletion(index);
                },
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.info, color: Colors.blueAccent), // Botón de detalles
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailsScreen(task: task),
                        ),
                      );
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20), // Mueve el botón de eliminar tarea a la izquierda
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        ref.read(taskListProvider.notifier).deleteTask(index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController taskController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController(); // Controlador para la descripción

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Agregar nueva tarea'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                hintText: 'Nombre de la tarea',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 8), // Espacio entre los campos
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Materia',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar', style: TextStyle(color: Color.fromARGB(255, 146, 3, 3))),
          ),
          ElevatedButton(
            onPressed: () {
              if (taskController.text.isNotEmpty) {
                final taskNotifier = ref.read(taskListProvider.notifier);
                taskNotifier.addTask(Task(title: taskController.text, description: descriptionController.text)); // Guarda la descripción
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 3, 78, 206),
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
