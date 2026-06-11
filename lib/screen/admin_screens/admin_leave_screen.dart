import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oceanbit_timeclock/bloc_logic/leave_bloc/leave_repositories.dart';
import 'package:oceanbit_timeclock/bloc_logic/leave_bloc/leave_state.dart';
import 'package:oceanbit_timeclock/screen/leaves/widget/my_leaves.dart';
import 'package:oceanbit_timeclock/widget/custom_text_field.dart';
import 'package:oceanbit_timeclock/widget/new/custom_header_container.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../bloc_logic/leave_bloc/leave_bloc.dart';
import '../../bloc_logic/leave_bloc/leave_event.dart';
import '../../constant/constant.dart';
import '../../constant/strings.dart';
import '../../models/leave_model.dart';
import '../../utils/date_formatter.dart';
import '../../utils/logger.dart';
import '../../widget/custom_button.dart';
import '../../widget/new/custom_datepicker_theme.dart';
import '../../widget/new/custom_dropdown.dart';
import '../dashboard/dashboard.dart';
import '../leaves/widget/apply_leave.dart';
import '../leaves/widget/leave_screen.dart';
import 'leave_alert_dialog.dart';

class AdminLeaveScreen extends StatefulWidget {
  const AdminLeaveScreen({Key? key, this.sizeTag}) : super(key: key);
  final int? sizeTag;

  @override
  State<AdminLeaveScreen> createState() => _AdminLeaveScreenState();
}

TextEditingController searchController = TextEditingController();
TextEditingController startDateController = TextEditingController();
TextEditingController endDateController = TextEditingController();
String? selectedStatus;

class _AdminLeaveScreenState extends State<AdminLeaveScreen> {
  bool isEmployee = false;
  late final LeaveRepository repository;

  @override
  void initState() {
    repository = context.read<LeaveRepository>();
    repository.page = 1;
    super.initState();
  }

