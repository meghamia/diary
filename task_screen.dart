



import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../database/dbhelper.dart'; // Import your DatabaseHelper

class TaskScreen extends StatelessWidget {
  final String taskName;

  TaskScreen({
    required this.taskName,
  });

  Future<List<double>> _fetchTaskProgress() async {
    final dbHelper = DatabaseHelper();

    print("Fetching progress data for task: $taskName");

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1)).toIso8601String();
    final endOfWeek = now.add(Duration(days: 6 - now.weekday)).toIso8601String();
    print("Start of week: $startOfWeek");
    print("End of week: $endOfWeek");

    try {
      final result = await dbHelper.getTaskProgress(taskName, startOfWeek, endOfWeek);

      if (result.isEmpty) {
        print("No progress data available for the specified date range.");
      } else {
        print("Progress data fetched: $result");
      }

      return result;
    } catch (e) {
      print("Error fetching progress data: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Details"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<double>>(
          future: _fetchTaskProgress(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              print('No data available');
              return Center(child: Text('No data available'));
            }

            final dailyProgress = snapshot.data!;
            final daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
            final today = DateTime.now();
            final currentDayIndex = today.weekday % 7; // Calculate current day index

            // Initialize progressData with minimal values for past days and 0 for future days
            final progressData = List<double>.filled(7, 0.0);

            // Assign fetched data to corresponding days
            for (int i = 0; i < dailyProgress.length; i++) {
              final dayIndex = (currentDayIndex + i) % 7;
              progressData[dayIndex] = dailyProgress[i];
            }

            // Set minimal bar for past days and ensure future days remain 0
            for (int i = 0; i < 7; i++) {
              if (i < currentDayIndex) {
                // Past days with minimal bar height
                progressData[i] = progressData[i] == 0.0 ? 0.1 : progressData[i];
              } else if (i > currentDayIndex) {
                // Future days with no data
                progressData[i] = 0.0;
              }
            }

            print("Days of Week: $daysOfWeek");
            print("Current Day Index: $currentDayIndex");
            print("Raw Progress Data: $dailyProgress");
            print("Processed Progress Data: $progressData");

            if (progressData.every((p) => p == 0.0)) {
              return Center(child: Text('No progress made yet.'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taskName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: progressData.isNotEmpty ? progressData.reduce((a, b) => a > b ? a : b) + 1 : 1,
                      barGroups: progressData.asMap().entries.map((entry) {
                        int index = entry.key;
                        double value = entry.value;
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: value,
                              color: index == currentDayIndex ? Colors.blue : Colors.grey, // Color for current vs past days
                              width: 20,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }).toList(),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              final dayLabel = daysOfWeek[value.toInt() % 7];
                              const style = TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              );
                              print("X-axis label for index ${value.toInt()}: $dayLabel");
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  dayLabel,
                                  style: style,
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              const style = TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              );
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  '${value.toInt()}',
                                  style: style,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: const Color(0xff37434d),
                          width: 1,
                        ),
                      ),
                      gridData: FlGridData(show: true),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

