import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/leave_bloc/leave_repositories.dart';
import 'package:oceanbit_timeclock/widget/new/custom_dropdown_with_label.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../bloc_logic/leave_bloc/leave_bloc.dart';
import '../../../bloc_logic/leave_bloc/leave_event.dart';
import '../../../constant/constant.dart';
import '../../../constant/strings.dart';
import '../../../utils/date_formatter.dart';
import '../../../utils/logger.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_form_label.dart';
import '../../../widget/custom_text_field.dart';
import '../../../widget/new/custom_datepicker_theme.dart';
import 'my_leaves.dart';

class ApplyLeave extends StatefulWidget {
  ApplyLeave({
    Key? key,
    this.sizeTag,
    required this.context,
    this.isUpdate = false,
  }) : super(key: key);
  int? sizeTag;
  BuildContext context;
  bool isUpdate = false;

  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

List<String> staticLeaveList = [
  'Leave Without Pay(LWP)',
  allLeaveBalances.isNotEmpty
      ? 'Sick Leave(SL)(${allLeaveBalances[0]?.masterLeave.name == "Sick Leave" ? allLeaveBalances[0]?.remainingLeaves : allLeaveBalances[1]?.remainingLeaves})'
      : 'Sick Leave(SL)',
  'Privilege Leave(PL)',
  allLeaveBalances.isNotEmpty
      ? 'Casual Leave(CL)(${allLeaveBalances[0]?.masterLeave.name == "Casual Leave" ? allLeaveBalances[0]?.remainingLeaves : allLeaveBalances[1]?.remainingLeaves})'
      : 'Casual Leave(CL)',
];

class _ApplyLeaveState extends State<ApplyLeave> {
  late final LeaveRepository repo;
  @override
  void initState() {
    repo = context.read<LeaveRepository>();
    staticLeaveList = [
      'Leave Without Pay(LWP)',
      allLeaveBalances.isNotEmpty
          ? 'Sick Leave(SL)(${allLeaveBalances[0]?.masterLeave.name == "Sick Leave" ? allLeaveBalances[0]?.remainingLeaves : allLeaveBalances[1]?.remainingLeaves})'
          : 'Sick Leave(SL)',
      'Privilege Leave(PL)',
      allLeaveBalances.isNotEmpty
          ? 'Casual Leave(CL)(${allLeaveBalances[0]?.masterLeave.name == "Casual Leave" ? allLeaveBalances[0]?.remainingLeaves : allLeaveBalances[1]?.remainingLeaves})'
          : 'Casual Leave(CL)',
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool autoValidate = false;
    String selectedLeave = Strings.leaveTypeHint;
    String selectedHalfLeave = Strings.halfLeaveHint;
    TextEditingController reasonController = TextEditingController();
    TextEditingController startDateController = TextEditingController();
    TextEditingController endDateController = TextEditingController();
    String leave = '1';
    DateTime? startDate;
    DateTime? endDate;
    int earnedLeave = 4;
    int casualLeave = 4;
    int sickLeave = 4;
    bool isLeaveTypeError = false;
    bool isHalfLeaveError = false;

    return StatefulBuilder(
      builder: (context, setState) {
        Widget datePicker({
          DateTime? date,
          TextEditingController? controller,
          String? hintText,
          String? validatorString,
          bool start = false,
          String? Function(String?)? validatorFunction,
        }) {
          return CustomTextField(
            controller: controller,
            hintText: hintText,
            isEnable: false,
            textColor: Constant.cFontLight,
            onChanged: (val) {},
            onTap: () async {
              date = await showDatePicker(
                context: context,
                initialDate: start ? DateTime.now() : startDate,
                firstDate: start
                    ? DateTime(DateTime.now().year - 1)
                    : startDate!,
                lastDate: start
                    ? DateTime(DateTime.now().year + 1)
                    : DateTime(
                        startDate!.year,
                        startDate!.month,
                        startDate!.day,
                      ).add(Duration(days: 2)),
                builder: (context, child) {
                  return CustomDatePickerTheme(child: child!);
                },
              );
              setState(() {
                if (date != null) {
                  controller!.text = DateFormatter.formateDate(
                    inputFormatter: "yyyy-MM-dd HH:mm:ss",
                    input: date.toString(),
                    outputFormatter: "dd-MM-yyyy",
                  );
                  if (start) {
                    startDate = date;
                  } else {
                    endDate = date;
                  }
                }
              });
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
              date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 5),
                builder: (context, child) {
                  return CustomDatePickerTheme(child: child!);
                },
              );
              setState(() {
                controller!.text = DateFormatter.formateDate(
                  inputFormatter: "yyyy-MM-dd HH:mm:ss",
                  input: date.toString(),
                  outputFormatter: "dd-MM-yyyy",
                );
              });
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

        Widget labelWithTextField({
          String? Function(String?)? validatorFunction,
          bool isEnable = true,
          String? labelText,
          TextEditingController? controller,
          String? hintText,
          bool isRequired = false,
          int maxLines = 1,
          TextInputType? keyboardType,
        }) {
          return Padding(
            padding: const EdgeInsets.only(top: Constant.paddingMidHalf),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: widget.sizeTag == 1 ? 150 : 180,
                  child: CustomFormLabel(
                    label: labelText,
                    style: Constant.textStyleSize12(
                      context,
                    )?.copyWith(color: Constant.cBlack),
                    isRequired: isRequired,
                    requiredStyle: Constant.textStyleSize14(
                      context,
                    )?.copyWith(color: Constant.cRed),
                  ),
                ),
                Constant.paddingHalf.widthBox,
                Expanded(
                  child: CustomTextField(
                    validatorFunction: validatorFunction,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: Constant.paddingMidHalf,
                      horizontal: Constant.paddingHalf,
                    ),
                    textColor: Constant.cFontLight,
                    controller: controller,
                    hintText: hintText,
                    type: keyboardType,
                    maxLines: maxLines,
                    isEnable: isEnable,
                  ),
                ),
              ],
            ),
          );
        }

        Widget buildRadioButtonWithLabel(int sizeTag) {
          return Padding(
            padding: const EdgeInsets.only(top: Constant.paddingMidHalf),
            child: Row(
              children: [
                SizedBox(
                  width: sizeTag == 1 ? 150 : 180,
                  child: CustomFormLabel(
                    label: 'Select Leave Type ',
                    style: Constant.textStyleSize12(
                      context,
                    )?.copyWith(color: Constant.cBlack),
                    isRequired: true,
                    requiredStyle: Constant.textStyleSize14(
                      context,
                    )?.copyWith(color: Constant.cRed),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: sizeTag == 1 ? 65 : 20,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: sizeTag == 1
                          ? Axis.vertical
                          : Axis.horizontal,
                      itemCount: Strings.leaveTypeList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) => Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Radio(
                            value: '${index + 1}',
                            groupValue: leave,
                            activeColor: Constant.cBlack,
                            onChanged: (value) {
                              setState(() {
                                leave = "${index + 1}";
                                // halfStartDateController.clear();
                                // fullStartDateController.clear();
                                // endDateController.clear();
                              });
                            },
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          Constant.paddingHalfHalf.widthBox,
                          Text(
                            Strings.leaveTypeList[index],
                            style: Constant.textStyleSize12(
                              context,
                            )?.copyWith(color: Constant.cBlack),
                          ),
                          SizedBox(
                            width: sizeTag == 1
                                ? Constant.paddingHalf
                                : Constant.padding,
                          ),
                          //SizedBox(width: Constant.paddingHalf),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Material(
          color: Colors.black.withOpacity(0.2),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.15,
              // vertical: 270,
            ),
            child: Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(Constant.paddingHalf),
                        topLeft: Radius.circular(Constant.paddingHalf),
                      ),
                      color: Constant.colorSelectedIndicator,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(Constant.paddingHalf),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.list_alt_sharp,
                            color: Constant.cWhite,
                          ),
                          Constant.paddingHalfHalf.widthBox,
                          Text(
                            widget.isUpdate
                                ? Strings.updateLeave.toUpperCase()
                                : Strings.applyLeave.toUpperCase(),
                            style: Constant.textStyleSize14(
                              context,
                            )?.copyWith(color: Constant.cWhite),
                          ),
                          widget.sizeTag != 1
                              ? Row(
                                  children: [
                                    Constant.padding.widthBox,
                                    Text(
                                      "( Earned Leave  =  $earnedLeave ,  Casual Leave  =  $casualLeave ,   Sick Leave  =  $sickLeave )",
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: Constant.textStyleSize10(
                                        context,
                                      )?.copyWith(color: Constant.cWhite),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              color: Constant.cWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(Constant.paddingHalf),
                        bottomRight: Radius.circular(Constant.paddingHalf),
                      ),
                      color: Constant.cWhite,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(Constant.paddingMidHalf),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Form(
                            key: formKey,
                            autovalidateMode: autoValidate
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                LabelWithDropDownButton(
                                  width: widget.sizeTag == 1 ? 150 : 180,
                                  hintText: selectedLeave,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedLeave = value;
                                      if (selectedLeave.contains(
                                            staticLeaveList[0],
                                          ) ||
                                          selectedLeave.contains(
                                            staticLeaveList[3],
                                          ) ||
                                          selectedLeave.contains(
                                            staticLeaveList[1],
                                          ) ||
                                          selectedLeave.contains(
                                            staticLeaveList[2],
                                          )) {
                                        isLeaveTypeError = false;
                                      }
                                    });
                                  },
                                  isRequired: true,
                                  list: staticLeaveList,
                                  labelText: Strings.leaveType,
                                ),
                                isLeaveTypeError
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: widget.sizeTag == 1
                                                  ? 163
                                                  : 193,
                                              top: Constant.paddingHalfHalf,
                                            ),
                                            child: Text(
                                              Strings.leaveTypeEmpty,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.error,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                                buildRadioButtonWithLabel(widget.sizeTag!),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: Constant.paddingMidHalf,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          (widget.sizeTag == 1 ? 160 : 190)
                                              .widthBox,
                                          Expanded(
                                            child: Column(
                                              children: [
                                                // datePicker(
                                                //     controller:
                                                //         startDateController,
                                                //     date: startDate,
                                                //     hintText: Strings.startDate,
                                                //     validatorString:
                                                //         Strings.startDateEmpty,
                                                //    start: true),
                                                datePickerWithOutCondition(
                                                  controller:
                                                      startDateController,
                                                  date: startDate,
                                                  hintText: Strings.startDate,
                                                  validatorString:
                                                      Strings.startDateEmpty,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          (widget.sizeTag == 1 ? 150 : 180)
                                              .widthBox,
                                          Expanded(
                                            child: leave == '1'
                                                ? Column(
                                                    children: [
                                                      LabelWithDropDownButton(
                                                        hintText:
                                                            selectedHalfLeave,
                                                        isNospace: true,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedHalfLeave =
                                                                value
                                                                    .toString();
                                                            if (selectedHalfLeave
                                                                    .contains(
                                                                      'First Half Leave',
                                                                    ) ||
                                                                selectedHalfLeave
                                                                    .contains(
                                                                      'Second Half Leave',
                                                                    )) {
                                                              setState(() {
                                                                isHalfLeaveError =
                                                                    false;
                                                              });
                                                            }
                                                          });
                                                        },
                                                        list: Strings
                                                            .halfLeaveTypeList,
                                                        labelText: '',
                                                      ),
                                                      isHalfLeaveError
                                                          ? Row(
                                                              // mainAxisSize: MainAxisSize.min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.only(
                                                                    left: Constant
                                                                        .paddingHalf,
                                                                    top: Constant
                                                                        .paddingHalfHalf,
                                                                  ),
                                                                  child: Text(
                                                                    Strings
                                                                        .halfLeaveError,
                                                                    style: Theme.of(context)
                                                                        .textTheme
                                                                        .bodySmall!
                                                                        .copyWith(
                                                                          color: Theme.of(
                                                                            context,
                                                                          ).colorScheme.error,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : const SizedBox.shrink(),
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      Constant
                                                          .paddingHalf
                                                          .widthBox,
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Constant
                                                                .paddingMidHalf
                                                                .heightBox,
                                                            // datePicker(
                                                            //   controller:
                                                            //       endDateController,
                                                            //   date: endDate,
                                                            //   hintText:
                                                            //       Strings.endDate,
                                                            //   validatorString:
                                                            //       Strings
                                                            //           .endDateEmpty,
                                                            // ),
                                                            datePickerWithOutCondition(
                                                              controller:
                                                                  endDateController,
                                                              date: endDate,
                                                              hintText: Strings
                                                                  .endDate,
                                                              validatorString:
                                                                  Strings
                                                                      .endDateEmpty,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                labelWithTextField(
                                  controller: reasonController,
                                  labelText: Strings.reason,
                                  hintText: Strings.reasonHint,
                                  maxLines: 4,
                                  isRequired: true,
                                  keyboardType: TextInputType.name,
                                  validatorFunction: (val) {
                                    if (val!.isEmpty) {
                                      return Strings.reasonEmpty;
                                    } else {
                                      autoValidate = true;
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          Constant.paddingMidDouble.heightBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomButton(
                                color: Constant.colorSelectedIndicator,
                                textStyle: Constant.textStyleSize10(
                                  context,
                                )!.copyWith(color: Constant.cWhite),
                                height: 40,
                                width: 130,
                                text: widget.isUpdate
                                    ? Strings.update
                                    : Strings.apply,
                                onTap: () {
                                  repo.page = 1;
                                  if (selectedLeave.contains(
                                    Strings.leaveTypeHint,
                                  )) {
                                    setState(() {
                                      isLeaveTypeError = true;
                                    });
                                  } else if (selectedLeave.contains(
                                        staticLeaveList[0],
                                      ) ||
                                      selectedLeave.contains(
                                        staticLeaveList[3],
                                      ) ||
                                      selectedLeave.contains(
                                        staticLeaveList[1],
                                      ) ||
                                      selectedLeave.contains(
                                        staticLeaveList[2],
                                      )) {
                                    setState(() {
                                      isLeaveTypeError = false;
                                    });
                                  }
                                  if (selectedHalfLeave.contains(
                                    Strings.halfLeaveHint,
                                  )) {
                                    setState(() {
                                      isHalfLeaveError = true;
                                    });
                                  } else if (selectedHalfLeave.contains(
                                        'First Half Leave',
                                      ) ||
                                      selectedHalfLeave.contains(
                                        'Second Half Leave',
                                      )) {
                                    setState(() {
                                      isHalfLeaveError = false;
                                    });
                                  }
                                  if (formKey.currentState!.validate()) {
                                    int leaveTypeValue = leave == '1'
                                        ? selectedHalfLeave ==
                                                  'First Half Leave'
                                              ? 1
                                              : 2
                                        : 0;
                                    int leaveValue =
                                        selectedLeave == staticLeaveList[0]
                                        ? 0
                                        : selectedLeave == staticLeaveList[3]
                                        ? 3
                                        : selectedLeave == staticLeaveList[1]
                                        ? 1
                                        : selectedLeave == staticLeaveList[2]
                                        ? 2
                                        : 0;
                                    widget.isUpdate
                                        ? Logger.println('')
                                        : BlocProvider.of<LeaveBloc>(
                                            context,
                                          ).add(
                                            AddLeaveEvent(
                                              startDateController.text,
                                              leave == '1'
                                                  ? startDateController.text
                                                  : endDateController.text,
                                              reasonController.text,
                                              leaveTypeValue.toString(),
                                              leaveValue.toString(),
                                              context: context,
                                            ),
                                          );
                                  } else {
                                    autoValidate = true;
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