  Widget datePickerWithOutCondition({
    DateTime? date,
    TextEditingController? controller,
    String? hintText,
    String? validatorString,
    String? Function(String?)? validatorFunction,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      isEnable: true,
      textColor: Constant.cFontLight,
      onChanged: (val) {},
      onTap: () async {
        final now = DateTime.now();
        final safeInitialDate = DateTime(now.year, now.month, now.day);

        final safeLastDate = DateTime(now.year, 12, 31);

        final safeFirstDate = DateTime(now.year - 5);

        date = await showDatePicker(
          context: context,
          initialDate: safeInitialDate,
          firstDate: safeFirstDate,
          lastDate: safeLastDate,
          builder: (context, child) {
            return CustomDatePickerTheme(child: child!);
          },
        );

        if (date != null) {
          setState(() {
            controller!.text = DateFormatter.formateDate(
              inputFormatter: "yyyy-MM-dd HH:mm:ss",
              input: date.toString(),
              outputFormatter: "dd-MM-yyyy",
            );
          });
        }
      },

      validatorFunction:
          validatorFunction ??
          (val) {
            if (val!.isEmpty) {
              return validatorString;
            }
            return null;
          },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LeaveBloc, LeaveState>(
      listener: (context, state) {
        if (state is GetLeaveLoading || state is UpdateLeaveLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is GetLeaveError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is GetLeaveLoaded) {
          repository.isLoading = false;
          if (repository.page < 2) {
            allLeave.clear();
          }
          allLeave.addAll(state.data!.data);
          print('leave count ::  ${allLeave.length}');

          selectedValues = List.generate(
            allLeave.length,
            (index) => allLeave[index].leaveStatus.value,
          );
          print('leave first adat ::  ${selectedValues[1]}');
          setState(() {});
        }
        if (state is UpdateLeaveError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is UpdateLeaveLoaded) {
          repository.page = 1;
          allLeave.clear();
          BlocProvider.of<LeaveBloc>(context).add(
            GetLeaveEvent(
              context: context,
              text: searchController.text,
              startDate: startDateController.text,
              endDate: endDateController.text,
              status: selectedStatus == Strings.statusList[0]
                  ? '-1'
                  : selectedStatus == Strings.statusList[1]
                  ? '1'
                  : selectedStatus == Strings.statusList[2]
                  ? '0'
                  : null,
            ),
          );
          Navigator.pop(context);
        }
      },
      child: CustomHeaderContainer(
        headerText: Strings.leave,
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 400,
                  decoration: BoxDecoration(
                    color: Constant.cBlack.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(Constant.paddingHalf),
                            child: Center(
                              child: Text(
                                Strings.myLeave,
                                style: Constant.textStyleSize20(context)
                                    ?.copyWith(
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
                          setState(() {
                            isEmployee = true;
                          });
                          if (!repository.isLoading && !repository.isLastPage) {
                            repository.isLoading = true;
                          }
                          repository.page = 1;
                          BlocProvider.of<LeaveBloc>(context).add(
                            GetLeaveEvent(
                              context: context,
                              text: searchController.text,
                              startDate: startDateController.text,
                              endDate: endDateController.text,
                              status: selectedStatus == Strings.statusList[0]
                                  ? '-1'
                                  : selectedStatus == Strings.statusList[1]
                                  ? '1'
                                  : selectedStatus == Strings.statusList[2]
                                  ? '0'
                                  : null,
                            ),
                          );
                        },
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                            color: isEmployee
                                ? Constant.colorSelectedIndicator
                                : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(Constant.paddingHalf),
                            child: Center(
                              child: Text(
                                Strings.employeeLeave,
                                style: Constant.textStyleSize20(context)
                                    ?.copyWith(
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
                ? Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CustomTextField(
                              // validatorFunction: validatorFunction,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: Constant.paddingMidHalf,
                                horizontal: Constant.paddingHalf,
                              ),
                              textColor: Constant.cFontLight,
                              controller: searchController,
                              hintText: 'Search',
                              suffixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Constant.paddingHalfHalf.widthBox,
                          Expanded(
                            child: datePickerWithOutCondition(
                              controller: startDateController,
                              date: DateTime(DateTime.now().year - 5),
                              hintText: Strings.startDate,
                              validatorString: Strings.startDateEmpty,
                            ),
                          ),
                          Constant.paddingHalfHalf.widthBox,
                          Expanded(
                            child: datePickerWithOutCondition(
                              controller: endDateController,
                              date: DateTime(DateTime.now().year - 5),
                              hintText: Strings.endDate,
                              validatorString: Strings.endDateEmpty,
                            ),
                          ),
                          Constant.paddingHalfHalf.widthBox,
                          Expanded(
                            child: CustomDropDown(
                              height: 45,
                              hintText: Strings.statusHint,
                              selectedValue: selectedStatus,
                              list: Strings.statusList,
                              onChange: (value) {
                                setState(() {
                                  selectedStatus = value.toString();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Constant.paddingHalf.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButton(
                            height: 40,
                            width: 120,
                            text: Strings.reset,
                            textStyle: Constant.textStyleSize14(
                              context,
                            )?.copyWith(color: Constant.cWhite),
                            color: Constant.cRedLight,
                            onTap: () {
                              selectedStatus = null;
                              startDateController.clear();
                              endDateController.clear();
                              searchController.clear();
                              allLeave.clear();
                              selectedValues.clear();
                              repository.page = 1;
                              BlocProvider.of<LeaveBloc>(context).add(
                                GetLeaveEvent(
                                  context: context,
                                  text: searchController.text,
                                  startDate: startDateController.text,
                                  endDate: endDateController.text,
                                  status:
                                      selectedStatus == Strings.statusList[0]
                                      ? '-1'
                                      : selectedStatus == Strings.statusList[1]
                                      ? '1'
                                      : selectedStatus == Strings.statusList[2]
                                      ? '0'
                                      : null,
                                ),
                              );
                            },
                          ),
                          Constant.paddingHalf.widthBox,
                          CustomButton(
                            height: 40,
                            width: 120,
                            text: Strings.apply,
                            textStyle: Constant.textStyleSize14(
                              context,
                            )?.copyWith(color: Constant.cWhite),
                            color: Constant.colorSelectedIndicator,
                            onTap: () {
                              allLeave.clear();
                              selectedValues.clear();
                              repository.page = 1;
                              BlocProvider.of<LeaveBloc>(context).add(
                                GetLeaveEvent(
                                  context: context,
                                  text: searchController.text,
                                  startDate: startDateController.text,
                                  endDate: endDateController.text,
                                  status:
                                      selectedStatus == Strings.statusList[0]
                                      ? '-1'
                                      : selectedStatus == Strings.statusList[1]
                                      ? '1'
                                      : selectedStatus == Strings.statusList[2]
                                      ? '0'
                                      : null,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Constant.paddingHalf.heightBox,
                    ],
                  )
                : const SizedBox.shrink(),
            isEmployee
                ? AdminLeave(sizeTag: widget.sizeTag)
                : Expanded(
                    child: Stack(
                      children: [
                        Column(
                          children: [MyLeave(), const SizedBox(height: 30)],
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
                                      return ApplyLeave(
                                        sizeTag: widget.sizeTag,
                                        // setState: setState,
                                        context: context,
                                      );
                                    },
                                  );
                                },
                                width: 130,
                                height: 40,
                                text: leaveList[1],
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
          ],
        ),
      ),
    );
  }
}

List<LeaveData> allLeave = [];
List<int?> selectedValues = [];

class AdminLeave extends StatefulWidget {
  const AdminLeave({super.key, required this.sizeTag});
  final int? sizeTag;

  @override
  State<AdminLeave> createState() => _AdminLeaveState();
}

class _AdminLeaveState extends State<AdminLeave> {
  final ScrollController _scrollController = ScrollController();
  String? leave = '1';

  bool isHalfLeave = false;
  late final LeaveRepository repository;

  @override
  void initState() {
    Logger.println("ReportListPage: initState");
    repository = context.read<LeaveRepository>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          Logger.println("PaginatedList: End of list reached");
          Logger.println(
            "Paginated: onScrollAtLast: isLoading: ${repository.isLoading} ",
          );
          Logger.println(
            "Paginated: onScrollAtLast: isLastPage: ${repository.isLastPage} ",
          );
          if (!repository.isLoading && !repository.isLastPage) {
            repository.isLoading = true;
            BlocProvider.of<LeaveBloc>(context).add(
              GetLeaveEvent(
                context: context,
                text: searchController.text,
                startDate: startDateController.text,
                endDate: endDateController.text,
                status: selectedStatus == Strings.statusList[0]
                    ? '-1'
                    : selectedStatus == Strings.statusList[1]
                    ? '1'
                    : selectedStatus == Strings.statusList[2]
                    ? '0'
                    : null,
              ),
            );
          }
        }
      });
    });
    // _scrollController.addListener(() {
    //   Logger.println(
    //       "PaginatedList: onScrollAtLast: isLoading: ${repository.isLoading} ");
    //   if (_scrollController.position.maxScrollExtent ==
    //       _scrollController.position.pixels) {
    //     Logger.println(
    //         "PaginatedList: onScrollAtLast: isLoading: ${repository.isLoading} ");
    //     Logger.println(
    //         "PaginatedList: onScrollAtLast: isLastPage: ${repository.isLastPage} ");
    //     if (!repository.isLoading && !repository.isLastPage) {
    //       repository.isLoading = true;
    //       BlocProvider.of<LeaveBloc>(context)
    //           .add(GetLeaveEvent(context: context));
    //     }
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    Logger.println("ReportListPage: dispose");
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          allLeave.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      Strings.noData,
                      style: Constant.textStyleSize15(
                        context,
                      )?.copyWith(color: Constant.cBlack.withOpacity(0.5)),
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Constant.cBlack5PerOpacity,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Constant.paddingHalf),
                    child: Table(
                      columnWidths: {
                        // 0: FlexColumnWidth(widget.sizeTag == 1 ? 1 : 0.5),
                        0: const FlexColumnWidth(2),
                        1: const FlexColumnWidth(4),
                        2: const FlexColumnWidth(1),
                        3: const FlexColumnWidth(2),
                        4: const FlexColumnWidth(2),
                        5: FlexColumnWidth(widget.sizeTag == 1 ? 1 : 1),
                        6: const FlexColumnWidth(3),
                      },
                      children: [
                        TableRow(
                          children: [
                            // Column(
                            //   children: [
                            //     Text(
                            //       Strings.number,
                            //       style: Constant.textStyleSize13(context)
                            //           ?.copyWith(color: Constant.cBlack),
                            //     ),
                            //   ],
                            // ),
                            Column(
                              children: [
                                Text(
                                  Strings.employeeName,
                                  style: Constant.textStyleSize13(
                                    context,
                                  )?.copyWith(color: Constant.cBlack),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  Strings.reason,
                                  style: Constant.textStyleSize13(
                                    context,
                                  )?.copyWith(color: Constant.cBlack),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  Strings.lT,
                                  style: Constant.textStyleSize13(
                                    context,
                                  )?.copyWith(color: Constant.cBlack),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  Strings.startDate,
                                  style: Constant.textStyleSize13(
                                    context,
                                  )?.copyWith(color: Constant.cBlack),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  isHalfLeave
                                      ? Strings.leaveType
                                      : Strings.endDate,
                                  style: Constant.textStyleSize13(
                                    context,
                                  )?.copyWith(color: Constant.cBlack),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  Strings.days,
                                  style: Constant.textStyleSize13(
                                    context,
                                  )?.copyWith(color: Constant.cBlack),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  Strings.status,
                                  style: Constant.textStyleSize13(
                                    context,
                                  )?.copyWith(color: Constant.cBlack),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
          Expanded(
            flex: 1,
            child: ListView.separated(
              controller: _scrollController,
              itemCount: allLeave.length,
              separatorBuilder: (BuildContext context, int index) {
                return Container(color: Constant.cLightGray, height: 1);
              },
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Table(
                      columnWidths: {
                        // 0: FlexColumnWidth(widget.sizeTag == 1 ? 1 : 0.5),
                        0: const FlexColumnWidth(2),
                        1: const FlexColumnWidth(4),
                        2: const FlexColumnWidth(1),
                        3: const FlexColumnWidth(2),
                        4: const FlexColumnWidth(2),
                        5: FlexColumnWidth(widget.sizeTag == 1 ? 1 : 1),
                        6: const FlexColumnWidth(3),
                      },
                      children: [
                        TableRow(
                          children: [
                            // Column(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Padding(
                            //       padding: const EdgeInsets.only(
                            //           left: Constant.padding,
                            //           right: Constant.paddingHalf,
                            //           top: Constant.paddingMidHalf),
                            //       child: Text(
                            //         '${index + 1}',
                            //         style: Constant.textStyleSize12(context)
                            //             ?.copyWith(color: Constant.cBlack),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: Constant.padding,
                                    right: Constant.paddingHalf,
                                    top: Constant.paddingMidHalf,
                                  ),
                                  child: Text(
                                    '${allLeave[index].user.firstName.toString()} ${allLeave[index].user.lastName.toString()}',
                                    style: Constant.textStyleSize12(
                                      context,
                                    )?.copyWith(color: Constant.cBlack),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: Constant.padding,
                                    right: Constant.paddingHalf,
                                    top: Constant.paddingMidHalf,
                                  ),
                                  child: Text(
                                    allLeave[index].reason,
                                    style: Constant.textStyleSize12(
                                      context,
                                    )?.copyWith(color: Constant.cBlack),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: Constant.padding,
                                    right: Constant.paddingHalf,
                                    top: Constant.paddingMidHalf,
                                  ),
                                  child: Text(
                                    allLeave[index].leave.shortName!,
                                    style: Constant.textStyleSize12(
                                      context,
                                    )?.copyWith(color: Constant.cBlack),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: Constant.paddingHalf,
                                    right: Constant.paddingHalf,
                                    top: Constant.paddingMidHalf,
                                  ),
                                  child: Text(
                                    allLeave[index].startDate,
                                    style: Constant.textStyleSize12(
                                      context,
                                    )?.copyWith(color: Constant.cBlack),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: Constant.paddingHalf,
                                    right: Constant.paddingHalf,
                                    top: Constant.paddingMidHalf,
                                  ),
                                  child: Text(
                                    allLeave[index].leaveType.value == 1
                                        ? 'First Half Leave'
                                        : allLeave[index].leaveType.value == 2
                                        ? 'Second Half Leave'
                                        : allLeave[index].endDate,
                                    style: Constant.textStyleSize12(
                                      context,
                                    )?.copyWith(color: Constant.cBlack),
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
                                    top: Constant.paddingMidHalf,
                                  ),
                                  child: Text(
                                    allLeave[index].leaveDaysCount.toString(),
                                    style: Constant.textStyleSize12(
                                      context,
                                    )?.copyWith(color: Constant.cBlack),
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
                                    // height: widget.sizeTag! > 1 ? 20 : 60,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Radio<int>(
                                              value: 1,
                                              groupValue: selectedValues[index],
                                              fillColor:
                                                  WidgetStateProperty.all(
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
                                                        padding:
                                                            EdgeInsets.only(
                                                              right: Constant
                                                                  .padding3x,
                                                              left:
                                                                  MediaQuery.of(
                                                                    context,
                                                                  ).size.width *
                                                                  0.2,
                                                            ),
                                                        child: Center(
                                                          child: LeaveAlertDialogue(
                                                            leave:
                                                                allLeave[index],
                                                            isAccept: value == 0
                                                                ? false
                                                                : true,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                );
                                              },
                                            ),
                                            widget.sizeTag == 1
                                                ? const SizedBox.shrink()
                                                : const Text(
                                                    "Accept",
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          children: [
                                            Radio<int>(
                                              value: 0,
                                              groupValue: selectedValues[index],
                                              fillColor:
                                                  WidgetStateProperty.all(
                                                    Colors.red,
                                                  ),
                                              onChanged:
                                                  DateFormat("dd-MM-yyyy")
                                                      .parse(
                                                        allLeave[index].endDate,
                                                      )
                                                      .isBefore(
                                                        DateTime(
                                                          DateTime.now().year,
                                                          DateTime.now().month,
                                                          DateTime.now().day,
                                                        ),
                                                      )
                                                  ? (value) {}
                                                  : (value) {
                                                      showDialog(
                                                        context: context,
                                                        builder: ((context) {
                                                          return Material(
                                                            color: Constant
                                                                .cBlack
                                                                .withOpacity(
                                                                  0.1,
                                                                ),
                                                            child: Padding(
                                                              padding: EdgeInsets.only(
                                                                right: Constant
                                                                    .padding3x,
                                                                left:
                                                                    MediaQuery.of(
                                                                      context,
                                                                    ).size.width *
                                                                    0.2,
                                                              ),
                                                              child: Center(
                                                                child: LeaveAlertDialogue(
                                                                  leave:
                                                                      allLeave[index],
                                                                  isAccept:
                                                                      value == 0
                                                                      ? false
                                                                      : true,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                      );
                                                      // BlocProvider.of<LeaveBloc>(context).add(
                                                      //     UpdateLeaveEvent(
                                                      //         allLeave[index].userId,
                                                      //         allLeave[index].id,
                                                      //         selectedValues[index]!,
                                                      //         context: context));
                                                    },
                                            ),
                                            widget.sizeTag == 1
                                                ? const SizedBox.shrink()
                                                : const Text(
                                                    "Reject",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    //     Row(
                                    //   mainAxisAlignment: MainAxisAlignment.start,
                                    //   crossAxisAlignment:
                                    //       CrossAxisAlignment.center,
                                    //   children: [
                                    //     Radio(
                                    //       value: valueList[i],
                                    //       fillColor: MaterialStateProperty.all(
                                    //         leaveStatus[i] == 'Accept'
                                    //             ? Constant.cGreenLight
                                    //             : Constant.cRedLight,
                                    //       ),
                                    //       groupValue: statusList[index],
                                    //       activeColor: statusList[index] != '3' &&
                                    //               leaveStatus[i] == 'Accept'
                                    //           ? Constant.cGreenLight
                                    //           : Constant.cRedLight,
                                    //       onChanged: (value) {
                                    //         setState(() {
                                    //           leave = "${i + 1}";
                                    //           selectedIndex = i;
                                    //           if (selectedIndex == i) {
                                    //             valueList[selectedIndex!] =
                                    //                 '${i + 1}';
                                    //             statusList[index] = "${i + 1}";
                                    //           }
                                    //         });
                                    //         print('selected index value ::$selectedIndex');
                                    //       },
                                    //       materialTapTargetSize:
                                    //           MaterialTapTargetSize.shrinkWrap,
                                    //     ),
                                    //     Text(
                                    //       leaveStatus[i],
                                    //       style: Constant.textStyleSize12(context)
                                    //           ?.copyWith(
                                    //         color: leaveStatus[i] == 'Accept'
                                    //             ? Constant.cGreenLight
                                    //             : Constant.cRedLight,
                                    //       ),
                                    //     ),
                                    //     const SizedBox(
                                    //         width: Constant.paddingHalf),
                                    //   ],
                                    // ),
                                  ) /*(statusList[index] != 'Pending')
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: Constant.paddingHalfHalf,
                                                  bottom: Constant.paddingHalfHalf
                                                ),
                                                child: Text(
                                                  statusList[index],
                                                  style: Constant.textStyleSize12(
                                                          context)
                                                      ?.copyWith(
                                                    color: Constant.cBlack,
                                                  ),
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Flexible(
                                                    child: CustomContainerButton(
                                                      height: 25,
                                                      width: 100,
                                                      text: Strings.accept,
                                                      color: Constant.cGreenLight,
                                                      onTap: () {
                                                        setState(() {});
                                                        selectedIndex = index;
                                                        if (selectedIndex ==
                                                            index) {
                                                          statusList[
                                                                  selectedIndex!] =
                                                              'Accept';
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  Constant
                                                      .paddingHalfHalf.widthBox,
                                                  Flexible(
                                                    child: CustomContainerButton(
                                                      height: 25,
                                                      width: 100,
                                                      text: Strings.reject,
                                                      color: Constant.cRed,
                                                      onTap: () {
                                                        setState(() {});
                                                        selectedIndex = index;
                                                        if (selectedIndex ==
                                                            index) {
                                                          statusList[
                                                                  selectedIndex!] =
                                                              "Reject";
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),*/,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    index == allLeave.lastIndex
                        ? Container(height: 1, color: Constant.colorGrey)
                        : const SizedBox.shrink(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
