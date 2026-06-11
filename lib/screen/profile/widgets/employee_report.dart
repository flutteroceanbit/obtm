import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_employee_report/get_employee_report_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_employee_report/get_employee_report_repository.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_employee_report/get_employee_report_state.dart';
import 'package:oceanbit_timeclock/models/employee_report_list_model.dart';
import 'package:oceanbit_timeclock/models/user_detail_model.dart';
import 'package:oceanbit_timeclock/utils/date_formatter.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../bloc_logic/get_employee_report/get_employee_report_event.dart';
import '../../../constant/constant.dart' as constant;
import '../../../constant/constant.dart';
import '../../../constant/strings.dart';
import '../../../gen/assets.gen.dart';
import '../../../utils/logger.dart';
import '../../../widget/new/custom_header_container.dart';
import '../../dashboard/dashboard.dart';
import '../../report_list/report_list_screen.dart';

class EmployeeReport extends StatefulWidget {
  const EmployeeReport({Key? key, this.userData, this.sizeTag, this.rowSegment})
    : super(key: key);
  final UserData? userData;
  final int? sizeTag;
  final int? rowSegment;

  @override
  State<EmployeeReport> createState() => _EmployeeReportState();
}

class _EmployeeReportState extends State<EmployeeReport> {
  late GetEmployeeReportRepository getEmployeeReportRepository;
  int selectedYear = DateTime.now().year;
  List<int> years = [];

  @override
  void initState() {
    super.initState();
    getEmployeeReportRepository = context.read<GetEmployeeReportRepository>();
    int currentYear = DateTime.now().year;
    years = List<int>.generate(5, (index) => currentYear - index);
    selectedYear = currentYear;
  }

  @override
  Widget build(BuildContext context) {
    Logger.println('selected user id:${widget.userData!.id}');
    return BlocProvider(
      create: (context) =>
          GetEmployeeReportBloc(reportRepository: getEmployeeReportRepository)
            ..add(
              FetchEmployeeReport(
                selectedYear,
                context: context,
                id: widget.userData!.id!,
              ),
            ),
      child: EmployeeReportPage(
        userData: widget.userData,
        sizeTag: widget.sizeTag,
        rowSegment: widget.rowSegment,
      ),
    );
  }
}

class EmployeeReportPage extends StatefulWidget {
  const EmployeeReportPage({
    Key? key,
    this.userData,
    this.sizeTag,
    this.rowSegment,
  }) : super(key: key);
  final UserData? userData;
  final int? sizeTag;
  final int? rowSegment;

  @override
  State<EmployeeReportPage> createState() => _EmployeeReportPageState();
}

class _EmployeeReportPageState extends State<EmployeeReportPage> {
  late final GetEmployeeReportRepository repository;
  int listLength = 0;
  final ScrollController _scrollController = ScrollController();
  EmployeeReportListModel? model;
  int sunday = 0;
  int workingDay = 0;
  int halfLeaveDay = 0;
  int fullLeaveDay = 0;
  List<int> years = [];
  late GetEmployeeReportRepository getEmployeeReportRepository;
  int selectedYear = DateTime.now().year;

  // int overTimeDay=0;
  //final MyLoader myLoader = MyLoader();

