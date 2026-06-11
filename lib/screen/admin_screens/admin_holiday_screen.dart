import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/add_holiday_bloc/add_holiday_event.dart';
import 'package:oceanbit_timeclock/constant/constant.dart';
import 'package:oceanbit_timeclock/models/holiday_model.dart';
import 'package:oceanbit_timeclock/widget/new/custom_header_container.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../bloc_logic/add_holiday_bloc/add_holiday_bloc.dart';
import '../../bloc_logic/add_holiday_bloc/add_holiday_state.dart';
import '../../bloc_logic/get_holiday/get_holiday_bloc.dart';
import '../../bloc_logic/get_holiday/get_holiday_event.dart';
import '../../bloc_logic/get_holiday/get_holiday_state.dart';
import '../../bloc_logic/get_holiday_types/get_holiday_bloc.dart';
import '../../bloc_logic/get_holiday_types/get_holiday_event.dart';
import '../../bloc_logic/get_holiday_types/get_holiday_state.dart';
import '../../constant/strings.dart';
import '../../models/holiday_type_model.dart';
import '../../utils/date_formatter.dart';
import '../../utils/logger.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_container_button.dart';
import '../../widget/custom_form_label.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/custom_textfield_with_label.dart';
import '../../widget/new/custom_cardview.dart';
import '../../widget/new/custom_datepicker_theme.dart';
import '../../widget/new/custom_dropdown_with_label.dart';
import '../dashboard/dashboard.dart';

class AdminHolidayScreen extends StatefulWidget {
  const AdminHolidayScreen({Key? key, required this.sizeTag}) : super(key: key);
  final int sizeTag;

  @override
  State<AdminHolidayScreen> createState() => _AdminHolidayScreenState();
}

