import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc_logic/local_database_bloc/local_database_bloc.dart';
import '../bloc_logic/local_database_bloc/local_database_repository.dart';
import '../bloc_logic/time_bloc/time_bloc.dart';
import '../bloc_logic/time_bloc/time_repository.dart';
import '../main.dart';
import '../models/auth_model.dart';
import '../screen/dashboard/dashboard.dart';
import '../screen/login_screen/login_screen.dart';
import '../utils/exceptions/route_exceptions.dart';

class MyRouter {
  //static const String initialRoute = "/";
  static const String splashRoute = "/splash";
  static const String loginRoute = "/login";
  static const String dashboardRoute = "/dashboard";

  const MyRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(
            user: settings.arguments as User,
          ),
        );
      case loginRoute:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );
      case dashboardRoute:
        return MaterialPageRoute(
          builder: (_) => MultiRepositoryProvider(
            providers: [
              RepositoryProvider(
                create: (context) => TimeRepository(),
              ),
              RepositoryProvider(
                create: (context) => LocalDatabaseRepository(),
              ),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => TimeBloc(context.read<TimeRepository>())
                    ..add(FetchCurrentMonthChartData(context: context)),
                ),
                BlocProvider(
                  create: (context) => LocalDatabaseBloc(
                      context.read<LocalDatabaseRepository>()),
                ),
              ],
              child: const Dashboard(
                  // totalSecondCount: settings.arguments as PassTotalTime,
                  ),
            ),
          ),
          /*    RepositoryProvider(
                create: (context) => LocalDatabaseRepository(),
                child: BlocProvider(
                    create: (context) =>
                        LocalDatabaseBloc(context.read<LocalDatabaseRepository>()),
                  child: Dashboard(
                    // totalSecondCount: settings.arguments as PassTotalTime,
                  ),
                ),
              ),*/
        );

      default:
        throw const RouteException('Route not found!');
    }
  }
}
