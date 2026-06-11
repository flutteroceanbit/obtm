import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/reset_password_bloc/reset_password_bloc.dart';
import 'package:oceanbit_timeclock/widget/custom_button.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../bloc_logic/reset_password_bloc/reset_password_event.dart';
import '../../../../bloc_logic/reset_password_bloc/reset_password_state.dart';
import '../../../../constant/constant.dart';
import '../../../../constant/strings.dart';
import '../../../dashboard/dashboard.dart';

class ResetPasswordAlertDialogue extends StatelessWidget {
  final int id;

  const ResetPasswordAlertDialogue({Key? key, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Wrap(
        children: [
          BlocListener<ResetPasswordBloc, ResetPasswordState>(
            listener: (context, state) {
              if (state is ResetPasswordError) {
                msgList.add(Constant().ShowErrorMessage(state.errors, context));
                Constant.myLoader.hide();
                //Constant().ShowErrorToast(state.error, context);
              } else if (state is ResetPasswordLoaded) {
                Navigator.pop(context);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Constant.paddingHalf),
                color: Constant.cWhite,
              ),
              padding: const EdgeInsets.all(Constant.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    Strings.resetPasswordAlertText,
                    style: Constant.textStyleSize15(context)
                        ?.copyWith(color: Constant.cBlack),
                  ),
                  Constant.padding.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomButton(
                        width: 80,
                        height: 30,
                        text: Strings.yes,
                        textStyle: Constant.textStyleSize14(context)?.copyWith(
                          color: Constant.cWhite,
                        ),
                        color: Constant.colorSelectedIndicator,
                        onTap: () {
                          BlocProvider.of<ResetPasswordBloc>(context)
                              .add(ResetEvent(id, context: context));
                        },
                      ),
                      Constant.padding.widthBox,
                      CustomButton(
                        width: 70,
                        height: 30,
                        text: Strings.no,
                        textStyle: Constant.textStyleSize14(context)?.copyWith(
                          color: Constant.cWhite,
                        ),
                        color: Constant.colorSelectedIndicator,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