class _AdminHolidayScreenState extends State<AdminHolidayScreen> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController selectedHolidayController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidateMode = false;
  DateTime? startDate;
  DateTime? endDate;
  List<HolidayData> allHoliday = [];
  List<String> allHolidayType = [];
  List<Data> allHolidayTypeList = [];
  int selectedHolidayId = 0;
  Data? holiday;
  String? selectedHoliday;
  String? holidayTypeId;

  Future<void> viewVisible() async {
    BlocProvider.of<GetHolidayBloc>(
      context,
    ).add(FetchHoliday(context: context));
    BlocProvider.of<GetHolidayTypeBloc>(
      context,
    ).add(FetchHolidayType(context: context));
  }

  @override
  void initState() {
    viewVisible();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetHolidayBloc, GetHolidayState>(
          listener: (context, state) {
            if (state is GetHolidayLoading) {
              Constant.myLoader.show(context);
            } else {
              Constant.myLoader.hide();
              setState(() {});
            }
            if (state is GetHolidayError) {
              msgList.add(Constant().ShowErrorMessage(state.errors, context));
              Constant.myLoader.hide();
              Logger.println('error ${state.errors}');
              //Constant().ShowToast(state.errors, context);
            } else if (state is GetHolidayLoaded) {
              allHoliday.clear();
              allHoliday = List.generate(
                state.data.data.length,
                (index) => state.data.data[index],
              );
              Logger.println("holiday data  2:${state.data.data}");
            }
            if (state is UpdateHolidayLoading) {
              Constant.myLoader.show(context);
            } else {
              Constant.myLoader.hide();
              setState(() {});
            }
            if (state is UpdateHolidayError) {
              msgList.add(Constant().ShowErrorMessage(state.errors, context));
              Constant.myLoader.hide();
              Logger.println('error ${state.errors}');
              //Constant().ShowToast(state.errors, context);
            } else if (state is UpdateHolidayLoaded) {
              Navigator.pop(context);
              descriptionController.clear();
              startDateController.clear();
              endDateController.clear();
              BlocProvider.of<GetHolidayBloc>(
                context,
              ).add(FetchHoliday(context: context));
            }
            if (state is DeleteHolidayLoading) {
              Constant.myLoader.show(context);
            } else {
              Constant.myLoader.hide();
              setState(() {});
            }
            if (state is DeleteHolidayError) {
              msgList.add(Constant().ShowErrorMessage(state.errors, context));
              Constant.myLoader.hide();
              Logger.println('error ${state.errors}');
              //Constant().ShowToast(state.errors, context);
            } else if (state is DeleteHolidayLoaded) {
              Navigator.pop(context);
              allHoliday.clear();
              BlocProvider.of<GetHolidayBloc>(
                context,
              ).add(FetchHoliday(context: context));
            }
          },
        ),
        BlocListener<GetHolidayTypeBloc, GetHolidayTypeState>(
          listener: (context, state) {
            if (state is GetHolidayTypeLoading) {
              Constant.myLoader.show(context);
            } else {
              Constant.myLoader.hide();
              setState(() {});
            }
            if (state is GetHolidayTypeError) {
              msgList.add(Constant().ShowErrorMessage(state.errors, context));
              Constant.myLoader.hide();
              Logger.println('error ${state.errors}');
              //Constant().ShowToast(state.errors, context);
            } else if (state is GetHolidayTypeLoaded) {
              allHolidayType.clear();
              allHolidayType = List.generate(
                state.data!.data.length,
                (index) => state.data!.data[index].name,
              );

              allHolidayTypeList.clear();
              allHolidayTypeList = List.generate(
                state.data!.data.length,
                (index) => state.data!.data[index],
              );

              Logger.println("holiday type data  :${state.data?.data[0].name}");
            }
          },
        ),
        BlocListener<AddHolidayBloc, AddHolidayState>(
          listener: (context, state) {
            if (state is AddHolidayLoading) {
              Constant.myLoader.show(context);
            } else {
              Constant.myLoader.hide();
              setState(() {});
            }
            if (state is AddHolidayError) {
              msgList.add(Constant().ShowErrorMessage(state.errors, context));
              Constant.myLoader.hide();
              Logger.println('error ${state.errors}');
              //Constant().ShowToast(state.errors, context);
            } else if (state is AddHolidayLoaded) {
              Navigator.pop(context);
              BlocProvider.of<GetHolidayBloc>(
                context,
              ).add(FetchHoliday(context: context));
            }
          },
        ),
      ],
      child: CustomHeaderContainer(
        headerWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              Strings.holiday,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Constant.cWhite),
            ),
            CustomContainerButton(
              text: Strings.addHolidays,
              textStyle: Constant.textStyleSize13(
                context,
              )!.copyWith(color: Constant.cBlack),
              color: Constant.cWhite,
              width: 120,
              onTap: () {
                startDateController.clear();
                endDateController.clear();
                descriptionController.clear();
                showDialog(
                  context: context,
                  builder: ((context) {
                    return Material(
                      color: Constant.cBlack.withOpacity(0.1),
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width / 8,
                          left: MediaQuery.of(context).size.width / 8,
                        ),
                        child: Center(child: customDialog(widget.sizeTag)),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Constant.cBlack.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                Constant.paddingHalfHalf,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                Constant.paddingHalf,
                              ),
                              child: Table(
                                columnWidths: const {
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(2),
                                  2: FlexColumnWidth(1.5),
                                  3: FlexColumnWidth(1.5),
                                  4: FlexColumnWidth(1),
                                  5: FlexColumnWidth(1),
                                  6: FlexColumnWidth(1),
                                  7: FlexColumnWidth(1),
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
                                      Column(
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
                                            Strings.startDate,
                                            style: Constant.textStyleSize14(
                                              context,
                                            )?.copyWith(color: Constant.cBlack),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            Strings.endDate,
                                            style: Constant.textStyleSize14(
                                              context,
                                            )?.copyWith(color: Constant.cBlack),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            Strings.days,
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
                                      Column(
                                        children: [
                                          Text(
                                            Strings.update,
                                            style: Constant.textStyleSize14(
                                              context,
                                            )?.copyWith(color: Constant.cBlack),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            Strings.delete,
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
                          allHoliday.isEmpty
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
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: allHoliday.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                        return Container(
                                          height: 1,
                                          color: Constant.colorGrey,
                                        );
                                      },
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(
                                            Constant.paddingHalf,
                                          ),
                                          child: Table(
                                            columnWidths: const {
                                              0: FlexColumnWidth(1),
                                              1: FlexColumnWidth(2),
                                              2: FlexColumnWidth(1.5),
                                              3: FlexColumnWidth(1.5),
                                              4: FlexColumnWidth(1),
                                              5: FlexColumnWidth(1),
                                              6: FlexColumnWidth(1),
                                              7: FlexColumnWidth(1),
                                            },
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
                                                              color: Constant
                                                                  .cBlack,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        allHoliday[index]
                                                            .holidayType
                                                            .name,
                                                        style:
                                                            Constant.textStyleSize13(
                                                              context,
                                                            )?.copyWith(
                                                              color: Constant
                                                                  .cBlack,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        date(
                                                          date:
                                                              allHoliday[index]
                                                                  .startDate,
                                                        ),
                                                        style: const TextStyle(
                                                          color:
                                                              Constant.cBlack,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        allHoliday[index]
                                                                    .endDate ==
                                                                allHoliday[index]
                                                                    .startDate
                                                            ? date(
                                                                date: allHoliday[index]
                                                                    .startDate,
                                                              )
                                                            : date(
                                                                date:
                                                                    allHoliday[index]
                                                                        .endDate,
                                                              ),
                                                        style: const TextStyle(
                                                          color:
                                                              Constant.cBlack,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        allHoliday[index]
                                                                    .days !=
                                                                null
                                                            ? allHoliday[index]
                                                                  .days!
                                                                  .padLeft(
                                                                    2,
                                                                    '0',
                                                                  )
                                                                  .toString()
                                                            : '00',
                                                        style:
                                                            Constant.textStyleSize13(
                                                              context,
                                                            )?.copyWith(
                                                              color: Constant
                                                                  .cBlack,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: Constant
                                                                  .paddingHalfHalf,
                                                            ),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            selectedHolidayController
                                                                    .text =
                                                                allHoliday[index]
                                                                    .holidayType
                                                                    .name;
                                                            selectedHoliday =
                                                                allHoliday[index]
                                                                    .holidayType
                                                                    .name;

                                                            for (var e
                                                                in allHolidayTypeList) {
                                                              if (e.name ==
                                                                  selectedHoliday) {
                                                                holiday = e;
                                                              }
                                                            }

                                                            descriptionController
                                                                    .text =
                                                                allHoliday[index]
                                                                    .description;
                                                            startDateController
                                                                .text = date(
                                                              date:
                                                                  allHoliday[index]
                                                                      .startDate,
                                                            );
                                                            endDateController
                                                                .text = date(
                                                              date:
                                                                  allHoliday[index]
                                                                      .endDate,
                                                            );

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
                                                                      right:
                                                                          MediaQuery.of(
                                                                            context,
                                                                          ).size.width /
                                                                          8,
                                                                      left:
                                                                          MediaQuery.of(
                                                                            context,
                                                                          ).size.width /
                                                                          8,
                                                                    ),
                                                                    child: Center(
                                                                      child: customDialog(
                                                                        widget
                                                                            .sizeTag,
                                                                        isView:
                                                                            true,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }),
                                                            );
                                                          },
                                                          child: const CustomCardView(
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                horizontal:
                                                                    Constant
                                                                        .padding,
                                                                vertical: Constant
                                                                    .paddingHalfHalf,
                                                              ),
                                                              child: Icon(
                                                                CupertinoIcons
                                                                    .eye_fill,
                                                                size: 18,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: Constant
                                                                  .paddingHalfHalf,
                                                            ),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            selectedHoliday =
                                                                allHoliday[index]
                                                                    .holidayType
                                                                    .name;

                                                            for (var e
                                                                in allHolidayTypeList) {
                                                              if (e.name ==
                                                                  selectedHoliday) {
                                                                holiday = e;
                                                              }
                                                            }

                                                            descriptionController
                                                                    .text =
                                                                allHoliday[index]
                                                                    .description;
                                                            startDateController
                                                                .text = date(
                                                              date:
                                                                  allHoliday[index]
                                                                      .startDate,
                                                            );
                                                            endDateController
                                                                .text = date(
                                                              date:
                                                                  allHoliday[index]
                                                                      .endDate,
                                                            );

                                                            holidayTypeId =
                                                                allHoliday[index]
                                                                    .id
                                                                    .toString();

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
                                                                      right:
                                                                          MediaQuery.of(
                                                                            context,
                                                                          ).size.width /
                                                                          8,
                                                                      left:
                                                                          MediaQuery.of(
                                                                            context,
                                                                          ).size.width /
                                                                          8,
                                                                    ),
                                                                    child: Center(
                                                                      child: customDialog(
                                                                        widget
                                                                            .sizeTag,
                                                                        isUpdate:
                                                                            true,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }),
                                                            );
                                                          },
                                                          child: const CustomCardView(
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                horizontal:
                                                                    Constant
                                                                        .padding,
                                                                vertical: Constant
                                                                    .paddingHalfHalf,
                                                              ),
                                                              child: Icon(
                                                                Icons.edit,
                                                                size: 18,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: Constant
                                                                  .paddingHalfHalf,
                                                            ),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            int updateId =
                                                                allHoliday[index]
                                                                    .id;

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
                                                                      right:
                                                                          MediaQuery.of(
                                                                            context,
                                                                          ).size.width /
                                                                          8,
                                                                      left:
                                                                          MediaQuery.of(
                                                                            context,
                                                                          ).size.width /
                                                                          8,
                                                                    ),
                                                                    child: Center(
                                                                      child: deleteDialog(
                                                                        updateId,
                                                                        widget
                                                                            .sizeTag,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }),
                                                            );
                                                          },
                                                          child: const CustomCardView(
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                horizontal:
                                                                    Constant
                                                                        .padding,
                                                                vertical: Constant
                                                                    .paddingHalfHalf,
                                                              ),
                                                              child: Icon(
                                                                CupertinoIcons
                                                                    .delete_solid,
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
                                        index == allHoliday.lastIndex
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
                  ),
                ],
              ),
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
                              'Are you sure to delete this holiday type?',
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
                                    BlocProvider.of<GetHolidayBloc>(
                                      context,
                                    ).add(
                                      DeleteHoliday(
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

  Widget customDialog(int sizeTag, {isView = false, isUpdate = false}) {
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Spacer(),
                          Text(
                            isView
                                ? Strings.viewHolidays
                                : isUpdate
                                ? Strings.updateHolidays
                                : Strings.addHolidays,
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
                      child: Form(
                        key: _formKey,
                        autovalidateMode: _autoValidateMode
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            isView
                                ? LabelWithTextField(
                                    labelText: 'Select Holiday',
                                    controller: selectedHolidayController,
                                    validatorString: 'Please enter description',
                                    hintText: 'Select Holiday',
                                    isRequired: true,
                                    maxLines: 1,
                                    isEnable: false,
                                  )
                                : LabelWithDropDownButton(
                                    hintText: 'Select Holiday',
                                    onChanged: isView
                                        ? (val) {}
                                        : allHolidayType.isEmpty
                                        ? (val) {
                                            Constant().show_toast(
                                              'Please first add Holiday Type',
                                              context,
                                            );
                                          }
                                        : (val) {
                                            setState(() {
                                              selectedHoliday = val;
                                            });
                                            for (var e in allHolidayTypeList) {
                                              if (e.name == val) {
                                                selectedHolidayId = e.id;
                                                holiday = e;
                                              }
                                            }
                                          },
                                    list: allHolidayType.isEmpty
                                        ? ['Please first add Holiday Type']
                                        : allHolidayType,
                                    labelText: 'Select Holiday',
                                    selectedValue: selectedHoliday,
                                  ),
                            Constant.paddingMidDoubleHalf.heightBox,
                            LabelWithTextField(
                              labelText: 'Description',
                              controller: descriptionController,
                              validatorString: 'Please enter description',
                              hintText: 'Enter Description',
                              isRequired: true,
                              maxLines: 5,
                              isEnable: !isView ? true : false,
                            ),
                            Constant.paddingMidDoubleHalf.heightBox,
                            Row(
                              //mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 175,
                                  child: CustomFormLabel(
                                    label: Strings.selectDate,
                                    style: Constant.textStyleSize13(
                                      context,
                                    )?.copyWith(color: Constant.cBlack),
                                    isRequired: true,
                                    requiredStyle: Constant.textStyleSize14(
                                      context,
                                    )?.copyWith(color: Constant.cRed),
                                  ),
                                ),
                                Constant.paddingHalf.widthBox,
                                Flexible(
                                  flex: 2,
                                  child: datePicker(
                                    // labelText: Strings.startDate,
                                    controller: startDateController,
                                    date: startDate,
                                    hintText: Strings.startDate,
                                    validatorString: Strings.startDateEmpty,
                                    isEnable: !isView ? true : false,
                                  ),
                                ),
                                holiday?.isMulti != 0
                                    ? const SizedBox(width: Constant.padding)
                                    : const SizedBox.shrink(),
                                holiday?.isMulti == 0
                                    ? const SizedBox.shrink()
                                    : Flexible(
                                        flex: 2,
                                        child: datePicker(
                                          //labelText: Strings.endDate,
                                          controller: endDateController,
                                          date: endDate,
                                          hintText: Strings.endDate,
                                          validatorString: Strings.endDateEmpty,
                                          isEnable: !isView ? true : false,
                                          isEndDate: true,
                                        ),
                                      ),
                              ],
                            ),
                            Constant.padding.heightBox,
                            CustomButton(
                              height: 40,
                              width: 120,
                              text: isView ? Strings.close : Strings.submit,
                              textStyle: Constant.textStyleSize14(
                                context,
                              )?.copyWith(color: Constant.cWhite),
                              color: Constant.colorSelectedIndicator,
                              onTap: isView
                                  ? () {
                                      Navigator.pop(context);
                                    }
                                  : isUpdate
                                  ? (() {
                                      if (_formKey.currentState!.validate()) {
                                        String start =
                                            DateFormatter.formateDate(
                                              inputFormatter: 'dd-MM-yyyy',
                                              input: startDateController.text,
                                              outputFormatter: 'yyyy-MM-dd',
                                            );
                                        String end = DateFormatter.formateDate(
                                          inputFormatter: 'dd-MM-yyyy',
                                          input: holiday?.isMulti == 1
                                              ? endDateController.text
                                              : startDateController.text,
                                          outputFormatter: 'yyyy-MM-dd',
                                        );

                                        BlocProvider.of<GetHolidayBloc>(
                                          context,
                                        ).add(
                                          UpdateHoliday(
                                            context: context,
                                            id: holidayTypeId!,
                                            startDate: start,
                                            endDate: holiday?.isMulti == 1
                                                ? end
                                                : start,
                                            desc: descriptionController.text,
                                            holidayTypeId: holiday!.id
                                                .toString(),
                                          ),
                                        );
                                      } else {
                                        setState(() {
                                          _autoValidateMode = true;
                                        });
                                      }
                                    })
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        for (var e in allHolidayTypeList) {
                                          if (e.name == selectedHoliday) {
                                            holiday = e;
                                          }
                                        }
                                        String start =
                                            DateFormatter.formateDate(
                                              inputFormatter: 'dd-MM-yyyy',
                                              input: startDateController.text,
                                              outputFormatter: 'yyyy-MM-dd',
                                            );
                                        String end = DateFormatter.formateDate(
                                          inputFormatter: 'dd-MM-yyyy',
                                          input: holiday?.isMulti == 1
                                              ? endDateController.text
                                              : startDateController.text,
                                          outputFormatter: 'yyyy-MM-dd',
                                        );

                                        BlocProvider.of<AddHolidayBloc>(
                                          context,
                                        ).add(
                                          AddHolidayWithType(
                                            holidayTypeId: selectedHolidayId,
                                            startDate: start,
                                            endDate: holiday?.isMulti == 1
                                                ? end
                                                : start,
                                            description:
                                                descriptionController.text,
                                            context: context,
                                          ),
                                        );
                                      } else {
                                        setState(() {
                                          _autoValidateMode = true;
                                        });
                                      }
                                    },
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

  Widget datePicker({
    DateTime? date,
    TextEditingController? controller,
    String? hintText,
    String? validatorString,
    String? Function(String?)? validatorFunction,
    bool isEnable = true,
    isEndDate = false,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      //type: TextInputType.datetime,
      isEnable: isEnable,
      onChanged: (val) {},
      onTap: isEnable
          ? () async {
              String start = DateFormatter.formateDate(
                inputFormatter: 'dd-MM-yyyy',
                input: startDateController.text != ''
                    ? startDateController.text
                    : DateTime.now().toString(),
                outputFormatter: 'yyyy-MM-dd',
              );
              date = await showDatePicker(
                context: context,
                initialDate: isEndDate ? DateTime.parse(start) : DateTime.now(),
                firstDate: isEndDate ? DateTime.parse(start) : DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 1),
                builder: (context, child) {
                  return CustomDatePickerTheme(child: child!);
                },
              );
              setState(() {
                controller!.text = DateFormatter.formateDate(
                  inputFormatter: "yyyy-MM-dd 00:00:00.000",
                  input: date.toString(),
                  outputFormatter: "dd-MM-yyyy",
                );
              });
            }
          : () {},
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
}

String date({required DateTime date}) {
  return '${date.day.padLeft(2, '0')}-${date.month.padLeft(2, '0')}-${date.year}';
}

// update holiday & holiday type api
// delete holiday & holiday type api
// view holiday & holiday type dialog
