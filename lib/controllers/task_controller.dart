import 'package:flutter_to_do/db/db_helper.dart';
import 'package:flutter_to_do/models/task.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    getTasks();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task task}) async {
    return await DbHelper.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DbHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
    taskList.sort((a, b) =>
        _get24HourTime(a.startTime).compareTo(_get24HourTime(b.startTime)));
    taskList.sort((a,b)=>a.isCompleted.compareTo(b.isCompleted));
    print(taskList.length);
  }

  void delete(Task task) {
    DbHelper.delete(task);
    getTasks();
  }

  void updateTaskStatus(int id, int status) async {
    await DbHelper.updateTaskStatus(id, status);
    getTasks();
  }

  updateTask({Task task}) async {
    return await DbHelper.updateTask(task);
  }

  String _get24HourTime(String startTime) {

    DateTime date =
    DateFormat.jm().parse(startTime.toString());
    var myTime = DateFormat("HH:mm").format(date);

    return myTime;
  }
}
