import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/utils/logger.dart';
import 'package:oceanbit_timeclock/widget/new/custom_header_container.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../bloc_logic/get_daily_report/get_daily_report_bloc.dart';
import '../../bloc_logic/get_daily_report/get_daily_report_repository.dart';
import '../../constant/constant.dart';
import '../../constant/strings.dart';
import '../../models/get_daily_report_model.dart';
import '../../utils/date_formatter.dart';
import '../dashboard/dashboard.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({
    Key? key,
    this.rowSegment,
    this.sizeTag,
    this.isSmallSize = false,
  }) : super(key: key);
  final int? rowSegment;
  final int? sizeTag;
  final bool isSmallSize;

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  late final GetDailyReportRepository repository;

  @override
  void initState() {
    repository = context.read<GetDailyReportRepository>();
    if (!repository.isLoading && !repository.isLastPage) {
      repository.isLoading = true;
    }
    // BlocProvider.of<GetDailyReportBloc>(context)
    //     .add(FetchGetDailyReport(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /* GetDailyReportRepository getDailyReportRepository =
        context.read<GetDailyReportRepository>();*/
    return /* BlocProvider(
      create: (context) => GetDailyReportBloc(
        repository: getDailyReportRepository,
      ),//..add(FetchGetDailyReport()),
      child:*/ ReportListPage(
      rowSegment: widget.rowSegment,
      sizeTag: widget.sizeTag,
      isSmallSize: widget.isSmallSize,
    );

    //);
  }
}

int selectedYear = DateTime.now().year;

class ReportListPage extends StatefulWidget {
  const ReportListPage({
    Key? key,
    this.rowSegment,
    this.sizeTag,
    this.isSmallSize = false,
  }) : super(key: key);
  final int? rowSegment;
  final int? sizeTag;
  final bool isSmallSize;

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  late final GetDailyReportRepository repository;
  final ScrollController _scrollController = ScrollController();
  List<int> years = [];

  //final MyLoader myLoader = MyLoader();

