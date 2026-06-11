import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/update_ui_bloc/update_ui_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/update_ui_bloc/update_ui_event.dart';
import 'package:velocity_x/velocity_x.dart';

import '../constant/constant.dart';

class TodayTimeSlotsDialog extends StatefulWidget {
  const TodayTimeSlotsDialog(this.timeData, {Key? key, this.sizeTag})
      : super(key: key);
  final int? sizeTag;
  final Map<String, dynamic> timeData;

  @override
  State<TodayTimeSlotsDialog> createState() => _TodayTimeSlotsDialogState();
}

class _TodayTimeSlotsDialogState extends State<TodayTimeSlotsDialog> {
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
                        widget.timeData["date"],
                        style: Constant.textStyleSize14(context)
                            ?.copyWith(color: Constant.cWhite),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          //Navigator.pop(context);
                          BlocProvider.of<UpdateUiBloc>(context)
                              .add(const AddOpenDialog(false));
                          // setState(() {
                          //   showTimeDialog = false;
                          // });
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.timeData["work"],
                        style: Constant.textStyleSize14(context)
                            ?.copyWith(color: Constant.cBlack),
                      ),
                      Text(
                        widget.timeData["break"],
                        style: Constant.textStyleSize14(context)
                            ?.copyWith(color: Constant.cBlack),
                      ),
                      Text(
                        widget.timeData["total"],
                        style: Constant.textStyleSize14(context)
                            ?.copyWith(color: Constant.cBlack),
                      ),
                      Constant.paddingMidDouble.heightBox,
                      /* Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButton(
                            color: Constant.colorSelectedIndicator,
                            textStyle: Constant.textStyleSize10(context)!
                                .copyWith(color: Constant.cWhite),
                            height: 40,
                            width: 130,
                            text: Strings.apply,
                            onTap: () {
                              if (selectedLeave
                                  .contains(Strings.leaveTypeHint)) {
                                setState(() {
                                  isLeaveTypeError = true;
                                });
                              } else if (selectedLeave
                                  .contains('Earned Leave(EL)') ||
                                  selectedLeave
                                      .contains('Casual Leave(CL)') ||
                                  selectedLeave.contains('Sick Leave(SL)') ||
                                  selectedLeave.contains('Paid Leave(PL)')) {
                                setState(() {
                                  isLeaveTypeError = false;
                                });
                              }
                              if (selectedHalfLeave
                                  .contains(Strings.halfLeaveHint)) {
                                setState(() {
                                  isHalfLeaveError = true;
                                });
                              } else if (selectedHalfLeave
                                  .contains('First Half Leave') ||
                                  selectedHalfLeave
                                      .contains('Second Half Leave')) {
                                setState(() {
                                  isHalfLeaveError = false;
                                });
                              }
                              if (_formKey.currentState!.validate()) {
                              } else {
                                _autoValidate = true;
                              }
                            },
                          ),
                        ],
                      ),*/
                    ],
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
