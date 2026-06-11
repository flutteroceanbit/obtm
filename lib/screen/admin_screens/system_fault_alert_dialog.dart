import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/widget/custom_button.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../constant/constant.dart';
import '../../../../constant/strings.dart';
import '../../bloc_logic/systemfaults_bloc/systemfaults_bloc.dart';
import '../../bloc_logic/systemfaults_bloc/systemfaults_event.dart';
import '../../models/get_admin_system_fault_model.dart';
import '../../utils/logger.dart';

class SystemFaultAlertDialogue extends StatelessWidget {
  const SystemFaultAlertDialogue(
      {Key? key, required this.isSolved, required this.fault})
      : super(key: key);
  final bool isSolved;
  final AdminSystemFaultData fault;

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
                  isSolved
                      ? Strings.conformFaultSolved
                      : Strings.conformFaultInProgress,
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
                      text: isSolved ? Strings.solved : Strings.inProgress,
                      textStyle: Constant.textStyleSize14(context)?.copyWith(
                        color: Constant.cWhite,
                      ),
                      color: Constant.cGreenLight,
                      onTap: () {
                        Logger.println('allFaults[index] ${fault.id}');
                        isSolved
                            ? BlocProvider.of<SystemFaultBloc>(context).add(
                                UpdateAdminSystemFaultEvent(fault.id, "2",
                                    context: context))
                            : BlocProvider.of<SystemFaultBloc>(context).add(
                                UpdateAdminSystemFaultEvent(fault.id, "1",
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
