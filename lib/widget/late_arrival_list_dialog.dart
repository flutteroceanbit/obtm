import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constant/constant.dart';
import '../constant/strings.dart';
import '../screen/dashboard/dashboard.dart';

class LateArrivalDialog extends StatefulWidget {
  const LateArrivalDialog(this.list, {Key? key, this.sizeTag})
      : super(key: key);
  final int? sizeTag;
  final List<LateArrivalDetail> list;

  @override
  State<LateArrivalDialog> createState() => _LateArrivalDialogState();
}

class _LateArrivalDialogState extends State<LateArrivalDialog> {
  @override
  Widget build(BuildContext context) {
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
                      topLeft: Radius.circular(Constant.paddingHalf)),
                  color: Constant.colorSelectedIndicator,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Constant.paddingHalf),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.list_alt_sharp, color: Constant.cWhite),
                      Constant.paddingHalfHalf.widthBox,
                      Text(
                        Strings.lateArrivalTimeList,
                        style: Constant.textStyleSize14(context)
                            ?.copyWith(color: Constant.cWhite),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close,
                          color: Constant.cWhite,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(Constant.paddingHalf),
                      bottomRight: Radius.circular(Constant.paddingHalf)),
                  color: Constant.cWhite,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Constant.paddingMidHalf),
                  child: Expanded(
                    flex: 1,
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
                                0: FlexColumnWidth(2),
                                1: FlexColumnWidth(3),
                                2: FlexColumnWidth(3),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          Strings.date,
                                          style:
                                              Constant.textStyleSize14(context)
                                                  ?.copyWith(
                                            color: Constant.cBlack,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Your ${Strings.time_status[0]} ${Strings.time}',
                                          style:
                                              Constant.textStyleSize14(context)
                                                  ?.copyWith(
                                            color: Constant.cBlack,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          Strings.lateArrivalCount,
                                          style:
                                              Constant.textStyleSize14(context)
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
                        ),
                        ListView.separated(
                            shrinkWrap: true,
                            itemCount: widget.list.length,
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
                                        0: FlexColumnWidth(2),
                                        1: FlexColumnWidth(3),
                                        2: FlexColumnWidth(3),
                                      },
                                      children: [
                                        TableRow(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  widget.list[index]
                                                      .initialTimeSlot.date!,
                                                  style:
                                                      Constant.textStyleSize13(
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
                                                  widget.list[index]
                                                      .initialTimeSlot.time!,
                                                  style:
                                                      Constant.textStyleSize13(
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
                                                  widget.list[index]
                                                      .lateArrivalTime,
                                                  style:
                                                      Constant.textStyleSize13(
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
                                  index == widget.list.lastIndex
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