  @override
  void initState() {
    Logger.println("EmployeeReportListPage: initState");
    repository = context.read<GetEmployeeReportRepository>();
    repository.page = 1;
    repository.month = DateTime.now().month;
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        Logger.println(
          "EmployeeReportPaginatedList: onScrollAtLast: isLoading: ${repository.isLoading} ",
        );
        Logger.println(
          "EmployeeReportPaginatedList: onScrollAtLast: isLastPage: ${repository.isLastPage} ",
        );
        if (!repository.isLoading && !repository.isLastPage) {
          repository.isLoading = true;
          BlocProvider.of<GetEmployeeReportBloc>(context).add(
            FetchEmployeeReport(
              selectedYear,
              context: context,
              id: widget.userData!.id!,
            ),
          );
        }
      }
    });
    super.initState();
    getEmployeeReportRepository = context.read<GetEmployeeReportRepository>();
    int currentYear = DateTime.now().year;
    years = List<int>.generate(5, (index) => currentYear - index);
    selectedYear = currentYear;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeaderContainer(
      headerWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.list_alt_sharp, color: constant.Constant.cWhite),
              constant.Constant.paddingHalfHalf.widthBox,
              Text(
                Strings.reportList.toUpperCase(),
                style: constant.Constant.textStyleSize14(
                  context,
                )?.copyWith(color: constant.Constant.cWhite),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {});

                  getEmployeeWorkInfo(
                    list: getEmployeeReportRepository.dataList,
                    sizeTag: widget.sizeTag /*widget.sizeTag*/,
                    rowSegment: widget.rowSegment /*widget.rowSegment*/,
                    context: context,
                  );
                },
                child: Assets.images.showPassword.image(
                  color: constant.Constant.cWhite,
                ) /*Icon(Icons.visibility, color: Colors.black.withOpacity(0.8),)*/, //:  Assets.images.showPassword.image()//Icon(Icons.visibility_off, color: Colors.black.withOpacity(0.8))),
              ),
              GestureDetector(
                onTap: repository.month == 1
                    ? () {}
                    : () {
                        if (repository.month == 1) {
                          repository.month = 12;
                          Logger.println(
                            "Month ::: -12  ::: ${repository.month}",
                          );
                        } else {
                          repository.month = repository.month - 1;
                          Logger.println(
                            "Month ::: -1 ::: ${repository.month}",
                          );
                        }
                        repository.clearReportList();
                        BlocProvider.of<GetEmployeeReportBloc>(context).add(
                          FetchEmployeeReport(
                            selectedYear,
                            context: context,
                            id: widget.userData?.id ?? 1,
                          ),
                        );
                        Logger.println("Month ::: ${repository.month}");
                        setState(() {});
                      },
                child: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: repository.month == 1
                      ? Constant.cWhite.withOpacity(0.5)
                      : Constant.cWhite,
                ),
              ),
              Constant.paddingHalfHalf.widthBox,
              Text(
                DateFormatter.formateDate(
                  inputFormatter: "MM",
                  input: repository.month.toString(),
                  outputFormatter: "MMMM",
                ),
                style: Constant.textStyleSize14(
                  context,
                )?.copyWith(color: Constant.cWhite),
              ),
              Constant.paddingHalfHalf.widthBox,
              GestureDetector(
                onTap:
                    repository.month == DateTime.now().month &&
                        selectedYear == DateTime.now().year
                    ? () {}
                    : () {
                        if (repository.month == 12) {
                          repository.month = 1;
                          Logger.println(
                            "Month == 12  ::: ${repository.month}",
                          );
                        } else {
                          repository.month = repository.month + 1;
                          Logger.println("Month == +1 ::: ${repository.month}");
                        }
                        repository.clearReportList();
                        BlocProvider.of<GetEmployeeReportBloc>(context).add(
                          FetchEmployeeReport(
                            selectedYear,
                            context: context,
                            id: widget.userData?.id ?? 1,
                          ),
                        );
                        Logger.println("Month ::: ${repository.month}");
                        setState(() {});
                      },
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color:
                      repository.month == DateTime.now().month &&
                          selectedYear == DateTime.now().year
                      ? Constant.cWhite.withOpacity(0.5)
                      : Constant.cWhite,
                ),
              ),
              Constant.paddingHalfHalf.widthBox,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Constant.paddingHalf,
                ),
                height: 40,
                decoration: BoxDecoration(
                  color: Constant.cWhite,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    iconStyleData: IconStyleData(
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Constant.cGrayDark,
                      ),
                    ),
                    hint: Text(
                      'hintText',
                      style: Constant.textStyleSize13(
                        context,
                      )?.copyWith(color: Constant.cFontLight),
                    ),
                    items: years.map((year) {
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }).toList(),
                    style: const TextStyle(color: Constant.cBlack),
                    value: selectedYear,
                    onChanged: (newYear) {
                      setState(() {
                        selectedYear =
                            newYear ??
                            DateTime.now().year; // Update the selected year
                      });
                      // if (repository.month == 12) {
                      //   repository.month = 1;
                      //   Logger.println("Month == 12  ::: ${repository.month}");
                      // } else {
                      //   repository.month = repository.month + 1;
                      //   Logger.println("Month == +1 ::: ${repository.month}");
                      // }
                      if (selectedYear == DateTime.now().year) {
                        repository.month = DateTime.now().month;
                      }
                      repository.clearReportList();
                      BlocProvider.of<GetEmployeeReportBloc>(context).add(
                        FetchEmployeeReport(
                          selectedYear,
                          context: context,
                          id: widget.userData?.id ?? 1,
                        ),
                      );
                      Logger.println("Month ::: ${repository.month}");
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 40,
                      width: 140,
                      decoration: BoxDecoration(
                        color: Constant.cWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 12,
                    ),
                    // buttonHeight: 40,
                    // buttonWidth: 140,
                    // itemHeight: 40,
                    // dropdownDecoration:
                    //     const BoxDecoration(color: Constant.cWhite),
                    // dropdownElevation: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: BlocListener<GetEmployeeReportBloc, GetEmployeeReportState>(
              listener: (context, state) {
                if (state is GetEmployeeReportLoading) {
                  Logger.println(
                    'Is data loaded: ${getEmployeeReportRepository.isLoading}',
                  );
                  constant.Constant.myLoader.show(context);
                } else {
                  constant.Constant.myLoader.hide();
                }
                if (state is GetEmployeeReportError) {
                  msgList.add(
                    constant.Constant().ShowErrorMessage(state.errors, context),
                  );
                  constant.Constant.myLoader.hide();
                  //Constant().ShowToast(state.errors, context);
                } else if (state is GetEmployeeReportLoaded) {
                  getEmployeeReportRepository.isLoading = false;
                  sunday = 0;
                  workingDay = 0;
                  halfLeaveDay = 0;
                  fullLeaveDay = 0;
                  // overTimeDay=0;
                  for (
                    int i = 1;
                    i <=
                        DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          repository.month,
                        ).lastDayOfMonth.day;
                    i++
                  ) {
                    if (DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          i,
                        ).weekday ==
                        7) {
                      sunday = sunday + 1;
                    }
                  }
                  workingDay = workingDay - sunday;
                  // workingDay=repository.dataList.length;
                  for (var d in repository.dataList) {
                    workingDay = workingDay + 1;
                    getDayCalculation(d.totalTime!);
                  }
                  setState(() {});
                }
              },
              child: BlocBuilder<GetEmployeeReportBloc, GetEmployeeReportState>(
                builder: (context, state) {
                  return Container(
                    color: constant.Constant.cWhite.withOpacity(0.1),
                    child: getEmployeeReportRepository.dataList.isEmpty
                        ? Center(
                            child: Text(
                              Strings.noData,
                              style: constant.Constant.textStyleSize15(context)
                                  ?.copyWith(
                                    color: constant.Constant.cBlack.withOpacity(
                                      0.5,
                                    ),
                                  ),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: constant.Constant.cBlack.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    constant.Constant.paddingHalfHalf,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    constant.Constant.paddingHalf,
                                  ),
                                  child: Table(
                                    columnWidths: const {
                                      0: FlexColumnWidth(0.5),
                                      1: FlexColumnWidth(1),
                                      2: FlexColumnWidth(4),
                                      3: FlexColumnWidth(1),
                                      4: FlexColumnWidth(1),
                                    },
                                    children: [
                                      TableRow(
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                Strings.number,
                                                style:
                                                    constant.Constant.textStyleSize14(
                                                      context,
                                                    )?.copyWith(
                                                      color: constant
                                                          .Constant
                                                          .cBlack,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                Strings.reportDate,
                                                style:
                                                    constant.Constant.textStyleSize14(
                                                      context,
                                                    )?.copyWith(
                                                      color: constant
                                                          .Constant
                                                          .cBlack,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                Strings.report,
                                                style:
                                                    constant.Constant.textStyleSize14(
                                                      context,
                                                    )?.copyWith(
                                                      color: constant
                                                          .Constant
                                                          .cBlack,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                Strings.totalTime,
                                                style:
                                                    constant.Constant.textStyleSize14(
                                                      context,
                                                    )?.copyWith(
                                                      color: constant
                                                          .Constant
                                                          .cBlack,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                Strings.intermediateTime,
                                                style:
                                                    constant.Constant.textStyleSize14(
                                                      context,
                                                    )?.copyWith(
                                                      color: constant
                                                          .Constant
                                                          .cBlack,
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
                              Expanded(
                                flex: 1,
                                child: ListView.separated(
                                  controller: _scrollController,
                                  itemCount: getEmployeeReportRepository
                                      .dataList
                                      .length,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                        return Container(
                                          height: 1,
                                          color: constant.Constant.colorGrey,
                                        );
                                      },
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(
                                            constant.Constant.paddingHalf,
                                          ),
                                          child: Table(
                                            columnWidths: const {
                                              0: FlexColumnWidth(0.5),
                                              1: FlexColumnWidth(1),
                                              2: FlexColumnWidth(4),
                                              3: FlexColumnWidth(1),
                                              4: FlexColumnWidth(1),
                                            },
                                            children: [
                                              TableRow(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        '${index + 1}',
                                                        style:
                                                            constant.Constant.textStyleSize13(
                                                              context,
                                                            )?.copyWith(
                                                              color: getColorTimeWise(
                                                                getEmployeeReportRepository
                                                                    .dataList[index]
                                                                    .totalTime!,
                                                              ) /*Constant.cBlack*/,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        getEmployeeReportRepository
                                                            .dataList[index]
                                                            .date!,
                                                        style:
                                                            constant.Constant.textStyleSize13(
                                                              context,
                                                            )?.copyWith(
                                                              color: getColorTimeWise(
                                                                getEmployeeReportRepository
                                                                    .dataList[index]
                                                                    .totalTime!,
                                                              ) /*Constant.cBlack*/,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        getEmployeeReportRepository
                                                            .dataList[index]
                                                            .reportText!,
                                                        style:
                                                            constant.Constant.textStyleSize13(
                                                              context,
                                                            )?.copyWith(
                                                              color: getColorTimeWise(
                                                                getEmployeeReportRepository
                                                                    .dataList[index]
                                                                    .totalTime!,
                                                              ) /*Constant.cBlack*/,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        getEmployeeReportRepository
                                                            .dataList[index]
                                                            .totalTime!,
                                                        style:
                                                            constant.Constant.textStyleSize13(
                                                              context,
                                                            )?.copyWith(
                                                              color: getColorTimeWise(
                                                                getEmployeeReportRepository
                                                                    .dataList[index]
                                                                    .totalTime!,
                                                              ) /*Constant.cBlack*/,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        getEmployeeReportRepository
                                                                .dataList[index]
                                                                .intermediateTime ??
                                                            '00:00:00',
                                                        style:
                                                            constant.Constant.textStyleSize13(
                                                              context,
                                                            )?.copyWith(
                                                              color: getColorTimeWise(
                                                                getEmployeeReportRepository
                                                                    .dataList[index]
                                                                    .totalTime!,
                                                              ) /*Constant.cBlack*/,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        index ==
                                                getEmployeeReportRepository
                                                    .dataList
                                                    .lastIndex
                                            ? Container(
                                                height: 1,
                                                color:
                                                    constant.Constant.colorGrey,
                                              )
                                            : const SizedBox.shrink(),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getEmployeeWorkInfo({
    required List<Data> list,
    int? sizeTag,
    int? rowSegment,
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: ((ctx) {
        return Material(
          color: constant.Constant.cBlack.withOpacity(0.1),
          child: Center(
            child: customDialog(sizeTag ?? 1, rowSegment ?? 1, ctx),
          ),
        );
      }),
    );
  }

  Widget customDialog(int sizeTag, int rowSegment, BuildContext ctx) {
    return Wrap(
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(constant.Constant.paddingHalf),
            color: constant.Constant.cWhite,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(constant.Constant.paddingHalf),
                    topLeft: Radius.circular(constant.Constant.paddingHalf),
                  ),
                  color: constant.Constant.colorSelectedIndicator,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(constant.Constant.paddingHalf),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${DateFormatter.formateDate(inputFormatter: "MM", input: repository.month.toString(), outputFormatter: "MMMM")} ',
                        style: Theme.of(ctx).textTheme.titleLarge!.copyWith(
                          color: constant.Constant.cWhite,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(ctx);
                        },
                        child: const Icon(
                          Icons.close,
                          color: constant.Constant.cWhite,
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
                    bottomRight: Radius.circular(constant.Constant.paddingHalf),
                    bottomLeft: Radius.circular(constant.Constant.paddingHalf),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: constant.Constant.padding,
                    left: constant.Constant.padding,
                    bottom: constant.Constant.padding,
                    right: constant.Constant.padding,
                  ),
                  child: Column(
                    children: [
                      labelTextWithCount("Working Day", workingDay, ctx),
                      labelTextWithCount("Sunday", sunday, ctx),
                      labelTextWithCount("Half Leaves", halfLeaveDay, ctx),
                      labelTextWithCount("Full Leaves", fullLeaveDay, ctx),
                      //labelTextWithCount("Over Time Days",overTimeDay,ctx),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  labelTextWithCount(String label, int i, BuildContext ctx) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: constant.Constant.textStyleSize14(
            ctx,
          )?.copyWith(color: constant.Constant.cBlack),
        ),
        Text(
          '$i',
          style: constant.Constant.textStyleSize14(
            ctx,
          )?.copyWith(color: constant.Constant.cBlack),
        ),
      ],
    );
  }

  getDayCalculation(String time) {
    int sec = int.parse(time.split(':')[2]);
    int h = int.parse(time.split(':')[0]);
    int m = int.parse(time.split(':')[1]);
    sec = sec + ((h * 60) * 60) + (m * 60);
    if (sec < 12600) {
      fullLeaveDay = fullLeaveDay + 1;
    } else if (sec < 25200) {
      halfLeaveDay = halfLeaveDay + 1;
    } /*else if(sec>28800) {
      return overTimeDay = overTimeDay + 1;
    }*/
  }
}
