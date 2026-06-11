import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/constant/custom_flutter_adptive_scaffold/custom_adaptive_layout.dart';
import 'package:oceanbit_timeclock/local_storage/my_local_storage.dart';
import 'package:oceanbit_timeclock/screen/dashboard/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../bloc_logic/get_monthly_report/monthly_report_bloc.dart';
import '../../bloc_logic/login_logic/login_bloc.dart';
import '../../constant/constant.dart';
import '../../constant/custom_flutter_adptive_scaffold/custom_adaptive_scaffold.dart';
import '../../constant/custom_flutter_adptive_scaffold/custom_breakpoints.dart';
import '../../constant/custom_flutter_adptive_scaffold/custom_slot_layout.dart';
import '../../constant/local_key.dart';
import '../../constant/strings.dart';
import '../../gen/assets.gen.dart';
import '../../router/my_router.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FocusNode _nodeUserName = FocusNode();
  final FocusNode _nodePassword = FocusNode();
  final FocusNode _nodeButton = FocusNode();
  bool _autoValidate = false;
  //MyLoader myLoader = MyLoader();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: AdaptiveLayout(
        internalAnimations: true,
        body: SlotLayout(config: <Breakpoint, SlotLayoutConfig?>{
          Breakpoints.small: SlotLayout.from(
            key: const Key('body'),
            inAnimation: AdaptiveScaffold.fadeIn,
            outAnimation: AdaptiveScaffold.fadeOut,
            builder: (_) =>
                !(Provider.of<ConnectivityProvider>(context).isOnline)
                    ? const Center(child: Text(Strings.offlineMsg))
                    : loginWidget(context, rowSegment: 1, sizeTag: 0),
          ),
          Breakpoints.medium: SlotLayout.from(
            key: const Key('body'),
            inAnimation: AdaptiveScaffold.fadeIn,
            outAnimation: AdaptiveScaffold.fadeOut,
            builder: (_) =>
                !(Provider.of<ConnectivityProvider>(context).isOnline)
                    ? const Center(child: Text(Strings.offlineMsg))
                    : loginWidget(context, rowSegment: 2, sizeTag: 1),
          ),
          Breakpoints.large: SlotLayout.from(
            key: const Key('body'),
            inAnimation: AdaptiveScaffold.fadeIn,
            outAnimation: AdaptiveScaffold.fadeOut,
            builder: (_) =>
                !(Provider.of<ConnectivityProvider>(context).isOnline)
                    ? const Center(child: Text(Strings.offlineMsg))
                    : loginWidget(context, rowSegment: 2, sizeTag: 2),
          )
        }),
      ),
    );
  }

  Widget loginWidget(BuildContext context,
      {required int rowSegment, required int sizeTag}) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
        }
        if (state is LoginError) {
          //msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant().ShowErrorToast(state.errors, context);
          Constant.myLoader.hide();
        } else if (state is LoginLoaded) {
          msgList.add(Constant().ShowMessage(state.data!.message!, context));
          // Constant().ShowToast(state.data!.message!, context);
          BlocProvider.of<MonthlyReportBloc>(context)
            ..isFetching = true
            ..page = 1
            ..add(FetchMonthlyReport(context: context));
          //BlocProvider.of<TimeBloc>(context).add(const FetchCurrentMonthChartData());
          Navigator.pushNamedAndRemoveUntil(
            context,
            MyRouter.dashboardRoute,
            (route) => false,
          );
          selectedIndex = 0;
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: rowSegment == 2
                    ? 0
                    : MediaQuery.of(context).size.width / 10,
                right: MediaQuery.of(context).size.width / 10),
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: ResponsiveGridRow(
                rowSegments: rowSegment,
                crossAxisAlignment: CrossAxisAlignment.center,
                /*rowMainAxisAlignment: MainAxisAlignment.spaceAround,
                columnMainAxisAlignment: MainAxisAlignment.center,
                rowPadding: const EdgeInsets.all(30),
                columnPadding: const EdgeInsets.all(30),
                layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                    ? ResponsiveRowColumnType.COLUMN
                    : ResponsiveRowColumnType.ROW,*/
                children: [
                  ResponsiveGridCol(
                    lg: 1,
                    xs: 1,
                    md: 1,
                    sm: 1,
                    /*rowFlex: 1,
                    columnFlex: 1,*/
                    child: Center(
                      child: SizedBox(
                        height: sizeTag == 2
                            ? MediaQuery.of(context).size.width / 5
                            : sizeTag == 1
                                ? MediaQuery.of(context).size.width / 3
                                : MediaQuery.of(context).size.width / 2,
                        width: sizeTag == 2
                            ? MediaQuery.of(context).size.width / 5
                            : sizeTag == 1
                                ? MediaQuery.of(context).size.width / 3
                                : MediaQuery.of(context).size.width / 2,
                        child: Center(
                            child: Assets.images.oceanbitLogoTransparentBg
                                .image() /*Image.asset(
                            'assets/images/oceanbit_logo.jpg',
                            fit: BoxFit.fitHeight,
                          ),*/
                            ),
                      ),
                    ),
                  ),
                  ResponsiveGridCol(
                    lg: 1,
                    xs: 1,
                    md: 1,
                    sm: 1,
                    child: Center(child: loginFields(context)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginFields(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomFormField(
            isSuffix: false,
            focus: _nodeUserName,
            hintText: Strings.username,
            type: TextInputType.text,
            controller: emailController,
            onTap: () {
              setState(() {
                _nodeUserName.canRequestFocus;
              });
            },
            onFieldSubmitted: (val) {
              FocusScope.of(context).requestFocus(_nodePassword);
            },
            onChanged: (val) {},
            validatorFunction: (val) {
              RegExp regExp = RegExp(Strings.emailValidate);
              if (val!.isEmpty) {
                return Strings.userEmailEmpty;
              } else if (!regExp.hasMatch(emailController.text)) {
                return Strings.emailValid;
              }
              return null;
            },
            validator: Strings.userEmailEmpty,
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 25),
          CustomFormField(
            // height: MediaQuery.of(context).size.height/20,
            isSuffix: false,
            isPasswordField: true,
            focus: _nodePassword,
            hintText: Strings.password,
            type: TextInputType.text,
            controller: passwordController,
            onTap: () {
              setState(() {
                _nodeUserName.canRequestFocus;
              });
            },
            onChanged: (val) {},
            validator: Strings.passwordEmpty,
            onFieldSubmitted: (val) {
              _nodeButton.requestFocus();
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 15),
          CustomButton(
              focus: _nodeButton,
              height: MediaQuery.of(context).size.height / 20,
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Constant.cWhite),
              text: Strings.login,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  BlocProvider.of<LoginBloc>(context).add(FetchLogin(
                      context: context,
                      password: passwordController.text,
                      email: emailController.text));
                  // Navigator.pushNamedAndRemoveUntil(
                  //     context, MyRouter.dashboardRoute, (route) => false);
                } else {
                  _autoValidate = true;
                }
              })
        ]);
  }
}
/*class SmallLoginBody extends StatefulWidget {
  const SmallLoginBody({Key? key}) : super(key: key);

  @override
  State<SmallLoginBody> createState() => _SmallLoginBodyState();
}*/

/*class _SmallLoginBodyState extends State<SmallLoginBody> {
  @override
  Widget build(BuildContext context) {
    return ;
  }
}*/
