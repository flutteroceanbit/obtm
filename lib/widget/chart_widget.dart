import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/update_ui_bloc/update_ui_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/update_ui_bloc/update_ui_event.dart';
import 'package:oceanbit_timeclock/models/add_time_slot_model.dart';
import 'package:oceanbit_timeclock/models/chart_data_model.dart';
import 'package:oceanbit_timeclock/models/get_daily_report_model.dart';
import 'package:oceanbit_timeclock/utils/logger.dart';

import 'package:velocity_x/velocity_x.dart';
import '../constant/constant.dart';
import '../constant/strings.dart';
import '../gen/assets.gen.dart';
import '../screen/profile/widgets/chart_widget/src/chart/bar_chart/bar_chart.dart';
import '../screen/profile/widgets/chart_widget/src/chart/bar_chart/bar_chart_data.dart';
import '../screen/profile/widgets/chart_widget/src/chart/base/axis_chart/axis_chart_data.dart';
import '../screen/profile/widgets/chart_widget/src/chart/base/axis_chart/axis_chart_widgets.dart';
import '../screen/profile/widgets/chart_widget/src/chart/base/base_chart/base_chart_data.dart';
import '../screen/profile/widgets/chart_widget/src/chart/base/base_chart/fl_touch_event.dart';
import '../utils/date_formatter.dart';

// import this
bool showTimeDialog = false;
Map<String, dynamic> timeDetail = {};

class ChartWidget extends StatelessWidget {
  ChartWidget(
      {Key? key,
      this.reportList,
      this.rowSegment = 0,
      this.timeSlotList,
      this.maxTime})
      : super(key: key);
  final List<ReportData>? reportList;
  final List<TimeSlotData>? timeSlotList;
  final int rowSegment;

  final int maxY = 10;

  final List<double> timeList = [];

  double? maxTime;

  final List<String> dateList = [];

  double? timeData;

