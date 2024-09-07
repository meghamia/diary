import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goalsync/controller/weekmodel.dart';
import 'package:goalsync/database/dbhelper.dart';
import 'package:intl/intl.dart';


class TaskController extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  var taskList = <String>[].obs;
  var isTaskSelected = <bool>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  void loadTasks() async {
    final tasks = await _databaseHelper.getTasks();
    print("Fetched tasks from database: $tasks");

    taskList.value = tasks.map((task) => task['task'] as String).toList();
    print("Task names: ${taskList.value}");

    isTaskSelected.value = tasks.map((task) {
      final isChecked = task['is_checked'];
      return (isChecked != null && (isChecked as int) == 1);
    }).toList();
    print("Task selection states: ${isTaskSelected.value}");
  }

  void addTask(String task) async {
    bool isChecked = false; // Default checkbox state
    double progress = 0.0;  // Default progress value
    String createdDate = DateTime.now().toIso8601String(); // Convert DateTime to String

    // Insert the task into the database with its initial state
    int? result = await _databaseHelper.insertTask(task, isChecked, progress, createdDate);

    if (result == null) {
      print("Task already exists");
    } else {
      print("Task added successfully");
    }

    // After adding the task, load the tasks again to refresh the UI
    loadTasks();
  }

  void deleteTask(int index) async {
    String taskToDelete = taskList[index];
    await _databaseHelper.deleteTask(taskToDelete);
    taskList.removeAt(index);
    isTaskSelected.removeAt(index);
  }

  Future<void> toggleTaskSelection(int index, bool value) async {
    try {
      if (index < 0 || index >= taskList.length) {
        throw ArgumentError("Index out of range");
      }

      String taskToUpdate = taskList[index];
      double progress = value ? 1.0 : 0.0;
      String updatedDate = DateTime.now().toIso8601String(); // Convert DateTime to String

      isTaskSelected[index] = value;

      if (value) {
        print("Marking task '$taskToUpdate' as completed. Progress: $progress");
      } else {
        print("Marking task '$taskToUpdate' as uncompleted. Progress: $progress");
      }

      // Ensure the update operation is awaited
      await _databaseHelper.updateTask(taskToUpdate, taskToUpdate, value, progress, updatedDate);
      print("Task updated successfully");

    } catch (e) {
      print("Error toggling task selection: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchProgressDataForWeek(String taskName) async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1)).toIso8601String();
    final endOfWeek = now.add(Duration(days: 6 - now.weekday)).toIso8601String();

    return await _databaseHelper.getTaskProgressForRange(taskName, startOfWeek, endOfWeek);
  }
}


