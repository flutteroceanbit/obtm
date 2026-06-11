import 'dart:async';
import 'dart:io' as io;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_daily_report/get_daily_report_repository.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_holiday/get_holiday_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/knowledge_bloc/knowledge_state.dart';
import 'package:oceanbit_timeclock/bloc_logic/quote_bloc/quote_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/quote_bloc/quote_event.dart';
import 'package:oceanbit_timeclock/bloc_logic/quote_bloc/quote_state.dart';
import 'package:oceanbit_timeclock/bloc_logic/update_ui_bloc/update_ui_bloc.dart';
import 'package:oceanbit_timeclock/main.dart';
import 'package:oceanbit_timeclock/models/add_time_slot_model.dart';
import 'package:oceanbit_timeclock/models/get_daily_report_model.dart';
import 'package:oceanbit_timeclock/models/get_knowledge_model.dart';
import 'package:oceanbit_timeclock/models/quotes/get_quotes_model.dart';
import 'package:oceanbit_timeclock/screen/admin_screens/admin_holiday_screen.dart';
import 'package:oceanbit_timeclock/screen/dashboard/widget/dashboard_large_body.dart';
import 'package:oceanbit_timeclock/screen/dashboard/widget/dashboard_medium_body.dart';
import 'package:oceanbit_timeclock/widget/custom_button.dart';
import 'package:oceanbit_timeclock/widget/late_arrival_list_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:window_manager/window_manager.dart';

import '../../bloc_logic/add_daily_report_bloc/add_daily_report_bloc.dart';
import '../../bloc_logic/birthday_users_bloc/birthday_list_bloc.dart';
import '../../bloc_logic/common_repositories/preference_repository.dart';
import '../../bloc_logic/get_daily_report/get_daily_report_bloc.dart';
import '../../bloc_logic/get_holiday/get_holiday_event.dart';
import '../../bloc_logic/get_holiday/get_holiday_state.dart';
import '../../bloc_logic/get_last_daily_report_bloc/last_daily_report_bloc.dart';
import '../../bloc_logic/get_monthly_report/monthly_report_bloc.dart';
import '../../bloc_logic/knowledge_bloc/knowledge_bloc.dart';
import '../../bloc_logic/knowledge_bloc/knowledge_event.dart';
import '../../bloc_logic/local_database_bloc/local_database_bloc.dart';
import '../../bloc_logic/time_bloc/time_bloc.dart';
import '../../bloc_logic/update_ui_bloc/update_ui_state.dart';
import '../../constant/api.dart';
import '../../constant/constant.dart';
import '../../constant/custom_flutter_adptive_scaffold/custom_adaptive_scaffold.dart';
import '../../constant/custom_flutter_adptive_scaffold/custom_breakpoints.dart';
import '../../constant/local_key.dart';
import '../../constant/strings.dart';
import '../../gen/assets.gen.dart';
import '../../local_database/timer_database.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/add_local_time_slot_model.dart';
import '../../models/auth_model.dart' as auth;
import '../../models/chart_data_model.dart';
import '../../models/daily_report_model.dart';
import '../../models/get_holiday_by_month.dart';
import '../../models/user_detail_model.dart';
import '../../router/my_router.dart';
import '../../utils/date_formatter.dart';
import '../../utils/logger.dart';
import '../../widget/chart_widget.dart';
import '../../widget/cusom_dialog.dart';
import '../../widget/custom_container.dart';
import '../../widget/custom_container_button.dart';
import '../../widget/new/custom_cardview.dart';
import '../admin_screens/employee_screen/current_employee.dart' as current;
import '../admin_screens/employee_screen/past_employee.dart' as past;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

int selectedIndex = 0;
List<Widget> msgList = [];

class _DashboardState extends State<Dashboard> with WindowListener {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  // Widget? dashboardChild;
  TextEditingController taskController = TextEditingController();
  TextEditingController breakReasonController = TextEditingController();
  Duration duration = const Duration();
  Duration monthDuration = const Duration();
  Duration interMediateDuration = const Duration();
  Duration monthIntermediateDuration = const Duration();
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
  bool isExpand = false;
  String? totalHour = "00";
  String? totalMinutes = "00";
  String? totalSecond = "00";
  int missUseCounter = 0;
  int lateArrivalCounter = 0;
  String lateArrivalTotalTime = '00:00:00';
  bool isTimeIn = false;
  DateTime? totalTime;
  DateTime? lastStatusReportDate = DateTime.now();
  Data? data;
  GetDailyReportModel? reportModel;
  List<UserData> birthDayList = [];
  int navigationIndex = 0;
  String totalInterMediateTime = '00:00:00';
  String totalWorkingTime = '00:00:00';
  bool isFinalOut = false;
  late PreferenceManagerRepository preferenceManagerRepository;
  String currentStatusTimer = '';
  int totalMonthWorkingSecond = 0; //store total working time of current month
  int totalMonthInterMediateSecond = 0;
  List<TimerDetailData> timerData = [];
  List<TimerDetailData> timerDataIsSyncFalse = [];
  TimerDetailData?
  timerDetailData; //store total intermediate time of current month
  bool isUpdate = false;
  bool isClose = false;
  bool isSubmit = false;
  List<TimeSlotData>? timeSlotData;
  List<LateArrivalDetail> initialTimeSlotList = [];
  List<Map<String, String>> localTimeSlotModel = [];
  final bool _copyToClipboard = false;
  late auth.User userData;
  int tic = 0;
  List<FileSystemEntity> ssFiles = [];
  Map<String, dynamic> tempTimeData = {};
  List<HolidayInMonth> holidaysByMonth = [];
  List<KnowledgeData> knowledgeList = [];
  QuoteData? quote;
  DateTime sleepTime = DateTime.now();
  bool isStart = false;
  bool isLastReportAdded = false;
  bool isFinalOutDone = false;

