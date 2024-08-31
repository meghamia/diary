import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiledevelopment/dbhelper/database_helper.dart';

class TaskController extends GetxController {
  var isBottomSheetOpen = false.obs;
  var taskList = <String>[].obs;

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  void loadTasks() async {
    final tasks = await _databaseHelper.getTasks();
    taskList.value = tasks.map((task) => task['task'] as String).toList();
  }

  void deleteTask(int index) async {
    String taskToDelete = taskList[index];
    // Deleting the task from database
    await _databaseHelper.deleteTask(taskToDelete);
    taskList.removeAt(index);
  }

  void openDialog() {
    final TextEditingController taskController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: Text("Add Task"),
        content: TextField(
          controller: taskController,
          decoration: InputDecoration(
            labelText: "Enter task",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (taskController.text.isNotEmpty) {
                addTask(taskController.text);
                Get.back(); // Close the dialog
                print("saved successfully");
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }


  void openEditDialog(int index){
    final TextEditingController taskController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: Text("Edit Task"),
        content: TextField(
          controller: taskController,
          decoration: InputDecoration(
            labelText: "Edit task",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: (){Get.back();},
              child: Text("Cancel"),

          ),
          ElevatedButton(onPressed: (){
            if(taskController.text.isNotEmpty){
              updateTask(index,taskController.text);
              Get.back();
              print('updated successfully');
            }
          }, child: Text("Update"))
        ],
      )
    );

  }
  void updateTask(int index,String newTask)async{
    String oldTask = taskList[index];
    await _databaseHelper.updateTask(oldTask,newTask);
    loadTasks();
  }

  void addTask(String task) async {
    await _databaseHelper.insertTask(task);
    loadTasks(); // Reload tasks after adding
  }
}