  @override
  void initState() {
    super.initState();
    Logger.println("ReportListPage: initState");
    repository = context.read<GetDailyReportRepository>();
    repository.page = 1;
    //repository.month = DateTime.now().month;
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        Logger.println(
          "PaginatedList: onScrollAtLast: isLoading: ${repository.isLoading} ",
        );
        Logger.println(
          "PaginatedList: onScrollAtLast: isLastPage: ${repository.isLastPage} ",
        );
        if (!repository.isLoading && !repository.isLastPage) {
          repository.isLoading = true;
          BlocProvider.of<GetDailyReportBloc>(
            context,
          ).add(FetchGetDailyReport(context: context));
        }
      }
    });
    int currentYear = DateTime.now().year;
    years = List<int>.generate(5, (index) => currentYear - index);
    selectedYear = currentYear;
  }

  @override
  void dispose() {
    Logger.println("ReportListPage: dispose");
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GetDailyReportRepository getDailyReportRepository = context
        .read<GetDailyReportRepository>();
    return CustomHeaderContainer(
      headerWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Strings.reportList,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Constant.cWhite),
          ),
          Container(
            width:
                MediaQuery.of(context).size.width /
                (widget.sizeTag == 2
                    ? 5.5
                    : widget.isSmallSize
                    ? 3.5
                    : 5),
            decoration: BoxDecoration(
              color: Constant.cWhite,
              borderRadius: BorderRadius.circular(100),
            ),
            padding: const EdgeInsets.all(Constant.paddingMidHalf),
            child: ResponsiveGridRow(
              rowSegments: widget.rowSegment ?? 2,
              children: [
                ResponsiveGridCol(
                  lg: 1,
                  xs: 1,
                  md: 1,
                  sm: 1,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width / 170,
                        backgroundColor: Constant.cRedLight,
                      ),
                      Constant.padding.widthBox,
                      SizedBox(
                        // color: Colors.blueGrey,
                        width:
                            MediaQuery.of(context).size.width /
                            (widget.sizeTag == 2
                                ? 21
                                : widget.isSmallSize
                                ? 6
                                : 10),
                        child: Text(
                          Strings.fullLeave.toUpperCase(),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(color: Constant.cRedLight),
                        ),
                      ),
                    ],
                  ),
                ),
                ResponsiveGridCol(
                  lg: 1,
                  xs: 1,
                  md: 1,
                  sm: 1,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width / 170,
                        backgroundColor: Constant.cYellowDark,
                      ),
                      Constant.padding.widthBox,
                      SizedBox(
                        //color: Colors.blueGrey,
                        width:
                            MediaQuery.of(context).size.width /
                            (widget.sizeTag == 2
                                ? 21
                                : widget.isSmallSize
                                ? 6
                                : 10),
                        child: Text(
                          Strings.halfLeave.toUpperCase(),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(color: Constant.cYellowDark),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
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
                        BlocProvider.of<GetDailyReportBloc>(
                          context,
                        ).add(FetchGetDailyReport(context: context));
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
                        BlocProvider.of<GetDailyReportBloc>(
                          context,
                        ).add(FetchGetDailyReport(context: context));
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
                      BlocProvider.of<GetDailyReportBloc>(
                        context,
                      ).add(FetchGetDailyReport(context: context));
                      Logger.println("Month ::: ${repository.month}");
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 40,
                      width: 140,
                      decoration: BoxDecoration(color: Constant.cWhite),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 12,
                    ),
                    // buttonHeight: 40,
                    // buttonWidth: 140,
                    // itemHeight: 40,
                    // dropdownDecoration: const BoxDecoration(
                    //   color: Constant.cWhite,
                    // ),
                    // dropdownElevation: 12,),
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
            child: BlocConsumer<GetDailyReportBloc, GetDailyReportState>(
              listener: (context, state) {
                if (state is GetDailyReportLoading) {
                  Constant.myLoader.show(context);
                }
                if (state is GetDailyReportError) {
                  msgList.add(
                    Constant().ShowErrorMessage(state.errors, context),
                  );
                  // Constant().ShowErrorToast(state.errors, context);
                } else if (state is GetDailyReportLoaded) {
                  Constant.myLoader.hide();
                  getDailyReportRepository.isLoading = false;
                  print('cren : ${repository.reportList}');
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getDailyReportRepository.reportList.isEmpty
                        ? Expanded(
                            child: Center(
                              child: Text(
                                Strings.noData,
                                style: Constant.textStyleSize15(context)
                                    ?.copyWith(
                                      color: Constant.cBlack.withOpacity(0.5),
                                    ),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Constant.cBlack.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                Constant.paddingHalfHalf,
                              ),
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
                                        Padding(
                                          padding: const EdgeInsets.all(
                                            Constant.paddingHalf,
                                          ),
                                          child: Text(
                                            Strings.number,
                                            style: Constant.textStyleSize14(
                                              context,
                                            )?.copyWith(color: Constant.cBlack),
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
                                            Strings.reportDate,
                                            style: Constant.textStyleSize14(
                                              context,
                                            )?.copyWith(color: Constant.cBlack),
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
                                            Strings.report,
                                            style: Constant.textStyleSize14(
                                              context,
                                            )?.copyWith(color: Constant.cBlack),
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
                                            Strings.totalTime,
                                            style: Constant.textStyleSize14(
                                              context,
                                            )?.copyWith(color: Constant.cBlack),
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
                                            Strings.intermediateTime,
                                            style: Constant.textStyleSize14(
                                              context,
                                            )?.copyWith(color: Constant.cBlack),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                    Expanded(
                      flex: 1,
                      child: ListView.separated(
                        controller: _scrollController,
                        itemCount: getDailyReportRepository.reportList.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 1,
                            color: Constant.colorGrey,
                          );
                        },
                        itemBuilder: (context, index) {
                          ReportData reportList =
                              getDailyReportRepository.reportList[index];
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Constant.paddingHalf,
                                ),
                                child: Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(0.5),
                                    1: FlexColumnWidth(1),
                                    2: FlexColumnWidth(4),
                                    3: FlexColumnWidth(1),
                                    4: FlexColumnWidth(1),
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
                                            Text(
                                              '${index + 1}',
                                              style:
                                                  Constant.textStyleSize13(
                                                    context,
                                                  )?.copyWith(
                                                    color: getColorTimeWise(
                                                      reportList.totalTime!,
                                                    ),
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          //   crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              reportList.date!,
                                              style:
                                                  Constant.textStyleSize13(
                                                    context,
                                                  )?.copyWith(
                                                    color: getColorTimeWise(
                                                      reportList.totalTime!,
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
                                            Text(
                                              reportList.reportText!,
                                              style:
                                                  Constant.textStyleSize13(
                                                    context,
                                                  )?.copyWith(
                                                    color: getColorTimeWise(
                                                      reportList.totalTime!,
                                                    ),
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              reportList.totalTime!,
                                              style:
                                                  Constant.textStyleSize13(
                                                    context,
                                                  )?.copyWith(
                                                    color: getColorTimeWise(
                                                      reportList.totalTime!,
                                                    ),
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              reportList.intermediateTime ??
                                                  '00:00:00',
                                              style:
                                                  Constant.textStyleSize13(
                                                    context,
                                                  )?.copyWith(
                                                    color: getColorTimeWise(
                                                      reportList.totalTime!,
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
                              index ==
                                      getDailyReportRepository
                                          .reportList
                                          .lastIndex
                                  ? Container(
                                      height: 1,
                                      color: Constant.colorGrey,
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          );
                        },
                      ),
                    ),
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

getColorTimeWise(String time) {
  int sec = int.parse(time.split(':')[2]);
  int h = int.parse(time.split(':')[0]);
  int m = int.parse(time.split(':')[1]);
  sec = sec + ((h * 60) * 60) + (m * 60);
  if (sec < 12600) {
    return Constant.cRedLight;
  } else if (sec < 25200) {
    return Constant.cYellowDark;
  } /*else if(sec>28800){
    return Constant.cGreenLight;
  }*/ else {
    return Constant.cBlack;
  }
}

class PaginatedList extends StatefulWidget {
  const PaginatedList({
    Key? key,
    required this.itemBuilder,
    required this.onScrollAtLast,
    required this.itemCount,
    required this.controller,
    ChildIndexGetter? findChildIndexCallback,
  }) : super(key: key);

  final Function() onScrollAtLast;
  final int? itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final ScrollController controller;

  @override
  State<PaginatedList> createState() => _PaginatedListState();
}

class _PaginatedListState extends State<PaginatedList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Logger.println(
      "PaginatedList: initState: _scrollController.addListener() called",
    );
    _scrollController.addListener(() {
      Logger.println("PaginatedList: initState: addListener");
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        widget.onScrollAtLast();
        Logger.println(
          "PaginatedList: initState:  widget.onScrollAtLast() called",
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    Logger.println(
      "PaginatedList: dispose: _scrollController.dispose() called",
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.controller,
      itemBuilder: widget.itemBuilder,
      itemCount: widget.itemCount,
    );
  }
}
