import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_holiday/get_holiday_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_holiday/get_holiday_event.dart';
import 'package:oceanbit_timeclock/models/get_holiday_by_month.dart';
import 'package:oceanbit_timeclock/screen/profile/profile_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constant/constant.dart';
import '../constant/strings.dart';
import '../utils/logger.dart';
import '../widget/chart_widget.dart';
import '../widget/cusom_dialog.dart';
import '../widget/custom_container.dart';
import 'login_screen/login_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  Widget? dashboardChild;
  TextEditingController taskController = TextEditingController();
  TextEditingController breakReasonController = TextEditingController();
  Duration duration = const Duration();
  Duration interMediateDuration = const Duration();
  Timer? timer;
  Timer? interMediateTimer;
  bool isTime = false;
  bool isTimeOut = false;
  int totalSecondCount = 0;
  int totalInterMediateSecondCount = 0;
  double timeDifference = 0.0;
  DateTime? stopTime, resumeTime;
  String? hour;
  String? minutes;
  String? seconds;
  String? interMediateHour;
  String? interMediateMinutes;
  String? interMediateSeconds;
  int selectedIndex = 0;
  int selectedSubIndex = 0;
  bool isExpand = false;
  String? totalHour = "00";
  String? totalMinutes = "00";
  String? totalSecond = "00";
  int missUseCounter = 0;
  int lateArrivalCounter = 0;
  bool isTimeIn = false;
  DateTime? totalTime;
  DateTime? lastStatusReportDate = DateTime.now();

  void startTimer(bool isResume) {
    timer =
        Timer.periodic(const Duration(seconds: 1), (_) => addTime(isResume));
  }

  void addTime(bool isResume) {
    const addSeconds = 1;
    setState(() {
      !isResume
          ? totalSecondCount = duration.inSeconds + addSeconds
          : totalSecondCount = totalSecondCount + addSeconds;
      if (totalSecondCount < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: totalSecondCount);
      }
    });
  }

  void startInterMediateTime(bool isResume) {
    interMediateTimer = Timer.periodic(
        const Duration(seconds: 1), (_) => addInterMediateTime(isResume));
  }

  void addInterMediateTime(bool isResume) {
    const addSeconds = 1;
    setState(() {
      !isResume
          ? totalInterMediateSecondCount =
              interMediateDuration.inSeconds + addSeconds
          : totalInterMediateSecondCount =
              totalInterMediateSecondCount + addSeconds;
      if (totalInterMediateSecondCount < 0) {
        interMediateTimer?.cancel();
      } else {
        interMediateDuration = Duration(seconds: totalInterMediateSecondCount);
      }
    });
  }

  void stopTimer() {
    setState(() {
      timer!.cancel();
    });
  }

  void stopInterMediateTimer() {
    setState(() {
      interMediateTimer?.cancel();
    });
  }

  void timeIn() {
    startTimer(false);
    Logger.println("$totalSecondCount");
  }

  void interMediateTimeIn() {
    startInterMediateTime(false);
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      duration = const Duration();
    });
  }

  void resetInterMediateTimer() {
    stopInterMediateTimer();
    setState(() {
      interMediateDuration = const Duration();
    });
  }

  void getFinalTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    hour = twoDigits(duration.inHours);
    minutes = twoDigits(duration.inMinutes.remainder(60));
    seconds = twoDigits(duration.inSeconds.remainder(60));
  }

  int? getTimeDifference() {
    return resumeTime!.difference(stopTime!).inMinutes;
  }

  void _onItemTapped(int index, BuildContext context) {
    setState(() {
      dashboardChild = index == 0
          ? dashboardMainWidget(context)
          : (index == 3)
              ? ProfileScreen(
                  subMenuItem: Strings.profileItem[selectedSubIndex],
                  menuItem: Strings.drawerItem[index],
                )
              : Center(
                  child: Strings.drawerItem[selectedIndex].text
                      .textStyle(context.textTheme.displayLarge)
                      .color(Constant.cBlack)
                      .make(),
                );
      //_bottomNavScreen(index,context);
      Logger.println("menuItem=${Strings.drawerItem[index]}");
      //print("subMenuItem=${Strings.profileItem[selectedSubIndex]}");
    });
  }

  @override
  void initState() {
    BlocProvider.of<GetHolidayBloc>(context).add(
      FetchHolidayByMonth(
        context: context,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.cWhite,
      /*  appBar: AppBar(title: Text(Strings.oceanBitTimeClock),),
      backgroundColor: Constant.cWhite,
      key: _drawerScaffoldKey, //set global key defined above
      drawer: _buildDrawer(context),*/
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDrawer(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Constant.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //const TimerScreen(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            decoration: const BoxDecoration(
                                color: Constant.cGreenLight),
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(Constant.paddingHalf),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.all(
                                          Constant.paddingHalf),
                                      color:
                                          Constant.cGreenDark.withOpacity(0.5),
                                      child: buildTime()),
                                  Constant.padding.widthBox,
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(Strings.welcome,
                                          style:
                                              Constant.textStyleSize25(context)
                                                  ?.copyWith(
                                                      color: Constant.cBlack),
                                          textAlign: TextAlign.end),
                                      Text(
                                        "Milin",
                                        style: Constant.textStyleSize15(context)
                                            ?.copyWith(color: Constant.cBlack),
                                        textAlign: TextAlign.end,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                    Constant.paddingHalf.heightBox,
                    dashboardChild ?? dashboardMainWidget(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width / 6,
      color: Constant.cBlack,
      child: Padding(
        padding: const EdgeInsets.only(
            top: Constant.padding, bottom: Constant.padding),
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: Strings.drawerItem.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                    top: Constant.paddingHalf, bottom: Constant.paddingHalf),
                child: drawerTile(
                  list: Strings.drawerSubItem[index],
                  name: Strings.drawerItem[index],
                  icon: Strings.drawerIcon[index],
                  index,
                  context,
                  onTap: () {},
                ),
              );
            }),
      ),
    );
  }

  Widget drawerTile(int index, BuildContext context,
      {String? name,
      IconData? icon,
      Function()? onTap,
      required List<String> list}) {
    return Container(
      color: index == selectedIndex
          ? Constant.cWhite.withOpacity(0.3)
          : Colors.transparent,
      child: list.isNotEmpty
          ? Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: Icon(
                  icon,
                  color: Constant.cWhite,
                  size: 20,
                ),
                title: Text(
                  name!,
                  style: Constant.textStyleSize15(context)
                      ?.copyWith(color: Constant.cWhite),
                ),
                trailing: list.isNotEmpty && !isExpand
                    ? const Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: Constant.cWhite,
                        size: 30,
                      )
                    : list.isNotEmpty && isExpand
                        ? const Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: Constant.cWhite,
                            size: 30,
                          )
                        : Container(),
                onExpansionChanged: (isExpanded) {
                  // selectedIndex = index;
                  setState(() {
                    isExpand = isExpanded;
                  });

                  //_onItemTapped(index, context);
                },
                children: [
                  isExpand
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (context, listIndex) {
                            return ListTile(
                              title: Text(list[listIndex],
                                  style: Constant.textStyleSize14(context)
                                      ?.copyWith(color: Constant.cWhite)),
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                  selectedSubIndex = listIndex;
                                  _onItemTapped(index, context);
                                });
                                //isExpand = false;
                              },
                            );
                          })
                      : const SizedBox.shrink()
                ],
                /*onTap: (){
            selectedIndex=index;

            _onItemTapped(index,context);
        },*/
              ),
            )
          : ListTile(
              leading: Icon(
                icon,
                color: Constant.cWhite,
                size: 20,
              ),
              title: Text(
                name!,
                style: Constant.textStyleSize15(context)
                    ?.copyWith(color: Constant.cWhite),
              ),
              //trailing: list.isNotEmpty&&!isExpand?Icon(Icons.arrow_forward_ios_rounded,color: Constant.cWhite,size: 30,):list.isNotEmpty&&isExpand?Icon(Icons.keyboard_arrow_down_outlined,color: Constant.cWhite,size: 30,):Container(),

              onTap: () {
                setState(() {
                  selectedIndex = index;
                  isExpand = false;
                  //selectedSubIndex=-1;
                  _onItemTapped(index, context);
                });
              },
            ),
    );
  }

