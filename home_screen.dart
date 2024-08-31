import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:mobiledevelopment/config/my_theme.dart';
import 'package:mobiledevelopment/controller/task_controller.dart';
import 'package:mobiledevelopment/controller/theme_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TaskController taskController = Get.put(TaskController());
    ThemeController themeController = Get.put(ThemeController());

    DateTime currentDateTime = DateTime.now().toLocal();
    String formattedDate = DateFormat('d MMMM, yyyy').format(currentDateTime);

    return Scaffold(
      appBar: AppBar(
        title: Text("HomeScreen"),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            onPressed: () {
              themeController.changeTheme();
            },
            icon: Obx(
                  () => themeController.isDark.value
                  ? Icon(Icons.dark_mode)
                  : Icon(Icons.light_mode),
            ),
          ),
        ],
      ),
      body: Obx(() {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date display below AppBar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text("Today"),
                    ],
                  ),
                ),
              ),
              // Horizontal Date Picker
              Container(
                height: 100,
                child: DatePicker(
                  DateTime.now(),
                  width: 80,
                  height: 80,
                  initialSelectedDate: DateTime.now(),
                  selectionColor: primaryClr,
                  selectedTextColor: Colors.white,

                  onDateChange: (date) {
                    // Logic to handle date change
                  },
                ),
              ),
              // Task list
              ...taskController.taskList.map((task) {
                int index = taskController.taskList.indexOf(task);
                return Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryClr,
                      borderRadius: BorderRadius.circular(21),
                    ),
                    child: ListTile(
                      title: Text(task),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                taskController.deleteTask(index);
                              },
                              icon: Icon(Icons.delete_outlined)),
                          IconButton(
                              onPressed: () {
                                taskController.openEditDialog(index);
                              },
                              icon: Icon(Icons.edit))
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          taskController.openDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}



