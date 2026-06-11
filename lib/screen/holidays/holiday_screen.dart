import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_holiday/get_holiday_event.dart';
import 'package:oceanbit_timeclock/widget/new/custom_header_container.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../bloc_logic/get_holiday/get_holiday_bloc.dart';
import '../../bloc_logic/get_holiday/get_holiday_state.dart';
import '../../constant/constant.dart';
import '../../constant/strings.dart';
import '../../models/holiday_model.dart';
import '../../utils/logger.dart';
import '../dashboard/dashboard.dart';

class HolidayScreen extends StatefulWidget {
  const HolidayScreen({Key? key}) : super(key: key);

  @override
  State<HolidayScreen> createState() => _HolidayScreenState();
}

class _HolidayScreenState extends State<HolidayScreen> {
  List<HolidayData> allHoliday = [];

  @override
  void initState() {
    BlocProvider.of<GetHolidayBloc>(context).add(
      FetchHoliday(context: context),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetHolidayBloc, GetHolidayState>(
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
              state.data.data.length, (index) => state.data.data[index]);
        }
      },
      child: CustomHeaderContainer(
        headerWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              Strings.holiday,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Constant.cWhite),
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
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            Strings.number,
                                            style: Constant.textStyleSize14(
                                                    context)
                                                ?.copyWith(
                                              color: Constant.cBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            Strings.name,
                                            style: Constant.textStyleSize14(
                                                    context)
                                                ?.copyWith(
                                              color: Constant.cBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            Strings.startDate,
                                            style: Constant.textStyleSize14(
                                                    context)
                                                ?.copyWith(
                                              color: Constant.cBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            Strings.endDate,
                                            style: Constant.textStyleSize14(
                                                    context)
                                                ?.copyWith(
                                              color: Constant.cBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            Strings.days,
                                            style: Constant.textStyleSize14(
                                                    context)
                                                ?.copyWith(
                                                    color: Constant.cBlack),
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
                                        },
                                        children: [
                                          TableRow(
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    '${index + 1}',
                                                    style: Constant
                                                            .textStyleSize13(
                                                                context)
                                                        ?.copyWith(
                                                      color: Constant.cBlack,
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
                                                    style: Constant
                                                            .textStyleSize13(
                                                                context)
                                                        ?.copyWith(
                                                            color: Constant
                                                                .cBlack),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    date(
                                                        date: allHoliday[index]
                                                            .startDate),
                                                    style: const TextStyle(
                                                        color: Constant.cBlack),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Logger.println(
                                                          'date data is :: ${allHoliday[index].endDate}');
                                                    },
                                                    child: Text(
                                                      allHoliday[index]
                                                                  .endDate ==
                                                              allHoliday[index]
                                                                  .startDate
                                                          ? date(
                                                              date: allHoliday[
                                                                      index]
                                                                  .startDate)
                                                          : date(
                                                              date: allHoliday[
                                                                      index]
                                                                  .endDate),
                                                      style: const TextStyle(
                                                          color:
                                                              Constant.cBlack),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    allHoliday[index].days !=
                                                            null
                                                        ? allHoliday[index]
                                                            .days!
                                                            .padLeft(2, '0')
                                                            .toString()
                                                        : '00',
                                                    style: Constant
                                                            .textStyleSize13(
                                                                context)
                                                        ?.copyWith(
                                                      color: Constant.cBlack,
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
                              }),
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

  String date({required DateTime date}) {
    return '${date.day.padLeft(2, '0')}-${date.month.padLeft(2, '0')}-${date.year}';
  }
}
