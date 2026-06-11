import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oceanbit_timeclock/bloc_logic/employee_info_bloc/employee_info_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/employee_info_bloc/employee_info_event.dart';
import 'package:oceanbit_timeclock/models/user_detail_model.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../bloc_logic/employee_info_bloc/employee_info_state.dart';
import '../../../constant/constant.dart';
import '../../../constant/strings.dart';
import '../../../local_storage/my_local_storage.dart';
import '../../../models/get_employee_info_model.dart';
import '../../../utils/date_formatter.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_text_field.dart';
import '../../../widget/new/custom_datepicker_theme.dart';
import '../../../widget/new/custom_dropdown.dart';
import '../../admin_screens/employee_screen/widgets/alert_dialog.dart';
import '../../dashboard/dashboard.dart';

class EmployeeInfo extends StatefulWidget {
  const EmployeeInfo({
    Key? key,
    this.userDetail,
    required this.isEmployee,
    this.rowSegment,
    this.sizeTag,
  }) : super(key: key);
  final UserData? userDetail;
  final bool isEmployee;
  final int? rowSegment;
  final int? sizeTag;

  @override
  State<EmployeeInfo> createState() => _EmployeeInfoState();
}

class _EmployeeInfoState extends State<EmployeeInfo> {
  TextEditingController employeeCodeController = TextEditingController();
  TextEditingController joiningDateController = TextEditingController();
  TextEditingController promotionPeriodController = TextEditingController();
  TextEditingController basicSalaryController = TextEditingController();
  TextEditingController hraController = TextEditingController();
  TextEditingController daController = TextEditingController();
  TextEditingController taController = TextEditingController();
  TextEditingController securityDepositController = TextEditingController();
  TextEditingController monthlySecurityDepositController =
      TextEditingController();
  TextEditingController bonusOneController = TextEditingController();
  TextEditingController bonusTwoController = TextEditingController();
  TextEditingController minimumFullTimeController = TextEditingController();
  TextEditingController minimumHalfTimeController = TextEditingController();
  Department? selectedDepartment;
  Department? selectedDesignation;
  List<String> departmentNameList = [];
  List<String> designationNameList = [];
  List<Department> departmentList = [];
  List<Department> designationList = [];
  DateTime? joiningDate;
  TimeOfDay? minimumFullTime;
  TimeOfDay? minimumHalfTime;
  List<EmployeeInfoData> employeeData = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    BlocProvider.of<EmployeeInfoBloc>(context).add(
      GetEmployeeInfo(
        context: context,
        id: widget.userDetail?.id ?? MyLocalStorage().getUser()!.id,
      ),
    );
    BlocProvider.of<EmployeeInfoBloc>(
      context,
    ).add(GetEmployeeInfoDetail(context: context));
    employeeCodeController.text =
        widget.userDetail?.employeeId ?? MyLocalStorage().getUser()!.employeeId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeInfoBloc, EmployeeInfoState>(
      listener: (context, state) {
        if (state is GetEmployeeInfoLoading ||
            state is AddEmployeeInfoLoading ||
            state is GetEmployeeInfoDetailLoading ||
            state is IncrementLoading ||
            state is UpdateEmployeeInfoLoading ||
            state is DeleteEmployeeInfoLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
        }
        if (state is GetEmployeeInfoError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          // Constant().ShowToast(state.error, context);
        } else if (state is GetEmployeeInfoLoaded) {
          selectedDesignation = null;
          selectedDepartment = null;
          joiningDateController.clear();
          promotionPeriodController.clear();
          basicSalaryController.clear();
          hraController.text = '0';
          daController.text = '0';
          taController.text = '0';
          minimumFullTimeController.clear();
          minimumHalfTimeController.clear();
          securityDepositController.text = '0';
          monthlySecurityDepositController.text = '0';
          bonusOneController.text = '0';
          bonusTwoController.text = '0';
          employeeData.clear();
          employeeData = List.generate(
            state.data.data.length,
            (index) => state.data.data[index],
          );
          setState(() {});
        }
        if (state is GetEmployeeInfoDetailError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          // Constant().ShowToast(state.error, context);
        } else if (state is GetEmployeeInfoDetailLoaded) {
          departmentNameList.clear();
          designationNameList.clear();
          departmentList.clear();
          designationList.clear();
          departmentNameList = List.generate(
            state.data.data.departments.length,
            (index) => state.data.data.departments[index].name,
          );
          designationNameList = List.generate(
            state.data.data.designations.length,
            (index) => state.data.data.designations[index].name,
          );

          departmentList = List.generate(
            state.data.data.departments.length,
            (index) => state.data.data.departments[index],
          );
          designationList = List.generate(
            state.data.data.designations.length,
            (index) => state.data.data.designations[index],
          );
          setState(() {});
        }

        if (state is AddEmployeeInfoError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Constant().show_toast(state.errors, context);
        } else if (state is AddEmployeeInfoLoaded) {
          BlocProvider.of<EmployeeInfoBloc>(context).add(
            GetEmployeeInfo(
              context: context,
              id: widget.userDetail?.id ?? MyLocalStorage().getUser()!.id,
            ),
          );
          Navigator.pop(context);
          Constant().show_toast('Add successfully', context);
        }

        if (state is IncrementError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Constant().show_toast(state.errors, context);
        } else if (state is IncrementLoaded) {
          BlocProvider.of<EmployeeInfoBloc>(context).add(
            GetEmployeeInfo(
              context: context,
              id: widget.userDetail?.id ?? MyLocalStorage().getUser()!.id,
            ),
          );
          Navigator.pop(context);
          Constant().show_toast('Increment successfully', context);
        }

        if (state is UpdateEmployeeInfoError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Constant().show_toast(state.errors, context);
        } else if (state is UpdateEmployeeInfoLoaded) {
          BlocProvider.of<EmployeeInfoBloc>(context).add(
            GetEmployeeInfo(
              context: context,
              id: widget.userDetail?.id ?? MyLocalStorage().getUser()!.id,
            ),
          );
          Navigator.pop(context);
          Constant().show_toast('Update successfully', context);
        }

        if (state is DeleteEmployeeInfoError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
        } else if (state is DeleteEmployeeInfoLoaded) {
          BlocProvider.of<EmployeeInfoBloc>(context).add(
            GetEmployeeInfo(
              context: context,
              id: widget.userDetail?.id ?? MyLocalStorage().getUser()!.id,
            ),
          );
          Navigator.pop(context);
          Constant().show_toast('Delete successfully', context);
        }
      },
      child: Stack(
        children: [
          employeeData.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: employeeData.length,
                        itemBuilder: (context, index) {
                          return mainContainer(
                            employee: employeeData[index],
                            isCurrent: index == 0 ? true : false,
                          );
                        },
                      ),
                      const SizedBox(height: Constant.padding2_5x),
                    ],
                  ),
                )
              : const Center(
                  child: Text(
                    'No any Data',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
          Positioned(
            bottom: 0,
            right: 0,
            child: MyLocalStorage().getUser()!.isAdmin
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        color: Constant.colorSelectedIndicator,
                        height: 35,
                        width: 130,
                        radius: 5,
                        text: Strings.add,
                        textStyle: Constant.textStyleSize10(
                          context,
                        )!.copyWith(color: Constant.cWhite),
                        onTap: () {
                          selectedDesignation = null;
                          selectedDepartment = null;
                          joiningDateController.clear();
                          promotionPeriodController.clear();
                          basicSalaryController.clear();
                          hraController.text = '0';
                          daController.text = '0';
                          taController.text = '0';
                          minimumFullTimeController.clear();
                          minimumHalfTimeController.clear();
                          securityDepositController.text = '0';
                          monthlySecurityDepositController.text = '0';
                          bonusOneController.text = '0';
                          bonusTwoController.text = '0';
                          showDialog(
                            context: context,
                            builder: ((context) {
                              return Material(
                                color: Constant.cBlack.withOpacity(0.1),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right:
                                        MediaQuery.of(context).size.width * 0.2,
                                    left:
                                        MediaQuery.of(context).size.width * 0.2,
                                  ),
                                  child: Center(child: customDialog()),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget mainContainer({
    bool isTextField = false,
    required EmployeeInfoData employee,
    bool isCurrent = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(Constant.paddingHalf),
      child: Container(
        decoration: BoxDecoration(
          color: Constant.cWhite,
          boxShadow: [
            BoxShadow(
              color: isCurrent
                  ? Colors.green.withOpacity(0.50)
                  : Constant.cRed.withOpacity(0.50),
              offset: const Offset(0, 0),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
          borderRadius: BorderRadius.circular(Constant.paddingHalf),
        ),
        child: Stack(
          children: [
            if (widget.isEmployee && employee.designation.shortName == 'IN')
              Positioned(
                right: 20,
                top: 10,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: ((context) {
                            return Material(
                              color: Constant.cBlack.withOpacity(0.1),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: Constant.padding3x,
                                  left: MediaQuery.of(context).size.width * 0.2,
                                ),
                                child: Center(
                                  child: markSheetPreviewDialog(
                                    context,
                                    widget.userDetail?.employeeId ??
                                        MyLocalStorage().getUser()!.employeeId,
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      },
                      child: Container(
                        child: Text(
                          Strings.markSheet,
                          style: Constant.textStyleSize15(context)!.copyWith(
                            color: Constant.cGreenLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    10.widthBox,
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: ((context) {
                            return Material(
                              color: Constant.cBlack.withOpacity(0.1),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: Constant.padding3x,
                                  left: MediaQuery.of(context).size.width * 0.2,
                                ),
                                child: Center(
                                  child: internshipOfferLetterPreviewDialog(
                                    context,
                                    employee,
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      },
                      child: Container(
                        child: Text(
                          Strings.internship,
                          style: Constant.textStyleSize15(context)!.copyWith(
                            color: Constant.cRedLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Constant.padding),
              child: ResponsiveGridList(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                rowMainAxisAlignment: MainAxisAlignment.start,
                desiredItemWidth: MediaQuery.of(context).size.width,
                minSpacing: 20,
                children: [
                  ResponsiveGridRow(
                    rowSegments: 2,
                    children: [
                      ResponsiveGridCol(
                        lg: 1,
                        xs: 1,
                        md: 1,
                        sm: 1,
                        child: Padding(
                          padding: widget.rowSegment == 2
                              ? const EdgeInsets.only(
                                  right: Constant.paddingMidDoubleHalf,
                                )
                              : EdgeInsets.zero,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelWithTextField(
                                isTextField: isTextField,
                                labelText: Strings.employeeCode,
                                labelInfoText:
                                    widget.userDetail?.employeeId ??
                                    MyLocalStorage().getUser()!.employeeId,
                                child: CustomTextField(
                                  controller: employeeCodeController,
                                  hintText: Strings.employeeCode,
                                  type: TextInputType.name,
                                  isEnable: false,
                                  maxLines: 1,
                                ),
                              ),
                              Constant.paddingHalf.heightBox,
                              labelWithTextField(
                                isTextField: isTextField,
                                labelText: Strings.joiningDate,
                                labelInfoText: employee.startDate,
                              ),
                              Constant.paddingHalf.heightBox,
                              labelWithTextField(
                                isTextField: isTextField,
                                labelText: Strings.endDate,
                                labelInfoText:
                                    employee.endDate ?? employee.startDate,
                              ),
                              Constant.paddingHalf.heightBox,
                              labelWithTextField(
                                isTextField: isTextField,
                                labelText: Strings.department,
                                labelInfoText:
                                    employee.department?.name ??
                                    'No any department',
                              ),
                              Constant.paddingHalf.heightBox,
                              labelWithTextField(
                                isTextField: isTextField,
                                labelText: Strings.designation,
                                labelInfoText: employee.designation.name,
                              ),
                              Constant.paddingHalf.heightBox,
                              labelWithTextField(
                                isTextField: isTextField,
                                labelText: Strings.securityDeposit,
                                labelInfoText: employee.securityDeposit
                                    .toString(),
                              ),
                              Constant.paddingHalf.heightBox,
                              labelWithTextField(
                                isTextField: isTextField,
                                labelText: Strings.monthlySecurityDeposit,
                                labelInfoText: employee.monthlySecurityDeposit
                                    .toString(),
                              ),
                              Constant.paddingHalf.heightBox,
                              labelWithTextField(
                                isTextField: isTextField,
                                labelText: Strings.workFullTime,
                                labelInfoText: (employee.workFullTime ?? 0)
                                    .toString(),
                              ),
                              Constant.paddingHalf.heightBox,
                              labelWithTextField(
                                isTextField: isTextField,
                                labelText: Strings.workHalfTime,
                                labelInfoText: (employee.workHalfTime ?? 0)
                                    .toString(),
                              ),
                              Constant.paddingHalf.heightBox,
                            ],
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        lg: 1,
                        xs: 1,
                        md: 1,
                        sm: 1,
                        child: Padding(
                          padding: widget.rowSegment == 2
                              ? const EdgeInsets.only(
                                  right: Constant.paddingMidDoubleHalf,
                                )
                              : EdgeInsets.zero,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              labelWithTextField(
                                isTextField: isTextField,
                                labelText: Strings.promotionPeriod,
                                labelInfoText:
                                    '${employee.period.toString()} month',
                              ),
                              Constant.paddingHalf.heightBox,
                              labelWithTextField(
                                isTextField: isTextField,
                                labelText: Strings.basicSalary,
                                labelInfoText: employee.basicSalary.toString(),
                              ),
                              Constant.paddingHalf.heightBox,
                              labelWithTextField(
                                isTextField: isTextField,
                                labelText: Strings.hra,
                                labelInfoText: employee.hra.toString(),
                              ),
                              Constant.paddingHalf.heightBox,
                              labelWithTextField(
                                isTextField: isTextField,
                                labelText: Strings.da,
                                labelInfoText: employee.da.toString(),
                              ),
                              Constant.paddingHalf.heightBox,
                              labelWithTextField(
                                isTextField: isTextField,
                                labelText: Strings.ta,
                                labelInfoText: employee.ta.toString(),
                              ),
                              Constant.paddingHalf.heightBox,
                              labelWithTextField(
                                isTextField: isTextField,
                                labelText: Strings.bonusOne,
                                labelInfoText: employee.bonusOne.toString(),
                              ),
                              Constant.paddingHalf.heightBox,
                              labelWithTextField(
                                isTextField: isTextField,
                                labelText: Strings.bonusTwo,
                                labelInfoText: employee.bonusTwo.toString(),
                              ),
                              Constant.paddingHalf.heightBox,
                              labelWithTextField(
                                isTextField: isTextField,
                                labelText: Strings.minimumFullTime,
                                labelInfoText: (employee.minimumFullTime ?? 0)
                                    .toString(),
                              ),
                              Constant.paddingHalf.heightBox,
                              labelWithTextField(
                                isTextField: isTextField,
                                labelText: Strings.minimumHalfTime,
                                labelInfoText: (employee.minimumHalfTime ?? 0)
                                    .toString(),
                              ),
                              Constant.paddingHalf.heightBox,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Positioned(
              right: 20,
              bottom: 10,
              child: (widget.isEmployee)
                  ? Row(
                      children: [
                        isCurrent
                            ? GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: ((context) {
                                      return Material(
                                        color: Constant.cBlack.withOpacity(0.1),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            right:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.2,
                                            left:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.2,
                                          ),
                                          child: Center(
                                            child: customDialog(
                                              isIncrement: true,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  );
                                },
                                child: Text(
                                  Strings.increment,
                                  style: Constant.textStyleSize15(context)!
                                      .copyWith(
                                        color: Constant.colorSelectedIndicator,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        Constant.paddingHalf.widthBox,
                        GestureDetector(
                          onTap: () {
                            selectedDesignation = employeeData[0].designation;
                            selectedDepartment = employeeData[0].department;
                            joiningDateController.text =
                                employeeData[0].startDate;
                            promotionPeriodController.text = employeeData[0]
                                .period
                                .toString();
                            basicSalaryController.text = employeeData[0]
                                .basicSalary
                                .toString();
                            hraController.text = employeeData[0].hra.toString();
                            daController.text = employeeData[0].da.toString();
                            taController.text = employeeData[0].ta.toString();
                            minimumFullTimeController.text = employeeData[0]
                                .minimumFullTime
                                .toString();
                            minimumHalfTimeController.text = employeeData[0]
                                .minimumHalfTime
                                .toString();
                            securityDepositController.text = employeeData[0]
                                .securityDeposit
                                .toString();
                            monthlySecurityDepositController.text =
                                employeeData[0].monthlySecurityDeposit
                                    .toString();
                            bonusOneController.text = employeeData[0].bonusOne
                                .toString();
                            bonusTwoController.text = employeeData[0].bonusTwo
                                .toString();
                            joiningDate = DateTime.parse(
                              employeeData[0].startDate,
                            );

                            showDialog(
                              context: context,
                              builder: ((context) {
                                return Material(
                                  color: Constant.cBlack.withOpacity(0.1),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right:
                                          MediaQuery.of(context).size.width *
                                          0.2,
                                      left:
                                          MediaQuery.of(context).size.width *
                                          0.2,
                                    ),
                                    child: Center(
                                      child: customDialog(
                                        isUpdate: true,
                                        isCurrent: isCurrent,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                          child: Text(
                            Strings.update,
                            style: Constant.textStyleSize15(context)!.copyWith(
                              color: Constant.cGreenLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Constant.paddingHalf.widthBox,
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: ((context) {
                                return Material(
                                  color: Constant.cBlack.withOpacity(0.1),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right:
                                          MediaQuery.of(context).size.width / 8,
                                      left:
                                          MediaQuery.of(context).size.width / 8,
                                    ),
                                    child: Center(
                                      child: deleteDialog(
                                        employee.id,
                                        widget.sizeTag!,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                          child: Text(
                            Strings.delete,
                            style: Constant.textStyleSize15(context)!.copyWith(
                              color: Constant.cRedLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget deleteDialog(int id, int sizeTag) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Wrap(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Constant.paddingHalf),
                color: Constant.cWhite,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Spacer(),
                          Text(
                            Strings.delete,
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(color: Constant.cWhite),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              color: Constant.cWhite,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(Constant.paddingHalf),
                        bottomLeft: Radius.circular(Constant.paddingHalf),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: Constant.padding,
                        left: Constant.padding,
                        bottom: Constant.padding,
                        right: Constant.padding,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'Are you sure to delete this Employee information?',
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(color: Constant.cBlack),
                            ),
                            Constant.padding.heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomButton(
                                  height: 40,
                                  width: 120,
                                  text: Strings.close,
                                  textStyle: Constant.textStyleSize14(
                                    context,
                                  )?.copyWith(color: Constant.cWhite),
                                  color: Constant.colorSelectedIndicator,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                Constant.padding4x.widthBox,
                                CustomButton(
                                  height: 40,
                                  width: 120,
                                  text: Strings.delete,
                                  textStyle: Constant.textStyleSize14(
                                    context,
                                  )?.copyWith(color: Constant.cWhite),
                                  color: Constant.colorSelectedIndicator,
                                  onTap: () {
                                    BlocProvider.of<EmployeeInfoBloc>(
                                      context,
                                    ).add(
                                      DeleteEmployeeInfo(
                                        context: context,
                                        id: id.toString(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget customDialog({
    bool isUpdate = false,
    bool isIncrement = false,
    bool isCurrent = true,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Wrap(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Constant.paddingHalf),
                color: Constant.cWhite,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Text(
                            isUpdate
                                ? Strings.updateEmployee
                                : isIncrement
                                ? Strings.incrementEmployee
                                : Strings.addEmployee,
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(color: Constant.cWhite),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              selectedDesignation = null;
                              selectedDepartment = null;
                              joiningDateController.clear();
                              promotionPeriodController.clear();
                              basicSalaryController.clear();
                              hraController.text = '0';
                              daController.text = '0';
                              taController.text = '0';
                              minimumFullTimeController.clear();
                              minimumHalfTimeController.clear();
                              securityDepositController.text = '0';
                              monthlySecurityDepositController.text = '0';
                              bonusOneController.text = '0';
                              bonusTwoController.text = '0';
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              color: Constant.cWhite,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  (widget.sizeTag! >= 2 && widget.sizeTag != null)
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 20.0, top: 10),
                          child: ResponsiveGridList(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            rowMainAxisAlignment: MainAxisAlignment.start,
                            desiredItemWidth: MediaQuery.of(context).size.width,
                            minSpacing: 20,
                            children: [
                              Form(
                                key: _formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(
                                          Constant.paddingHalf,
                                        ),
                                        child: ResponsiveGridRow(
                                          rowSegments: widget.rowSegment ?? 2,
                                          children: [
                                            ResponsiveGridCol(
                                              lg: 1,
                                              xs: 1,
                                              md: 1,
                                              sm: 1,
                                              child: Padding(
                                                padding: widget.rowSegment == 2
                                                    ? const EdgeInsets.only(
                                                        right: Constant
                                                            .paddingMidDoubleHalf,
                                                      )
                                                    : EdgeInsets.zero,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    labelWithTextField(
                                                      isTextField: true,
                                                      labelText:
                                                          Strings.department,
                                                      labelInfoText:
                                                          "Flutter Development",
                                                      child: CustomDropDown(
                                                        height: 48,
                                                        onChange: (value) {
                                                          setState(() {
                                                            for (
                                                              int i = 0;
                                                              i <
                                                                  departmentNameList
                                                                      .length;
                                                              i++
                                                            ) {
                                                              if (departmentList[i]
                                                                      .name ==
                                                                  value) {
                                                                selectedDepartment =
                                                                    departmentList[i];
                                                              }
                                                            }
                                                          });
                                                        },
                                                        selectedValue:
                                                            selectedDepartment
                                                                ?.name,
                                                        hintText:
                                                            Strings.department,
                                                        list:
                                                            departmentNameList,
                                                      ),
                                                    ),
                                                    Constant
                                                        .paddingHalf
                                                        .heightBox,
                                                    labelWithTextField(
                                                      isTextField: true,
                                                      labelText:
                                                          Strings.designation,
                                                      labelInfoText:
                                                          "Flutter Development",
                                                      child: CustomDropDown(
                                                        height: 48,
                                                        onChange: (value) {
                                                          setState(() {
                                                            for (
                                                              int i = 0;
                                                              i <
                                                                  designationList
                                                                      .length;
                                                              i++
                                                            ) {
                                                              if (designationList[i]
                                                                      .name ==
                                                                  value) {
                                                                selectedDesignation =
                                                                    designationList[i];
                                                              }
                                                            }
                                                          });
                                                        },
                                                        selectedValue:
                                                            selectedDesignation
                                                                ?.name,
                                                        hintText:
                                                            Strings.designation,
                                                        list:
                                                            designationNameList,
                                                      ),
                                                    ),
                                                    Constant
                                                        .paddingHalf
                                                        .heightBox,
                                                    labelWithTextField(
                                                      isTextField: true,
                                                      labelText:
                                                          Strings.joiningDate,
                                                      labelInfoText:
                                                          "13-06-2022",
                                                      child: CustomTextField(
                                                        isEnable: false,
                                                        validator: Strings
                                                            .joiningDateEmpty,
                                                        onTap: isCurrent
                                                            ? () async {
                                                                joiningDate = await showDatePicker(
                                                                  context:
                                                                      context,
                                                                  initialDate:
                                                                      DateTime.now(),
                                                                  firstDate: DateTime(
                                                                    DateTime.now()
                                                                            .year -
                                                                        1,
                                                                  ),
                                                                  lastDate: DateTime(
                                                                    DateTime.now()
                                                                            .year +
                                                                        1,
                                                                  ),
                                                                  builder:
                                                                      (
                                                                        context,
                                                                        child,
                                                                      ) {
                                                                        return CustomDatePickerTheme(
                                                                          child:
                                                                              child!,
                                                                        );
                                                                      },
                                                                );
                                                                joiningDateController
                                                                    .text = DateFormatter.formateDate(
                                                                  inputFormatter:
                                                                      "yyyy-MM-dd 00:00:00.000",
                                                                  input: joiningDate
                                                                      .toString(),
                                                                  outputFormatter:
                                                                      "dd-MM-yyyy",
                                                                );
                                                                setState(() {});
                                                              }
                                                            : () {},
                                                        controller:
                                                            joiningDateController,
                                                        hintText:
                                                            Strings.joiningDate,
                                                        type:
                                                            TextInputType.name,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                    Constant
                                                        .paddingHalf
                                                        .heightBox,
                                                    labelWithTextField(
                                                      isTextField: true,
                                                      labelText: Strings
                                                          .promotionPeriod,
                                                      labelInfoText: "0 month",
                                                      child: CustomTextField(
                                                        isEnable: isCurrent,
                                                        validator: isIncrement
                                                            ? null
                                                            : Strings
                                                                  .profileDesignationEmpty,
                                                        controller:
                                                            promotionPeriodController,
                                                        hintText: Strings
                                                            .promotionPeriod,
                                                        type:
                                                            TextInputType.name,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                    Constant
                                                        .paddingHalf
                                                        .heightBox,
                                                    labelWithTextField(
                                                      isTextField: true,
                                                      labelText: Strings
                                                          .securityDeposit,
                                                      labelInfoText: "0",
                                                      child: CustomTextField(
                                                        isEnable: isCurrent,
                                                        validator: Strings
                                                            .securityDepositEmpty,
                                                        controller:
                                                            securityDepositController,
                                                        hintText: Strings
                                                            .securityDeposit,
                                                        type:
                                                            TextInputType.name,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                    Constant
                                                        .paddingHalf
                                                        .heightBox,
                                                    labelWithTextField(
                                                      isTextField: true,
                                                      labelText: Strings
                                                          .monthlySecurityDeposit,
                                                      labelInfoText: "0",
                                                      child: CustomTextField(
                                                        isEnable: isCurrent,
                                                        validator: Strings
                                                            .monthlySecurityDepositEmpty,
                                                        controller:
                                                            monthlySecurityDepositController,
                                                        hintText: Strings
                                                            .monthlySecurityDeposit,
                                                        type:
                                                            TextInputType.name,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                    labelWithTextField(
                                                      isTextField: true,
                                                      labelText:
                                                          Strings.basicSalary,
                                                      labelInfoText: "22000",
                                                      child: CustomTextField(
                                                        isEnable: isCurrent,
                                                        validator: Strings
                                                            .basicSalaryEmpty,
                                                        controller:
                                                            basicSalaryController,
                                                        hintText:
                                                            Strings.basicSalary,
                                                        type:
                                                            TextInputType.name,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            ResponsiveGridCol(
                                              lg: 1,
                                              xs: 1,
                                              md: 1,
                                              sm: 1,
                                              child: Column(
                                                children: [
                                                  labelWithTextField(
                                                    isTextField: true,
                                                    labelText: Strings.hra,
                                                    labelInfoText: "0",
                                                    child: CustomTextField(
                                                      isEnable: isCurrent,
                                                      validator:
                                                          Strings.hraEmpty,
                                                      controller: hraController,
                                                      hintText: Strings.hra,
                                                      type: TextInputType.name,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  Constant
                                                      .paddingHalf
                                                      .heightBox,
                                                  labelWithTextField(
                                                    isTextField: true,
                                                    labelText: Strings.da,
                                                    labelInfoText: "0",
                                                    child: CustomTextField(
                                                      isEnable: isCurrent,
                                                      validator:
                                                          Strings.daEmpty,
                                                      controller: daController,
                                                      hintText: Strings.da,
                                                      type: TextInputType.name,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  Constant
                                                      .paddingHalf
                                                      .heightBox,
                                                  labelWithTextField(
                                                    isTextField: true,
                                                    labelText: Strings.ta,
                                                    labelInfoText: "0",
                                                    child: CustomTextField(
                                                      isEnable: isCurrent,
                                                      validator:
                                                          Strings.taEmpty,
                                                      controller: taController,
                                                      hintText: Strings.ta,
                                                      type: TextInputType.name,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  Constant
                                                      .paddingHalf
                                                      .heightBox,
                                                  labelWithTextField(
                                                    isTextField: true,
                                                    labelText: Strings.bonusOne,
                                                    labelInfoText: "0",
                                                    child: CustomTextField(
                                                      isEnable: isCurrent,
                                                      validator:
                                                          Strings.bonusOneEmpty,
                                                      controller:
                                                          bonusOneController,
                                                      hintText:
                                                          Strings.bonusOne,
                                                      type: TextInputType.name,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  Constant
                                                      .paddingHalf
                                                      .heightBox,
                                                  labelWithTextField(
                                                    isTextField: true,
                                                    labelText: Strings.bonusTwo,
                                                    labelInfoText: "0",
                                                    child: CustomTextField(
                                                      isEnable: isCurrent,
                                                      validator:
                                                          Strings.bonusTwoEmpty,
                                                      controller:
                                                          bonusTwoController,
                                                      hintText:
                                                          Strings.bonusTwo,
                                                      type: TextInputType.name,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  Constant
                                                      .paddingHalf
                                                      .heightBox,
                                                  labelWithTextField(
                                                    isTextField: true,
                                                    labelText:
                                                        Strings.minimumFullTime,
                                                    labelInfoText: "00:00:00",
                                                    child: CustomTextField(
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                        LengthLimitingTextInputFormatter(
                                                          5,
                                                        ),
                                                        TimeTextInputFormatter(),
                                                      ],
                                                      isEnable: isCurrent,
                                                      validator: Strings
                                                          .minimumFullTimeEmpty,
                                                      controller:
                                                          minimumFullTimeController,
                                                      hintText: 'HH:MM',
                                                      type:
                                                          TextInputType.number,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  Constant
                                                      .paddingHalf
                                                      .heightBox,
                                                  labelWithTextField(
                                                    isTextField: true,
                                                    labelText:
                                                        Strings.minimumHalfTime,
                                                    labelInfoText: "00:00:00",
                                                    child: CustomTextField(
                                                      isEnable: isCurrent,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                        LengthLimitingTextInputFormatter(
                                                          5,
                                                        ),
                                                        TimeTextInputFormatter(),
                                                      ],
                                                      validator: Strings
                                                          .minimumHalfTimeEmpty,
                                                      controller:
                                                          minimumHalfTimeController,
                                                      hintText: 'HH:MM',
                                                      type:
                                                          TextInputType.number,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Constant.paddingHalf.heightBox,
                                      CustomButton(
                                        height: 40,
                                        width: 120,
                                        text: Strings.submit,
                                        textStyle: Constant.textStyleSize14(
                                          context,
                                        )?.copyWith(color: Constant.cWhite),
                                        color: Constant.colorSelectedIndicator,
                                        onTap: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            isUpdate
                                                ? BlocProvider.of<EmployeeInfoBloc>(
                                                    context,
                                                  ).add(
                                                    UpdateEmployeeInfo(
                                                      context: context,
                                                      userId:
                                                          widget
                                                              .userDetail
                                                              ?.id ??
                                                          MyLocalStorage()
                                                              .getUser()!
                                                              .id,
                                                      departmentId:
                                                          selectedDepartment!.id
                                                              .toString(),
                                                      designationId:
                                                          selectedDesignation!
                                                              .id
                                                              .toString(),
                                                      period:
                                                          promotionPeriodController
                                                              .text
                                                              .toString(),
                                                      basicSalary:
                                                          basicSalaryController
                                                              .text
                                                              .toString(),
                                                      startDate: DateFormat(
                                                        'yyyy-MM-dd',
                                                      ).format(joiningDate!),
                                                      hra: hraController.text
                                                          .toString(),
                                                      da: daController.text
                                                          .toString(),
                                                      ta: taController.text
                                                          .toString(),
                                                      securityDeposit:
                                                          securityDepositController
                                                              .text,
                                                      monthlySecurityDeposit:
                                                          monthlySecurityDepositController
                                                              .text,
                                                      bonusOne:
                                                          bonusOneController
                                                              .text,
                                                      bonusTwo:
                                                          bonusTwoController
                                                              .text,
                                                      minimumFullTime:
                                                          normalizeToFullTime(
                                                            minimumFullTimeController
                                                                .text,
                                                          ),
                                                      minimumHalfTime:
                                                          normalizeToFullTime(
                                                            minimumHalfTimeController
                                                                .text,
                                                          ),
                                                    ),
                                                  )
                                                : isIncrement
                                                ? BlocProvider.of<EmployeeInfoBloc>(
                                                    context,
                                                  ).add(
                                                    IncrementEvent(
                                                      context: context,
                                                      userId:
                                                          widget
                                                              .userDetail
                                                              ?.id ??
                                                          MyLocalStorage()
                                                              .getUser()!
                                                              .id,
                                                      departmentId:
                                                          selectedDepartment!.id
                                                              .toString(),
                                                      designationId:
                                                          selectedDesignation!
                                                              .id
                                                              .toString(),
                                                      period:
                                                          promotionPeriodController
                                                              .text
                                                              .toString(),
                                                      basicSalary:
                                                          basicSalaryController
                                                              .text
                                                              .toString(),
                                                      startDate: DateFormat(
                                                        'yyyy-MM-dd',
                                                      ).format(joiningDate!),
                                                      hra: hraController.text
                                                          .toString(),
                                                      da: daController.text
                                                          .toString(),
                                                      ta: taController.text
                                                          .toString(),
                                                      securityDeposit:
                                                          securityDepositController
                                                              .text,
                                                      monthlySecurityDeposit:
                                                          monthlySecurityDepositController
                                                              .text,
                                                      bonusOne:
                                                          bonusOneController
                                                              .text,
                                                      bonusTwo:
                                                          bonusTwoController
                                                              .text,
                                                      minimumFullTime:
                                                          normalizeToFullTime(
                                                            minimumFullTimeController
                                                                .text,
                                                          ),
                                                      minimumHalfTime:
                                                          normalizeToFullTime(
                                                            minimumHalfTimeController
                                                                .text,
                                                          ),
                                                    ),
                                                  )
                                                : BlocProvider.of<EmployeeInfoBloc>(
                                                    context,
                                                  ).add(
                                                    AddEmployeeInfoEvent(
                                                      context: context,
                                                      userId:
                                                          widget
                                                              .userDetail
                                                              ?.id ??
                                                          MyLocalStorage()
                                                              .getUser()!
                                                              .id,
                                                      departmentId:
                                                          selectedDepartment!.id
                                                              .toString(),
                                                      designationId:
                                                          selectedDesignation!
                                                              .id
                                                              .toString(),
                                                      period:
                                                          promotionPeriodController
                                                              .text
                                                              .toString(),
                                                      basicSalary:
                                                          basicSalaryController
                                                              .text
                                                              .toString(),
                                                      startDate: DateFormat(
                                                        'yyyy-MM-dd',
                                                      ).format(joiningDate!),
                                                      hra: hraController.text
                                                          .toString(),
                                                      da: daController.text
                                                          .toString(),
                                                      ta: taController.text
                                                          .toString(),
                                                      securityDeposit:
                                                          securityDepositController
                                                              .text,
                                                      monthlySecurityDeposit:
                                                          monthlySecurityDepositController
                                                              .text,
                                                      bonusOne:
                                                          bonusOneController
                                                              .text,
                                                      bonusTwo:
                                                          bonusTwoController
                                                              .text,
                                                      minimumFullTime:
                                                          normalizeToFullTime(
                                                            minimumFullTimeController
                                                                .text,
                                                          ),
                                                      minimumHalfTime:
                                                          normalizeToFullTime(
                                                            minimumHalfTimeController
                                                                .text,
                                                          ),
                                                    ),
                                                  );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.8,
                          ),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 20.0,
                                top: 10,
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(
                                        Constant.paddingHalf,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          labelWithTextField(
                                            isTextField: true,
                                            labelText: Strings.department,
                                            labelInfoText:
                                                "Flutter Development",
                                            child: CustomDropDown(
                                              height: 48,
                                              onChange: (value) {
                                                setState(() {
                                                  for (
                                                    int i = 0;
                                                    i <
                                                        departmentNameList
                                                            .length;
                                                    i++
                                                  ) {
                                                    if (departmentList[i]
                                                            .name ==
                                                        value) {
                                                      selectedDepartment =
                                                          departmentList[i];
                                                    }
                                                  }
                                                });
                                              },
                                              selectedValue:
                                                  selectedDepartment?.name,
                                              hintText: Strings.department,
                                              list: departmentNameList,
                                            ),
                                          ),
                                          Constant.paddingHalf.heightBox,
                                          labelWithTextField(
                                            isTextField: true,
                                            labelText: Strings.designation,
                                            labelInfoText:
                                                "Flutter Development",
                                            child: CustomDropDown(
                                              height: 48,
                                              onChange: (value) {
                                                setState(() {
                                                  for (
                                                    int i = 0;
                                                    i < designationList.length;
                                                    i++
                                                  ) {
                                                    if (designationList[i]
                                                            .name ==
                                                        value) {
                                                      selectedDesignation =
                                                          designationList[i];
                                                    }
                                                  }
                                                });
                                              },
                                              selectedValue:
                                                  selectedDesignation?.name,
                                              hintText: Strings.designation,
                                              list: designationNameList,
                                            ),
                                          ),
                                          Constant.paddingHalf.heightBox,
                                          labelWithTextField(
                                            isTextField: true,
                                            labelText: Strings.joiningDate,
                                            labelInfoText: "13-06-2022",
                                            child: CustomTextField(
                                              isEnable: false,
                                              validator:
                                                  Strings.joiningDateEmpty,
                                              onTap: isCurrent
                                                  ? () async {
                                                      joiningDate =
                                                          await showDatePicker(
                                                            context: context,
                                                            initialDate:
                                                                DateTime.now(),
                                                            firstDate: DateTime(
                                                              DateTime.now()
                                                                      .year -
                                                                  1,
                                                            ),
                                                            lastDate: DateTime(
                                                              DateTime.now()
                                                                      .year +
                                                                  1,
                                                            ),
                                                            builder:
                                                                (
                                                                  context,
                                                                  child,
                                                                ) {
                                                                  return CustomDatePickerTheme(
                                                                    child:
                                                                        child!,
                                                                  );
                                                                },
                                                          );
                                                      joiningDateController
                                                              .text =
                                                          DateFormatter.formateDate(
                                                            inputFormatter:
                                                                "yyyy-MM-dd 00:00:00.000",
                                                            input: joiningDate
                                                                .toString(),
                                                            outputFormatter:
                                                                "dd-MM-yyyy",
                                                          );
                                                      setState(() {});
                                                    }
                                                  : () {},
                                              controller: joiningDateController,
                                              hintText: Strings.joiningDate,
                                              type: TextInputType.name,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Constant.paddingHalf.heightBox,
                                          labelWithTextField(
                                            isTextField: true,
                                            labelText: Strings.promotionPeriod,
                                            labelInfoText: "0 month",
                                            child: CustomTextField(
                                              isEnable: isCurrent,
                                              validator: Strings
                                                  .profileDesignationEmpty,
                                              controller:
                                                  promotionPeriodController,
                                              hintText: Strings.promotionPeriod,
                                              type: TextInputType.name,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Constant.paddingHalf.heightBox,
                                          labelWithTextField(
                                            isTextField: true,
                                            labelText: Strings.securityDeposit,
                                            labelInfoText: "0",
                                            child: CustomTextField(
                                              isEnable: isCurrent,
                                              validator:
                                                  Strings.securityDepositEmpty,
                                              controller:
                                                  securityDepositController,
                                              hintText: Strings.securityDeposit,
                                              type: TextInputType.name,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Constant.paddingHalf.heightBox,
                                          labelWithTextField(
                                            isTextField: true,
                                            labelText:
                                                Strings.monthlySecurityDeposit,
                                            labelInfoText: "0",
                                            child: CustomTextField(
                                              isEnable: isCurrent,
                                              validator: Strings
                                                  .monthlySecurityDepositEmpty,
                                              controller:
                                                  monthlySecurityDepositController,
                                              hintText: Strings
                                                  .monthlySecurityDeposit,
                                              type: TextInputType.name,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Constant.paddingHalf.heightBox,
                                          labelWithTextField(
                                            isTextField: true,
                                            labelText: Strings.basicSalary,
                                            labelInfoText: "22000",
                                            child: CustomTextField(
                                              isEnable: isCurrent,
                                              validator:
                                                  Strings.basicSalaryEmpty,
                                              controller: basicSalaryController,
                                              hintText: Strings.basicSalary,
                                              type: TextInputType.name,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Constant.paddingHalf.heightBox,
                                          labelWithTextField(
                                            isTextField: true,
                                            labelText: Strings.hra,
                                            labelInfoText: "0",
                                            child: CustomTextField(
                                              isEnable: isCurrent,
                                              validator: Strings.hraEmpty,
                                              controller: hraController,
                                              hintText: Strings.hra,
                                              type: TextInputType.name,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Constant.paddingHalf.heightBox,
                                          labelWithTextField(
                                            isTextField: true,
                                            labelText: Strings.da,
                                            labelInfoText: "0",
                                            child: CustomTextField(
                                              isEnable: isCurrent,
                                              validator: Strings.daEmpty,
                                              controller: daController,
                                              hintText: Strings.da,
                                              type: TextInputType.name,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Constant.paddingHalf.heightBox,
                                          labelWithTextField(
                                            isTextField: true,
                                            labelText: Strings.ta,
                                            labelInfoText: "0",
                                            child: CustomTextField(
                                              validator: Strings.taEmpty,
                                              isEnable: isCurrent,
                                              controller: taController,
                                              hintText: Strings.ta,
                                              type: TextInputType.name,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Constant.paddingHalf.heightBox,
                                          labelWithTextField(
                                            isTextField: true,
                                            labelText: Strings.bonusOne,
                                            labelInfoText: "0",
                                            child: CustomTextField(
                                              isEnable: isCurrent,
                                              validator: Strings.bonusOneEmpty,
                                              controller: bonusOneController,
                                              hintText: Strings.bonusOne,
                                              type: TextInputType.name,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Constant.paddingHalf.heightBox,
                                          labelWithTextField(
                                            isTextField: true,
                                            labelText: Strings.bonusTwo,
                                            labelInfoText: "0",
                                            child: CustomTextField(
                                              isEnable: isCurrent,
                                              validator: Strings.bonusTwoEmpty,
                                              controller: bonusTwoController,
                                              hintText: Strings.bonusTwo,
                                              type: TextInputType.name,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Constant.paddingHalf.heightBox,
                                          labelWithTextField(
                                            isTextField: true,
                                            labelText: Strings.minimumFullTime,
                                            labelInfoText: "00:00:00",
                                            child: CustomTextField(
                                              isEnable: isCurrent,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                  5,
                                                ),
                                                TimeTextInputFormatter(),
                                              ],
                                              validator:
                                                  Strings.minimumFullTimeEmpty,
                                              controller:
                                                  minimumFullTimeController,
                                              hintText: 'HH:MM',
                                              type: TextInputType.number,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Constant.paddingHalf.heightBox,
                                          labelWithTextField(
                                            isTextField: true,
                                            labelText: Strings.minimumHalfTime,
                                            labelInfoText: "00:00:00",
                                            child: CustomTextField(
                                              isEnable: isCurrent,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                  5,
                                                ),
                                                TimeTextInputFormatter(),
                                              ],
                                              validator:
                                                  Strings.minimumHalfTimeEmpty,
                                              controller:
                                                  minimumHalfTimeController,
                                              hintText: 'HH:MM',
                                              type: TextInputType.number,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Constant.paddingHalf.heightBox,
                                    CustomButton(
                                      height: 40,
                                      width: 120,
                                      text: Strings.submit,
                                      textStyle: Constant.textStyleSize14(
                                        context,
                                      )?.copyWith(color: Constant.cWhite),
                                      color: Constant.colorSelectedIndicator,
                                      onTap: () {
                                        if (_formKey.currentState!.validate()) {
                                          isUpdate
                                              ? BlocProvider.of<EmployeeInfoBloc>(
                                                  context,
                                                ).add(
                                                  UpdateEmployeeInfo(
                                                    context: context,
                                                    userId:
                                                        widget.userDetail?.id ??
                                                        MyLocalStorage()
                                                            .getUser()!
                                                            .id,
                                                    departmentId:
                                                        selectedDepartment!.id
                                                            .toString(),
                                                    designationId:
                                                        selectedDesignation!.id
                                                            .toString(),
                                                    period:
                                                        promotionPeriodController
                                                            .text
                                                            .toString(),
                                                    basicSalary:
                                                        basicSalaryController
                                                            .text
                                                            .toString(),
                                                    startDate: DateFormat(
                                                      'yyyy-MM-dd',
                                                    ).format(joiningDate!),
                                                    hra: hraController.text
                                                        .toString(),
                                                    da: daController.text
                                                        .toString(),
                                                    ta: taController.text
                                                        .toString(),
                                                    securityDeposit:
                                                        securityDepositController
                                                            .text,
                                                    monthlySecurityDeposit:
                                                        monthlySecurityDepositController
                                                            .text,
                                                    bonusOne:
                                                        bonusOneController.text,
                                                    bonusTwo:
                                                        bonusTwoController.text,
                                                    minimumFullTime:
                                                        normalizeToFullTime(
                                                          minimumFullTimeController
                                                              .text,
                                                        ),
                                                    minimumHalfTime:
                                                        normalizeToFullTime(
                                                          minimumHalfTimeController
                                                              .text,
                                                        ),
                                                  ),
                                                )
                                              : isIncrement
                                              ? BlocProvider.of<EmployeeInfoBloc>(
                                                  context,
                                                ).add(
                                                  IncrementEvent(
                                                    context: context,
                                                    userId:
                                                        widget.userDetail?.id ??
                                                        MyLocalStorage()
                                                            .getUser()!
                                                            .id,
                                                    departmentId:
                                                        selectedDepartment!.id
                                                            .toString(),
                                                    designationId:
                                                        selectedDesignation!.id
                                                            .toString(),
                                                    period:
                                                        promotionPeriodController
                                                            .text
                                                            .toString(),
                                                    basicSalary:
                                                        basicSalaryController
                                                            .text
                                                            .toString(),
                                                    startDate: DateFormat(
                                                      'yyyy-MM-dd',
                                                    ).format(joiningDate!),
                                                    hra: hraController.text
                                                        .toString(),
                                                    da: daController.text
                                                        .toString(),
                                                    ta: taController.text
                                                        .toString(),
                                                    securityDeposit:
                                                        securityDepositController
                                                            .text,
                                                    monthlySecurityDeposit:
                                                        monthlySecurityDepositController
                                                            .text,
                                                    bonusOne:
                                                        bonusOneController.text,
                                                    bonusTwo:
                                                        bonusTwoController.text,
                                                    minimumFullTime:
                                                        normalizeToFullTime(
                                                          minimumFullTimeController
                                                              .text,
                                                        ),
                                                    minimumHalfTime:
                                                        normalizeToFullTime(
                                                          minimumHalfTimeController
                                                              .text,
                                                        ),
                                                  ),
                                                )
                                              : BlocProvider.of<EmployeeInfoBloc>(
                                                  context,
                                                ).add(
                                                  AddEmployeeInfoEvent(
                                                    context: context,
                                                    userId:
                                                        widget.userDetail?.id ??
                                                        MyLocalStorage()
                                                            .getUser()!
                                                            .id,
                                                    departmentId:
                                                        selectedDepartment!.id
                                                            .toString(),
                                                    designationId:
                                                        selectedDesignation!.id
                                                            .toString(),
                                                    period:
                                                        promotionPeriodController
                                                            .text
                                                            .toString(),
                                                    basicSalary:
                                                        basicSalaryController
                                                            .text
                                                            .toString(),
                                                    startDate: DateFormat(
                                                      'yyyy-MM-dd',
                                                    ).format(joiningDate!),
                                                    hra: hraController.text
                                                        .toString(),
                                                    da: daController.text
                                                        .toString(),
                                                    ta: taController.text
                                                        .toString(),
                                                    securityDeposit:
                                                        securityDepositController
                                                            .text,
                                                    monthlySecurityDeposit:
                                                        monthlySecurityDepositController
                                                            .text,
                                                    bonusOne:
                                                        bonusOneController.text,
                                                    bonusTwo:
                                                        bonusTwoController.text,
                                                    minimumFullTime:
                                                        normalizeToFullTime(
                                                          minimumFullTimeController
                                                              .text,
                                                        ),
                                                    minimumHalfTime:
                                                        normalizeToFullTime(
                                                          minimumHalfTimeController
                                                              .text,
                                                        ),
                                                  ),
                                                );
                                        }
                                      },
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
          ],
        );
      },
    );
  }

  Widget labelWithTextField({
    required String labelText,
    required String labelInfoText,
    Widget? child,
    bool isTextField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: Constant.paddingMidHalf),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              labelText,
              style: Constant.textStyleSize15(
                context,
              )?.copyWith(color: Colors.black),
            ),
          ),
          //Spacer(),
          Constant.padding.widthBox,
          !isTextField
              ? Expanded(
                  child: Text(
                    labelInfoText,
                    style: Constant.textStyleSize13(
                      context,
                    )!.copyWith(color: Constant.cGrayDark),
                  ),
                )
              : Expanded(child: child!),
        ],
      ),
    );
  }
}

String formatTimeOfDayToFull(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute:00'; // seconds defaulted to 00
}

String normalizeToFullTime(String input) {
  final parts = input.split(':');

  final hour = parts.isNotEmpty ? parts[0].padLeft(2, '0') : '00';
  final minute = parts.length > 1 ? parts[1].padLeft(2, '0') : '00';

  return '$hour:$minute:00';
}

class TimeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(':', '');

    if (digitsOnly.length > 4) {
      return oldValue;
    }

    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 2) formatted += ':';
      formatted += digitsOnly[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
