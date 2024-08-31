import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateTimeController extends GetxController {
  var currentDateTime = ''.obs;

  @override
  void onInit() {
    super.onInit();
    updateDateTime();
    // Update date and time every second
    ever(currentDateTime, (_) => updateDateTime()); // Correct method name
  }

  void updateDateTime() {
    currentDateTime.value = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
  }
}
