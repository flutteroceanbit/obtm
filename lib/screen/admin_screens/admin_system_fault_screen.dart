import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/systemfaults_bloc/systemfaults_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/systemfaults_bloc/systemfaults_event.dart';
import 'package:oceanbit_timeclock/bloc_logic/systemfaults_bloc/systemfaults_state.dart';
import 'package:oceanbit_timeclock/models/get_admin_system_fault_model.dart';
import 'package:oceanbit_timeclock/screen/SystemFaults/widget/apply_systemfaults.dart';
import 'package:oceanbit_timeclock/screen/SystemFaults/widget/my_SystemFaults.dart';
import 'package:oceanbit_timeclock/screen/admin_screens/system_fault_alert_dialog.dart';
import 'package:oceanbit_timeclock/widget/new/custom_header_container.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constant/constant.dart';
import '../../constant/strings.dart';
import '../../utils/logger.dart';
import '../../widget/custom_button.dart';
import '../SystemFaults/widget/systemfaults_screen.dart';
import '../dashboard/dashboard.dart';

class AdminSystemFaultScreen extends StatefulWidget {
  const AdminSystemFaultScreen({Key? key, this.sizeTag}) : super(key: key);
  final int? sizeTag;

  @override
  State<AdminSystemFaultScreen> createState() => _AdminSystemFaultScreenState();
}

