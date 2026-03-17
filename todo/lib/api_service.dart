import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:todo/routes.dart';
import 'package:todo/tsk_title.dart';

class ApiService {
  // Replace with your actual MockAPI endpoint
  static const String baseUrl = 'https://YOUR_REAL_MOCKAPI_URL/api/v1/tasks';

  // ---------------------------------------------------------
  // GET ALL TASKS
  // ---------------------------------------------------------
  static Future<List<Task>> fetchTasks() async {
    try {
      final uri = Uri.parse(baseUrl);
      final res = await http.get(uri).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(res.body);
        return data.map((e) => Task.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch tasks: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }

  static Future<Task> addTask(Task task) async {
    try {
      final uri = Uri.parse(baseUrl);

      final res = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'title': task.title,
              'description': task.description,
              'completed': task.completed,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 201 || res.statusCode == 200) {
        return Task.fromJson(json.decode(res.body));
      } else {
        throw Exception('Failed to create task: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }

  static Future<Task> updateTaskStatus(String id, bool completed) async {
    try {
      final uri = Uri.parse('$baseUrl/$id');

      final res = await http
          .patch(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'completed': completed}),
          )
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        return Task.fromJson(json.decode(res.body));
      } else {
        throw Exception('Failed to update task: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }
}
