import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oceanbit_timeclock/bloc_logic/Inventory_bloc/inventory_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/Inventory_bloc/inventory_repository.dart';
import 'package:oceanbit_timeclock/bloc_logic/add_holiday_type_bloc/add_holiday_type_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/add_update_personal_detail_bloc/add_update_personal_detail_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/change_password_bloc/change_password_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/department_bloc/department_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/department_bloc/department_repository.dart';
import 'package:oceanbit_timeclock/bloc_logic/designation_bloc/designation_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/designation_bloc/designation_repository.dart';
import 'package:oceanbit_timeclock/bloc_logic/employeeCredential/employee_credential_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/employeeCredential/employee_credential_repositories.dart';
import 'package:oceanbit_timeclock/bloc_logic/employee_info_bloc/employee_info_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/employee_info_bloc/employee_info_repository.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_bank_info/get_bank_info_repositories.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_holiday/get_holiday_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_holiday/get_holiday_repository.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_ocean_team/get_ocean_team_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_ocean_team/get_ocean_team_repository.dart';
import 'package:oceanbit_timeclock/bloc_logic/knowledge_bloc/knowledge_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/knowledge_bloc/knowledge_repository.dart';
import 'package:oceanbit_timeclock/bloc_logic/previous_employer/previous_employer_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/previous_employer/previous_employer_repositories.dart';
import 'package:oceanbit_timeclock/bloc_logic/quote_bloc/quote_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/quote_bloc/quote_repository.dart';
import 'package:oceanbit_timeclock/bloc_logic/register_bloc/register_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/reset_password_bloc/reset_password_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/reviews_bloc/reviews_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/reviews_bloc/reviews_repository.dart';
import 'package:oceanbit_timeclock/bloc_logic/rules_bloc/rules_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/rules_bloc/rules_repository.dart';
import 'package:oceanbit_timeclock/bloc_logic/salary_bloc/salary_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/systemfaults_bloc/systemfaults_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/systemfaults_bloc/systemfaults_repositories.dart';
import 'package:oceanbit_timeclock/bloc_logic/transport_bloc/transport_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/transport_bloc/transport_repository.dart';
import 'package:oceanbit_timeclock/bloc_logic/update_ui_bloc/update_ui_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/user_detail_bloc/user_detail_bloc.dart';
import 'package:oceanbit_timeclock/constant/custom_flutter_adptive_scaffold/custom_slot_layout.dart';
import 'package:oceanbit_timeclock/gen/assets.gen.dart';
import 'package:oceanbit_timeclock/router/my_router.dart';
import 'package:oceanbit_timeclock/screen/Inventorys/salary_repository.dart';
import 'package:oceanbit_timeclock/screen/my_salary/salary_repository.dart';
import 'package:oceanbit_timeclock/utils/check_network/connectivity_provider.dart';
import 'package:oceanbit_timeclock/utils/date_formatter.dart';
import 'package:oceanbit_timeclock/utils/logger.dart';
import 'package:oceanbit_timeclock/widget/new/my_custom_scroll_behavior.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'bloc_logic/add_daily_report_bloc/add_daily_report_bloc.dart';
import 'bloc_logic/add_holiday_bloc/add_holiday_bloc.dart';
import 'bloc_logic/change_password_bloc/change_password_repository.dart';
import 'bloc_logic/common_repositories/preference_repository.dart';
import 'bloc_logic/get_bank_info/get_bank_info_bloc.dart';
import 'bloc_logic/get_daily_report/get_daily_report_bloc.dart';
import 'bloc_logic/get_daily_report/get_daily_report_repository.dart';
import 'bloc_logic/get_employee_report/get_employee_report_repository.dart';
import 'bloc_logic/get_holiday_types/get_holiday_bloc.dart';
import 'bloc_logic/get_holiday_types/get_holiday_repository.dart';
import 'bloc_logic/get_last_daily_report_bloc/last_daily_report_bloc.dart';
import 'bloc_logic/get_last_daily_report_bloc/last_daily_report_repository.dart';
import 'bloc_logic/get_monthly_report/monthly_report_bloc.dart';
import 'bloc_logic/get_monthly_report/monthly_report_repository.dart';
import 'bloc_logic/leave_bloc/leave_bloc.dart';
import 'bloc_logic/leave_bloc/leave_repositories.dart';
import 'bloc_logic/login_logic/login_bloc.dart';
import 'bloc_logic/reset_password_bloc/reset_password_repository.dart';
import 'bloc_logic/salary_bloc/salary_repository.dart';
import 'bloc_logic/user_list_bloc/user_list_bloc.dart';
import 'constant/app_bloc_observer.dart';
import 'constant/constant.dart';
import 'constant/custom_flutter_adptive_scaffold/custom_adaptive_layout.dart';
import 'constant/custom_flutter_adptive_scaffold/custom_adaptive_scaffold.dart';
import 'constant/custom_flutter_adptive_scaffold/custom_breakpoints.dart';
import 'constant/local_key.dart';
import 'local_database/custom_queries.dart';
import 'local_database/timer_database.dart';
import 'local_storage/my_local_storage.dart';
import 'models/auth_model.dart';

