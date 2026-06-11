import 'dart:async';
import 'package:flutter/material.dart';
import '../constant/constant.dart';
import '../constant/strings.dart';
import '../utils/logger.dart';
import '../widget/cusom_dialog.dart';
import '../widget/custom_button.dart';
import 'login_screen/login_screen.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  TextEditingController taskController = TextEditingController();
  Duration duration = const Duration();
  Timer? timer;
  bool isTime = false;
  bool isTimeOut = false;
  int totalSeconds = 0;
  String? hour;
  double timeDifference = 0.0;
  DateTime? stopTime, resumeTime;
  String? minutes;
  String? seconds;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  void startTimer(bool isResume) {
    timer =
        Timer.periodic(const Duration(seconds: 1), (_) => addTime(isResume));
  }

  void addTime(bool isResume) {
    const addSeconds = 1;
    setState(() {
      !isResume
          ? totalSeconds = duration.inSeconds + addSeconds
          : totalSeconds = totalSeconds + addSeconds;
      if (totalSeconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: totalSeconds);
      }
    });
  }

  void stopTimer() {
    setState(() {
      timer!.cancel();
    });
  }

  void timeIn() {
    startTimer(true);
    Logger.println(totalSeconds.toString());
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      duration = const Duration();
    });
  }

  void getFinalTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    hour = twoDigits(duration.inHours);
    minutes = twoDigits(duration.inMinutes.remainder(60));
    seconds = twoDigits(duration.inSeconds.remainder(60));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text("${duration.inSeconds}",
                      // style: Theme.of(context).textTheme.displaySmall,)
                      buildTime()
                    ],
                  ),
                ),
                const SizedBox(height: 190),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      !isTime
                          ? CustomButton(
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Constant.cWhite),
                              radius: 10,
                              width: MediaQuery.of(context).size.width / 4,
                              text: Strings.start,
                              onTap: () {
                                setState(() {
                                  startTimer(false);
                                  isTime = !isTime;
                                });
                              },
                            )
                          : !isTimeOut
                              ? CustomButton(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Constant.cWhite),
                                  radius: 10,
                                  width: MediaQuery.of(context).size.width / 4,
                                  text: Strings.interIn,
                                  onTap: () {
                                    setState(() {
                                      stopTime = DateTime.now();
                                      stopTimer();
                                      isTimeOut = !isTimeOut;
                                    });
                                  },
                                )
                              : CustomButton(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Constant.cWhite),
                                  radius: 10,
                                  width: MediaQuery.of(context).size.width / 4,
                                  text: Strings.timeOut,
                                  onTap: () {
                                    setState(() {
                                      resumeTime = DateTime.now();
                                      Logger.println(
                                          'stop time : ${stopTime!.minute}');
                                      Logger.println(
                                          'resume time : ${resumeTime!.minute}');
                                      if (getTimeDifference()! < 1) {
                                        timeIn();
                                        isTimeOut = !isTimeOut;
                                      } else {
                                        taskController.clear();
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
                                                    maxLine: 5,
                                                    validationString:
                                                        Strings.taskReason,
                                                    hintText: Strings
                                                        .enterBreakReason,
                                                    // dialogTitle:
                                                    //     'Your Break Time : ',
                                                    // dialogSubTitle:
                                                    //     "${resumeTime!.hour - stopTime!.hour} : ${resumeTime!.minute - stopTime!.minute} : ${resumeTime!.second - stopTime!.second}",
                                                    onTapTextField: () {
                                                      menuSetState(() {});
                                                    },
                                                    onChanged: (val) {
                                                      /* if (val.isNotEmpty) {
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
                                                          timeIn();
                                                          isTimeOut =
                                                              !isTimeOut;
                                                          stopTime = null;
                                                          resumeTime = null;
                                                          Navigator.pop(
                                                              context);
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
                                      }
                                    });
                                  },
                                ),
                      const SizedBox(height: 30),
                      isTime
                          ? CustomButton(
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Constant.cWhite),
                              radius: 10,
                              width: MediaQuery.of(context).size.width / 4,
                              text: Strings.finalize,
                              onTap: () {
                                setState(() {
                                  getFinalTime();
                                  stopTimer();
                                  isTimeOut = !isTimeOut;
                                  taskController.clear();
                                });
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                          builder: (context, menuSetState) {
                                        return Form(
                                          key: _formKey,
                                          autovalidateMode: _autoValidate
                                              ? AutovalidateMode
                                                  .onUserInteraction
                                              : AutovalidateMode.disabled,
                                          child: CustomDialog(
                                            maxLine: 5,
                                            validationString: Strings.taskEmpty,
                                            hintText: Strings.enterTask,
                                            // dialogTitle: 'Your Final Time : ',
                                            // dialogSubTitle:
                                            //     "$hour : $minutes : $seconds",
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
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  isTime = !isTime;
                                                  isTimeOut = !isTimeOut;
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
                              },
                            )
                          : Container(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  int? getTimeDifference() {
    return resumeTime!.difference(stopTime!).inMinutes;
  }

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
    return Row(
      children: [
        Wrap(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(10),
              child: Text(
                hour!,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(10),
              child: Text(
                minutes!,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(10),
              child: Text(
                seconds!,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        // Text('$minutes:$seconds',
        //   style: Theme.of(context).textTheme.displaySmall,
        // ),
      ],
    );
  }
}
