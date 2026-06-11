import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oceanbit_timeclock/bloc_logic/salary_bloc/salary_bloc.dart';
import 'package:oceanbit_timeclock/local_storage/my_local_storage.dart';
import 'package:oceanbit_timeclock/models/salary_detail_model.dart';
import 'package:oceanbit_timeclock/screen/my_salary/salary_repository.dart';
import 'package:oceanbit_timeclock/widget/new/custom_cardview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../bloc_logic/salary_bloc/salary_repository.dart';
import '../../constant/constant.dart';
import '../../constant/strings.dart';
import '../../models/get_salary_model.dart';
import '../../utils/logger.dart';
import '../dashboard/dashboard.dart';
import 'example_file.dart';

List<SalaryData> allSalary = [];

class MySalaryScreen extends StatefulWidget {
  final bool isEmployee;
  const MySalaryScreen({Key? key, required this.isEmployee}) : super(key: key);

  @override
  State<MySalaryScreen> createState() => _MySalaryScreenState();
}

class _MySalaryScreenState extends State<MySalaryScreen> {
  late final SalaryRepository repository;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    repository = context.read<SalaryRepository>();
    repository.page = 1;
    allSalary.clear();
    widget.isEmployee
        ? BlocProvider.of<SalaryBloc>(context).add(
            FetchSalaryEvent(
              context: context,
              userId: MyLocalStorage().getUser()?.id,
            ),
          )
        : BlocProvider.of<SalaryBloc>(
            context,
          ).add(FetchSalaryEvent(context: context));
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
            widget.isEmployee
                ? BlocProvider.of<SalaryBloc>(context).add(
                    FetchSalaryEvent(
                      context: context,
                      userId: MyLocalStorage().getUser()?.id,
                    ),
                  )
                : BlocProvider.of<SalaryBloc>(
                    context,
                  ).add(FetchSalaryEvent(context: context));
          }
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SalaryBloc, SalaryState>(
      listener: (context, state) {
        if (state is SalaryLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is SalaryError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is SalaryLoaded) {
          repository.isLoading = false;
          if (repository.page < 2) {
            allSalary.clear();
          }
          allSalary.addAll(state.data.data);
          setState(() {});
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Constant.cBlack5PerOpacity,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Constant.paddingHalfHalf,
                vertical: Constant.paddingHalf,
              ),
              child: Table(
                columnWidths: widget.isEmployee
                    ? const {
                        0: FlexColumnWidth(0.6),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(3),
                        4: FlexColumnWidth(2),
                      }
                    : const {
                        0: FlexColumnWidth(0.6),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(2),
                        4: FlexColumnWidth(3),
                        5: FlexColumnWidth(2),
                      },
                children: [
                  TableRow(
                    children: [
                      Column(
                        children: [
                          Text(
                            Strings.number,
                            style: Constant.textStyleSize14(
                              context,
                            )?.copyWith(color: Constant.cBlack),
                          ),
                        ],
                      ),
                      widget.isEmployee
                          ? const SizedBox.shrink()
                          : Column(
                              children: [
                                Text(
                                  Strings.name,
                                  style: Constant.textStyleSize14(
                                    context,
                                  )?.copyWith(color: Constant.cBlack),
                                ),
                              ],
                            ),
                      Column(
                        children: [
                          Text(
                            Strings.month,
                            style: Constant.textStyleSize14(
                              context,
                            )?.copyWith(color: Constant.cBlack),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            Strings.salary,
                            style: Constant.textStyleSize14(
                              context,
                            )?.copyWith(color: Constant.cBlack),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            Strings.accountNo,
                            style: Constant.textStyleSize14(
                              context,
                            )?.copyWith(color: Constant.cBlack),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            Strings.view,
                            style: Constant.textStyleSize14(
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
          allSalary.isEmpty
              ? const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Spacer(),
                      Text('No Data', style: TextStyle(color: Colors.black)),
                      Spacer(),
                    ],
                  ),
                )
              : Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: allSalary.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(color: Constant.cLightGray, height: 1);
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Constant.paddingHalfHalf,
                            ),
                            child: Table(
                              columnWidths: widget.isEmployee
                                  ? const {
                                      0: FlexColumnWidth(0.6),
                                      1: FlexColumnWidth(2),
                                      2: FlexColumnWidth(2),
                                      3: FlexColumnWidth(3),
                                      4: FlexColumnWidth(2),
                                    }
                                  : const {
                                      0: FlexColumnWidth(0.6),
                                      1: FlexColumnWidth(2),
                                      2: FlexColumnWidth(2),
                                      3: FlexColumnWidth(2),
                                      4: FlexColumnWidth(3),
                                      5: FlexColumnWidth(2),
                                    },
                              children: [
                                TableRow(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: Constant.paddingHalf,
                                          ),
                                          child: Text(
                                            '${index + 1}',
                                            style: Constant.textStyleSize13(
                                              context,
                                            )?.copyWith(color: Constant.cBlack),
                                          ),
                                        ),
                                      ],
                                    ),
                                    widget.isEmployee
                                        ? const SizedBox.shrink()
                                        : Column(
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: Constant
                                                              .paddingHalf,
                                                        ),
                                                    child: Text(
                                                      allSalary[index]
                                                          .user
                                                          .firstName,
                                                      style:
                                                          Constant.textStyleSize13(
                                                            context,
                                                          )?.copyWith(
                                                            color:
                                                                Constant.cBlack,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: Constant.paddingHalf,
                                          ),
                                          child: Text(
                                            '${DateFormat.MMMM().format(DateTime(0, allSalary[index].month))} - ${allSalary[index].year}',
                                            style: Constant.textStyleSize13(
                                              context,
                                            )?.copyWith(color: Constant.cBlack),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: Constant.paddingHalf,
                                          ),
                                          child: Text(
                                            allSalary[index].paidSalary
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: Constant.textStyleSize13(
                                              context,
                                            )?.copyWith(color: Constant.cBlack),
                                            softWrap: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: Constant.paddingHalf,
                                          ),
                                          child: Text(
                                            allSalary[index]
                                                    .bankInformation
                                                    ?.accountNo ??
                                                'Add Account Detail',
                                            style: Constant.textStyleSize13(
                                              context,
                                            )?.copyWith(color: Constant.cBlack),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: Constant.paddingHalfHalf,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                context
                                                        .read<
                                                          SalaryPDFRepository
                                                        >()
                                                        .salaryModel =
                                                    SalaryDetailModel(
                                                      totalDeductionAmt:
                                                          allSalary[index]
                                                              .totalDeductionAmt
                                                              .toDouble(),
                                                      paidSalary:
                                                          allSalary[index]
                                                              .paidSalary
                                                              .toDouble(),
                                                      basicSalary:
                                                          allSalary[index]
                                                              .grossSalary
                                                              .toDouble(),
                                                      presentDays: double.parse(
                                                        allSalary[index]
                                                            .userWorkingDays,
                                                      ),
                                                      workingDays:
                                                          allSalary[index]
                                                              .totalWorkingDays
                                                              .toDouble(),
                                                      holiday: allSalary[index]
                                                          .totalHolidays
                                                          .toDouble(),
                                                      leaves: double.parse(
                                                        allSalary[index]
                                                            .totalLeaveDays,
                                                      ),
                                                      bonus: allSalary[index]
                                                          .employeeInformation
                                                          .bonusOne
                                                          .toDouble(),
                                                      hra: allSalary[index]
                                                          .employeeInformation
                                                          .hra
                                                          .toDouble(),
                                                      ta: allSalary[index]
                                                          .employeeInformation
                                                          .ta
                                                          .toDouble(),
                                                      designation:
                                                          allSalary[index]
                                                              .employeeInformation
                                                              .designation
                                                              .name,
                                                      loan: 0,
                                                      others: 0,
                                                      professionalTax: 0,
                                                      casualLeave: double.parse(
                                                        allSalary[index]
                                                            .clLeaveDays,
                                                      ),
                                                      leaveWithoutPay:
                                                          double.parse(
                                                            allSalary[index]
                                                                .lwpLeaveDays,
                                                          ),
                                                      penaltyLeave:
                                                          double.parse(
                                                            allSalary[index]
                                                                .pnltLeaveDays,
                                                          ),
                                                      sickLeave: double.parse(
                                                        allSalary[index]
                                                            .slLeaveDays,
                                                      ),
                                                    );

                                                context
                                                        .read<
                                                          SalaryPDFRepository
                                                        >()
                                                        .bankACno =
                                                    allSalary[index]
                                                        .bankInformation
                                                        ?.accountNo ??
                                                    'Add Account Detail';

                                                context
                                                        .read<
                                                          SalaryPDFRepository
                                                        >()
                                                        .employeeCode =
                                                    allSalary[index]
                                                        .user
                                                        .employeeId;
                                                context
                                                        .read<
                                                          SalaryPDFRepository
                                                        >()
                                                        .userName =
                                                    '${allSalary[index].user.firstName} ${allSalary[index].user.lastName}';
                                                context
                                                        .read<
                                                          SalaryPDFRepository
                                                        >()
                                                        .bankName =
                                                    allSalary[index]
                                                        .bankInformation
                                                        ?.bankName ??
                                                    'Add Account Detail';
                                                context
                                                        .read<
                                                          SalaryPDFRepository
                                                        >()
                                                        .department =
                                                    allSalary[index]
                                                        .employeeInformation
                                                        .department
                                                        .name
                                                        .toString();
                                                context
                                                        .read<
                                                          SalaryPDFRepository
                                                        >()
                                                        .selectedMonthShort =
                                                    '${DateFormat.MMM().format(DateTime(0, allSalary[index].month))} - ${allSalary[index].year}';
                                              });
                                              showDialog(
                                                context: context,
                                                builder: ((context) {
                                                  return customDialog(context);
                                                }),
                                              );
                                            },
                                            child: const CustomCardView(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: Constant.padding,
                                                  vertical:
                                                      Constant.paddingHalfHalf,
                                                ),
                                                child: Icon(
                                                  CupertinoIcons.eye_fill,
                                                  size: 18,
                                                ),
                                              ),
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
                          index == allSalary.lastIndex
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

  Widget customDialog(BuildContext context) {
    return Material(
      color: Constant.cBlack.withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width / 8,
          left: MediaQuery.of(context).size.width / 8,
        ),
        child: Center(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.height / 1.5,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Constant.paddingHalf),
                      color: Constant.colorSelectedIndicator,
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  Strings.salary,
                                  style: Theme.of(context).textTheme.titleLarge!
                                      .copyWith(color: Constant.cWhite),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        Uint8List pdf = await examples[0]
                                            .builder(PdfPageFormat.a4, context);
                                        //downloadPDF(pdf);
                                        final directory = /* Platform.isMacOS
        ?*/
                                            await getDownloadsDirectory(); //FOR ANDROID
                                        // : await getApplicationDocumentsDirectory();
                                        Logger.println(
                                          'external storage path:${directory!.path}',
                                        );
                                        final myPDFPath =
                                            '${directory.path}/${Strings.downloadDirName}';
                                        final myImgDir = Directory(myPDFPath);
                                        if (myImgDir.existsSync() == false) {
                                          myImgDir.create();
                                        }
                                        File file = await File(
                                          "$myPDFPath/Salary_${DateTime.now()}.pdf",
                                        ).writeAsBytes(pdf);

                                        //  var pdfFile=await file.writeAsBytes(pdf);
                                        Logger.println(
                                          'save file path: ${file.path}',
                                        );
                                        /*msgList.add(*/
                                        Constant().show_toast(
                                          file.path,
                                          context,
                                        ) /*)*/;
                                        //Navigator.pop(context);
                                      },
                                      child: const Icon(
                                        Icons.print,
                                        color: Constant.cWhite,
                                        size: 20,
                                      ),
                                    ),
                                    Constant.padding.widthBox,
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
                              ],
                            ),
                          ),
                          /*Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Constant.paddingHalf,
                            vertical: Constant.paddingHalfHalf,
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(Constant.paddingHalf),
                                topLeft: Radius.circular(Constant.paddingHalf),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Strings.salary,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(color: Constant.cWhite),
                                ),
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
                        ),*/
                          Container(
                            width: MediaQuery.of(context).size.height / 1.5,
                            height: MediaQuery.of(context).size.height - 40,
                            decoration: const BoxDecoration(
                              color: Constant.cWhite,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(
                                  Constant.paddingHalf,
                                ),
                                bottomLeft: Radius.circular(
                                  Constant.paddingHalf,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Theme(
                                data: ThemeData(
                                  //  backgroundColor: Constant.colorPrimary,
                                  primaryColor: Constant.colorSelectedIndicator,
                                  indicatorColor:
                                      Constant.colorSelectedIndicator,
                                  // splashColor: Constant.colorSelectedIndicator,
                                  //platform: Platform.isMacOS?TargetPlatform.macOS:TargetPlatform.windows,
                                  useMaterial3: false,
                                ),
                                child: PdfPreview(
                                  padding: const EdgeInsets.all(0),
                                  previewPageMargin: const EdgeInsets.only(
                                    bottom: Constant.paddingHalfHalf,
                                    top: Constant.paddingHalfHalf,
                                  ),
                                  useActions: false,
                                  //allowSharing: true,
                                  //allowPrinting: true,
                                  maxPageWidth: 700,
                                  build: (format) =>
                                      examples[0].builder(format, context),
                                ),
                              ),
                            ) /*Padding(
                            padding: const EdgeInsets.all(
                              Constant.padding,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.32,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      customLabelWithText(
                                        context,
                                        labelText: Strings.month,
                                        labelInfoText: 'March 2021',
                                      ),
                                      customLabelWithText(
                                        context,
                                        labelText: Strings.employeeAccNo,
                                        labelInfoText: '1234567890',
                                      ),
                                      customLabelWithText(
                                        context,
                                        labelText: Strings.amount,
                                        labelInfoText: '10000',
                                      ),
                                      Constant.paddingHalf.heightBox,
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                              ),
                                              color: Constant.colorSelectedIndicator
                                            ),
                                            child: Table(
                                              columnWidths: const {
                                                0: FlexColumnWidth(0.5),
                                                1: FlexColumnWidth(3),
                                              },
                                              children: [
                                                TableRow(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(
                                                            Constant.paddingHalf,
                                                          ),
                                                          child: Text(
                                                            Strings.no,
                                                            style: Constant
                                                                    .textStyleSize15(
                                                                        context)
                                                                ?.copyWith(
                                                                    // fontSize:
                                                                    //     11.sp,
                                                                    color: Constant
                                                                        .cWhite),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets
                                                                  .all(
                                                              Constant
                                                                  .paddingHalf),
                                                          child: Text(
                                                            Strings.totalLeave,
                                                            style: Constant
                                                                    .textStyleSize15(
                                                                        context)
                                                                ?.copyWith(
                                                                    // fontSize:
                                                                    //     11.sp,
                                                                    color: Constant
                                                                        .cWhite),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                Strings.totalLeaveList.length,
                                            itemBuilder: (context, index) {
                                              return Table(
                                                columnWidths: const {
                                                  0: FlexColumnWidth(0.5),
                                                  1: FlexColumnWidth(3),
                                                },
                                                border: TableBorder.all(
                                                  color: Constant.colorGrey,
                                                  style: BorderStyle.solid,
                                                  width: 0.5,
                                                  borderRadius: BorderRadius.only(
                                                    bottomLeft: Radius.circular(index == Strings.totalLeaveList.lastIndex ? 10 : 0),
                                                    bottomRight: Radius.circular(index == Strings.totalLeaveList.lastIndex ? 10 : 0)
                                                  ),
                                                ),
                                                children: [
                                                  TableRow(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                Constant
                                                                    .paddingHalf),
                                                            child: Text(
                                                              '${index + 1}',
                                                              style: Constant
                                                                      .textStyleSize13(
                                                                          context)
                                                                  ?.copyWith(
                                                                      // fontSize:
                                                                      //     11.sp,
                                                                      color: Constant
                                                                          .cBlack),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .all(
                                                                    Constant
                                                                        .paddingHalf),
                                                            child: Text(
                                                              Strings.totalLeaveList[
                                                                  index],
                                                              style: Constant
                                                                      .textStyleSize13(
                                                                          context)
                                                                  ?.copyWith(
                                                                // fontSize: 11.sp,
                                                                color: Constant
                                                                    .cBlack,
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
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                               const Spacer(),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.32,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      customLabelWithText(
                                        context,
                                        labelText: Strings.totalDays,
                                        labelInfoText: '28',
                                      ),
                                      customLabelWithText(
                                        context,
                                        labelText: Strings.companyAccountNo,
                                        labelInfoText: '1234567890',
                                      ),
                                      customLabelWithText(
                                        context,
                                        labelText: Strings.totalWorkingDays,
                                        labelInfoText: '24',
                                      ),
                                      Constant.paddingHalf.heightBox,
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft: Radius.circular(10),
                                                ),
                                                color: Constant.colorSelectedIndicator
                                            ),
                                            child: Table(
                                              columnWidths: const {
                                                0: FlexColumnWidth(0.5),
                                                1: FlexColumnWidth(3),
                                              },
                                              children: [
                                                TableRow(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(
                                                            Constant.paddingHalf,
                                                          ),
                                                          child: Text(
                                                            Strings.no,
                                                            style: Constant
                                                                    .textStyleSize15(
                                                                        context)
                                                                ?.copyWith(
                                                              color:
                                                                  Constant.cWhite,
                                                              // fontSize: 11.sp,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(
                                                            Constant.paddingHalf,
                                                          ),
                                                          child: Text(
                                                            Strings.totalHoliday,
                                                            style: Constant
                                                                    .textStyleSize15(
                                                                        context)
                                                                ?.copyWith(
                                                              color:
                                                                  Constant.cWhite,
                                                              // fontSize: 11.sp,
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
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                Strings.totalHolidayList.length,
                                            itemBuilder: (context, index) {
                                              return Table(
                                                columnWidths: const {
                                                  0: FlexColumnWidth(0.5),
                                                  1: FlexColumnWidth(3),
                                                },
                                                border: TableBorder.all(
                                                  color: Constant.colorGrey,
                                                  style: BorderStyle.solid,
                                                  width: 1,
                                                  borderRadius: BorderRadius.only(
                                                      bottomLeft: Radius.circular(index == Strings.totalLeaveList.lastIndex ? 10 : 0),
                                                      bottomRight: Radius.circular(index == Strings.totalLeaveList.lastIndex ? 10 : 0)
                                                  ),
                                                ),
                                                children: [
                                                  TableRow(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(
                                                              Constant
                                                                  .paddingHalf,
                                                            ),
                                                            child: Text(
                                                              '${index + 1}',
                                                              style: Constant
                                                                      .textStyleSize13(
                                                                          context)
                                                                  ?.copyWith(
                                                                color: Constant
                                                                    .cBlack,
                                                                // fontSize: 11.sp,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(
                                                              Constant
                                                                  .paddingHalf,
                                                            ),
                                                            child: Text(
                                                              Strings.totalHolidayList[
                                                                  index],
                                                              style: Constant
                                                                      .textStyleSize13(
                                                                          context)
                                                                  ?.copyWith(
                                                                color: Constant
                                                                    .cBlack,
                                                                // fontSize: 11.sp,
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
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )*/,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  customLabelWithText(
    BuildContext context, {
    required String labelText,
    required String labelInfoText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: Constant.paddingMidHalf),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 8,
            child: Text(
              labelText,
              style: Constant.textStyleSize13(
                context,
              )!.copyWith(/*fontSize: 11.sp,*/ color: Constant.cBlack),
            ),
          ),
          Text(
            ":",
            style: Constant.textStyleSize13(
              context,
            )!.copyWith(color: Constant.cBlack /*fontSize: 11.sp*/),
          ),
          //Spacer(),
          Constant.paddingHalf.widthBox,
          Text(
            labelInfoText,
            style: Constant.textStyleSize13(
              context,
            )!.copyWith(color: Constant.cBlack /*fontSize: 11.sp*/),
          ),
        ],
      ),
    );
  }
}