  CapturedData? _lastCapturedData;
  Uint8List? _imageBytesFromClipboard;
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  void startTimer(bool isResume) {
    isStart = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      addTime(isResume, timer);
      //print('timer tic: ${timer.tick}');
      tic = tic + timer.tick;
      if (tic % 5 == 0) {
        _handleClickCapture(CaptureMode.screen);
        _getAllFileList();
        _checkAndDeleteUploadedFile();
      }
    });
    Logger.println("Start Time From Start Button :: $timer");
  }

  void addTime(bool isResume, Timer timer) {
    //add time duration in working time and intermediate time based on related condition is true
    const addSeconds = 1;
    if (mounted) {
      setState(() {
        if (isFinalOut && !isTime) {
          // stop timer is if final time out done for current day
          timer.cancel();
        } else if (isTime && isTimeOut && !isFinalOut) {
          //for working time
          /*(totalSecondCount = duration.inSeconds + addSeconds);
          duration = Duration(seconds: totalSecondCount);
          totalMonthWorkingSecond = totalMonthWorkingSecond + addSeconds;*/
          duration = Duration(
            seconds: totalSecondCount = duration.inSeconds + addSeconds,
          );
          //   totalMonthWorkingSecond = totalMonthWorkingSecond + addSeconds;//=duration.inSeconds;
          // Duration duration = Duration(seconds: totalMonthInterMediateSecond);
          monthDuration = Duration(
            seconds: totalMonthWorkingSecond =
                monthDuration.inSeconds + addSeconds,
          );
          //String twoDigits(int n) => n.toString().padLeft(2, '0');
          totalWorkingTime =
              '${twoDigits(monthDuration.inHours)}:${twoDigits(monthDuration.inMinutes.remainder(60))}:${twoDigits(monthDuration.inSeconds.remainder(60))}';
        } else if (isTime && !isTimeOut && !isFinalOut) {
          //for intermediate time
          interMediateDuration = Duration(
            seconds: totalInterMediateSecondCount =
                interMediateDuration.inSeconds + addSeconds,
          );
          totalMonthInterMediateSecond =
              totalMonthInterMediateSecond +
              addSeconds; //= interMediateDuration.inSeconds;
          monthIntermediateDuration = Duration(
            seconds: totalMonthInterMediateSecond =
                monthIntermediateDuration.inSeconds + addSeconds,
          );
          //  String twoDigits(int n) => n.toString().padLeft(2, '0');
          totalInterMediateTime =
              '${twoDigits(monthIntermediateDuration.inHours)}:${twoDigits(monthIntermediateDuration.inMinutes.remainder(60))}:${twoDigits(monthIntermediateDuration.inSeconds.remainder(60))}';
        }
        //Logger.println("Stored Current Date ::: ${timer.tick}");
      });
    }
  }

  void stopTimer() {
    setState(() {
      timer?.cancel();
    });
  }

  int? getTimeDifference() {
    //get time difference for taking break reason input form user
    return resumeTime?.difference(stopTime ?? DateTime.now()).inMinutes;
  }

  _setMonthTimerWidget(BuildContext context) {
    //set initial total month timer for current month
    BlocProvider.of<LocalDatabaseBloc>(context).add(
      CurrentMonthDataEvent(
        userId: context.read<PreferenceManagerRepository>().user!.employeeId,
        isWorkingTime: true,
      ),
    ); // set current month total working hours
    BlocProvider.of<LocalDatabaseBloc>(context).add(
      CurrentMonthDataEvent(
        userId: context.read<PreferenceManagerRepository>().user!.employeeId,
        isWorkingTime: false,
      ),
    ); // set current month total intermediate hours
  }

  _setCurrentTimerWidget(BuildContext context) {
    //use to set current day timer if user forced quit app without final time out
    BlocProvider.of<LocalDatabaseBloc>(context).add(
      TodayAllDataEvent(
        userId: context.read<PreferenceManagerRepository>().user!.employeeId,
        isWorkingTime: true,
      ),
    ); //set current day working hours
    BlocProvider.of<LocalDatabaseBloc>(context).add(
      TodayAllDataEvent(
        userId: context.read<PreferenceManagerRepository>().user!.employeeId,
        isWorkingTime: false,
      ),
    ); //set current day intermediate hours
  }

  @override
  void initState() {
    windowManager.addListener(this);
    _init();
    preferenceManagerRepository = context.read<PreferenceManagerRepository>();
    BlocProvider.of<MonthlyReportBloc>(context)
      ..isFetching = true
      ..page = 1
      ..add(FetchMonthlyReport(context: context));

    BlocProvider.of<LastDailyReportBloc>(
      context,
    ).add(FetchLastDailyReport(context: context));

    BlocProvider.of<TimeBloc>(
      context,
    ).add(FetchCurrentMonthChartData(context: context));

    BlocProvider.of<KnowledgeBloc>(
      context,
    ).add(FetchKnowledge(context: context));
    BlocProvider.of<MyQuoteBloc>(context).add(GetQuoteEvent(context: context));

    BlocProvider.of<LocalDatabaseBloc>(
      context,
    ).add(const CheckTableEmptyEvent());
    BlocProvider.of<GetHolidayBloc>(
      context,
    ).add(FetchHolidayByMonth(context: context));

    userData = preferenceManagerRepository.user!;

    super.initState();
    // Logger.println("Is Admin :: ${preferenceManagerRepository.user?.isAdmin}");
  }

  Future<void> _getAllFileList() async {
    Directory directory = await getTemporaryDirectory();
    var dirPath = '${directory.path}/Screenshots/';
    ssFiles = io.Directory(dirPath).listSync();
    // Logger.println('Screenshot ImageList:::');
    // for (var file in ssFiles) {
    //   Logger.println(file.path);
    // }
  }

  _checkAndDeleteUploadedFile() async {
    if (ssFiles.isNotEmpty) {
      File file = File(ssFiles[0].path);
      Logger.println('file path when delete file[0] :: $file');
      if (file.existsSync()) {
        try {
          await file.delete();
        } catch (e) {
          Logger.println('File delete error : $e');
        }
        Logger.println('File list after delete first file');
        // _getAllFileList();
      }
    }
  }

  void _handleClickCapture(CaptureMode mode) async {
    if (isAccessAllowed) {
      Directory directory = await getTemporaryDirectory();
      String imageName =
          'Screenshot-${DateTime.now().millisecondsSinceEpoch}.png';
      String imagePath = '${directory.path}/Screenshots/$imageName';
      _lastCapturedData = await screenCapturer.capture(
        mode: mode,
        imagePath: imagePath,
        copyToClipboard: _copyToClipboard,
        silent: true,
      );
    }
    /*if (_lastCapturedData != null) {
      var dir = await getDownloadsDirectory();
      var mkDir=Directory('${dir?.path}/screenshots');
      if(!(await mkDir.exists())){
        mkDir.create();
      }
      var path='${mkDir.path}/ss_${DateTime.now().millisecondsSinceEpoch}.png';
      var file=File(path);
      file.writeAsBytes(List<int>.from(_lastCapturedData!.imageBytes!), flush: true);
      if(await file.exists()){
        print('file path:${file.path}');
        msgList.add(Constant().ShowMessage('image saved at ${file.path}', context));
      }
      // ignore: avoid_print
      // print(_lastCapturedData!.toJson());
    } else {
      // ignore: avoid_print
      print('User canceled capture');
    }*/
    setState(() {});
  }

  Widget timeSlotDialog(BuildContext context, TimeData? timeData) {
    return Material(
      child: Center(
        child: Container(
          height: 100,
          width: 100,
          color: Colors.pink,
          child: Text(timeData!.actionType!),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    rootCtx = context;
    PreferenceManagerRepository preferenceManagerRepository = context
        .read<PreferenceManagerRepository>();

    List<NavigationDestination> employeeDrawerItemList = [
      NavigationDestination(
        icon: Assets.images.dashboardIconSvg.svg(
          color: selectedIndex == 0 ? Constant.cWhite : Constant.cBlack,
        ) /*Icon(Icons.dashboard)*/,
        label: 'Dashboard',
      ),
      NavigationDestination(
        icon: Assets.images.myTaskIcon.image(
          color: selectedIndex == 1 ? Constant.cWhite : Constant.cBlack,
        ) /*Icon(Icons.list_alt_sharp)*/,
        label: 'My Task',
      ),
      NavigationDestination(
        icon: Assets.images.timeIcon.image(
          color: selectedIndex == 2 ? Constant.cWhite : Constant.cBlack,
        ) /*Icon(Icons.timer_outlined)*/,
        label: 'Time',
      ),
      NavigationDestination(
        icon: Assets.images.profileIcon.image(
          color: selectedIndex == 3 ? Constant.cWhite : Constant.cBlack,
        ) /*Icon(Icons.person)*/,
        label: 'Profile',
      ),
      NavigationDestination(
        icon: Assets.images.leaveIcon.image(
          color: selectedIndex == 4 ? Constant.cWhite : Constant.cBlack,
        ) /*Icon(Icons.leave_bags_at_home)*/,
        label: 'Leave',
      ),
      NavigationDestination(
        icon: Assets.images.holidayIcon.image(
          color: selectedIndex == 5 ? Constant.cWhite : Constant.cBlack,
        ) /*Icon(Icons.holiday_village)*/,
        label: 'Holidays',
      ),
      NavigationDestination(
        icon: Assets.images.knowledgeBaseIcon.image(
          color: selectedIndex == 6 ? Constant.cWhite : Constant.cBlack,
        ) /*Icon(Icons.library_books)*/,
        label: 'Knowledge Base',
      ),
      NavigationDestination(
        icon: Assets.images.myReportIcon.image(
          color: selectedIndex == 7 ? Constant.cWhite : Constant.cBlack,
        ) /*Icon(Icons.inbox)*/,
        label: 'My Report',
      ),
      NavigationDestination(
        icon: Assets.images.empReviewIcon.image(
          color: selectedIndex == 8 ? Constant.cWhite : Constant.cBlack,
        ) /*Icon(Icons.messenger_outline_rounded)*/,
        label: 'Employee Reviews',
      ),
      NavigationDestination(
        icon: Assets.images.systemFaultIcon.image(
          color: selectedIndex == 9 ? Constant.cWhite : Constant.cBlack,
        ) /*Icon(Icons.error_outline)*/,
        label: 'System Faults',
      ),
      NavigationDestination(
        icon: Assets.images.mySalaryIcon.image(
          color: selectedIndex == 10 ? Constant.cWhite : Constant.cBlack,
        ) /*Icon(Icons.money)*/,
        label: 'My Salary',
      ),
      NavigationDestination(
        icon: Assets.images.oceanTeamIcon.image(
          color: selectedIndex == 11 ? Constant.cWhite : Constant.cBlack,
        ) /*Icon(Icons.group)*/,
        label: 'Ocean Team',
      ),
      NavigationDestination(
        icon: Assets.images.oceanRulesIcon.image(
          color: selectedIndex == 12 ? Constant.cWhite : Constant.cBlack,
        ) /*Icon(Icons.rule)*/,
        label: 'Ocean Rules',
      ),
      NavigationDestination(
        icon: Icon(
          Icons.format_quote,
          color: selectedIndex == 13 ? Constant.cWhite : Constant.cBlack,
        ) /*Icon(Icons.rule)*/,
        label: 'Ocean Quotes',
      ),
      if (preferenceManagerRepository.user!.isAdmin)
        NavigationDestination(
          icon: Icon(
            CupertinoIcons.person,
            color: selectedIndex == 14 ? Constant.cWhite : Constant.cBlack,
          ),
          label: 'Current Employee',
        ),
      if (preferenceManagerRepository.user!.isAdmin)
        NavigationDestination(
          icon: Icon(
            CupertinoIcons.person_alt,
            color: selectedIndex == 15 ? Constant.cWhite : Constant.cBlack,
          ),
          label: 'Past Employee',
        ),
      if (preferenceManagerRepository.user!.isAdmin)
        NavigationDestination(
          icon: Icon(
            Icons.inventory_2_outlined,
            color: selectedIndex == 16 ? Constant.cWhite : Constant.cBlack,
          ) /*Icon(Icons.rule)*/,
          label: 'Inventory',
        ),
      if (preferenceManagerRepository.user!.isAdmin)
        NavigationDestination(
          icon: Icon(
            Icons.settings,
            color: selectedIndex == 17 ? Constant.cWhite : Constant.cBlack,
          ) /*Icon(Icons.rule)*/,
          label: 'Settings',
        ),
      NavigationDestination(
        icon: Assets.images.logoutIcon.image(
          color: selectedIndex == 18 ? Constant.cWhite : Constant.cBlack,
        ) /*Icon(Icons.logout)*/,
        label: 'Logout',
      ),
    ];

    return Scaffold(
      backgroundColor: Constant.cWhite,
      body: BottomNavigationBarTheme(
        data: const BottomNavigationBarThemeData(
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.black,
          backgroundColor: Colors.white,
        ),
        child: MultiBlocListener(
          listeners: [
            BlocListener<TimeBloc, TimeState>(
              listener: (context, state) {
                if (state is GetLastTimeSlotLoaded) {
                  Logger.println(
                    'last time timeSlot:${state.data?.timeData?.actionType}',
                  );
                  /*   showDialog(context: context, builder: (context){
                    return TodayTimeSlotsDialog(state.data!.timeData!);
                  });*/
                }
                if (state is GetLastTimeSlotError) {
                  Constant.myLoader.hide();
                  Logger.println('last time timeSlot error:${state.errors}');
                } else if (state is GetCurrentMonthChartDataLoading) {
                  Constant.myLoader.show(context);
                } else if (state is GetCurrentMonthChartDataLoaded) {
                  timeSlotData?.clear();
                  lateArrivalCounter = 0;
                  initialTimeSlotList.clear();
                  timeSlotData = state.data?.timeSlotData;
                  if (timeSlotData != null && timeSlotData!.isNotEmpty) {
                    for (TimeSlotData timeSlot in timeSlotData!) {
                      if (timeSlot.timeSlots != null &&
                          timeSlot.timeSlots!.isNotEmpty) {
                        for (var slot in timeSlot.timeSlots!) {
                          if (slot.actionType == Strings.time_status[0]) {
                            initialTimeSlotList.add(
                              LateArrivalDetail(
                                initialTimeSlot: slot,
                                lateArrivalTime: '00:00:00',
                              ),
                            );
                          }
                        }
                      }
                    }
                    if (initialTimeSlotList.isNotEmpty) {
                      setLateArrivalCounter(initialTimeSlotList);
                    }
                  }
                  Constant.myLoader.hide();
                  setState(() {});
                } else if (state is GetCurrentMonthChartDataError) {
                  Constant.myLoader.hide();
                  msgList.add(
                    Constant().ShowErrorMessage(state.errors, context),
                  );
                  // Constant().ShowErrorToast(state.errors, context);
                } else if (state is AddTimeSlotLoading) {
                  Constant.myLoader.show(context);
                } else if (state is AddTimeSlotError) {
                  isUpdate = true;
                  Constant.myLoader.hide();
                  msgList.add(
                    Constant().ShowErrorMessage(state.errors, context),
                  );
                  BlocProvider.of<LocalDatabaseBloc>(context).add(
                    (InsertDataEvent(
                      context: context,
                      status: tempTimeData['status'],
                      timeData: tempTimeData['time'],
                      isSync: false,
                      sessionTime:
                          tempTimeData['sessionTime'] /*'${twoDigits(hour)}:${twoDigits(minute)}:${twoDigits(second)}'*/,
                    )),
                  );
                  tempTimeData.clear();
                  // Constant().ShowErrorToast(state.errors, context);
                  Logger.printTag('Insert time Error:', state.errors!);
                } else if (state is AddTimeSlotLoaded) {
                  Constant.myLoader.hide();
                  msgList.add(
                    Constant().ShowMessage('${state.data?.timeData}', context),
                  );
                  //Constant().ShowToast('${state.data}', context);
                  Logger.printTag(
                    'Insert time timeSlot Success:',
                    "${state.data!.timeData!.actionType!} added at id:${state.data}",
                  );
                  BlocProvider.of<LocalDatabaseBloc>(context).add(
                    (InsertDataEvent(
                      context: context,
                      status: tempTimeData['status'],
                      timeData: tempTimeData['time'],
                      isSync: true,
                      sessionTime:
                          tempTimeData['sessionTime'] /*'${twoDigits(hour)}:${twoDigits(minute)}:${twoDigits(second)}'*/,
                    )),
                  );
                  tempTimeData.clear();
                  //isUpdate=false;
                  /*BlocProvider.of<LocalDatabaseBloc>(context).add(
                      GetAllDataEvent(
                          userId: context
                              .read<PreferenceManagerRepository>()
                              .user!
                              .employeeId!));
                  BlocProvider.of<TimeBloc>(context).add(FetchTime(context: context));*/
                } else if (state is GetTimeSlotLoading) {
                  // Constant.myLoader.show(context);
                } else if (state is GetTimeSlotError) {
                  Constant.myLoader.hide();
                  msgList.add(
                    Constant().ShowErrorMessage(state.errors, context),
                  );
                  //Constant().ShowErrorToast(state.errors, context);
                  Logger.printTag('get all time data Error:', state.errors!);
                } else if (state is GetTimeSlotLoaded) {
                  Constant.myLoader.hide();
                  BlocProvider.of<TimeBloc>(
                    context,
                  ).add(FetchCurrentMonthChartData(context: context));
                  msgList.add(Constant().ShowMessage('${state.data}', context));
                  // Constant().ShowToast('${state.data}', context);
                  Logger.printTag(
                    'get all time data:',
                    "${state.data?.timeData ?? []}",
                  );
                } else if (state is AddLocalTimeSlotLoading) {
                  Constant.myLoader.show(context);
                } else if (state is AddLocalTimeSlotLoaded) {
                  Constant.myLoader.hide();
                  isUpdate = true;
                  for (int i = 0; i < timerDataIsSyncFalse.length; i++) {
                    var result = database!.updateTimer(
                      timerId: timerDataIsSyncFalse[i].timerId,
                      employeeId: timerDataIsSyncFalse[i].employeeId,
                      empName: timerDataIsSyncFalse[i].employeeName,
                      timerType: timerDataIsSyncFalse[i].timerType!,
                      time: timerDataIsSyncFalse[i].setTime,
                      date: timerDataIsSyncFalse[i].setDate,
                      sessionTime: timerDataIsSyncFalse[i].sessionTime!,
                      isSync: true,
                    );
                    Logger.println("update isSync result:$result");
                  }
                  isUpdate = false;
                } else if (state is AddLocalTimeSlotError) {
                  Constant.myLoader.hide();
                }
                setState(() {});
              },
            ),
            BlocListener<LocalDatabaseBloc, LocalDatabaseState>(
              listener: (context, state) async {
                //listen all bloc events and reset widgets
                if (state is InsertDataError) {
                  msgList.add(
                    Constant().ShowErrorMessage(state.errors, context),
                  );
                  Constant.myLoader.hide();
                  Constant.myLoader.hide();
                  //Constant().ShowErrorToast(state.errors, context);
                  Logger.printTag('Insert Error:', state.errors!);
                } else if (state is GetSingleDataForTodayByIdError) {
                  msgList.add(
                    Constant().ShowErrorMessage(state.errors, context),
                  );
                  Constant.myLoader.hide();
                  // Constant().ShowErrorToast(state.errors, context);
                  Logger.printTag('Get Single record Error:', state.errors!);
                } else if (state is CheckTableEmptyError) {
                  //Constant().ShowErrorToast(state.errors, context);
                  msgList.add(
                    Constant().ShowErrorMessage(state.errors, context),
                  );
                  Constant.myLoader.hide();
                  Logger.printTag('Get Check Table Error:', state.errors!);
                } else if (state is CurrentMonthDataError) {
                  // Constant().ShowErrorToast(state.errors, context);
                  msgList.add(
                    Constant().ShowErrorMessage(state.errors, context),
                  );
                  Constant.myLoader.hide();
                  Logger.printTag(
                    'Get Current month data Error:',
                    state.errors!,
                  );
                } else if (state is AllDataError) {
                  // Constant().ShowErrorToast(state.errors, context);
                  msgList.add(
                    Constant().ShowErrorMessage(state.errors, context),
                  );
                  Constant.myLoader.hide();
                  Logger.printTag('Fetch all data Error:', state.errors!);
                } else if (state is CheckTableEmptyLoaded) {
                  //msgList.add(Constant().ShowMessage(state.count.toString(), context));
                  msgList.add(
                    Constant().ShowMessage(state.count.toString(), context),
                  );
                  //Constant().ShowToast(state.count.toString(), context);

                  Logger.printTag(
                    'Get Check Table response:',
                    state.count.toString(),
                  );
                  Logger.printTag(
                    'from check table event isTime:',
                    isTime.toString(),
                  );
                  if (state.count != 0) {
                    _setMonthTimerWidget(context);
                    _setCurrentTimerWidget(context);
                    BlocProvider.of<LocalDatabaseBloc>(context).add(
                      GetAllDataEvent(
                        userId: context
                            .read<PreferenceManagerRepository>()
                            .user!
                            .employeeId,
                      ),
                    );
                    BlocProvider.of<LocalDatabaseBloc>(context).add(
                      GetSingleDataForInitialEvent(
                        status: Strings.time_status[3],
                        userId: context
                            .read<PreferenceManagerRepository>()
                            .user!
                            .employeeId,
                      ),
                    );
                  } else {
                    isTime = false;
                    hour = 0.toString();
                    minutes = 0.toString();
                    seconds = 0.toString();
                  }
                } else if (state is AllDataLoaded) {
                  msgList.add(
                    Constant().ShowMessage(
                      'total records:${state.data?.length}',
                      context,
                    ),
                  );
                  // Constant().ShowToast(
                  //     'total records:${state.data?.length}', context);
                  Logger.println("TIMER-TABLE");
                  timerData.clear();
                  timerDataIsSyncFalse.clear();
                  timerData = state.data!;
                  for (var time in timerData) {
                    if (time.isSync == 0) {
                      timerDataIsSyncFalse.add(time);
                      localTimeSlotModel.add(
                        TimeSlot(
                          id: time.timerId.toString(),
                          actionType: time.timerType,
                          date:
                              '${time.setDate.day}-${time.setDate.month}-${time.setDate.year}',
                          dateTime:
                              '${time.setDate.day}-${time.setDate.month}-${time.setDate.year} ${time.setTime}',
                          time: time.setTime,
                          timeDifference: time.sessionTime,
                        ).toJson(),
                      );
                    }
                  }
                  if (localTimeSlotModel.isNotEmpty /* && isUpdate*/ ) {
                    BlocProvider.of<TimeBloc>(context).add(
                      AddLocalTimeSlotEvent(
                        context: context,
                        localTimeSlotList: localTimeSlotModel,
                      ),
                    );
                  }
                  /*if(localTimeSlotModel.isNotEmpty && !isUpdate){
                      for(int i=0;i<timerDataIsSyncFalse.length;i++){
                        var result= database!.updateTimer(timerId: timerDataIsSyncFalse[i].timerId, employeeId: timerDataIsSyncFalse[i].employeeId, empName: timerDataIsSyncFalse[i].employeeName, timerType: timerDataIsSyncFalse[i].timerType!, time: timerDataIsSyncFalse[i].setTime, date: timerDataIsSyncFalse[i].setDate, session_time: timerDataIsSyncFalse[i].sessionTime!,isSync: true);
                        print("update isSync result:$result");
                      }
                    }*/
                } else if (state is GetSingleDataForInitialError) {
                  // Constant().ShowErrorToast(state.errors, context);
                  msgList.add(
                    Constant().ShowErrorMessage(state.errors, context),
                  );
                  Constant.myLoader.hide();
                  Logger.printTag(
                    'Get Single record for initial Error:',
                    state.errors!,
                  );
                } else if (state is TodayAllDataError) {
                  //Constant().ShowErrorToast(state.errors, context);
                  msgList.add(
                    Constant().ShowErrorMessage(state.errors, context),
                  );
                  Constant.myLoader.hide();
                  Logger.printTag(
                    'Get today record for initial timer Error:',
                    state.errors!,
                  );
                } else if (state is TodayAllDataLoaded) {
                  msgList.add(
                    Constant().ShowMessage(
                      '${state.data?.length} is working time:${state.isWorkingTime}',
                      context,
                    ),
                  );
                  /*  Constant().ShowToast(
                        '${state.data?.length} is working time:${state.isWorkingTime}',
                        context);*/
                  if (state.isWorkingTime) {
                    totalSecondCount = 0;
                    totalSecondCount = setTodayTimer(state.data!);
                    Logger.println(
                      "today working store time:$totalSecondCount",
                    );
                  }
                  if (state.isWorkingTime == false) {
                    totalInterMediateSecondCount = 0;
                    totalInterMediateSecondCount = setTodayTimer(state.data!);
                    Logger.println(
                      "today intermediate store time:$totalInterMediateSecondCount",
                    );
                  }
                  Logger.printTag(
                    'get monthly record for total initial timer for working time:${state.isWorkingTime}',
                    state.data.toString(),
                  );
                  setState(() {});
                } else if (state is CurrentMonthDataLoaded) {
                  msgList.add(
                    Constant().ShowMessage(
                      '${state.data} is working time:${state.isWorkingTime}',
                      context,
                    ),
                  );
                  // Constant().ShowToast(
                  //     '${state.data} is working time:${state.isWorkingTime}',
                  //     context);
                  if (state.isWorkingTime) {
                    String detail = calculateTotalMonthTime(state.data!);
                    totalWorkingTime = detail.split(" ")[0];
                    totalMonthWorkingSecond = int.parse(detail.split(" ")[1]);
                    monthDuration = Duration(seconds: totalMonthWorkingSecond);
                    Logger.println('working time:$totalWorkingTime');
                  } else if (state.isWorkingTime == false) {
                    String detail = calculateTotalMonthTime(state.data!);
                    totalInterMediateTime = detail.split(
                      " ",
                    )[0]; //'${hour}:${minute}:${second}';
                    totalMonthInterMediateSecond = int.parse(
                      detail.split(" ")[1],
                    );
                    monthIntermediateDuration = Duration(
                      seconds: totalMonthInterMediateSecond,
                    );
                    Logger.println('intermediate time:$totalInterMediateTime');
                  }
                  Logger.printTag(
                    'get monthly record for total initial timer for working time:${state.isWorkingTime}',
                    state.data.toString(),
                  );
                  setState(() {});
                } else if (state is GetSingleDataForTodayByIdLoaded) {
                  msgList.add(
                    Constant().ShowMessage(
                      'get today last data : ${state.data}',
                      context,
                    ),
                  );
                  // Constant().ShowToast('${state.data} ', context);
                  TimerDetailData? data = state.data;
                  int hour = 0, minute = 0, second = 0;
                  DateTime current = DateTime.now();
                  Duration c = Duration(
                    seconds: current.second,
                    minutes: current.minute,
                    hours: current.hour,
                  );
                  Duration p = Duration(
                    seconds: int.parse(data!.setTime.split(':')[2]),
                    minutes: (int.parse(data.setTime.split(':')[1])),
                    hours: (int.parse(data.setTime.split(':')[0])),
                  );
                  int currentSec = c.inSeconds - p.inSeconds;
                  // Logger.println(
                  //     "Current : $current previous: ${data.setTime} current second: $currentSec");
                  Duration diff = Duration(seconds: currentSec);
                  second = diff.inSeconds.remainder(60);
                  minute = diff.inMinutes.remainder(60);
                  hour = diff.inHours;
                  // Logger.println('hour:$hour');
                  // Logger.println('minute:$minute');
                  // Logger.println('sec:$second');
                  // Logger.println('time difference::$hour:$minute:$second');
                  // String twoDigits(int n) => n.toString().padLeft(2, '0');
                  /*BlocProvider.of<LocalDatabaseBloc>(context).add((InsertDataEvent(
                        context: context,
                        status: currentStatusTimer,
                        timeData: DateTime.now(),
                        isSync: false,
                        sessionTime:
                            '${twoDigits(hour)}:${twoDigits(minute)}:${twoDigits(second)}')));*/
                  Logger.println(
                    'currentStatusTimer when add in db & api:: $currentStatusTimer',
                  );
                  tempTimeData = {
                    'status': currentStatusTimer,
                    "time": DateTime.now(),
                    'sessionTime':
                        '${twoDigits(hour)}:${twoDigits(minute)}:${twoDigits(second)}',
                  };

                  BlocProvider.of<TimeBloc>(context).add(
                    AddTimeSlotEvent(
                      context: context,
                      timerStatus: currentStatusTimer, //Strings.time_status[3],
                      dateTime: DateTime.now().toString(),
                    ),
                  );

                  Logger.printTag(
                    'single data for today event isTime:',
                    isTime.toString(),
                  );
                  setState(() {});
                } else if (state is GetSingleDataForInitialLoaded) {
                  msgList.add(
                    Constant().ShowMessage(
                      'last record :${state.data} is time status:${state.timeStatus}',
                      context,
                    ),
                  );
                  // Constant().show_toast(
                  //     '${state.data} is time status:${state.timeStatus}',
                  //     context);
                  Logger.printTag(
                    'from set initial before edit event isTime:',
                    isTime.toString(),
                  );
                  String previousDate =
                      '${state.data?.setDate.year}-${state.data?.setDate.month}-${state.data?.setDate.day}';
                  String currentDate =
                      '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
                  if (previousDate == currentDate) {
                    if (state.data?.timerType == Strings.time_status[0]) {
                      isFinalOut = false;
                      totalSecondCount =
                          totalSecondCount +
                          getCurrentTimeDifference(state.data!);
                      totalMonthWorkingSecond =
                          totalMonthWorkingSecond +
                          getCurrentTimeDifference(state.data!);
                      Logger.println(
                        'currentStatusTimer when time_status is 0:: $currentStatusTimer',
                      );

                      currentStatusTimer = Strings.time_status[1];
                      monthDuration = Duration(
                        seconds: totalMonthWorkingSecond,
                      );
                      !isStart ? startTimer(true) : null;
                      isTimeOut = true;
                      isTime = true;
                      Logger.println(' isTime  From Start Button ::: $isTime');
                    } else if (state.data?.timerType ==
                        Strings.time_status[1]) {
                      isFinalOut = false;
                      stopTime = state.data?.setDate;
                      Logger.println(
                        'currentStatusTimer when time_status is 1:: $currentStatusTimer',
                      );

                      currentStatusTimer = Strings.time_status[2];
                      totalInterMediateSecondCount =
                          totalInterMediateSecondCount +
                          getCurrentTimeDifference(state.data!);
                      totalMonthInterMediateSecond =
                          totalMonthInterMediateSecond +
                          getCurrentTimeDifference(state.data!);
                      monthIntermediateDuration = Duration(
                        seconds: totalMonthInterMediateSecond,
                      );
                      !isStart ? startTimer(true) : null;
                      isTimeOut = false;
                      isTime = true;
                      Logger.println(' isTime  From Start Button ::: $isTime');
                    } else if (state.data?.timerType ==
                        Strings.time_status[2]) {
                      resumeTime = DateTime.now();
                      isTimeOut = true;
                      Logger.println(
                        'currentStatusTimer when time_status is 2:: $currentStatusTimer',
                      );

                      // currentStatusTimer = Strings.time_status[1];
                      totalSecondCount =
                          totalSecondCount +
                          getCurrentTimeDifference(state.data!);
                      totalMonthWorkingSecond =
                          totalMonthWorkingSecond +
                          getCurrentTimeDifference(state.data!);
                      monthDuration = Duration(
                        seconds: totalMonthWorkingSecond,
                      );
                      !isStart ? startTimer(true) : null;
                      isTime = true;
                      Logger.println(' isTime  From Start Button ::: $isTime');
                    } else if (state.data?.timerType ==
                        Strings.time_status[3]) {
                      Logger.println(
                        'currentStatusTimer when time_status is 3:: $currentStatusTimer',
                      );

                      currentStatusTimer = Strings.time_status[3];
                      isFinalOut = true;
                      stopTimer();
                      isTime = false;
                      Logger.println(' isTime  From Start Button ::: $isTime');
                    }
                  } else {
                    isTime = false;
                  }
                  Logger.printTag(
                    'from set initial before edit event isTime:',
                    isTime.toString(),
                  );
                  setState(() {});
                } else if (state is InsertDataLoaded) {
                  Logger.println('call add Daily report api::');
                  Constant.myLoader.hide();
                  // msgList.add(
                  //     Constant().ShowMessage(state.data!.message!, context));
                  // Constant().show_toast(state.data!.message!, context);
                  if (isFinalOutDone) {
                    MyLocalStorage().delete(LocalStorageKeys.token);
                    MyLocalStorage().delete(LocalStorageKeys.userData);
                    MyLocalStorage().delete(LocalStorageKeys.leaveData);
                    isTime = !isTime;
                    Logger.println(' isTime :::: $isTime');
                    MyLocalStorage().clear();
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      MyRouter.loginRoute,
                      (route) => false,
                    );
                    Constant.myLoader.hide();
                    isFinalOutDone = false;
                  }
                  msgList.add(
                    Constant().ShowMessage(
                      'inserted data id:${state.data}',
                      context,
                    ),
                  );
                  // Constant().ShowToast('${state.data}', context);
                  BlocProvider.of<LocalDatabaseBloc>(context).add(
                    GetAllDataEvent(
                      userId: context
                          .read<PreferenceManagerRepository>()
                          .user!
                          .employeeId,
                    ),
                  );
                  if (MyLocalStorage().getToken() != null) {
                    BlocProvider.of<TimeBloc>(
                      context,
                    ).add(FetchTime(context: context));
                  }

                  Logger.println('insert queries===${state.data}');
                  if (state.data != 0) {
                    Logger.printTag(
                      'Insert Success:',
                      "${state.timeStatus} added at id:${state.data}",
                    );
                  } else {
                    Logger.printTag(
                      'Insert Success:',
                      "${state.timeStatus} added at id:${state.data}",
                    );
                  }
                  setState(() {
                    if (state.timeStatus == Strings.time_status[0]) {
                      !isStart ? startTimer(true) : null;
                      isTime = true;
                      isTimeOut = true;
                      isFinalOut = false;
                      Logger.println(' isTime  From Start Button:::: $isTime');
                    } else if (state.timeStatus == Strings.time_status[1]) {
                      Logger.println("Resume Time :::: $stopTime");
                      isTimeOut = false;
                      isTime = true;
                      isFinalOut = false;
                      Logger.println(
                        'Inter Time Out isTimeOut :::: $isTimeOut',
                      );
                      Logger.println('Inter Time In isTime :::: $isTime');
                    } else if (state.timeStatus == Strings.time_status[2]) {
                      Logger.println("Resume Time :::: $resumeTime");
                      isTimeOut = true;
                      isTime = true;
                      isFinalOut = false;
                      Logger.println(
                        'Inter Time Out isTimeOut :::: $isTimeOut',
                      );
                      Logger.println('Inter Time In isTime :::: $isTime');
                    } else if (state.timeStatus == Strings.time_status[3]) {
                      isFinalOut = true;
                      isTime = false;
                      Logger.println("Resume Time :::: $resumeTime");
                      stopTimer();
                      Logger.println(
                        'Inter Time Out isTimeOut :::: $isTimeOut',
                      );
                      Logger.println('Inter Time In isTime :::: $isTime');
                    }
                  });
                }
              },
            ),
            BlocListener<GetHolidayBloc, GetHolidayState>(
              listener: (context, state) {
                if (state is GetHolidayByMonthLoading) {
                  Constant.myLoader.show(context);
                } else {
                  Constant.myLoader.hide();
                  setState(() {});
                }
                if (state is GetHolidayByMonthError) {
                  // msgList
                  //     .add(Constant().ShowErrorMessage(state.errors, context));
                  Constant.myLoader.hide();
                  Logger.println('error ${state.errors}');
                  if (state.errors ==
                      'No holidays found for the current month.') {
                    holidaysByMonth.clear();
                  }
                } else if (state is GetHolidayByMonthLoaded) {
                  holidaysByMonth.clear();
                  holidaysByMonth = List.generate(
                    state.data.data.length,
                    (index) => state.data.data[index],
                  );

                  Logger.println('holidaysByMonth: $holidaysByMonth');
                }
              },
            ),
            BlocListener<KnowledgeBloc, KnowledgeState>(
              listener: (context, state) {
                if (state is GetKnowledgeLoading) {
                  Constant.myLoader.show(context);
                } else {
                  Constant.myLoader.hide();
                  setState(() {});
                }
                if (state is GetKnowledgeError) {
                  msgList.add(
                    Constant().ShowErrorMessage(state.errors, context),
                  );
                  Constant.myLoader.hide();
                  Logger.println('error ${state.errors}');
                  //Constant().ShowToast(state.errors, context);
                } else if (state is GetKnowledgeLoaded) {
                  knowledgeList.clear();
                  for (int i = 0; i < 5; i++) {
                    if (i < state.data.data.length) {
                      Logger.println("knowledge data :: ${state.data.data[i]}");
                      knowledgeList.add(state.data.data[i]);
                    }
                  }
                  Logger.println('latest knowledge list :: $knowledgeList');
                }
              },
            ),
            BlocListener<MyQuoteBloc, QuoteState>(
              listener: (context, state) {
                if (state is GetQuoteLoading) {
                  Constant.myLoader.show(context);
                } else {
                  Constant.myLoader.hide();
                  setState(() {});
                }
                if (state is GetQuoteError) {
                  msgList.add(
                    Constant().ShowErrorMessage(state.errors, context),
                  );
                  Constant.myLoader.hide();
                  Logger.println('error ${state.errors}');
                  //Constant().ShowToast(state.errors, context);
                } else if (state is GetQuoteLoaded) {
                  quote = null;
                  Random random = Random();
                  quote =
                      state.data.data[random.nextInt(state.data.data.length)];
                }
              },
            ),
            BlocListener<UpdateUiBloc, UpdateUiState>(
              listener: (context, state) {
                if (state is UpdateUiLoading) {
                  Constant.myLoader.show(context);
                } else {
                  Constant.myLoader.hide();
                  setState(() {});
                }
                if (state is UpdateUiError) {
                } else if (state is UpdateUiLoaded) {
                  userData = state.isUpdateUi!;
                  Logger.println('data is userdata :: ${userData.imageUrl}');
                  setState(() {});
                }
              },
            ),
            BlocListener<LastDailyReportBloc, LastDailyReportState>(
              listener: (context, state) {
                if (state is GetLastDailyReportError) {
                  msgList.add(
                    Constant().ShowErrorMessage(state.errors, context),
                  );
                  Constant.myLoader.hide();
                  // Constant().ShowToast(state.errors, context);
                } else if (state is GetLastDailyReportLoaded) {
                  Logger.println("Get Data :::: ${state.data!.data!.date}");
                  msgList.add(
                    Constant().ShowMessage(state.data!.message!, context),
                  );
                  data = state.data!.data;
                  //Constant().ShowToast(state.data!.message!, context);
                  String date = DateFormatter.formateDate(
                    inputFormatter: "yyyy-MM-dd",
                    input: data?.date.toString(),
                    outputFormatter: "dd-MM-yyyy",
                  );

                  String currentDate = DateFormat(
                    'dd-MM-yyyy',
                  ).format(DateTime.now());
                  Logger.println(
                    'date :: $date && current date :: $currentDate',
                  );
                  if (currentDate == date) {
                    isLastReportAdded = true;
                  }
                  setState(() {});
                }
              },
            ),
          ],
          child: AdaptiveScaffold(
            leadingUnextendedNavRail: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 10,
                left: 5,
                right: 5,
              ),
              child: Center(child: Assets.images.drawerHeaderRoundLogo.image()),
            ),
            trailingUnExtendedNavRail: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Constant.colorSelectedIndicator,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 8,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  child: const Text(
                    "${Api.baseurl == 'https://timeclock.oceanbitsolutions.com' ? 'Live' : 'Dev'} 1.0.3",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            trailingNavRail: Column(
              children: [
                Container(
                  width: 230,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Constant.colorSelectedIndicator,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 8,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "${Api.baseurl == 'https://timeclock.oceanbitsolutions.com' ? 'Live' : 'Dev'} : 1.0.3",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Constant.paddingHalf.heightBox,
              ],
            ),
            leadingExtendedNavRail: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Center(child: Assets.images.drawerHeaderLogo.image()),
            ),
            smallBreakpoint: const WidthPlatformBreakpoint(end: 600),
            mediumBreakpoint: const WidthPlatformBreakpoint(
              begin: 600,
              end: 1200,
            ),
            largeBreakpoint: const WidthPlatformBreakpoint(begin: 1200),
            useDrawer: true,
            selectedIndex: selectedIndex,
            onSelectedIndexChangeForCloseDrawer: (index) {
              setState(() {
                selectedIndex = index;
                Navigator.pop(context);
              });
            },
            onSelectedIndexChange: (index) {
              setState(() {
                selectedIndex = index;
                Logger.println('selectedIndex :: $selectedIndex');
                if (index == 0) {
                  BlocProvider.of<TimeBloc>(
                    context,
                  ).add(FetchCurrentMonthChartData(context: context));
                  BlocProvider.of<GetHolidayBloc>(
                    context,
                  ).add(FetchHolidayByMonth(context: context));
                  BlocProvider.of<KnowledgeBloc>(
                    context,
                  ).add(FetchKnowledge(context: context));
                  BlocProvider.of<MyQuoteBloc>(
                    context,
                  ).add(GetQuoteEvent(context: context));
                  BlocProvider.of<BirthdayListBloc>(context).add(
                    FetchUserBirthdayEvent(
                      context: context,
                      month: DateTime.now().month.toString(),
                    ),
                  );
                }
                if (index == 7) {
                  context.read<GetDailyReportRepository>().month =
                      DateTime.now().month;
                  context.read<GetDailyReportRepository>().page = 1;
                  setState(() {});
                  //context.read<GetDailyReportRepository>().clearReportList();
                  BlocProvider.of<GetDailyReportBloc>(
                    context,
                  ).add(FetchGetDailyReport(context: context));
                }
              });
              if (preferenceManagerRepository.user?.isAdmin == true) {
                if (index == 18) {
                  MyLocalStorage().clear();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    MyRouter.loginRoute,
                    (route) => false,
                  );
                }
              } else {
                if (index == 14) {
                  MyLocalStorage().clear();
                  stopTimer();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    MyRouter.loginRoute,
                    (route) => false,
                  );
                }
              }
              if (MediaQuery.of(context).size <= const Size(600, 600)) {
                Navigator.pop(context);
              }
              current.isProfileDetail = false;
              past.isProfileDetail = false;
            },
            destinations: employeeDrawerItemList,
            largeBody: (_) => LargeBodyWidget(
              selectedIndex: selectedIndex,
              dashboardWidget: dashboardMainWidget(
                context,
                rowSegment: 4,
                sizeTag: 3,
              ),
              timerWidget: customHeaderTimerContainer(),
            ),
            body: (_) => MediumBodyWidget(
              selectedIndex: selectedIndex,
              dashboardWidget: dashboardMainWidget(
                context,
                rowSegment: 2,
                sizeTag: 2,
              ),
              timerWidget: smallCustomHeaderTimerContainer(),
            ),
            smallBody: (_) => MediumBodyWidget(
              selectedIndex: selectedIndex,
              isSmall: true,
              dashboardWidget: dashboardMainWidget(
                context,
                rowSegment: 1,
                sizeTag: 1,
              ),
              timerWidget: smallCustomHeaderTimerContainer(),
            ),
          ),
        ),
      ),
    );
  }

  Widget customHeaderTimerContainer() {
    return ResponsiveGridRow(
      rowSegments: 1,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveGridCol(
          lg: 1,
          xs: 1,
          md: 1,
          sm: 1,
          child: Padding(
            padding: const EdgeInsets.only(
              top: Constant.paddingHalf,
              left: Constant.paddingHalf,
              right: Constant.paddingHalf,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: CustomCardView(
                      child: Padding(
                        padding: const EdgeInsets.all(Constant.paddingHalf),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // width: MediaQuery.of(context).size.width*0.4,
                              padding: const EdgeInsets.symmetric(
                                vertical: Constant.paddingHalf,
                                horizontal: Constant.paddingHalf,
                              ),
                              // color: Constant.cGreenDark.withOpacity(0.5),
                              child: buildTime(),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      Strings.welcome,
                                      style: Constant.textStyleSize25(context)
                                          ?.copyWith(
                                            color:
                                                Constant.colorSelectedIndicator,
                                          ),
                                      textAlign: TextAlign.end,
                                    ),
                                    Text(
                                      '${userData.firstName} ${userData.lastName}',
                                      style: Constant.textStyleSize20(
                                        context,
                                      )?.copyWith(color: Constant.cBlack),
                                      textAlign: TextAlign.end,
                                    ),
                                    Text(
                                      userData.email,
                                      style: Constant.textStyleSize16(
                                        context,
                                      )?.copyWith(color: Constant.cBlack),
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                                Constant.paddingHalf.widthBox,
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Constant.cWhite,
                                  child: CircleAvatar(
                                    radius: 29,
                                    backgroundImage: NetworkImage(
                                      "${Api.baseurl}${userData.imageUrl}",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget smallCustomHeaderTimerContainer() {
    return ResponsiveGridRow(
      rowSegments: 1,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveGridCol(
          lg: 1,
          xs: 1,
          md: 1,
          sm: 1,
          child: Padding(
            padding: const EdgeInsets.only(
              top: Constant.paddingHalf,
              left: Constant.paddingHalf,
              right: Constant.paddingHalf,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(Constant.paddingHalfHalf),
                    child: CustomCardView(
                      child: Padding(
                        padding: const EdgeInsets.all(Constant.paddingHalf),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      Strings.welcome,
                                      style: Constant.textStyleSize25(context)
                                          ?.copyWith(
                                            color:
                                                Constant.colorSelectedIndicator,
                                          ),
                                      textAlign: TextAlign.end,
                                    ),
                                    Text(
                                      '${userData.firstName} ${userData.lastName}',
                                      style: Constant.textStyleSize18(
                                        context,
                                      )?.copyWith(color: Constant.cBlack),
                                      textAlign: TextAlign.end,
                                    ),
                                    Text(
                                      userData.email,
                                      style: Constant.textStyleSize16(
                                        context,
                                      )?.copyWith(color: Constant.cBlack),
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                                Constant.paddingHalf.widthBox,
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Constant.cWhite,
                                  child: CircleAvatar(
                                    radius: 29,
                                    backgroundImage: NetworkImage(
                                      "${Api.baseurl}${userData.imageUrl}",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Constant.paddingHalf.heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                      Constant.paddingHalf,
                                    ),
                                    child: buildTime(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTime() {
    // String twoDigits(int n) => n.toString().padLeft(2, '0');
    duration = Duration(seconds: totalSecondCount);
    Logger.println("Duration :: $duration");

    hour = twoDigits(duration.inHours);
    Logger.println('Hours From Build Time: $hour');
    minutes = twoDigits(duration.inMinutes.remainder(60));
    seconds = twoDigits(duration.inSeconds.remainder(60));
    interMediateDuration = Duration(seconds: totalInterMediateSecondCount);
    Logger.println("InterMediate Duration :: $interMediateDuration");
    interMediateHour = twoDigits(interMediateDuration.inHours);
    interMediateMinutes = twoDigits(
      interMediateDuration.inMinutes.remainder(60),
    );
    interMediateSeconds = twoDigits(
      interMediateDuration.inSeconds.remainder(60),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "${Strings.total} - ",
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontSize: Constant.textSize16,
            color: Colors.black,
          ),
        ),
        SizedBox(
          width: 22,
          child: Text(
            hour!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.black,
              fontSize: Constant.textSize16,
            ),
          ),
        ),
        const SizedBox(width: 2),
        Text(
          ":",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: Constant.textSize16,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 2),
        SizedBox(
          width: 22,
          child: Text(
            minutes!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: Constant.textSize16,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 2),
        Text(
          ":",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: Constant.textSize16,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 2),
        SizedBox(
          width: 22,
          child: Text(
            seconds!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: Constant.textSize16,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: Constant.padding),
        Text(
          "${Strings.intermediate} - ",
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Colors.black,
            fontSize: Constant.textSize16,
          ),
        ),
        SizedBox(
          width: 22,
          child: Text(
            interMediateHour!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: Constant.textSize16,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 2),
        Text(
          ":",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: Constant.textSize16,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 2),
        SizedBox(
          width: 22,
          child: Text(
            interMediateMinutes!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: Constant.textSize16,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 2),
        Text(
          ":",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: Constant.textSize16,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 2),
        SizedBox(
          width: 22,
          child: Text(
            interMediateSeconds!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: Constant.textSize16,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 5),
      ],
    );
  }

  Widget dashboardMainWidget(
    BuildContext context, {
    required int rowSegment,
    required int sizeTag,
  }) {
    double height = MediaQuery.of(context).size.height / 3.5;
    return SingleChildScrollView(
      child: ResponsiveGridRow(
        rowSegments: rowSegment,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Your Timing
          ResponsiveGridCol(
            lg: 1,
            xs: 1,
            md: 1,
            sm: 1,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: BlocListener<AddDailyReportBloc, AddDailyReportState>(
                listener: (context, state) async {
                  if (state is AddDailyReportError) {
                    Constant.myLoader.hide();
                    msgList.add(
                      Constant().ShowErrorMessage(state.errors, context),
                    );
                    Constant().show_toast(state.errors, context);
                    if (state.errors.toString().contains(
                      "Today daily report already added, Please contact Admin",
                    )) {
                      Navigator.pop(context);
                    }
                  } else if (state is AddDailyReportLoaded) {
                    context.read<LocalDatabaseBloc>().add(
                      GetAllDataEvent(
                        userId: context
                            .read<PreferenceManagerRepository>()
                            .user!
                            .employeeId,
                      ),
                    );
                    Logger.println(
                      'currentStatusTimer when final out:: $currentStatusTimer',
                    );
                    currentStatusTimer = Strings.time_status[3];
                    getSessionTime(
                      context,
                      previousTimeStatus: Strings.time_status[1],
                      currentTimeStatus: Strings.time_status[3],
                    );
                    isFinalOutDone = true;
                    // Logger.println('call add Daily report api::');
                    // Constant.myLoader.hide();
                    // msgList.add(
                    //     Constant().ShowMessage(state.data!.message!, context));
                    // Constant().show_toast(state.data!.message!, context);
                    // MyLocalStorage().delete(LocalStorageKeys.token);
                    // MyLocalStorage().delete(LocalStorageKeys.userData);
                    // MyLocalStorage().delete(LocalStorageKeys.leaveData);
                    // isTime = !isTime;
                    // Logger.println(' isTime :::: $isTime');
                    // MyLocalStorage().clear();
                    // Navigator.pop(context);
                    // Navigator.pushNamedAndRemoveUntil(
                    //     context, MyRouter.loginRoute, (route) => false);
                    // Constant.myLoader.hide();
                  }
                },
                child: CustomContainer(
                  rowSegment: rowSegment,
                  headerText: Strings.yourTiming.toUpperCase(),
                  headerTextColor: Constant.cBlack,
                  color: Constant.colorSelectedIndicator,
                  //Constant.cCyanDark,
                  height: height,
                  child: timerButtonWidget(context, rowSegment),
                ),
              ),
            ),
          ),

          ///Total Time and InterMediateTime  Time
          ResponsiveGridCol(
            lg: 1,
            xs: 1,
            md: 1,
            sm: 1,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                height: height,
                child: Column(
                  children: [
                    ///Total Time
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: CustomContainer(
                          rowSegment: rowSegment,
                          headerText: Strings.totalTime.toUpperCase(),
                          color: Constant.cGreenLight,
                          width: MediaQuery.of(context).size.width,
                          child: Expanded(
                            child: SingleChildScrollView(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 80 /*rowSegment>2?80:65*/,
                                    child: Text(
                                      totalWorkingTime.split(":")[0],
                                      textAlign: TextAlign.center,
                                      style: rowSegment == 4
                                          ? Constant.textStyleSize35(
                                              context,
                                            )?.copyWith(
                                              color: Constant.cGreenLight,
                                              fontWeight: FontWeight.w500,
                                            )
                                          : Constant.textStyleSize32(
                                              context,
                                            )?.copyWith(
                                              color: Constant.cGreenLight,
                                              fontWeight: FontWeight.w500,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    ":",
                                    style: rowSegment == 4
                                        ? Constant.textStyleSize35(
                                            context,
                                          )?.copyWith(
                                            color: Constant.cGreenLight,
                                            fontWeight: FontWeight.w500,
                                          )
                                        : Constant.textStyleSize32(
                                            context,
                                          )?.copyWith(
                                            color: Constant.cGreenLight,
                                            fontWeight: FontWeight.w500,
                                          ),
                                  ),
                                  const SizedBox(width: 2),
                                  SizedBox(
                                    width: 55,
                                    child: Text(
                                      totalWorkingTime.split(":")[1],
                                      textAlign: TextAlign.center,
                                      style: rowSegment == 4
                                          ? Constant.textStyleSize35(
                                              context,
                                            )?.copyWith(
                                              color: Constant.cGreenLight,
                                              fontWeight: FontWeight.w500,
                                            )
                                          : Constant.textStyleSize32(
                                              context,
                                            )?.copyWith(
                                              color: Constant.cGreenLight,
                                              fontWeight: FontWeight.w500,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    ":",
                                    style: rowSegment == 4
                                        ? Constant.textStyleSize35(
                                            context,
                                          )?.copyWith(
                                            color: Constant.cGreenLight,
                                            fontWeight: FontWeight.w500,
                                          )
                                        : Constant.textStyleSize32(
                                            context,
                                          )?.copyWith(
                                            color: Constant.cGreenLight,
                                            fontWeight: FontWeight.w500,
                                          ),
                                  ),
                                  const SizedBox(width: 2),
                                  SizedBox(
                                    width: 55,
                                    child: Text(
                                      totalWorkingTime.split(":")[2],
                                      textAlign: TextAlign.center,
                                      style: rowSegment == 4
                                          ? Constant.textStyleSize35(
                                              context,
                                            )?.copyWith(
                                              color: Constant.cGreenLight,
                                              fontWeight: FontWeight.w500,
                                            )
                                          : Constant.textStyleSize32(
                                              context,
                                            )?.copyWith(
                                              color: Constant.cGreenLight,
                                              fontWeight: FontWeight.w500,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    ///Intermediate
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 7),
                        child: CustomContainer(
                          rowSegment: rowSegment,
                          headerText: Strings.intermediateTime.toUpperCase(),
                          color: Constant.cRedLight,
                          width: MediaQuery.of(context).size.width,
                          child: Expanded(
                            child: SingleChildScrollView(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 80, //55,
                                    child: Text(
                                      totalInterMediateTime.split(":")[0],
                                      textAlign: TextAlign.center,
                                      style: rowSegment == 4
                                          ? Constant.textStyleSize35(
                                              context,
                                            )?.copyWith(
                                              color: Constant.cRedLight,
                                              fontWeight: FontWeight.w500,
                                            )
                                          : Constant.textStyleSize32(
                                              context,
                                            )?.copyWith(
                                              color: Constant.cRedLight,
                                              fontWeight: FontWeight.w500,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    ":",
                                    style: rowSegment == 4
                                        ? Constant.textStyleSize35(
                                            context,
                                          )?.copyWith(
                                            color: Constant.cRedLight,
                                            fontWeight: FontWeight.w500,
                                          )
                                        : Constant.textStyleSize32(
                                            context,
                                          )?.copyWith(
                                            color: Constant.cRedLight,
                                            fontWeight: FontWeight.w500,
                                          ),
                                  ),
                                  const SizedBox(width: 2),
                                  SizedBox(
                                    width: 55,
                                    child: Text(
                                      totalInterMediateTime.split(":")[1],
                                      textAlign: TextAlign.center,
                                      style: rowSegment == 4
                                          ? Constant.textStyleSize35(
                                              context,
                                            )?.copyWith(
                                              color: Constant.cRedLight,
                                              fontWeight: FontWeight.w500,
                                            )
                                          : Constant.textStyleSize32(
                                              context,
                                            )?.copyWith(
                                              color: Constant.cRedLight,
                                              fontWeight: FontWeight.w500,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    ":",
                                    style: rowSegment == 4
                                        ? Constant.textStyleSize35(
                                            context,
                                          )?.copyWith(
                                            color: Constant.cRedLight,
                                            fontWeight: FontWeight.w500,
                                          )
                                        : Constant.textStyleSize32(
                                            context,
                                          )?.copyWith(
                                            color: Constant.cRedLight,
                                            fontWeight: FontWeight.w500,
                                          ),
                                  ),
                                  const SizedBox(width: 2),
                                  SizedBox(
                                    width: 55,
                                    child: Text(
                                      totalInterMediateTime.split(":")[2],
                                      textAlign: TextAlign.center,
                                      style: rowSegment == 4
                                          ? Constant.textStyleSize35(
                                              context,
                                            )?.copyWith(
                                              color: Constant.cRedLight,
                                              fontWeight: FontWeight.w500,
                                            )
                                          : Constant.textStyleSize32(
                                              context,
                                            )?.copyWith(
                                              color: Constant.cRedLight,
                                              fontWeight: FontWeight.w500,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          ///Your timing for this month timing
          ResponsiveGridCol(
            lg: 2,
            xs: 2,
            md: 2,
            sm: 2,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: CustomContainer(
                rowSegment: rowSegment,
                headerText: Strings.yourTimingForMonth.toUpperCase(),
                isHeaderInStart: sizeTag <= 2 ? false : true,
                color: Constant.cGreenLight,
                height: height,
                child: /*context
                          .read<MonthlyReportRepository>()
                          .monthlyReportList
                          .isNotEmpty||*/
                    timeSlotData != null && timeSlotData!.isNotEmpty
                    ? Expanded(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              right: 20,
                              top: -30,
                              child: SizedBox(
                                //width: MediaQuery.of(context).size.width*0.8,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    labelWidget(
                                      context,
                                      Constant.cGreenLight,
                                      "Working Hours",
                                      Assets.images.barIconGreen.svg(
                                        width: 15,
                                        height: 15,
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width *
                                          0.003),
                                    ),
                                    labelWidget(
                                      context,
                                      Constant.cRedLight,
                                      "Break Hours",
                                      Assets.images.barIconRed.svg(
                                        width: 15,
                                        height: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            timeSlotData != null && timeSlotData!.isNotEmpty
                                ? ChartWidget(
                                    timeSlotList: timeSlotData,
                                    rowSegment: rowSegment,
                                  )
                                : Expanded(
                                    child: Center(
                                      child: Text(
                                        Strings.noDataFoundForChart,
                                        style: Constant.textStyleSize13(context)
                                            ?.copyWith(
                                              color: Constant.cGreenLight,
                                            ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: Center(
                          child: Text(
                            Strings.noDataFoundForChart,
                            style: Constant.textStyleSize13(
                              context,
                            )?.copyWith(color: Constant.cGreenLight),
                          ),
                        ),
                      ),
              ),
              // }),
            ),
          ),

          ///Busy or Free
          ResponsiveGridCol(
            lg: 1,
            xs: 1,
            md: 1,
            sm: 1,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: CustomContainer(
                rowSegment: rowSegment,
                headerText: Strings.busyOrFree.toUpperCase(),
                color: Constant.cPinkLight,
                height: height,
                child: Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: rowSegment == 4
                              ? MediaQuery.of(context).size.width / 20
                              : rowSegment == 2
                              ? MediaQuery.of(context).size.width / 8
                              : MediaQuery.of(context).size.width / 3,
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Constant.cWhite,
                              border: Border.all(color: Constant.cPinkLight),
                            ),
                            height: 35,
                            //width: MediaQuery.of(context).size.width / 10,
                            // padding: EdgeInsets.symmetric(vertical: Constant.paddingHalf,horizontal: Constant.paddingHalfHalf),
                            child: Center(
                              child: Text(
                                Strings.busy,
                                style: Constant.textStyleSize20(context)!
                                    .copyWith(
                                      color: Constant.cPinkLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          ///Latest knowledgeBase
          ResponsiveGridCol(
            lg: 1,
            xs: 1,
            md: 1,
            sm: 1,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = 6;
                  });
                },
                child: CustomContainer(
                  rowSegment: rowSegment,
                  headerText: Strings.latestKnowledgeBase.toUpperCase(),
                  color: Constant.cBlueMedium,
                  height: height,
                  child: Expanded(child: latestKnowledgeBaseListView()),
                ),
              ),
            ),
          ),

          ///Quote of the day
          ResponsiveGridCol(
            lg: 2,
            xs: 2,
            md: 2,
            sm: 2,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: CustomContainer(
                rowSegment: rowSegment,
                headerText: Strings.quoteOfDay.toUpperCase(),
                color: Constant.cPurpleDark,
                height: height,
                child: Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Constant.paddingDouble,
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          quote != null ? quote!.quotes : Strings.quote,
                          textAlign: TextAlign.center,
                          style: Constant.textStyleSize15(context)!.copyWith(
                            color: Constant.cPurpleDark,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          ///Warning
          ResponsiveGridCol(
            lg: 1,
            xs: 1,
            md: 1,
            sm: 1,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: CustomContainer(
                rowSegment: rowSegment,
                headerText: Strings.warning.toUpperCase(),
                color: Constant.cCyanDark,
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Constant.padding.heightBox,
                    //(MediaQuery.of(context).size.height / 20).heightBox,
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Constant.paddingMidDouble,
                        vertical: Constant.paddingHalfHalf,
                      ),
                      child: Text(
                        "${Strings.internetMissUseCount} : $missUseCounter",
                        style: Constant.textStyleSize15(context)!.copyWith(
                          color: Constant.cCyanDark,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return LateArrivalDialog(
                              initialTimeSlotList,
                              sizeTag: sizeTag,
                            );
                          },
                        );
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                          horizontal: Constant.paddingMidDouble,
                          vertical: Constant.paddingHalfHalf,
                        ),
                        child: Text(
                          "${Strings.lateArrivalCount} : $lateArrivalCounter ${Strings.days}",
                          style: Constant.textStyleSize15(context)!.copyWith(
                            color: Constant.cCyanDark,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          ///Holiday in this month
          ResponsiveGridCol(
            lg: 1,
            xs: 1,
            md: 1,
            sm: 1,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = 5;
                  });
                },
                child: CustomContainer(
                  rowSegment: rowSegment,
                  headerText: Strings.holidaysInMonth.toUpperCase(),
                  color: Constant.cBlue,
                  height: height,
                  child: holidaysByMonth.isEmpty
                      ? Flexible(
                          child: Center(
                            child: Text(
                              Strings.noHoliday,
                              style: Constant.textStyleSize15(context)!
                                  .copyWith(
                                    color: Constant.cBlue,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ),
                        )
                      : Expanded(child: holidayListView()),
                ),
              ),
            ),
          ),

          ///Last Status Report
          ResponsiveGridCol(
            lg: 1,
            xs: 1,
            md: 1,
            sm: 1,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: CustomContainer(
                rowSegment: rowSegment,
                headerText: Strings.lastStatueReport.toUpperCase(),
                color: Constant.cCyanLight,
                height: height,
                child: data?.date == null
                    ? Expanded(
                        child: Center(
                          child: Text(
                            Strings.noDataFound,
                            style: Constant.textStyleSize15(context)!.copyWith(
                              color: Constant.cCyanLight,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: Constant.paddingMidDouble,
                                right: Constant.paddingMidDouble,
                                bottom: Constant.paddingHalf,
                              ),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Date  : ${DateFormatter.formateDate(inputFormatter: "yyyy-MM-dd", input: data?.date.toString(), outputFormatter: "dd-MM-yyyy")}",
                                  style: Constant.textStyleSize15(context)!
                                      .copyWith(
                                        color: Constant.cCyanLight,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: lastStatusRepostListView(data?.reportText),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),

          ///Birthday in this month
          ResponsiveGridCol(
            lg: 1,
            xs: 1,
            md: 1,
            sm: 1,
            child: BlocProvider<BirthdayListBloc>(
              create: (context) => BirthdayListBloc()
                ..add(
                  FetchUserBirthdayEvent(
                    context: context,
                    month: DateTime.now().month.toString(),
                  ),
                ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: BlocListener<BirthdayListBloc, BirthdayListState>(
                  listener: (context, state) {
                    if (state is UserBirthdayLoadedState) {
                      birthDayList = state.data?.data ?? [];
                      Logger.println("Birthday List::$birthDayList");
                    } else if (state is UserBirthdayErrorState) {
                      msgList.add(
                        Constant().ShowErrorMessage(state.error, context),
                      );
                      Constant.myLoader.hide();
                      //Constant().ShowToast(state.error, context);
                    }
                    setState(() {});
                  },
                  child: CustomContainer(
                    rowSegment: rowSegment,
                    headerText: Strings.birthdayInMonth.toUpperCase(),
                    color: Constant.cPinkDark,
                    height: height,
                    child: birthDayList.isEmpty
                        ? Flexible(
                            child: Center(
                              child: Text(
                                Strings.noData,
                                style: Constant.textStyleSize15(context)!
                                    .copyWith(
                                      color: Constant.cPinkDark,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                    top: Constant.paddingHalf,
                                    left: Constant.paddingMidDouble,
                                    right: Constant.paddingMidDouble,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Strings.name,
                                        style: Constant.textStyleSize20(context)
                                            ?.copyWith(
                                              color: Constant.cPinkDark,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      Text(
                                        Strings.birthdate,
                                        style: Constant.textStyleSize20(context)
                                            ?.copyWith(
                                              color: Constant.cPinkDark,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(child: birthdayList()),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  birthdayList() {
    return Expanded(
      child: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: birthDayList.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.only(
                top: Constant.paddingHalf,
                bottom: Constant.paddingHalf,
                left: Constant.paddingMidDouble,
                right: Constant.paddingMidDouble,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: RichText(
                      softWrap: true,
                      overflow: TextOverflow.clip,
                      text: TextSpan(
                        text:
                            '${birthDayList[index].firstName} ${birthDayList[index].lastName}',
                        style: Constant.textStyleSize15(context)?.copyWith(
                          color: Constant.cPinkDark,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      DateFormatter.formateDate(
                        inputFormatter: "dd-MM-yyyy",
                        input: birthDayList[index].personalData?.dob,
                        outputFormatter: "dd MMMM",
                      ),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: Constant.textStyleSize15(context)?.copyWith(
                        color: Constant.cPinkDark,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget labelWidget(
    BuildContext context,
    Color color,
    String text,
    Widget icon,
  ) {
    return Column(
      children: [
        /* text=="Break Hours"?Icon(Icons.bar_chart, color: color)
        :Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: Icon(Icons.bar_chart, color: color),
        ),*/
        icon,
        //SizedBox(height:10),
        Text(
          text,
          style: TextStyle(fontSize: Constant.textSize9, color: color),
        ),
      ],
    );
  }

  holidayListView() {
    return holidaysByMonth.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: holidaysByMonth.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.only(
                  top: Constant.paddingHalf,
                  left: Constant.paddingMidDouble,
                  right: Constant.paddingMidDouble,
                  bottom: Constant.paddingHalf,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // bulletPoint(color: Constant.cBlue),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: bulletPoint(color: Constant.cBlue),
                    ),
                    Constant.paddingHalf.widthBox,
                    Flexible(
                      flex: 1,
                      child: Text(
                        holidaysByMonth[index].isMulti == 0
                            ? "${date(date: holidaysByMonth[index].startDate)} ${holidaysByMonth[index].holidayType.name}"
                            : "${date(date: holidaysByMonth[index].startDate)} to ${date(date: holidaysByMonth[index].endDate)} ${holidaysByMonth[index].holidayType.name}",
                        softWrap: true,
                        overflow: TextOverflow.fade,
                        style: Constant.textStyleSize14(context)?.copyWith(
                          color: Constant.cBlue,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        : Flexible(
            child: Center(
              child: Text(
                Strings.noData,
                style: Constant.textStyleSize15(
                  context,
                )!.copyWith(color: Constant.cBlue, fontWeight: FontWeight.w400),
              ),
            ),
          );
  }

  lastStatusRepostListView(String? reportText) {
    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: Constant.paddingMidDouble,
            right: Constant.paddingMidDouble,
            bottom: Constant.paddingHalf,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: Constant.padding8),
                child: bulletPoint(color: Constant.cCyanLight),
              ),
              Constant.paddingHalf.widthBox,
              Flexible(
                child: RichText(
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  text: TextSpan(
                    text: reportText != null ? data?.reportText : "-",
                    style: Constant.textStyleSize15(context)!.copyWith(
                      color: Constant.cCyanLight,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  latestKnowledgeBaseListView() {
    return knowledgeList.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: knowledgeList.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(Constant.paddingHalf),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: bulletPoint(color: Constant.cBlue),
                    ),
                    Constant.paddingHalfHalf.widthBox,
                    Flexible(
                      child: RichText(
                        softWrap: true,
                        overflow: TextOverflow.fade,
                        text: TextSpan(
                          text: knowledgeList[index].title,
                          style: Constant.textStyleSize15(context)?.copyWith(
                            color: Constant.cBlueMedium,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        : Flexible(
            child: Center(
              child: Text(
                Strings.noData,
                style: Constant.textStyleSize15(context)!.copyWith(
                  color: Constant.cBlueMedium,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
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
      decoration: BoxDecoration(
        color: color ?? Colors.black54,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget timerButtonWidget(BuildContext context, int rowSegment) {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isTime
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: isTimeOut
                          ? () {
                              BlocProvider.of<LocalDatabaseBloc>(context).add(
                                GetAllDataEvent(
                                  userId: context
                                      .read<PreferenceManagerRepository>()
                                      .user!
                                      .employeeId,
                                ),
                              );

                              ///Inter Time Out Tap
                              stopTime = DateTime.now();
                              Logger.println("Resume Time :::: $resumeTime");
                              Logger.println(
                                'currentStatusTimer when change status on tap button interOutTime:: $currentStatusTimer',
                              );

                              currentStatusTimer = Strings.time_status[1];
                              getSessionTime(
                                context,
                                previousTimeStatus: resumeTime != null
                                    ? Strings.time_status[2]
                                    : Strings.time_status[0],
                                currentTimeStatus: Strings.time_status[1],
                              );
                            }
                          : () {
                              BlocProvider.of<LocalDatabaseBloc>(context).add(
                                GetAllDataEvent(
                                  userId: context
                                      .read<PreferenceManagerRepository>()
                                      .user!
                                      .employeeId,
                                ),
                              );

                              ///Inter Time In Tap
                              resumeTime = DateTime.now();
                              if (getTimeDifference()! < 1) {
                                Logger.println(
                                  'Inter Time In isTime :::: $isTime',
                                );
                                Logger.println(
                                  'Inter Time In isTimeOut :::: $isTimeOut',
                                );
                                Logger.println(
                                  'currentStatusTimer when change status on tap button interInTime:: $currentStatusTimer',
                                );

                                currentStatusTimer = Strings.time_status[2];
                                getSessionTime(
                                  context,
                                  previousTimeStatus: Strings.time_status[1],
                                  currentTimeStatus: Strings.time_status[2],
                                );
                              } else {
                                breakReasonController.clear();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext ctx) {
                                    return StatefulBuilder(
                                      builder: (ctx, menuSetState) {
                                        return Form(
                                          key: _formKey,
                                          autovalidateMode: _autoValidate
                                              ? AutovalidateMode
                                                    .onUserInteraction
                                              : AutovalidateMode.disabled,
                                          child: CustomDialog(
                                            maxLine: 10,
                                            validationString:
                                                "Please Enter break reason",
                                            hintText: "Enter break reason",
                                            onTapTextField: () {
                                              menuSetState(() {});
                                            },
                                            onChanged: (val) {},
                                            onTapButton: () {
                                              menuSetState(() {
                                                BlocProvider.of<LocalDatabaseBloc>(
                                                  context,
                                                ).add(
                                                  GetAllDataEvent(
                                                    userId: context
                                                        .read<
                                                          PreferenceManagerRepository
                                                        >()
                                                        .user!
                                                        .employeeId,
                                                  ),
                                                );
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  Logger.println(
                                                    'Inter Time In isTimeOut2 :::: $isTimeOut',
                                                  );
                                                  Logger.println(
                                                    'currentStatusTimer when change status on tap button interInTime without Dialog:: $currentStatusTimer',
                                                  );

                                                  currentStatusTimer =
                                                      Strings.time_status[2];
                                                  getSessionTime(
                                                    context,
                                                    previousTimeStatus:
                                                        Strings.time_status[1],
                                                    currentTimeStatus:
                                                        Strings.time_status[2],
                                                  );
                                                  Navigator.pop(context);
                                                } else {
                                                  _autoValidate = true;
                                                }
                                              });
                                            },
                                            controller: breakReasonController,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                            },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Constant.cGreenLight,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          height: 35,
                          width: 150,
                          // width: MediaQuery.of(context).size.width / 10,
                          child: Center(
                            child: Text(
                              isTimeOut
                                  ? Strings.interOutTime
                                  : Strings.interInTime,
                              style: Constant.textStyleSize15(context)!
                                  .copyWith(
                                    color: Constant.cWhite,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Constant.paddingHalf.heightBox,
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (currentStatusTimer == Strings.time_status[2]) {
                            taskController.clear();
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return StatefulBuilder(
                                  builder: (ctx, menuSetState) {
                                    return Form(
                                      key: _formKey,
                                      autovalidateMode: _autoValidate
                                          ? AutovalidateMode.onUserInteraction
                                          : AutovalidateMode.disabled,
                                      child: CustomDialog(
                                        isCancel: true,
                                        maxLine: 15,
                                        validationString: "Please Enter Task",
                                        hintText: "Enter Today Task",
                                        onTapTextField: () {
                                          menuSetState(() {});
                                        },
                                        onChanged: (val) {},
                                        onTapButton: () {
                                          Logger.println(
                                            "Total add time :: $hour:$minutes",
                                          );
                                          menuSetState(() async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              if (taskController.text.length >=
                                                  10) {
                                                // context
                                                //     .read<LocalDatabaseBloc>()
                                                //   .add(GetAllDataEvent(
                                                //       userId: context
                                                //           .read<
                                                //               PreferenceManagerRepository>()
                                                //           .user!
                                                //           .employeeId!));
                                                // // BlocProvider.of<
                                                // //             LocalDatabaseBloc>(
                                                // //         context)
                                                // //     .add(GetAllDataEvent(
                                                // //         userId: context
                                                // //             .read<
                                                // //                 PreferenceManagerRepository>()
                                                // //             .user!
                                                // //             .employeeId!));
                                                // print(
                                                //     'currentStatusTimer when final out:: $currentStatusTimer');
                                                //
                                                // currentStatusTimer =
                                                //     Strings.time_status[3];
                                                // await getSessionTime(
                                                //   context,
                                                //   previousTimeStatus:
                                                //       Strings.time_status[1],
                                                //   currentTimeStatus:
                                                //       Strings.time_status[3],
                                                // );

                                                BlocProvider.of<AddDailyReportBloc>(
                                                  context,
                                                ).add(
                                                  AddReportEvent(
                                                    context: context,
                                                    reportText:
                                                        taskController.text,
                                                    totalTime:
                                                        '$hour:$minutes:$seconds',
                                                    intermediateTime:
                                                        '$interMediateHour:$interMediateMinutes:$interMediateSeconds',
                                                  ),
                                                );
                                              } else {
                                                Constant().show_toast(
                                                  'The report text must be at least 10 characters.',
                                                  context,
                                                );
                                              }
                                              Logger.println(
                                                'call add Daily report api::',
                                              );
                                            } else {
                                              _autoValidate = true;
                                            }
                                          });
                                        },
                                        controller: taskController,
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          } else {
                            msgList.add(
                              Constant().ShowErrorMessage(
                                'Please ${Strings.time_status[2]} First',
                                context,
                              ),
                            );
                            Constant().show_toast(
                              'Please inter out first',
                              context,
                            );
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Constant.cRedLight,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          //color: Colors.redAccent,
                          height: 35,
                          width: 150,
                          //  width: MediaQuery.of(context).size.width / 10,
                          child: Center(
                            child: Text(
                              Strings.finalOutTime,
                              style: Constant.textStyleSize15(context)!
                                  .copyWith(
                                    color: Constant.cWhite,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: GestureDetector(
                    onTap: !isFinalOut && !isLastReportAdded
                        ? () async {
                            Logger.println(
                              'currentStatusTimer when start:: $currentStatusTimer',
                            );

                            currentStatusTimer = Strings.time_status[0];
                            /*BlocProvider.of<LocalDatabaseBloc>(context).add(
                                InsertDataEvent(
                                    context: context,
                                    status: Strings.time_status[0],
                                    timeData: DateTime.now(),
                                    sessionTime: '00:00:00',
                                isSync: false));*/
                            tempTimeData = {
                              'status': Strings.time_status[0],
                              'time': DateTime.now(),
                              'sessionTime': '00:00:00',
                            };
                            BlocProvider.of<TimeBloc>(context).add(
                              AddTimeSlotEvent(
                                context: context,
                                timerStatus: Strings.time_status[0],
                                dateTime: DateTime.now().toString(),
                              ),
                            );
                          }
                        : () {
                            Constant().show_toast(
                              'Only one time of day you are start time',
                              context,
                            );
                          },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Constant.cGreenLight,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 35,
                        width: 150,
                        //width: MediaQuery.of(context).size.width / 7,
                        child: Center(
                          child: Text(
                            Strings.start,
                            style: Constant.textStyleSize10(
                              context,
                            )!.copyWith(color: Constant.cWhite),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          // timerData.isNotEmpty && context.read<PreferenceManagerRepository>().user!.isAdmin!?Constant.paddingHalf.heightBox:SizedBox.shrink(),
          // timerData.isNotEmpty &&
          //         context.read<PreferenceManagerRepository>().user!.isAdmin!
          //     ? ShowAllLocalData()
          //     : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget showAllLocalData() {
    return Padding(
      padding: const EdgeInsets.only(top: Constant.paddingHalf),
      child: CustomContainerButton(
        textStyle: Constant.textStyleSize10(
          context,
        )!.copyWith(color: Constant.cWhite),
        text: Strings.showData,
        color: Constant.cBlack.withOpacity(0.5),
        width: 70,
        onTap: () {
          showDialog(
            context: context,
            builder: ((context) {
              return Material(
                color: Constant.cBlack.withOpacity(0.1),
                child: Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width / 8,
                    left: MediaQuery.of(context).size.width / 8,
                  ),
                  child: Center(child: customDialog()),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget customDialog() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Wrap(
          children: [
            Container(
              color: Constant.cGrayDark,
              child: Container(
                width: MediaQuery.of(context).size.width - 200,
                height: MediaQuery.of(context).size.height - 200,
                color: Constant.cWhite.withOpacity(0.2),
                child: Container(
                  color: Constant.cGrayDark,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: Constant.paddingHalf,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: Constant.paddingHalf,
                          ),
                          child: Container(
                            height: 25.h,
                            decoration: BoxDecoration(
                              color: Constant.cWhite.withOpacity(0.1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: Constant.paddingHalf,
                                right: Constant.paddingHalf,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Strings.records,
                                    style: Constant.textStyleSize15(
                                      context,
                                    )!.copyWith(color: Constant.cWhite),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Constant.cWhite,
                                      size: 15.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        timerData.isEmpty
                            ? Expanded(
                                child: Center(
                                  child: Text(
                                    Strings.noData,
                                    style: Constant.textStyleSize15(
                                      context,
                                    )?.copyWith(color: Constant.cWhite),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                  left: Constant.paddingHalf,
                                  right: Constant.paddingHalf,
                                ),
                                child: Container(
                                  color: Constant.cWhite.withOpacity(0.1),
                                  child: Table(
                                    columnWidths: const {
                                      0: FlexColumnWidth(0.5),
                                      1: FlexColumnWidth(1),
                                      2: FlexColumnWidth(2),
                                      3: FlexColumnWidth(1),
                                      4: FlexColumnWidth(1),
                                      5: FlexColumnWidth(1),
                                      6: FlexColumnWidth(1),
                                    },
                                    border: TableBorder.all(
                                      color: Constant.cWhite.withOpacity(0.2),
                                      style: BorderStyle.solid,
                                      width: 1,
                                    ),
                                    children: [
                                      TableRow(
                                        children: [
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  Constant.paddingHalf,
                                                ),
                                                child: Text(
                                                  Strings.recordNo,
                                                  style:
                                                      Constant.textStyleSize12(
                                                        context,
                                                      )?.copyWith(
                                                        color: Constant.cWhite,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  Constant.paddingHalf,
                                                ),
                                                child: Text(
                                                  Strings.empId,
                                                  style:
                                                      Constant.textStyleSize12(
                                                        context,
                                                      )?.copyWith(
                                                        color: Constant.cWhite,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  Constant.paddingHalf,
                                                ),
                                                child: Text(
                                                  Strings.empName,
                                                  style:
                                                      Constant.textStyleSize12(
                                                        context,
                                                      )?.copyWith(
                                                        color: Constant.cWhite,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  Constant.paddingHalf,
                                                ),
                                                child: Text(
                                                  Strings.storeDate,
                                                  style:
                                                      Constant.textStyleSize12(
                                                        context,
                                                      )?.copyWith(
                                                        color: Constant.cWhite,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  Constant.paddingHalf,
                                                ),
                                                child: Text(
                                                  Strings.storeTime,
                                                  style:
                                                      Constant.textStyleSize12(
                                                        context,
                                                      )?.copyWith(
                                                        color: Constant.cWhite,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  Constant.paddingHalf,
                                                ),
                                                child: Text(
                                                  Strings.timeType,
                                                  style:
                                                      Constant.textStyleSize12(
                                                        context,
                                                      )?.copyWith(
                                                        color: Constant.cWhite,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  Constant.paddingHalf,
                                                ),
                                                child: Text(
                                                  Strings.sessionTime,
                                                  style:
                                                      Constant.textStyleSize12(
                                                        context,
                                                      )?.copyWith(
                                                        color: Constant.cWhite,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        //color: Constant.cWhite.withOpacity(0.1),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: Constant.paddingHalf,
                                right: Constant.paddingHalf,
                              ),
                              child: Container(
                                color: Constant.cGrayDark,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: timerData.length,
                                  itemBuilder: (context, index) {
                                    TimerDetailData time = timerData[index];
                                    return Table(
                                      columnWidths: const {
                                        0: FlexColumnWidth(0.5),
                                        1: FlexColumnWidth(1),
                                        2: FlexColumnWidth(2),
                                        3: FlexColumnWidth(1),
                                        4: FlexColumnWidth(1),
                                        5: FlexColumnWidth(1),
                                        6: FlexColumnWidth(1),
                                      },
                                      border: TableBorder.all(
                                        color: Constant.cWhite.withOpacity(0.2),
                                        style: BorderStyle.solid,
                                        width: 1,
                                      ),
                                      children: [
                                        TableRow(
                                          children: [
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    Constant.paddingHalf,
                                                  ),
                                                  child: Text(
                                                    '${index + 1}',
                                                    style:
                                                        Constant.textStyleSize10(
                                                          context,
                                                        )?.copyWith(
                                                          color:
                                                              Constant.cWhite,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    Constant.paddingHalf,
                                                  ),
                                                  child: Text(
                                                    time.employeeId,
                                                    style:
                                                        Constant.textStyleSize10(
                                                          context,
                                                        )?.copyWith(
                                                          color:
                                                              Constant.cWhite,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    Constant.paddingHalf,
                                                  ),
                                                  child: Text(
                                                    time.employeeName,
                                                    style:
                                                        Constant.textStyleSize10(
                                                          context,
                                                        )?.copyWith(
                                                          color:
                                                              Constant.cWhite,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    Constant.paddingHalf,
                                                  ),
                                                  child: Text(
                                                    DateFormatter.formateDate(
                                                      outputFormatter:
                                                          'yyyy-MM-dd',
                                                      inputFormatter:
                                                          'yyyy-MM-dd HH:mm:ss',
                                                      input: time.setDate
                                                          .toString(),
                                                    ),
                                                    style:
                                                        Constant.textStyleSize10(
                                                          context,
                                                        )?.copyWith(
                                                          color:
                                                              Constant.cWhite,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    Constant.paddingHalf,
                                                  ),
                                                  child: Text(
                                                    time.setTime,
                                                    style:
                                                        Constant.textStyleSize10(
                                                          context,
                                                        )?.copyWith(
                                                          color:
                                                              Constant.cWhite,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    Constant.paddingHalf,
                                                  ),
                                                  child: Text(
                                                    time.timerType!,
                                                    style:
                                                        Constant.textStyleSize10(
                                                          context,
                                                        )?.copyWith(
                                                          color:
                                                              Constant.cWhite,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    Constant.paddingHalf,
                                                  ),
                                                  child: Text(
                                                    time.sessionTime!,
                                                    style:
                                                        Constant.textStyleSize10(
                                                          context,
                                                        )?.copyWith(
                                                          color:
                                                              Constant.cWhite,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  getSessionTime(
    BuildContext context, {
    required String previousTimeStatus,
    required String currentTimeStatus,
  }) async {
    setState(() {
      currentStatusTimer = currentTimeStatus;
      Logger.println('current status:$currentStatusTimer');
      BlocProvider.of<LocalDatabaseBloc>(context).add(
        GetSingleDataForTodayByIdEvent(
          status: previousTimeStatus,
          userId: context.read<PreferenceManagerRepository>().user!.employeeId,
        ),
      );
    });
  }

  String calculateTotalMonthTime(List<TimerDetailData> element) {
    //common method for calculate current month time based on session time stored
    int second = 0;

    for (var element in element) {
      /*  var sessionTime = DateFormatter.timeFromString(
          inputFormatter: "yyyy-mm-dd hh:mm:ss", input: element.sessionTime!);*/

      if ('${element.setDate.year}-${element.setDate.month}' ==
          '${DateTime.now().year}-${DateTime.now().month}') {
        Logger.println('working session time for month:${element.sessionTime}');
        second =
            second +
            Duration(
              seconds: int.parse(element.sessionTime!.split(':')[2]),
              minutes: int.parse(element.sessionTime!.split(':')[1]),
              hours: int.parse(element.sessionTime!.split(':')[0]),
            ).inSeconds; //int.parse(element.sessionTime!.split(':')[2]);//sessionTime.second;
        Logger.println('query:::${element.sessionTime}');
      }
    }
    Duration d = Duration(seconds: second);
    // String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))} $second';
  }

  int setTodayTimer(List<TimerDetailData> data) {
    //common method for set today initial timer
    int sec = 0;
    Logger.println("today data::$data");
    for (var t in data) {
      sec =
          sec +
          Duration(
            seconds: int.parse(t.sessionTime!.split(':')[2]),
            minutes: int.parse(t.sessionTime!.split(':')[1]),
            hours: int.parse(t.sessionTime!.split(':')[0]),
          ).inSeconds;
    }
    return sec;
  }

  void _init() async {
    // Add this line to override the default close handler
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  @override
  void onWindowClose() async {
    Logger.println('on window close call...');
    bool isPreventClose = await windowManager.isPreventClose();
    Logger.println('is Window closable =$isPreventClose');

    if (isPreventClose && isClose == false) {
      isClose = true;
      showDialog(
        barrierDismissible: false,
        context: rootCtx ?? context,
        builder: (rootCtx) {
          return AlertDialog(
            title: const Text('Do you really want to close this app!'),
            titleTextStyle: Constant.textStyleSize25(
              context,
            )?.copyWith(color: Constant.cBlack),
            actions: [
              CustomButton(
                width: 80,
                height: 30,
                color: Constant.cBlack,
                onTap: () {
                  Navigator.of(rootCtx).pop();
                  isClose = false;
                },
                text: 'No',
                textStyle: Constant.textStyleSize15(
                  context,
                )?.copyWith(color: Constant.cWhite),
              ),
              CustomButton(
                width: 80,
                height: 30,
                color: Constant.colorSelectedIndicator,
                text: 'Yes',
                textStyle: Constant.textStyleSize15(
                  context,
                )?.copyWith(color: Constant.cWhite),
                onTap: () async {
                  Navigator.of(rootCtx).pop();
                  windowManager.setClosable(false);
                  await windowManager.destroy();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void onWindowEvent(String eventName) {
    Logger.println('[WindowManager] onWindowEvent: $eventName');
    if (eventName == 'focus') {
      preferenceManagerRepository = context.read<PreferenceManagerRepository>();
      BlocProvider.of<MonthlyReportBloc>(context)
        ..isFetching = true
        ..page = 1
        ..add(FetchMonthlyReport(context: context));

      BlocProvider.of<LocalDatabaseBloc>(
        context,
      ).add(const CheckTableEmptyEvent());

      userData = preferenceManagerRepository.user!;
    }
  }

  @override
  void onWindowFocus() {}

  @override
  void onWindowBlur() {}

  @override
  void onWindowMaximize() {
    Logger.println('on window maximize call...');
  }

  @override
  void onWindowUnmaximize() {
    // do something
  }

  @override
  void onWindowMinimize() {
    Logger.println('on window minimize call...');
  }

  @override
  void onWindowRestore() {
    Logger.println('on window restore call...');
  }

  @override
  void onWindowResize() {
    Logger.println('on window resize call...');
  }

  @override
  void onWindowMove() {
    // do something
  }

  @override
  void onWindowEnterFullScreen() {}

  @override
  void onWindowLeaveFullScreen() {
    // do something
  }

  @override
  void dispose() {
    timer?.cancel();
    windowManager.removeListener(this);
    super.dispose();
  }

  int getCurrentTimeDifference(TimerDetailData data) {
    DateTime current = DateTime.now();
    int currentSec = 0;
    if (data.timerType != Strings.time_status[3]) {
      Duration currentDuration = Duration(
        seconds: current.second,
        minutes: current.minute,
        hours: current.hour,
      );
      Duration previous = Duration(
        seconds: (int.parse(data.setTime.split(':')[2])),
        minutes: (int.parse(data.setTime.split(':')[1])),
        hours: (int.parse(data.setTime.split(':')[0])),
      );
      /* var previousTime = DateFormatter.timeFromString(
          inputFormatter: "yyyy-mm-dd HH:mm:ss", input: data.setTime);*/
      currentSec = (currentDuration.inSeconds - previous.inSeconds);
      Logger.println(
        'current time:${current.hour}:${current.minute}:${current.second}: ${currentDuration.inSeconds}',
      );
      Logger.println('previous time:${data.setTime}: ${previous.inSeconds}');
      Logger.println('time difference in second:$currentSec:');
    }
    return currentSec;
  }

  // void getTimeSlotLastRecord(
  //     {required bool isSync, required BuildContext context}) {
  //   isUpdate = true;
  //
  //   BlocProvider.of<LocalDatabaseBloc>(context)
  //       .add(GetSingleDataForInitialEvent(
  //     status: currentStatusTimer,
  //     userId: context.read<PreferenceManagerRepository>().user!.employeeId!,
  //   ));
  // }

  void setLateArrivalCounter(List<LateArrivalDetail> list) {
    for (int i = 0; i < list.length; i++) {
      DateTime arrivalTime = DateTime.parse(list[i].initialTimeSlot.dateTime!);
      DateTime initialTime = DateTime.parse(
        '${list[i].initialTimeSlot.dateTime!.split(' ')[0]} 09:30:00',
      );
      if (arrivalTime.isAfter(initialTime)) {
        int second = (arrivalTime.difference(initialTime).inSeconds);
        Logger.println(
          'Date ${list[i].initialTimeSlot.dateTime!.split(' ')[0]} arrival : $arrivalTime difference:$seconds',
        );
        Duration d = Duration(seconds: second);
        list[i].lateArrivalTime =
            '${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}';
        lateArrivalCounter = lateArrivalCounter + 1;
      }
      Logger.println(
        'current mont initial in time ${list[i].initialTimeSlot.toJson()}',
      );
    }
    // Duration time=Duration(seconds: lateArrivalCounter);
    // Logger.println('total late arrival seconds:${time.inSeconds}');
    // lateArrivalTotalTime='${twoDigits(time.inHours)}:${twoDigits(time.inMinutes.remainder(60))}:${twoDigits(time.inSeconds.remainder(60))}';
    // Logger.println('late arrivalTime:$lateArrivalTotalTime');
    setState(() {});
  }
}

class LateArrivalDetail {
  TimeData initialTimeSlot;
  String lateArrivalTime;

  LateArrivalDetail({
    required this.initialTimeSlot,
    required this.lateArrivalTime,
  });
}
