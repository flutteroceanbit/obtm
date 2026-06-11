import 'dart:io';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../constant/constant.dart';
import '../constant/strings.dart';
import 'custom_button.dart';
import 'custom_form_field.dart';

class CustomDialog extends StatefulWidget {
  CustomDialog({
    Key? key,
    // this.dialogTitle,
    this.onTapTextField,
    this.onTapButton,
    // this.dialogSubTitle,
    this.hintText,
    this.onChanged,
    this.maxLine = 1,
    this.isCancel = false,
    this.validationString,
    required this.controller,
    this.focusNode,
  }) : super(key: key);
  // String? dialogTitle;
  // String? dialogSubTitle;
  final String? validationString;
  final String? hintText;
  int maxLine = 1;
  bool isCancel = false;
  final Function()? onTapTextField;
  final Function()? onTapButton;
  final Function(String)? onChanged;
  TextEditingController controller = TextEditingController();
  final FocusNode? focusNode;

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black45.withOpacity(0.5),
      child: Center(
        child: Padding(
            padding: EdgeInsets.all((Platform.isMacOS || Platform.isWindows)
                ? Constant.paddingDouble
                : Constant.padding),
            child: Wrap(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(Constant.paddingHalf)),
                  width: (Platform.isMacOS || Platform.isWindows)
                      ? MediaQuery.of(context).size.width / 2
                      : MediaQuery.of(context).size.width / 1.4,
                  // height: (Platform.isMacOS || Platform.isWindows)
                  //     ? MediaQuery.of(context).size.height / 2.5
                  //     : MediaQuery.of(context).size.height / 2.8,
                  child: Padding(
                    padding: const EdgeInsets.all(Constant.padding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // RichText(
                        //   textAlign: TextAlign.start,
                        //   softWrap: true,
                        //   overflow: TextOverflow.fade,
                        //   text: TextSpan(
                        //       text: widget.dialogTitle,
                        //       style: (Platform.isMacOS || Platform.isWindows)?Theme.of(context)
                        //           .textTheme
                        //           .titleMedium!
                        //           .copyWith(fontWeight: FontWeight.w600,color: Constant.cBlack):Theme.of(context)
                        //           .textTheme
                        //           .titleSmall!
                        //           .copyWith(fontWeight: FontWeight.bold,color: Constant.cBlack),
                        //       children: [
                        //         TextSpan(
                        //             text: "\t\t${widget.dialogSubTitle}",
                        //             style:(Platform.isMacOS || Platform.isWindows)?Theme.of(context).textTheme.titleMedium!.copyWith(color: Constant.cBlack):
                        //             Theme.of(context).textTheme.titleSmall!.copyWith(color: Constant.cBlack)),
                        //       ]),
                        // ),

                        (Platform.isMacOS || Platform.isWindows)
                            ? Constant.paddingMidHalf.heightBox
                            : Constant.paddingMidDoubleHalf.heightBox,
                        CustomFormField(
                          maxLine: widget.maxLine,
                          autoFocus: true,
                          isSuffix: false,
                          hintText: widget.hintText,
                          // focus: widget.focusNode,
                          type: TextInputType.text,
                          controller: widget.controller,
                          onTap: widget.onTapTextField,
                          onChanged: widget.onChanged,
                          validator: widget.validationString,
                        ),
                        (Platform.isMacOS || Platform.isWindows)
                            ? Constant.padding.heightBox
                            : Constant.paddingMidDouble.heightBox,
                        widget.isCancel
                            ? Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: CustomButton(
                                        color: Constant.cLightGray,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: Constant.cWhite),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        text: Strings.cancel,
                                      ).hPCT(context: context, heightPCT: 5),
                                    ),
                                    Constant.padding.widthBox,
                                    Expanded(
                                      child: CustomButton(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: Constant.cWhite),
                                        onTap: widget.onTapButton,
                                        text: Strings.submit,
                                      ).hPCT(context: context, heightPCT: 5),
                                    ),
                                  ],
                                ),
                              )
                            : Center(
                                child: CustomButton(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Constant.cWhite),
                                  onTap: widget.onTapButton,
                                  text: Strings.submit,
                                ).hPCT(context: context, heightPCT: 5),
                              )
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
