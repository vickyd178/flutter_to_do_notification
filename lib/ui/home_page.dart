import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_to_do/controllers/task_controller.dart';
import 'package:flutter_to_do/models/task.dart';
import 'package:flutter_to_do/services/notification_services.dart';
import 'package:flutter_to_do/services/theme_services.dart';
import 'package:flutter_to_do/ui/add_task_bar.dart';
import 'package:flutter_to_do/ui/theme.dart';
import 'package:flutter_to_do/ui/widgets/button.dart';
import 'package:flutter_to_do/ui/widgets/task_tile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(
            height: 10,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 15),
      child: DatePicker(
        DateTime.now(),
        height: 80,
        width: 64,
        initialSelectedDate: DateTime.now(),
        selectionColor: Themes.primaryClr,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Get.isDarkMode ? Colors.white : Colors.grey[800],
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                )
              ],
            ),
          ),
          MyButton(
            label: "+ Add Task",
            onTap: () async {
              await Get.to(() => AddTaskPage(
                    selectedDate: _selectedDate,
                  ));
              _taskController.getTasks();
            },
          )
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
              title: "Theme Changed",
              body: Get.isDarkMode
                  ? "Activated Light Theme"
                  : "Activated Dark Theme");
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
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

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index];
              if (task.repeat == "Daily" && task.isCompleted == 0) {
                DateTime date =
                    DateFormat.jm().parse(task.startTime.toString());
                var myTime = DateFormat("HH:mm").format(date);

                //schedule notification
                notifyHelper.scheduledNotification(
                    int.parse(myTime.split(":")[0]),
                    int.parse(myTime.split(":")[1]),
                    task);
                return _taskWidget(index, task);
              }
              //show tasks for selected date only
              if (task.date == DateFormat.yMd().format(_selectedDate)) {
                return _taskWidget(index, task);
              } else {
                return Container();
              }
            });
      }),
    );
  }

  _taskWidget(int index, Task task) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key(task.title),
      onDismissed: (direction) {
        _taskController.delete(task);
        notifyHelper.cancelNotification(task.id);
        Get.snackbar(
          task.title, // title
          "Task has been deleted !", // message
          icon: Icon(Icons.delete),
          shouldIconPulse: true,
          onTap: (key) {},
          snackPosition: SnackPosition.BOTTOM,
          barBlur: 20,
          isDismissible: true,
          duration: Duration(seconds: 3),
        );
      },
      background: Container(
        margin: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        color: Colors.transparent,
        child: Icon(Icons.delete),
      ),
      child: AnimationConfiguration.staggeredList(
          position: index,
          child: SlideAnimation(
            child: FadeInAnimation(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showBottomSheet(context, task);
                    },
                    child: TaskTile(task),
                  )
                ],
              ),
            ),
          )),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          color: Get.isDarkMode ? Themes.darkGreyClr : Colors.white,
          padding: const EdgeInsets.only(top: 4),
          height: task.isCompleted == 1
              ? MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.height * 0.30
                  : MediaQuery.of(context).size.height * 0.50
              : MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.height * 0.35
                  : MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[400],
                    borderRadius: BorderRadius.circular(10)),
                width: 120,
                height: 5,
              ),
              Spacer(
                flex: 2,
              ),
              task.isCompleted == 1
                  ? Container()
                  : _bottomSheetButton(
                      label: "Edit Task",
                      onTap: () async {
                        Get.back();
                        await Get.to(
                          () => AddTaskPage(
                            selectedDate: DateTime.now(),
                            task: task,
                          ),
                        );
                        _taskController.getTasks();
                      },
                      color: Themes.primaryClr,
                      context: context,
                    ),
              _bottomSheetButton(
                label:
                    task.isCompleted == 0 ? "Task Completed" : "Mark Incomplete",
                onTap: () {
                  if (task.isCompleted == 1) {
                    print("rescheduled notifications");
                    DateTime date =
                        DateFormat.jm().parse(task.startTime.toString());
                    var myTime = DateFormat("HH:mm").format(date);

                    //schedule notification
                    notifyHelper.scheduledNotification(
                        int.parse(myTime.split(":")[0]),
                        int.parse(myTime.split(":")[1]),
                        task);
                  } else {
                    notifyHelper.cancelNotification(task.id);
                    print("notifications cancelled");
                  }
                  _taskController.updateTaskStatus(
                      task.id, task.isCompleted == 0 ? 1 : 0);

                  Get.back();
                },
                color: task.isCompleted == 0 ? Themes.primaryClr : Colors.grey,
                context: context,
              ),
              _bottomSheetButton(
                label: "Delete Task",
                onTap: () {
                  _taskController.delete(task);
                  notifyHelper.cancelNotification(task.id);
                  Get.back();
                },
                color: Colors.red[300],
                context: context,
              ),
              Spacer(
                flex: 2,
              ),
              _bottomSheetButton(
                isClose: true,
                label: "Close",
                onTap: () {
                  Get.back();
                },
                color: Colors.red,
                context: context,
              ),
              Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true
    );
  }

  _bottomSheetButton(
      {@required String label,
      @required Function onTap,
      @required Color color,
      @required BuildContext context,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 40,
        width: MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width * 0.9
            : MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: isClose ? Colors.transparent : color,
            border: Border.all(
              width: 1,
              color: isClose
                  ? Get.isDarkMode
                      ? Colors.grey[600]
                      : Colors.grey[300]
                  : color,
            )),
        child: Center(
            child: Text(
          label,
          style:
              isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
        )),
      ),
    );
  }
}
