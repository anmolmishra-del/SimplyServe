import 'package:todo/routes.dart';
import 'package:todo/tsk_title.dart' show Task;

class LocalStorage {
  static const String _tasksKey = 'cached_tasks_v1';

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tasksKey, Task.listToJson(tasks));
  }

  static Future<List<Task>?> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_tasksKey);
    if (raw == null) return null;
    try {
      return Task.listFromJson(raw);
    } catch (_) {
      return null;
    }
  }
}
