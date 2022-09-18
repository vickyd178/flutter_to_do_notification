import 'package:flutter/material.dart';
import 'package:flutter_to_do/Constants.dart';
import 'package:flutter_to_do/controllers/task_controller.dart';
import 'package:flutter_to_do/models/task.dart';
import 'package:flutter_to_do/ui/theme.dart';
import 'package:flutter_to_do/ui/widgets/button.dart';
import 'package:flutter_to_do/ui/widgets/input_field.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  final DateTime selectedDate;
  final Task task;

  const AddTaskPage({Key key, this.selectedDate, this.task}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState(selectedDate, task);
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate;
  Task task;
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  String _selectedRepeat = "None";
  int _selectedColor = 0;

  _AddTaskPageState(this._selectedDate, [this.task]) {
    if (task != null) {
      _titleController = TextEditingController(text: task.title);
      _noteController = TextEditingController(text: task.note);
      _startTime = task.startTime;
      _endTime = task.endTime;
      _selectedRemind = task.remind;
      _selectedColor = task.color;
      _selectedRepeat = task.repeat;
      _selectedDate = new DateFormat.yMd().parse(task.date);
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {

    });
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task == null ? "Add Task" : "Edit Task",
                  style: headingStyle,
                ),
                MyInputField(
                  title: "Title",
                  hint: "Enter your title here",
                  controller: _titleController,
                ),
                MyInputField(
                  title: "Note",
                  hint: "Enter your note",
                  controller: _noteController,
                ),
                MyInputField(
                  title: "Date",
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                    color: Get.isDarkMode ? Colors.grey[300] : Colors.grey[600],
                    icon: Icon(Icons.calendar_today_outlined),
                    onPressed: () {
                      _getDateFromUser();
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: MyInputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        color: Get.isDarkMode
                            ? Colors.grey[300]
                            : Colors.grey[600],
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: Icon(Icons.access_time_rounded),
                      ),
                    )),
                    SizedBox(width: 8),
                    Expanded(
                        child: MyInputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        color: Get.isDarkMode
                            ? Colors.grey[300]
                            : Colors.grey[600],
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: Icon(Icons.access_time_rounded),
                      ),
                    )),
                  ],
                ),
                MyInputField(
                  title: "Remind",
                  hint: "$_selectedRemind minutes early",
                  widget: DropdownButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color:
                          Get.isDarkMode ? Colors.grey[300] : Colors.grey[600],
                    ),
                    iconSize: 32,
                    elevation: 4,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        _selectedRemind = int.parse(newValue);
                      });
                    },
                    style: subTitleStyle,
                    items: Constants.remindList
                        .map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                ),
                MyInputField(
                  title: "Repeat",
                  hint: "$_selectedRepeat",
                  widget: DropdownButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color:
                          Get.isDarkMode ? Colors.grey[300] : Colors.grey[600],
                    ),
                    iconSize: 32,
                    elevation: 4,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String repeatValue) {
                      setState(() {
                        _selectedRepeat = repeatValue;
                      });
                    },
                    style: subTitleStyle,
                    items: Constants.repeatList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _colorPallet(),
                    MyButton(
                      label: task == null ? "Create Task" : "Save Task",
                      onTap: () => _validateData(),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
        ),
      ),
      /*actions: [
        CircleAvatar(
          backgroundImage: AssetImage("images/profile.png"),
        ),
        SizedBox(
          width: 20,
        )
      ],*/
    );
  }

  _getDateFromUser() async {
    DateTime _pickerDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 15),
    );

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      print("it's null or something is wrong");
    }
  }

  _getTimeFromUser({@required bool isStartTime}) async {
    var pickedTime = await _showTimePicker(isStartTime);
    String _formattedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("Time Cancelled");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formattedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formattedTime;
      });
    }
  }

  _showTimePicker(bool isStartTime) {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.dial,
        context: context,
        initialTime: TimeOfDay(
          hour: isStartTime
              ? int.parse(_startTime.split(":")[0])
              : int.parse(_endTime.split(":")[0]),
          minute: int.parse(
            isStartTime
                ? _startTime.split(":")[1].split(" ")[0]
                : _endTime.split(":")[1].split(" ")[0],
          ),
        ));
  }

  _colorPallet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        SizedBox(
          height: 8,
        ),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? Themes.primaryClr
                      : index == 1
                          ? Themes.pinkClr
                          : Themes.yellowClr,
                  child: _selectedColor == index
                      ? Icon(
                          Icons.done,
                          size: 16,
                          color: Colors.white,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      if (task != null) {
        _updateTask();
      } else {
        _addTaskToDb();
      }
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required !",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          animationDuration: Duration(milliseconds: 600),
          backgroundColor:
              Get.isDarkMode ? Themes.darkGreyClr : Themes.primaryClr,
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[100],
          ),
          colorText: Get.isDarkMode ? Colors.grey[400] : Colors.grey[100],
          margin: EdgeInsets.only(bottom: 10, left: 15, right: 15));
    }
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(
        task: Task(
            note: _noteController.text,
            title: _titleController.text,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            remind: _selectedRemind,
            repeat: _selectedRepeat,
            color: _selectedColor,
            isCompleted: 0));

    print("My value is  $value");
  }

  void _updateTask() async {
    int value = await _taskController.updateTask(
        task: Task(
            id: task.id,
            note: _noteController.text,
            title: _titleController.text,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            remind: _selectedRemind,
            repeat: _selectedRepeat,
            color: _selectedColor,
            isCompleted: 0));
    print("My value is  $value");
  }
}