bool isAccessAllowed = false;
MyTimerDatabase? database;
BuildContext? rootCtx;
String? version;
String? buildNumber;
String? platform;
String? os;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  version = packageInfo.version;
  buildNumber = packageInfo.buildNumber;
  os = Platform.operatingSystem;
  // SleepWakeHandler.init();
  if (defaultTargetPlatform == TargetPlatform.android) {
    platform = "Android";
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    platform = "iOS";
  } else if (defaultTargetPlatform == TargetPlatform.macOS) {
    platform = "macOS";
  } else if (defaultTargetPlatform == TargetPlatform.windows) {
    platform = "Windows";
  } else if (defaultTargetPlatform == TargetPlatform.linux) {
    platform = "Linux";
  } else if (defaultTargetPlatform == TargetPlatform.fuchsia) {
    platform = "Fuchsia";
  } else {
    platform = "Web";
  }
  await windowManager.ensureInitialized();
  database = MyTimerDatabase();
  //database!.deleteEverything();
  // database!.delete(TimerDetail)
  //database?.deleteEverything();
  var count = database!.countRows();

  Logger.println('counter is here :: $count');

  // if (count != 0) {
  var allData = await CustomQueries.getTimerData();
  for (var element in allData) {
    Logger.println("Element :: $element");
  }
  // }
  /*var allData= await CustomQueries.getTimerData();
  allData.forEach((element) { print(element);});*/
  Logger.println(
    'date format::${DateFormatter.formateDate(outputFormatter: 'yyyy-MM-dd', inputFormatter: 'yyyy-MM-dd HH:mm:ss', input: DateTime.now().toString())}',
  );
  Constant.pref = await SharedPreferences.getInstance();
  //windowManager.setClosable(false);
  // windowManager.setMovable(true);
  User? user = MyLocalStorage().getUser();
  /*if(await windowManager.isFullScreen()){
    windowManager.setResizable(false);
  }*/
  //windowManager.setFullScreen(true);
  //windowManager.setMinimumSize(Size(SizeConfig.logicalWidth, SizeConfig.logicalHeight));
  //windowManager.setMaximumSize(Size(SizeConfig.logicalWidth, SizeConfig.logicalHeight));
  // windowManager.setMinimizable(true);
  //windowManager.setMaximizable(false);
  WindowOptions windowOptions = const WindowOptions(
    // fullScreen: true,
    // size: Size(SizeConfig.logicalWidth, SizeConfig.logicalHeight),
    // //maximumSize:Size(SizeConfig.logicalWidth, SizeConfig.logicalHeight),
    minimumSize: Size(400, 650),
    /* center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,*/
  );
  initAccess();
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  //DesktopWindow.setFullScreen(true);
  //var size = await DesktopWindow.getWindowSize();
  //DesktopWindow.setMaxWindowSize(Size(SizeConfig.logicalWidth, SizeConfig.logicalHeight));
  //DesktopWindow.setMinWindowSize(Size(SizeConfig.logicalWidth, SizeConfig.logicalHeight));
  Bloc.observer = AppBlocObserver();
  runApp(MyApp(user: user));
}