  Widget bottomTitles(double value, TitleMeta meta) {
    var style =
        const TextStyle(fontSize: Constant.textSize10, color: Constant.cBlack);
    String text = "";
    //Logger.println("value:::${value}");
    if (value < timeList.length) {
      switch (value.toInt()) {
        case 0:
          text = dateList[0];
          break;
        case 1:
          text = dateList[1];
          break;
        case 2:
          text = dateList[2];
          break;
        case 3:
          text = dateList[3];
          break;
        case 4:
          text = dateList[4];
          break;
        case 5:
          text = dateList[5];
          break;
        case 6:
          text = dateList[6];
          break;
        case 7:
          text = dateList[7];
          break;
        case 8:
          text = dateList[8];
          break;
        case 9:
          text = dateList[9];
          break;
        case 10:
          text = dateList[10];
          break;
        case 11:
          text = dateList[11];
          break;
        case 12:
          text = dateList[12];
          break;
        case 13:
          text = dateList[13];
          break;
        case 14:
          text = dateList[14];
          break;
        case 15:
          text = dateList[15];
          break;
        case 16:
          text = dateList[16];
          break;
        case 17:
          text = dateList[17];
          break;
        case 18:
          text = dateList[18];
          break;
        case 19:
          text = dateList[19];
          break;
        case 20:
          text = dateList[20];
          break;
        case 21:
          text = dateList[21];
          break;
        case 22:
          text = dateList[22];
          break;
        case 23:
          text = dateList[23];
          break;
        case 24:
          text = dateList[24];
          break;
        case 25:
          text = dateList[25];
          break;
        case 26:
          text = dateList[26];
          break;
        case 27:
          text = dateList[27];
          break;
        case 28:
          text = dateList[28];
          break;
        case 29:
          text = dateList[29];
          break;
        case 30:
          text = dateList[30];
          break;
        case 31:
          text = dateList[31];
          break;
        default:
          text = '';
          break;
      }
    }
    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: SideTitleWidget(
        axisSide: meta.axisSide,
        space: meta.appliedInterval,
        child: Text(value <= timeList.length ? '  $text' : '', style: style),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    var style =
        const TextStyle(fontSize: Constant.textSize10, color: Constant.cBlack);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '${value ~/ 60}',
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    dateList.clear();
    timeList.clear();
    if (timeSlotList != null && timeSlotList!.isNotEmpty) {
      //widget.timeSlotList?.reversed;
      timeSlotList?.forEach((element) {
        Logger.println('date:${element.date} ${element.timeSlots}');
        double minute = 0;
        if (element.timeSlots!.isNotEmpty) {
          for (var data in element.timeSlots!) {
            Logger.println('time slots : ${data.timeDifference}');
            // var totalTime = DateFormatter.dateFromString(
            //     inputFormatter: "hh:mm:ss", input: data.timeDifference);
            //var hours = totalTime.hour;
            //      minute = minute+totalTime.minute + (totalTime.hour * 60);

            minute = minute +
                (double.parse((data.timeDifference!.split(':')[2])) / 60) +
                double.parse(data.timeDifference!.split(':')[1]) +
                (double.parse(data.timeDifference!.split(':')[0]) * 60);
            Logger.println("Minute ::: $minute");
            //print("Hours ::: $hours");
          }
        }
        Logger.println("total day Minute ::: $minute");
        timeList.add(minute.toDouble());
        // var totalDay = DateFormatter.dateFromString(
        //     inputFormatter: 'yyyy-MM-dd', input: element.date);
        dateList.add(element.date!.split('-')[2]);
        // double minuts = int.parse((element.totalTime!.split(":")[0]) * 60) +
        //     int.parse(element.totalTime!.split(":")[1]) +
        //     (int.parse(element.totalTime!.split(":")[2]) / 60);
        // print("Minute ::: $minuts");
      });
      Logger.println('time slot list length : ${timeSlotList?.length}');
      Logger.println('time list length : ${timeList.length}');
    }
    Logger.println("DateList ::: $dateList");
    Logger.println("TimeList ::: $timeList");
    maxTime = timeList.max();
    Logger.println("MaxTime :::: $maxTime");
    Logger.println('length:::${timeList.length}, $timeList');
    return Stack(
      alignment: Alignment.center,
      children: [
        const Positioned(
          left: 0,
          child: Center(
            child: RotatedBox(
                quarterTurns: -1,
                child: Text(
                  'Hours',
                  style: TextStyle(
                      fontSize: Constant.textSize11, color: Constant.cBlack),
                  textAlign: TextAlign.center,
                )),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: 2,
              right: 2,
              left: rowSegment == 4 ? 15 : 10,
              bottom: rowSegment == 4 ? 15 : 10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final barsSpace = 4.0 * constraints.maxWidth / 400;
              final barsWidth = 8.0 * constraints.maxWidth / 400;
              return BarChart(
                BarChartData(
                  maxY: maxTime! + 120,
                  alignment: BarChartAlignment.start,
                  // barTouchData: BarTouchData(
                  //   touchTooltipData: BarTouchTooltipData(
                  //     direction: TooltipDirection.auto,
                  //     tooltipBgColor: Colors.transparent,
                  //     tooltipBorder:
                  //         const BorderSide(color: Colors.transparent),
                  //     getTooltipItem: (
                  //       BarChartGroupData group,
                  //       int groupIndex,
                  //       BarChartRodData rod,
                  //       int rodIndex,
                  //     ) {
                  //       //BlocProvider.of<TimeBloc>(context).add(const FetchTodayLastTimeSlot());
                  //       timeData = rod.toY;
                  //       double workingTime = 0;
                  //       double breakTime = 0;
                  //       String twoDigits(int n) => n.toString().padLeft(2, '0');
                  //       for (int i = 0; i < rod.rodStackItems.length; i++) {
                  //         if (rod.rodStackItems[i].color == Constant.cRed) {
                  //           breakTime = breakTime +
                  //               (rod.rodStackItems[i].toY -
                  //                   rod.rodStackItems[i].fromY);
                  //         } else {
                  //           workingTime = workingTime +
                  //               (rod.rodStackItems[i].toY -
                  //                   rod.rodStackItems[i].fromY);
                  //         }
                  //       }
                  //       if (rod.toY != 0) {
                  //         BlocProvider.of<UpdateUiBloc>(context)
                  //             .add(const AddOpenDialog(true));
                  //         // showTimeDialog = true;
                  //         timeDetail = {
                  //           "date":
                  //               '${dateList[groupIndex]} ${DateFormatter.formateDate(inputFormatter: 'yyyy-MM-dd', input: DateTime.now().toString(), outputFormatter: 'MMMM')}',
                  //           "work":
                  //               'Work     : ${twoDigits((workingTime / 60).floor())}:${twoDigits(workingTime.remainder(60).round())}',
                  //           "break":
                  //               'Break    : ${twoDigits((breakTime / 60).floor())}:${twoDigits(breakTime.remainder(60).round())}',
                  //           "total":
                  //               'Total     : ${twoDigits(((rod.toY) / 60).floor())}:${twoDigits((rod.toY).remainder(60).round())}'
                  //         };
                  //       }
                  //       return rod.toY == 0
                  //           ? BarTooltipItem(
                  //               '',
                  //               const TextStyle(
                  //                 color: Colors.transparent,
                  //                 fontWeight: FontWeight.w700,
                  //                 fontSize: Constant.textSize10,
                  //               ))
                  //           : BarTooltipItem(
                  //               '${dateList[groupIndex]} ${DateFormatter.formateDate(inputFormatter: 'yyyy-MM-dd', input: DateTime.now().toString(), outputFormatter: 'MMMM')}',
                  //               //'${((rod.toY)/60).floor()}:${((rod.toY)%60).round()} Hours\nOn ${dateList[groupIndex]} ${DateFormatter.formateDate(inputFormatter: 'yyyy-MM-dd', input: DateTime.now().toString(), outputFormatter: 'MMMM')}',
                  //               textAlign: TextAlign.left,
                  //               const TextStyle(
                  //                 color: Constant.cBlack,
                  //                 fontWeight: FontWeight.w900,
                  //                 fontSize: Constant.textSize10,
                  //               ),
                  //               children: [
                  //                   TextSpan(
                  //                     text:
                  //                         '\nWork     : ${twoDigits((workingTime / 60).floor())}:${twoDigits(workingTime.remainder(60).floor())}',
                  //                     style: const TextStyle(
                  //                       color: Constant.cBlack,
                  //                       fontWeight: FontWeight.w700,
                  //                       fontSize: Constant.textSize10,
                  //                     ),
                  //                   ),
                  //                   TextSpan(
                  //                     text:
                  //                         '\nBreak    : ${twoDigits((breakTime / 60).floor())}:${twoDigits(breakTime.remainder(60).floor())}',
                  //                     style: const TextStyle(
                  //                       color: Constant.cBlack,
                  //                       fontWeight: FontWeight.w700,
                  //                       fontSize: Constant.textSize10,
                  //                     ),
                  //                   ),
                  //                   TextSpan(
                  //                     text:
                  //                         '\nTotal     : ${twoDigits(((rod.toY) / 60).floor())}:${twoDigits((rod.toY).remainder(60).floor())}',
                  //                     style: const TextStyle(
                  //                       color: Constant.cBlack,
                  //                       fontWeight: FontWeight.w700,
                  //                       fontSize: Constant.textSize10,
                  //                     ),
                  //                   ),
                  //                 ]);
                  //     },
                  //   ),
                  //   enabled: false,
                  // ),
                  barTouchData: BarTouchData(
                    touchCallback: (FlTouchEvent event, barTouchResponse) {
                      if (event is FlTapUpEvent && barTouchResponse != null) {
                        final rod = barTouchResponse.spot!.touchedRodData;
                        final groupIndex =
                            barTouchResponse.spot!.touchedBarGroupIndex;

                        double workingTime = 0;
                        double breakTime = 0;

                        for (int i = 0; i < rod.rodStackItems.length; i++) {
                          if (rod.rodStackItems[i].color == Constant.cRed) {
                            breakTime += rod.rodStackItems[i].toY -
                                rod.rodStackItems[i].fromY;
                          } else {
                            workingTime += rod.rodStackItems[i].toY -
                                rod.rodStackItems[i].fromY;
                          }
                        }
                        String twoDigits(int n) => n.toString().padLeft(2, '0');

                        if (rod.toY != 0) {
                          BlocProvider.of<UpdateUiBloc>(context)
                              .add(const AddOpenDialog(true));
                          timeDetail = {
                            "date":
                                '${dateList[groupIndex]} ${DateFormatter.formateDate(inputFormatter: 'yyyy-MM-dd', input: DateTime.now().toString(), outputFormatter: 'MMMM')}',
                            "work":
                                'Work     : ${twoDigits((workingTime / 60).floor())}:${twoDigits(workingTime.remainder(60).round())}',
                            "break":
                                'Break    : ${twoDigits((breakTime / 60).floor())}:${twoDigits(breakTime.remainder(60).round())}',
                            "total":
                                'Total     : ${twoDigits(((rod.toY) / 60).floor())}:${twoDigits((rod.toY).remainder(60).round())}'
                          };
                        }
                      }
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        //reservedSize: widget.rowSegment==4?20:widget.rowSegment==2?25:30,//timeList.length.toDouble(),
                        getTitlesWidget: bottomTitles,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        // reservedSize: widget.rowSegment==4?25:widget.rowSegment==2?30:35,
                        interval: 120,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                      show: true,
                      //verticalInterval: 0.6,
                      //checkToShowHorizontalLine: (value) => value % 2 == 0,
                      getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.transparent,
                            //AppColors.borderColor.withOpacity(0.1),
                            strokeWidth: 1,
                          ),
                      horizontalInterval: 120,
                      drawVerticalLine: false,
                      drawHorizontalLine: true
                      // verticalInterval: 20
                      ),
                  borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                          color: Colors.transparent,
                          //AppColors.borderColor.withOpacity(0.1),
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignCenter)),
                  groupsSpace: barsSpace,
                  barGroups: getData(barsWidth, barsSpace, timeSlotList),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 2,
          child: Center(
            child: Text(
              DateFormatter.formateDate(
                  inputFormatter: 'yyyy-MM-dd',
                  input: DateTime.now().toString(),
                  outputFormatter: 'MMMM'),
              style: const TextStyle(
                  fontSize: Constant.textSize11, color: Constant.cBlack),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        // Positioned(
        //   top: 0,
        //   right: 10,
        //   child: SizedBox(
        //     //width: MediaQuery.of(context).size.width*0.8,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.end,
        //       children: [
        //         labelWidget(context, Constant.cGreenLight, "Working Hours",
        //             Assets.images.barIconGreen.svg(width: 15, height: 15)),
        //         SizedBox(width: (MediaQuery.of(context).size.width * 0.003)),
        //         labelWidget(context, Constant.cRedLight, "Break Hours",
        //             Assets.images.barIconRed.svg(width: 15, height: 15)),
        //       ],
        //     ),
        //   ),
        // ),
        // Text('Day Of Month',style: TextStyle(fontSize: 12),),
      ],
    );
  }

  Widget labelWidget(
      BuildContext context, Color color, String text, Widget icon) {
    return Column(
      children: [
        /* text=="Break Hours"?Icon(Icons.bar_chart, color: color)
        :Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: Icon(Icons.bar_chart, color: color),
        ),*/
        icon,
        //SizedBox(height:10),
        Text(text, style: TextStyle(fontSize: Constant.textSize9, color: color))
      ],
    );
  }

  List<BarChartGroupData> getData(
      double barsWidth, double barsSpace, List<TimeSlotData>? barTimeData) {
    List<BarChartGroupData> data = [];
    if (barTimeData != null && barTimeData.isNotEmpty) {
      for (int i = 0; i < barTimeData.length; i++) {
        //double to_y=(timeList[i].minute)/60;
        //Logger.println("minutes::::${timeList[i]}");
        // print('i=$i timeList[i]=${timeList[i]}');
        data.add(BarChartGroupData(
          // showingTooltipIndicators: [0],
          x: i,
          barsSpace: barsSpace,
          barRods: [
            BarChartRodData(
              toY: timeList[i],
              rodStackItems: barTimeData[i].timeSlots!.isNotEmpty
                  ? getBarData(barTimeData[i].timeSlots)
                  : [
                      // //BarChartRodStackItem(0, 1, Colors.red),
                      // BarChartRodStackItem(0, timeList[i], AppColors.colorGreen),
                      //BarChartRodStackItem(0,75, Colors.red),
                      //BarChartRodStackItem(75,100, Colors.green),
                      //  BarChartRodStackItem(100,150, Colors.green),
                    ],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(0), topRight: Radius.circular(0)),
              width: barsWidth,
            ),
          ],
        ));
      }
    }
    return data;
    /* return [
      BarChartGroupData(
        x: 0,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 9,
            rodStackItems: [
              BarChartRodStackItem(0, 1, Colors.red),
              BarChartRodStackItem(1, 5, Colors.green),
              BarChartRodStackItem(5,6, Colors.red),
              BarChartRodStackItem(6, 9, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 11,
            rodStackItems: [
              BarChartRodStackItem(0, 4, Colors.green),
              BarChartRodStackItem(4, 5, Colors.red),
              BarChartRodStackItem(5, 11, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 7,
            rodStackItems: [
              BarChartRodStackItem(0, 3.5, Colors.green),
              BarChartRodStackItem(3.5, 4, Colors.red),
              BarChartRodStackItem(4, 7, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 9,
            rodStackItems: [
              BarChartRodStackItem(0, 4, Colors.green),
              BarChartRodStackItem(4, 5, Colors.red),
              BarChartRodStackItem(5, 9, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 4,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 6,
            rodStackItems: [
              //BarChartRodStackItem(0, 7000000000, widget.dark),
              BarChartRodStackItem(0, 6, Colors.green),
              //BarChartRodStackItem(25000000000, 27000000000, widget.light),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 5,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 9,
            rodStackItems: [
              BarChartRodStackItem(0, 1, Colors.red),
              BarChartRodStackItem(1, 5, Colors.green),
              BarChartRodStackItem(5,6, Colors.red),
              BarChartRodStackItem(6, 9, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 6,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 11,
            rodStackItems: [
              BarChartRodStackItem(0, 4, Colors.green),
              BarChartRodStackItem(4, 5, Colors.red),
              BarChartRodStackItem(5, 11, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 7,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 7,
            rodStackItems: [
              BarChartRodStackItem(0, 3.5, Colors.green),
              BarChartRodStackItem(3.5, 4, Colors.red),
              BarChartRodStackItem(4, 7, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 8,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 9,
            rodStackItems: [
              BarChartRodStackItem(0, 4, Colors.green),
              BarChartRodStackItem(4, 5, Colors.red),
              BarChartRodStackItem(5, 9, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 9,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 6,
            rodStackItems: [
              //BarChartRodStackItem(0, 7000000000, widget.dark),
              BarChartRodStackItem(0, 6, Colors.green),
              //BarChartRodStackItem(25000000000, 27000000000, widget.light),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 10,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 9,
            rodStackItems: [
              BarChartRodStackItem(0, 1, Colors.red),
              BarChartRodStackItem(1, 5, Colors.green),
              BarChartRodStackItem(5,6, Colors.red),
              BarChartRodStackItem(6, 9, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 11,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 11,
            rodStackItems: [
              BarChartRodStackItem(0, 4, Colors.green),
              BarChartRodStackItem(4, 5, Colors.red),
              BarChartRodStackItem(5, 11, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 12,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 7,
            rodStackItems: [
              BarChartRodStackItem(0, 3.5, Colors.green),
              BarChartRodStackItem(3.5, 4, Colors.red),
              BarChartRodStackItem(4, 7, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 13,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 9,
            rodStackItems: [
              BarChartRodStackItem(0, 4, Colors.green),
              BarChartRodStackItem(4, 5, Colors.red),
              BarChartRodStackItem(5, 9, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 14,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 6,
            rodStackItems: [
              //BarChartRodStackItem(0, 7000000000, widget.dark),
              BarChartRodStackItem(0, 6, Colors.green),
              //BarChartRodStackItem(25000000000, 27000000000, widget.light),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 15,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 9,
            rodStackItems: [
              BarChartRodStackItem(0, 1, Colors.red),
              BarChartRodStackItem(1, 5, Colors.green),
              BarChartRodStackItem(5,6, Colors.red),
              BarChartRodStackItem(6, 9, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 16,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 11,
            rodStackItems: [
              BarChartRodStackItem(0, 4, Colors.green),
              BarChartRodStackItem(4, 5, Colors.red),
              BarChartRodStackItem(5, 11, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 17,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 7,
            rodStackItems: [
              BarChartRodStackItem(0, 3.5, Colors.green),
              BarChartRodStackItem(3.5, 4, Colors.red),
              BarChartRodStackItem(4, 7, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 18,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 9,
            rodStackItems: [
              BarChartRodStackItem(0, 4, Colors.green),
              BarChartRodStackItem(4, 5, Colors.red),
              BarChartRodStackItem(5, 9, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 19,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 6,
            rodStackItems: [
              //BarChartRodStackItem(0, 7000000000, widget.dark),
              BarChartRodStackItem(0, 6, Colors.green),
              //BarChartRodStackItem(25000000000, 27000000000, widget.light),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 20,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 9,
            rodStackItems: [
              BarChartRodStackItem(0, 1, Colors.red),
              BarChartRodStackItem(1, 5, Colors.green),
              BarChartRodStackItem(5,6, Colors.red),
              BarChartRodStackItem(6, 9, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 21,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 11,
            rodStackItems: [
              BarChartRodStackItem(0, 4, Colors.green),
              BarChartRodStackItem(4, 5, Colors.red),
              BarChartRodStackItem(5, 11, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 22,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 7,
            rodStackItems: [
              BarChartRodStackItem(0, 3.5, Colors.green),
              BarChartRodStackItem(3.5, 4, Colors.red),
              BarChartRodStackItem(4, 7, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 23,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 9,
            rodStackItems: [
              BarChartRodStackItem(0, 4, Colors.green),
              BarChartRodStackItem(4, 5, Colors.red),
              BarChartRodStackItem(5, 9, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 24,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 6,
            rodStackItems: [
              //BarChartRodStackItem(0, 7000000000, widget.dark),
              BarChartRodStackItem(0, 6, Colors.green),
              //BarChartRodStackItem(25000000000, 27000000000, widget.light),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 25,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 9,
            rodStackItems: [
              BarChartRodStackItem(0, 1, Colors.red),
              BarChartRodStackItem(1, 5, Colors.green),
              BarChartRodStackItem(5,6, Colors.red),
              BarChartRodStackItem(6, 9, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 26,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 11,
            rodStackItems: [
              BarChartRodStackItem(0, 4, Colors.green),
              BarChartRodStackItem(4, 5, Colors.red),
              BarChartRodStackItem(5, 11, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 27,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 7,
            rodStackItems: [
              BarChartRodStackItem(0, 3.5, Colors.green),
              BarChartRodStackItem(3.5, 4, Colors.red),
              BarChartRodStackItem(4, 7, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 28,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 9,
            rodStackItems: [
              BarChartRodStackItem(0, 4, Colors.green),
              BarChartRodStackItem(4, 5, Colors.red),
              BarChartRodStackItem(5, 9, Colors.green),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 29,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 6,
            rodStackItems: [
              //BarChartRodStackItem(0, 7000000000, widget.dark),
              BarChartRodStackItem(0, 6, Colors.green),
              //BarChartRodStackItem(25000000000, 27000000000, widget.light),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            width: barsWidth,
          ),
        ],
      ),
    ];*/
  }

  List<BarChartRodStackItem>? getBarData(List<TimeData>? timeSlots) {
    List<BarChartRodStackItem> barList = [];
    // BarChartRodStackItem(0, timeList[i], AppColors.colorGreen),
    // BarChartRodStackItem(5, 20, Colors.red),
    double min = 0;
    double singleSlotMinute = 0;
    for (int i = 0; i < timeSlots!.length; i++) {
      singleSlotMinute = min +
          (double.parse((timeSlots[i].timeDifference!.split(':')[2])) / 60) +
          double.parse(timeSlots[i].timeDifference!.split(':')[1]) +
          (double.parse(timeSlots[i].timeDifference!.split(':')[0]) * 60);
      // if (singleSlotMinute <= timeList[i]) {
      if (timeSlots[i].actionType == Strings.time_status[2]) {
        barList.add(BarChartRodStackItem(
            min,
            singleSlotMinute,
            /*  timeSlots[i].actionType == 'Inter Out'
                ?*/
            Constant.cRed /*: Colors.green*/));
      } else {
        barList.add(BarChartRodStackItem(
            timeSlots[i].actionType == Strings.time_status[0] ? 0 : min,
            singleSlotMinute,
            /*timeSlots[i].actionType == 'Inter Out'
                ? Colors.red
                :*/
            Constant.cGreenLight));
      }
      min = min +
          (double.parse((timeSlots[i].timeDifference!.split(':')[2])) / 60) +
          double.parse(timeSlots[i].timeDifference!.split(':')[1]) +
          (double.parse(timeSlots[i].timeDifference!.split(':')[0]) * 60);
      //double.parse(timeSlots[i].timeDifference!.split(':')[1])+double.parse(timeSlots[i].timeDifference!.split(':')[0]);}
      //}
    }
    /*setState(() {

  });*/
    return barList;
  }
}

/*class ChartSampleData{
  ChartSampleData(
        this.x,
        this.y,
        this.yValue,
        this.secondSeriesYValue,
        this.thirdSeriesYValue,
      );
  final String x;
  final double y;
  final double yValue;
  final int secondSeriesYValue;
  final int thirdSeriesYValue;
}*/

/*
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../constant/constant.dart';
import '../constant/strings.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({Key? key}) : super(key: key);

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [
      _ChartData('1', 7),
      _ChartData('2', 0),
      _ChartData('3', 0),
      _ChartData('4',0),
      _ChartData('5', 0),
      _ChartData('6', 0),
      _ChartData('7', 0),
      _ChartData('8', 9),
      _ChartData('9', 0),
      _ChartData('10', 0),
      _ChartData('11', 0),
      _ChartData('12', 7),
      _ChartData('13', 0),
      _ChartData('14', 6.4),
      _ChartData('15', 0),
      _ChartData('16', 9),
      _ChartData('17', 7),
      _ChartData('18', 9),
      _ChartData('19', 0),
      _ChartData('20', 0),
      _ChartData('21', 0),
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(Constant.paddingHalf),
        child: Container(
          color: Constant.cWhite,
          child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                  labelStyle:Constant.textStyleSize10(context)?.copyWith(
                      color: Constant.cGrayDark),
                  title: AxisTitle(text: Strings.xAxisChartTitle,
                      textStyle: Constant.textStyleSize10(context)?.copyWith(
                          color: Constant.cBlueDark))
              ),
              primaryYAxis: NumericAxis(minimum: 0, maximum: 10, interval: 2,
                  labelStyle:Constant.textStyleSize10(context)?.copyWith(
                      color: Constant.cGrayDark),
                  title: AxisTitle(text: Strings.yAxisChartTitle,
                      textStyle: Constant.textStyleSize10(context)?.copyWith(
                          color: Constant.cBlueDark))),

              tooltipBehavior: _tooltip,
              series: <ChartSeries<_ChartData, String>>[
                ColumnSeries<_ChartData, String>(
                  dataSource: data,
                  xValueMapper: (_ChartData data, _) => data.x,
                  yValueMapper: (_ChartData data, _) => data.y,
                  name: 'Gold',
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Constant.cRed,
                        Constant.cOrangeDark
                      ]
                  ),
                )
              ]),
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}*/
