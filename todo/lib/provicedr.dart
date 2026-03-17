import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/tsk_title.dart';

class TaskProvider with ChangeNotifier {
  // Use your actual API base URL
  static const String baseUrl = 'https://your-api-url.com/api';

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all tasks
  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('$baseUrl/tasks'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _tasks = data.map((json) => Task.fromJson(json)).toList();
        _error = null;
      } else {
        _error = 'Failed to load tasks: ${response.statusCode}';
      }
    } on http.ClientException catch (e) {
      _error = 'Network error: $e';
    } on Exception catch (e) {
      _error = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new task - FIRST METHOD (Recommended for your use case)
  Future<Task> addTask(Task task) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/tasks'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(task.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final newTask = Task.fromJson(json.decode(response.body));
        _tasks.insert(0, newTask); // Add at beginning
        _error = null;
        notifyListeners();
        return newTask;
      } else {
        throw Exception('Failed to create task: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: $e');
    } on Exception catch (e) {
      throw Exception('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update a task
  Future<void> updateTask(String taskId, Task updatedTask) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/tasks/$taskId'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(updatedTask.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final int index = _tasks.indexWhere((task) => task.id == taskId);
        if (index != -1) {
          _tasks[index] = updatedTask;
        }
        notifyListeners();
      } else {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating task: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/tasks/$taskId'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 204) {
        _tasks.removeWhere((task) => task.id == taskId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting task: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle task completion
  Future<void> toggleTaskCompletion(String taskId) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    final updatedTask = task.copyWith(completed: !task.completed);

    await updateTask(taskId, updatedTask);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
