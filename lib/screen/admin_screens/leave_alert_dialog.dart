import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/widget/custom_button.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../constant/constant.dart';
import '../../../../constant/strings.dart';
import '../../bloc_logic/leave_bloc/leave_bloc.dart';
import '../../bloc_logic/leave_bloc/leave_event.dart';
import '../../models/leave_model.dart';

class LeaveAlertDialogue extends StatelessWidget {
  const LeaveAlertDialogue(
      {Key? key, required this.isAccept, required this.leave})
      : super(key: key);
  final bool isAccept;
  final LeaveData leave;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Wrap(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constant.paddingHalf),
              color: Constant.cWhite,
            ),
            padding: const EdgeInsets.all(Constant.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  isAccept ? Strings.conformAccept : Strings.conformReject,
                  style: Constant.textStyleSize15(context)
                      ?.copyWith(color: Constant.cBlack),
                ),
                Constant.padding.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      width: 200,
                      height: 30,
                      text: isAccept ? Strings.accept : Strings.reject,
                      textStyle: Constant.textStyleSize14(context)?.copyWith(
                        color: Constant.cWhite,
                      ),
                      color: Constant.cGreenLight,
                      onTap: () {
                        isAccept
                            ? BlocProvider.of<LeaveBloc>(context).add(
                                UpdateLeaveEvent(leave.userId, leave.id, 1,
                                    context: context))
                            : BlocProvider.of<LeaveBloc>(context).add(
                                UpdateLeaveEvent(leave.userId, leave.id, 0,
                                    context: context));
                      },
                    ),
                    Constant.padding.widthBox,
                    CustomButton(
                      width: 200,
                      height: 30,
                      text: Strings.cancel,
                      textStyle: Constant.textStyleSize14(context)?.copyWith(
                        color: Constant.cWhite,
                      ),
                      color: Constant.cRed,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      );
    });
  }
}