/*  _bottomNavScreen(int selectedIndex, BuildContext context) {
    return IndexedStack(
      index: selectedIndex,
      children: [
        DashboardMainWidget(context),
        Center(
          child:
          Strings.drawerItem[selectedIndex].text.textStyle(context.textTheme.displayLarge).color(Constant.cBlack).make(),
        ),

      ],
    );
  }*/

  Widget buildFinalTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Final Time : ',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(
          width: 5,
        ),
        Text("$hour : $minutes : $seconds",
            style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    hour = twoDigits(duration.inHours);
    minutes = twoDigits(duration.inMinutes.remainder(60));
    seconds = twoDigits(duration.inSeconds.remainder(60));
    totalTime = DateTime.parse("2023-01-07 $hour:$minutes:$seconds");
    interMediateHour = twoDigits(interMediateDuration.inHours);
    interMediateMinutes =
        twoDigits(interMediateDuration.inMinutes.remainder(60));
    interMediateSeconds =
        twoDigits(interMediateDuration.inSeconds.remainder(60));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "${Strings.total} - ",
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.white),
        ),
        SizedBox(
          width: 22,
          child: Text(
            hour!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
        const SizedBox(width: 2),
        Text(
          ":",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
        const SizedBox(width: 2),
        SizedBox(
          width: 22,
          child: Text(
            minutes!,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          ),
        ),
        const SizedBox(width: 2),
        Text(
          ":",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
        const SizedBox(width: 2),
        SizedBox(
          width: 22,
          child: Text(
            seconds!,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          "${Strings.intermediate} - ",
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.white),
        ),
        SizedBox(
          width: 22,
          child: Text(
            interMediateHour!,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          ),
        ),
        const SizedBox(width: 2),
        Text(
          ":",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
        const SizedBox(width: 2),
        SizedBox(
          width: 22,
          child: Text(
            interMediateMinutes!,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          ),
        ),
        const SizedBox(width: 2),
        Text(
          ":",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
        const SizedBox(width: 2),
        SizedBox(
          width: 22,
          child: Text(
            interMediateSeconds!,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          ),
        ),
        const SizedBox(width: 5),
        // Text('$minutes:$seconds',
        //   style: Theme.of(context).textTheme.displaySmall,
        // ),
      ],
    );
  }

  Widget dashboardMainWidget(BuildContext context) {
    /*return Expanded(
      child: StaggeredGrid.count(
        axisDirection: AxisDirection.right,
        crossAxisCount: 6,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children:  [
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: Tile(index: 0),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: Tile(index: 1),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: Tile(index: 2),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: Tile(index: 3),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: Tile(index: 4),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: Tile(index: 5),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 1,
            child: Tile(index: 6),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Tile(index: 7),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Tile(index: 8),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 4,
            mainAxisCellCount: 2,
            child: Tile(index: 9),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 4,
            mainAxisCellCount: 2,
            child: Tile(index: 10),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 4,
            mainAxisCellCount: 2,
            child: Tile(index: 10),
          ),
        ],
      ),
    );*/
    return Expanded(
      flex: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomContainer(
                      headerText: Strings.yourTiming.toUpperCase(),
                      color: Constant.cCyanDark,
                      width: MediaQuery.of(context).size.width / 5,
                      child: Flexible(
                        child: isTime
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: isTimeOut
                                        ? () {
                                            ///Inter Time In On Tap
                                            setState(() {
                                              resumeTime = DateTime.now();
                                              Logger.println(
                                                  "Resume Time :::: $resumeTime");
                                              if (getTimeDifference()! < 1) {
                                                stopInterMediateTimer();
                                                timeIn();
                                                isTimeOut = !isTimeOut;
                                              } else {
                                                breakReasonController.clear();
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return StatefulBuilder(
                                                          builder: (context,
                                                              menuSetState) {
                                                        return Form(
                                                          key: _formKey,
                                                          autovalidateMode: _autoValidate
                                                              ? AutovalidateMode
                                                                  .onUserInteraction
                                                              : AutovalidateMode
                                                                  .disabled,
                                                          child: CustomDialog(
                                                            maxLine: 10,
                                                            validationString:
                                                                Strings
                                                                    .taskReason,
                                                            hintText: Strings
                                                                .enterBreakReason,
                                                            // dialogTitle:
                                                            // 'Your Break Time : ',
                                                            // dialogSubTitle:
                                                            // "${resumeTime!.hour - stopTime!.hour} : ${resumeTime!.minute - stopTime!.minute} : ${resumeTime!.second - stopTime!.second}",
                                                            onTapTextField: () {
                                                              menuSetState(
                                                                  () {});
                                                            },
                                                            onChanged: (val) {},
                                                            onTapButton: () {
                                                              menuSetState(() {
                                                                if (_formKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  stopInterMediateTimer();
                                                                  timeIn();
                                                                  isTimeOut =
                                                                      !isTimeOut;
                                                                  stopTime =
                                                                      null;
                                                                  resumeTime =
                                                                      null;
                                                                  Navigator.pop(
                                                                      context);
                                                                } else {
                                                                  _autoValidate =
                                                                      true;
                                                                }
                                                              });
                                                            },
                                                            controller:
                                                                breakReasonController,
                                                          ),
                                                        );
                                                      });
                                                    });
                                              }
                                            });
                                          }
                                        : () {
                                            ///Inter Time Out On Tap
                                            setState(() {
                                              stopTime = DateTime.now();
                                              Logger.println(
                                                  "Resume Time :::: $stopTime");
                                              stopTimer();
                                              totalInterMediateSecondCount > 0
                                                  ? interMediateTimeIn()
                                                  : startInterMediateTime(
                                                      false);
                                              isTimeOut = !isTimeOut;
                                            });
                                          },
                                    child: Container(
                                      color: Colors.green,
                                      height: 35,
                                      width:
                                          MediaQuery.of(context).size.width / 7,
                                      child: Center(
                                        child: Text(
                                          isTimeOut
                                              ? Strings.interInTime
                                              : Strings.interOutTime,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: Constant.cWhite,
                                                  fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Constant.paddingHalf.heightBox,
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        /*if (isTimeOut) {
                                          isTimeOut = !isTimeOut;
                                        }*/
                                        taskController.clear();
                                        // if(isTimeIn){
                                        //   isTimeIn = !isTimeIn;
                                        //   resetTimer();
                                        //   String twoDigits(int n) => n.toString().padLeft(2, '0');
                                        //   totalTime!.add(Duration(hours: int.parse(hour!)));
                                        //   totalTime!.add(Duration(minutes: int.parse(minutes!)));
                                        //   totalTime!.add(Duration(seconds: int.parse(seconds!)));
                                        //   totalHour = twoDigits(totalTime!.hour);
                                        //   totalMinutes = twoDigits(totalTime!.minute);
                                        //   totalSecond = twoDigits(totalTime!.second);
                                        // }
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return StatefulBuilder(builder:
                                                  (context, menuSetState) {
                                                return Form(
                                                  key: _formKey,
                                                  autovalidateMode:
                                                      _autoValidate
                                                          ? AutovalidateMode
                                                              .onUserInteraction
                                                          : AutovalidateMode
                                                              .disabled,
                                                  child: CustomDialog(
                                                    maxLine: 20,
                                                    validationString:
                                                        Strings.taskEmpty,
                                                    hintText: Strings.enterTask,
                                                    // dialogTitle: 'Your Total Time : ',
                                                    // dialogSubTitle:
                                                    // "$hour : $minutes : $seconds",
                                                    onTapTextField: () {
                                                      menuSetState(() {});
                                                    },
                                                    onChanged: (val) {
                                                      /*if (val.isNotEmpty) {
                                                  _autoValidate = false;
                                                } else {
                                                  _autoValidate = true;
                                                }
                                                menuSetState(() {});*/
                                                    },
                                                    onTapButton: () {
                                                      menuSetState(() {
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          isTime = !isTime;
                                                          resetTimer();
                                                          resetInterMediateTimer();
                                                          // isTime = !isTime;
                                                          if (isTimeOut) {
                                                            isTimeOut =
                                                                !isTimeOut;
                                                          }
                                                          resetTimer();
                                                          Navigator.of(context)
                                                              .pushAndRemoveUntil(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) {
                                                            return const LoginScreen();
                                                          }), (route) => false);
                                                        } else {
                                                          _autoValidate = true;
                                                        }
                                                      });
                                                    },
                                                    controller: taskController,
                                                  ),
                                                );
                                              });
                                            });
                                      });
                                    },
                                    child: Container(
                                      color: Colors.redAccent,
                                      height: 35,
                                      width:
                                          MediaQuery.of(context).size.width / 7,
                                      child: Center(
                                        child: Text(
                                          Strings.finalOutTime,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: Constant.cWhite,
                                                  fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      setState(() {
                                        startTimer(false);
                                        isTime = !isTime;
                                      });
                                    });
                                  },
                                  child: Container(
                                    color: Colors.green,
                                    height: 35,
                                    width:
                                        MediaQuery.of(context).size.width / 7,
                                    child: Center(
                                      child: Text(
                                        Strings.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: Constant.cWhite,
                                                fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomContainer(

                          ///Total Time
                          headerText: Strings.totalTime.toUpperCase(),
                          color: Constant.cGreenLight,
                          width: MediaQuery.of(context).size.width / 5,
                          height: MediaQuery.of(context).size.height / 7.2,
                          child: Flexible(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "$totalHour:$totalMinutes:$totalSecond",
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(color: Constant.cWhite),
                                ),
                              ),
                            ),
                          )),
                      CustomContainer(

                          ///Intermediate
                          headerText: Strings.intermediateTime.toUpperCase(),
                          color: Constant.cOrangeDark,
                          width: MediaQuery.of(context).size.width / 5,
                          height: MediaQuery.of(context).size.height / 7.2,
                          child: Flexible(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "$totalHour:$totalMinutes:$totalSecond",
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(color: Constant.cWhite),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                  CustomContainer(

                      ///Birthday in this month
                      headerText: Strings.birthdayInMonth.toUpperCase(),
                      color: Constant.cGrayDark,
                      width: MediaQuery.of(context).size.width / 5,
                      child: Column(
                        children: [
                          Container(
                            color: Colors.black26,
                            padding: const EdgeInsets.all(Constant.paddingHalf),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      Strings.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    Text(
                                      Strings.birthdate,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          birthdayList()
                        ],
                      )),
                  CustomContainer(

                      ///Holidays in this month
                      headerText: Strings.holidaysInMonth.toUpperCase(),
                      color: Constant.cRed,
                      width: MediaQuery.of(context).size.width / 5,
                      child: Container(
                        child: holidayListView(),
                      )),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomContainer(

                      ///chart for month timing
                      headerText: Strings.yourTimingForMonth.toUpperCase(),
                      color: Constant.cBlueDark,
                      width: MediaQuery.of(context).size.width / 2.47,
                      child: ChartWidget()),
                  CustomContainer(

                      ///latest knowledge
                      headerText: Strings.knowledgeBase.toUpperCase(),
                      color: Constant.cBlueLight,
                      width: MediaQuery.of(context).size.width / 5,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: latestKnowledgeBaseListView(),
                      )),
                  CustomContainer(

                      ///last status report
                      headerText: Strings.lastStatueReport.toUpperCase(),
                      color: Constant.cPurple,
                      width: MediaQuery.of(context).size.width / 5,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Date  : 40/01/2023",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Constant.cWhite),
                                )),
                          ),
                          lastStatusRepostListView()
                        ],
                      )),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomContainer(

                      ///quote of the day
                      headerText: Strings.quoteOfDay.toUpperCase(),
                      color: Constant.cYellowDark,
                      width: MediaQuery.of(context).size.width / 2.47,
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: Constant.padding,
                            right: Constant.padding,
                            top: Constant.paddingDouble),
                        child: Text(
                          Strings.quote,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Constant.cWhite,
                                  ),
                        ),
                      )),
                  CustomContainer(

                      ///busy or free
                      headerText: Strings.busyOrFree.toUpperCase(),
                      color: Constant.cGrayDark,
                      width: MediaQuery.of(context).size.width / 5,
                      child: Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                color: Colors.green,
                                height: 35,
                                width: MediaQuery.of(context).size.width / 7,
                                child: Center(
                                  child: Text(
                                    Strings.busy,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Constant.cWhite,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  CustomContainer(

                      ///warning
                      headerText: Strings.warning.toUpperCase(),
                      color: Constant.cPinkDark,
                      width: MediaQuery.of(context).size.width / 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Constant.paddingDouble.heightBox,
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constant.padding,
                                vertical: Constant.paddingHalf),
                            child: Text(
                              "${Strings.internetMissUseCount} : $missUseCounter",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constant.padding,
                                vertical: Constant.paddingHalf),
                            child: Text(
                              "${Strings.lateArrivalCount} : $lateArrivalCounter",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  birthdayList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: Strings.birthdayList.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(Constant.paddingHalf),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.birthdayList.keys.elementAt(index),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                Strings.birthdayList.values.elementAt(index),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }

  List<HolidayInMonth> holidaysByMonth = [];

  holidayListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: holidaysByMonth.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(Constant.paddingHalf),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              bulletPoint(color: Constant.cWhite),
              Constant.paddingHalf.widthBox,
              Text(
                holidaysByMonth[index].holidayType.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }

  lastStatusRepostListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: Strings.lastStatusReportList.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(Constant.paddingHalf),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              bulletPoint(color: Constant.cWhite),
              Constant.paddingHalf.widthBox,
              Expanded(
                child: RichText(
                    softWrap: true,
                    overflow: TextOverflow.fade,
                    text: TextSpan(
                      text: Strings.lastStatusReportList[index],
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  latestKnowledgeBaseListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: Strings.knowledgeBaseList.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(Constant.paddingHalf),
          child: RichText(
              softWrap: true,
              overflow: TextOverflow.fade,
              text: TextSpan(
                text:
                    "[${Strings.knowledgeBaseList.keys.elementAt(index)}] - ${Strings.knowledgeBaseList.values.elementAt(index)}",
                style: Theme.of(context).textTheme.bodyMedium,
              )),
        );
      },
    );
  }

  Widget tile({required int index}) {
    return Container(
      height: 100,
      width: 100,
      decoration: const BoxDecoration(color: Constant.cGreenLight),
      child: Center(child: Text(index.toString())),
    );
  }

  Widget bulletPoint({Color? color}) {
    return Container(
      height: 7,
      width: 7,
      decoration:
          BoxDecoration(color: color ?? Colors.black54, shape: BoxShape.circle),
    );
  }
}