class _AdminSystemFaultScreenState extends State<AdminSystemFaultScreen> {
  bool isEmployee = false;
  List<AdminSystemFaultData> allFaults = [];
  List selectedValues = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SystemFaultBloc, SystemFaultState>(
      listener: (context, state) {
        if (state is GetAdminSystemFaultLoading ||
            state is UpdateAdminSystemFaultLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is GetAdminSystemFaultError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is GetAdminSystemFaultLoaded) {
          allFaults.clear();
          allFaults = List.generate(
              state.data!.data.length, (index) => state.data!.data[index]);
          selectedValues = List.generate(
              allFaults.length, (index) => allFaults[index].status);
        }
        if (state is UpdateAdminSystemFaultError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is UpdateAdminSystemFaultLoaded) {
          BlocProvider.of<SystemFaultBloc>(context)
              .add(GetAdminSystemFaultEvent(context: context));
          Navigator.pop(context);
        }
      },
      child: CustomHeaderContainer(
        headerText: Strings.systemFaults,
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 500,
                  decoration: BoxDecoration(
                      color: Constant.cBlack.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isEmployee = false;
                          });
                        },
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                            color: !isEmployee
                                ? Constant.colorSelectedIndicator
                                : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                              Constant.paddingHalf,
                            ),
                            child: Center(
                              child: Text(
                                Strings.myFaults,
                                style:
                                    Constant.textStyleSize20(context)?.copyWith(
                                  color: !isEmployee
                                      ? Constant.colorOnError
                                      : Constant.cBlack,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<SystemFaultBloc>(context)
                              .add(GetAdminSystemFaultEvent(context: context));
                          setState(() {
                            isEmployee = true;
                          });
                        },
                        child: Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: isEmployee
                                ? Constant.colorSelectedIndicator
                                : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                              Constant.paddingHalf,
                            ),
                            child: Center(
                              child: Text(
                                Strings.employeeSystemFaults,
                                style:
                                    Constant.textStyleSize20(context)?.copyWith(
                                  color: isEmployee
                                      ? Constant.colorOnError
                                      : Constant.cBlack,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Constant.paddingMidDouble.heightBox,
            isEmployee
                ? adminSystemFaultScreen()
                : Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.transparent,
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  color: Constant.cWhite,
                                  child: MySystemFaults(
                                    sizeTag: widget.sizeTag,
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomButton(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ApplySystemFaults(
                                          sizeTag: widget.sizeTag,
                                          context: context,
                                        );
                                      },
                                    );
                                  },
                                  width: 130,
                                  height: 40,
                                  text: systemList[1],
                                  textStyle: Constant.textStyleSize14(context)
                                      ?.copyWith(
                                    color: Constant.cWhite,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  color: Constant.colorSelectedIndicator,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  adminSystemFaultScreen() {
    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Constant.cBlack5PerOpacity,
              ),
              child: Padding(
                padding: const EdgeInsets.all(Constant.paddingHalf),
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(widget.sizeTag == 1 ? 1 : 0.5),
                    1: const FlexColumnWidth(2),
                    2: const FlexColumnWidth(2),
                    3: const FlexColumnWidth(2),
                    4: const FlexColumnWidth(2),
                    5: const FlexColumnWidth(3),
                  },
                  children: [
                    TableRow(
                      children: [
                        Column(
                          children: [
                            Text(
                              Strings.number,
                              style: Constant.textStyleSize13(context)
                                  ?.copyWith(color: Constant.cBlack),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              Strings.employeeName,
                              style: Constant.textStyleSize13(context)
                                  ?.copyWith(color: Constant.cBlack),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              Strings.systemType,
                              style: Constant.textStyleSize13(context)
                                  ?.copyWith(color: Constant.cBlack),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              Strings.description,
                              style: Constant.textStyleSize13(context)
                                  ?.copyWith(color: Constant.cBlack),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              Strings.status,
                              style: Constant.textStyleSize13(context)
                                  ?.copyWith(color: Constant.cBlack),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            allFaults.isEmpty
                ? const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'No Data',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            )
                :  ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allFaults.length,
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  color: Constant.cLightGray,
                  height: 1,
                );
              },
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Table(
                      columnWidths: {
                        0: FlexColumnWidth(widget.sizeTag == 1 ? 1 : 0.5),
                        1: const FlexColumnWidth(2),
                        2: const FlexColumnWidth(2),
                        3: const FlexColumnWidth(2),
                        4: const FlexColumnWidth(2),
                        5: const FlexColumnWidth(3),
                      },
                      children: [
                        TableRow(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: Constant.padding,
                                      right: Constant.paddingHalf,
                                      top: Constant.paddingMidHalf),
                                  child: Text(
                                    '${index + 1}',
                                    style: Constant.textStyleSize12(context)
                                        ?.copyWith(color: Constant.cBlack),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: Constant.padding,
                                      right: Constant.paddingHalf,
                                      top: Constant.paddingMidHalf),
                                  child: Text(
                                    allFaults[index].user.firstName.toString(),
                                    style: Constant.textStyleSize12(context)
                                        ?.copyWith(color: Constant.cBlack),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: Constant.padding,
                                      right: Constant.paddingHalf,
                                      top: Constant.paddingMidHalf),
                                  child: Text(
                                    allFaults[index].systemType,
                                    style: Constant.textStyleSize12(context)
                                        ?.copyWith(color: Constant.cBlack),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: Constant.padding,
                                      right: Constant.paddingHalf,
                                      top: Constant.paddingMidHalf),
                                  child: Text(
                                    allFaults[index].description,
                                    style: Constant.textStyleSize12(context)
                                        ?.copyWith(color: Constant.cBlack),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: Constant.paddingHalf,
                                    horizontal: widget.sizeTag! > 1
                                        ? Constant.padding
                                        : 0,
                                  ),
                                  child: SizedBox(
                                    height: widget.sizeTag! > 1 ? 20 : 60,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Radio(
                                          value: "1",
                                          groupValue: selectedValues[index],
                                          fillColor: WidgetStateProperty.all(
                                              Constant.cBlue),
                                          onChanged: (value) {
                                            showDialog(
                                              context: context,
                                              builder: ((context) {
                                                return Material(
                                                  color: Constant.cBlack
                                                      .withOpacity(0.1),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right:
                                                            Constant.padding3x,
                                                        left: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.2),
                                                    child: Center(
                                                        child:
                                                            SystemFaultAlertDialogue(
                                                      fault: allFaults[index],
                                                      isSolved: value == "1"
                                                          ? false
                                                          : true,
                                                    )),
                                                  ),
                                                );
                                              }),
                                            );
                                          },
                                        ),
                                        widget.sizeTag == 1
                                            ? const SizedBox.shrink()
                                            : const Text(
                                                "In Progress",
                                                style: TextStyle(
                                                    color: Constant.cBlue),
                                              ),
                                        const SizedBox(width: 10),
                                        Radio(
                                          value: "2",
                                          groupValue: selectedValues[index],
                                          fillColor: WidgetStateProperty.all(
                                            Colors.green,
                                          ),
                                          onChanged: (value) {
                                            showDialog(
                                              context: context,
                                              builder: ((context) {
                                                return Material(
                                                  color: Constant.cBlack
                                                      .withOpacity(0.1),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right:
                                                            Constant.padding3x,
                                                        left: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.2),
                                                    child: Center(
                                                        child:
                                                            SystemFaultAlertDialogue(
                                                      fault: allFaults[index],
                                                      isSolved: value == "1"
                                                          ? false
                                                          : true,
                                                    )),
                                                  ),
                                                );
                                              }),
                                            );
                                          },
                                        ),
                                        widget.sizeTag == 1
                                            ? const SizedBox.shrink()
                                            : const Text(
                                                "Solved",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    index == allFaults.lastIndex
                        ? Container(
                            height: 1,
                            color: Constant.colorGrey,
                          )
                        : const SizedBox.shrink(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
