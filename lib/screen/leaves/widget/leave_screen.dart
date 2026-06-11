import 'package:flutter/material.dart';
import 'package:oceanbit_timeclock/bloc_logic/leave_bloc/leave_repositories.dart';
import 'package:oceanbit_timeclock/screen/leaves/widget/apply_leave.dart';
import 'package:oceanbit_timeclock/screen/leaves/widget/my_leaves.dart';
import '../../../constant/constant.dart';
import '../../../constant/strings.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/new/custom_header_container.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({
    Key? key,
    this.sizeTag,
  }) : super(key: key);
  final int? sizeTag;

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

List<String> leaveList = [Strings.myLeave, Strings.applyLeave];

class _LeaveScreenState extends State<LeaveScreen> {
  int selectedLeaveType = 0;

  @override
  Widget build(BuildContext context) {
    return CustomHeaderContainer(
      headerText: Strings.leave,
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.transparent,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              MyLeave(
                                sizeTag: widget.sizeTag!,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomButton(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ApplyLeave(
                                          sizeTag: widget.sizeTag,
                                          context: context,
                                        );
                                      },
                                    );
                                  },
                                  width: 130,
                                  height: 40,
                                  text: leaveList[1],
                                  textStyle: Constant.textStyleSize14(context)
                                      ?.copyWith(
                                    color: Constant.cWhite,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  color: Constant.colorSelectedIndicator,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