void initAccess() async {
  /*  SharedPreferences pref=await SharedPreferences.getInstance();
  if(pref.getBool(LocalStorageKeys.isRecordScreenAllow)!=null && pref.getBool(LocalStorageKeys.isRecordScreenAllow)!)
  {
    isAccessAllowed = pref.getBool(LocalStorageKeys.isRecordScreenAllow)!;
    // pref.setBool(LocalStorageKeys.isRecordScreenAllow,isAccessAllowed);
  }else{
    await screenCapturer.requestAccess().then((value) async {
      isAccessAllowed = await screenCapturer.isAccessAllowed();

    });
  }*/
  // isAccessAllowed = await screenCapturer.isAccessAllowed();
  // if (!isAccessAllowed) {
  //   await screenCapturer.requestAccess();
  //   isAccessAllowed = await screenCapturer.isAccessAllowed();
  // }
  // Logger.println('Screen Capture Access:$isAccessAllowed');

  /// isAccessAllowed = await screenCapturer.isAccessAllowed();
  /// if (!isAccessAllowed) {
  ///   await screenCapturer.requestAccess();
  /// }
  /// Logger.println('Screen Capture Access:$isAccessAllowed');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.user});

  final User? user;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> /*with WindowListener*/ {
  @override
  void initState() {
    /*windowManager.addListener(this);
    _init();*/
    super.initState();
    //initAccess();
  }

  /* void _init() async {
    // Add this line to override the default close handler
    await windowManager.setPreventClose(true);
    setState(() {});
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
  }

  @override
  void onWindowClose() async {
    print('on window close call...') ;
    bool _isPreventClose = await windowManager.isPreventClose();
    print('is Window closable =$_isPreventClose');
    if (_isPreventClose) {
      showDialog(
        barrierDismissible: false,
        context: rootCtx?? context,
        builder: (rootCtx) {
          return AlertDialog(
            title: Text('Do you really want to close this app!'),
            actions: [
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(rootCtx).pop();
                },
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () async {
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
    print('[WindowManager] onWindowEvent: $eventName');
  }

  @override
  void onWindowFocus() {
    // do something
  }

  @override
  void onWindowBlur() {
    // do something
  }

  @override
  void onWindowMaximize() {
    print('on window maximize call...') ;
    //windowManager.setMaximumSize(Size(SizeConfig.logicalWidth, SizeConfig.logicalHeight-SizeConfig.paddingTop));
  }

  @override
  void onWindowUnmaximize() {
    // do something
  }

  @override
  void onWindowMinimize() {
    print('on window minimize call...') ;
  }

  @override
  void onWindowRestore() {
    print('on window restore call...') ;  // do something;
  }

  @override
  void onWindowResize() {
     print('on window resize call...') ;
  }

  @override
  void onWindowMove() {
    // do something
  }

  @override
  void onWindowEnterFullScreen() {
    //windowManager.setMaximumSize(Size(SizeConfig.logicalWidth, SizeConfig.logicalHeight-SizeConfig.paddingTop));
  }

  @override
  void onWindowLeaveFullScreen() {
    // do something
  }
*/
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConnectivityProvider(),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => PreferenceManagerRepository(),
          ),
          RepositoryProvider(create: (context) => SalaryPDFRepository()),
          RepositoryProvider(create: (context) => InventoryPDFRepository()),
          RepositoryProvider(create: (context) => GetDailyReportRepository()),
          RepositoryProvider(create: (context) => MonthlyReportRepository()),
          RepositoryProvider(
            create: (context) => GetEmployeeReportRepository(),
          ),
          RepositoryProvider(
            create: (context) => GetEmployeeReportRepository(),
          ),
          RepositoryProvider(create: (context) => GetHolidayRepository()),
          RepositoryProvider(create: (context) => GetHolidayTypeRepository()),
          RepositoryProvider(create: (context) => BankInfoRepository()),
          RepositoryProvider(create: (context) => PreviousEmployerRepository()),
          RepositoryProvider(create: (context) => TransportRepository()),
          RepositoryProvider(
            create: (context) => EmployeeCredentialRepository(),
          ),
          RepositoryProvider(create: (context) => LeaveRepository()),
          RepositoryProvider(create: (context) => KnowledgeRepository()),
          RepositoryProvider(create: (context) => SystemFaultsRepository()),
          RepositoryProvider(create: (context) => InventoryRepository()),
          RepositoryProvider(create: (context) => RulesRepository()),
          RepositoryProvider(create: (context) => EmployeeInfoRepository()),
          RepositoryProvider(create: (context) => DepartmentRepository()),
          RepositoryProvider(create: (context) => DesignationRepository()),
          RepositoryProvider(create: (context) => QuoteRepository()),
          RepositoryProvider(create: (context) => ReviewRepository()),
          RepositoryProvider(create: (context) => ResetPassword()),
          RepositoryProvider(create: (context) => ChangePasswordRepository()),
          RepositoryProvider(create: (context) => LastDailyReportRepository()),
          RepositoryProvider(create: (context) => SalaryRepository()),
          RepositoryProvider(create: (context) => GetOceanTeamRepository()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<LoginBloc>(
              create: (context) =>
                  LoginBloc(context.read<PreferenceManagerRepository>()),
            ),
            BlocProvider<AddDailyReportBloc>(
              create: (context) => AddDailyReportBloc(),
            ),
            BlocProvider<GetDailyReportBloc>(
              create: (context) => GetDailyReportBloc(
                repository: context.read<GetDailyReportRepository>(),
              ),
            ),
            BlocProvider<MonthlyReportBloc>(
              create: (context) => MonthlyReportBloc(
                repository: context.read<MonthlyReportRepository>(),
              ),
            ),
            BlocProvider<UserListBloc>(create: (context) => UserListBloc()),
            BlocProvider<UserDetailBloc>(create: (context) => UserDetailBloc()),
            // BlocProvider<GetEmployeeReportBloc>(
            //   create: (context) => GetEmployeeReportBloc(
            //     reportRepository: context.read<GetEmployeeReportRepository>()
            //   ),
            // ),
            BlocProvider<AddUpdatePersonalDetailBloc>(
              create: (context) => AddUpdatePersonalDetailBloc(),
            ),
            BlocProvider<RegisterBloc>(create: (context) => RegisterBloc()),
            BlocProvider<GetHolidayBloc>(
              create: (context) => GetHolidayBloc(
                reportRepository: context.read<GetHolidayRepository>(),
              ),
            ),
            BlocProvider<GetHolidayTypeBloc>(
              create: (context) => GetHolidayTypeBloc(
                reportRepository: context.read<GetHolidayTypeRepository>(),
              ),
            ),
            BlocProvider<AddHolidayTypeBloc>(
              create: (context) => AddHolidayTypeBloc(),
            ),
            BlocProvider<AddHolidayBloc>(create: (context) => AddHolidayBloc()),
            BlocProvider<BankInfoBloc>(
              create: (context) => BankInfoBloc(
                reportRepository: context.read<BankInfoRepository>(),
              ),
            ),
            BlocProvider<PreviousEmployerBloc>(
              create: (context) => PreviousEmployerBloc(
                reportRepository: context.read<PreviousEmployerRepository>(),
              ),
            ),
            BlocProvider<TransportBloc>(
              create: (context) => TransportBloc(
                transportRepository: context.read<TransportRepository>(),
              ),
            ),
            BlocProvider<EmployeeCredentialBloc>(
              create: (context) => EmployeeCredentialBloc(
                reportRepository: context.read<EmployeeCredentialRepository>(),
              ),
            ),
            BlocProvider<LeaveBloc>(
              create: (context) =>
                  LeaveBloc(reportRepository: context.read<LeaveRepository>()),
            ),
            BlocProvider<KnowledgeBloc>(
              create: (context) => KnowledgeBloc(
                reportRepository: context.read<KnowledgeRepository>(),
              ),
            ),
            BlocProvider<EmployeeInfoBloc>(
              create: (context) => EmployeeInfoBloc(
                reportRepository: context.read<EmployeeInfoRepository>(),
              ),
            ),
            BlocProvider<InventoryBloc>(
              create: (context) => InventoryBloc(
                reportRepository: context.read<InventoryRepository>(),
              ),
            ),
            BlocProvider<SystemFaultBloc>(
              create: (context) => SystemFaultBloc(
                repository: context.read<SystemFaultsRepository>(),
              ),
            ),
            BlocProvider<RulesBloc>(
              create: (context) =>
                  RulesBloc(reportRepository: context.read<RulesRepository>()),
            ),
            BlocProvider<MyDepartmentBloc>(
              create: (context) => MyDepartmentBloc(
                reportRepository: context.read<DepartmentRepository>(),
              ),
            ),
            BlocProvider<MyQuoteBloc>(
              create: (context) => MyQuoteBloc(
                reportRepository: context.read<QuoteRepository>(),
              ),
            ),
            BlocProvider<DesignationBloc>(
              create: (context) => DesignationBloc(
                reportRepository: context.read<DesignationRepository>(),
              ),
            ),
            BlocProvider<MyReviewBloc>(
              create: (context) => MyReviewBloc(
                reportRepository: context.read<ReviewRepository>(),
              ),
            ),
            BlocProvider<SalaryBloc>(
              create: (context) =>
                  SalaryBloc(repository: context.read<SalaryRepository>()),
            ),
            BlocProvider<LastDailyReportBloc>(
              create: (context) => LastDailyReportBloc(),
            ),
            BlocProvider<ChangePasswordBloc>(
              create: (context) => ChangePasswordBloc(),
            ),
            BlocProvider<ResetPasswordBloc>(
              create: (context) => ResetPasswordBloc(),
            ),
            BlocProvider<UpdateUiBloc>(create: (context) => UpdateUiBloc()),
            BlocProvider<GetOceanTeamBloc>(
              create: (context) => GetOceanTeamBloc(
                reportRepository: context.read<GetOceanTeamRepository>(),
              ),
            ),
          ],
          child: ScreenUtilInit(
            minTextAdapt: true,
            designSize: const Size(360, 690),
            builder: (context, child) {
              return MaterialApp(
                title: "OceanBit TimeClock",
                scrollBehavior: MyCustomScrollBehavior(),
                // builder: (context, child) => ResponsiveWrapper.builder(
                //   child,
                //   maxWidth: MediaQuery.of(context).size.width,
                //   minWidth: 1200,
                //   defaultScale: true,
                //   breakpoints: [
                //     const ResponsiveBreakpoint.resize(480, name: MOBILE),
                //     const ResponsiveBreakpoint.resize(800, name: TABLET),
                //     const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                //   ],
                //   background: Container(color: const Color(0xFFF5F5F5)),
                // ),
                theme: Constant.lightTheme(context),
                // darkTheme: Constant.darkTheme(context),
                debugShowCheckedModeBanner: false,
                home: child,
                //widget.data != null ?Dashboard() : LoginTutorStudent(),
                onGenerateRoute: MyRouter.onGenerateRoute,
              );
            },
            child: SplashScreen(user: widget.user),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    Logger.println('dispose call from my app dispose..');
    // windowManager.removeListener(this);
    super.dispose();
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, this.user}) : super(key: key);
  final User? user;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // int? storedCurrentTime;
  // int? storedInterMediateTime;
  Future<void> viewVisible() async {
    String lastLoginDate = DateFormatter.formateDate(
      inputFormatter: "yyyy-MM-dd",
      input: DateTime.now().toString(),
      outputFormatter: "dd-MM-yyyy",
    );
    Logger.println("Last Login Date :: $lastLoginDate");
    // Logger.println("Stored Time From Main :: ${MyLocalStorage().read(LocalStorageKeys.currentTime)}");
    Future.delayed(const Duration(seconds: 3), () async {
      Logger.println('user data:::${widget.user}');
      // storedCurrentTime = MyLocalStorage().read(LocalStorageKeys.currentTime);
      // storedInterMediateTime = MyLocalStorage().read(LocalStorageKeys.currentInterMediateTime);
      // Logger.println("Stored Current Time From Main :: $storedCurrentTime");
      // Logger.println("Stored InterMediate Time From Main :: $storedInterMediateTime");
      if ( /*(MyLocalStorage().read(LocalStorageKeys.currentTime) != null) &&
          (MyLocalStorage().read(LocalStorageKeys.currentDate) ==
              lastLoginDate)&& */ MyLocalStorage().getUser() != null) {
        context.read<PreferenceManagerRepository>().user = MyLocalStorage()
            .getUser();
        // BlocProvider.of<TimeBloc>(context).add(const FetchCurrentMonthChartData());
        BlocProvider.of<GetDailyReportBloc>(
          context,
        ).add(FetchGetDailyReport(context: context));
        BlocProvider.of<MonthlyReportBloc>(context)
          ..isFetching = true
          ..page = 1
          ..add(
            FetchMonthlyReport(
              context: context,
              /* keyword: productSearchController.text.isNotEmpty?productSearchController.text:''*/
            ),
          );
        Navigator.pushNamedAndRemoveUntil(
          context,
          MyRouter.dashboardRoute,
          (route) => false,
        );
      } else {
        MyLocalStorage().delete(LocalStorageKeys.currentTime);
        MyLocalStorage().delete(LocalStorageKeys.currentInterMediateTime);
        Navigator.pushNamedAndRemoveUntil(
          context,
          MyRouter.loginRoute,
          (route) => false,
        );
      }
      //  if(widget.user==null) {
      //     Navigator.pushNamedAndRemoveUntil(
      //         context, MyRouter.loginRoute, (route) => false);
      /* }else{
        Navigator.pushNamedAndRemoveUntil(
            context, MyRouter.dashboardRoute, (route) => false);
      }*/
      /* Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
        return const LoginScreen();
      }), (route) => false);*/
    });
  }

  @override
  void initState() {
    viewVisible();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AdaptiveLayout(
        body: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig?>{
            Breakpoints.standard: SlotLayout.from(
              key: const Key('body'),
              inAnimation: AdaptiveScaffold.fadeIn,
              outAnimation: AdaptiveScaffold.fadeOut,
              builder: (_) => Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Assets.images.oceanbitLogoTransparentBg
                      .image(), //Image.asset('assets/images/oceanbit_logo.jpg')),
                ),
              ),
            ),
          },
        ),
      ),
    );
  }
}
