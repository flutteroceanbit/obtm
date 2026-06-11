import 'package:flutter/material.dart';
import '../../../constant/constant.dart';
import '../../../constant/strings.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/new/custom_header_container.dart';
import 'apply_systemfaults.dart';
import 'my_SystemFaults.dart';

class SystemFaultsScreen extends StatefulWidget {
  const SystemFaultsScreen({Key? key, this.sizeTag}) : super(key: key);
  final int? sizeTag;

  @override
  State<SystemFaultsScreen> createState() => _SystemFaultsScreenState();
}

List<String> systemList = [Strings.myLeave, Strings.applyLeave];

class _SystemFaultsScreenState extends State<SystemFaultsScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomHeaderContainer(
      headerText: Strings.systemFaults,
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
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  color: Constant.cWhite,
                                  child: MySystemFaults(
                                    sizeTag: widget.sizeTag,
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
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
                                        return ApplySystemFaults(
                                          sizeTag: widget.sizeTag,
                                          context: context,
                                        );
                                      },
                                    );
                                  },
                                  width: 130,
                                  height: 40,
                                  text: systemList[1],
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
