import 'dart:core';
import 'package:flutter/cupertino.dart';
import '../constant/constant.dart';
import 'custom_form_label.dart';
import 'custom_text_field.dart';

class LabelWithTextField extends StatefulWidget {
  const LabelWithTextField(
      {Key? key,
      this.validatorFunction,
      this.isEnable = true,
      this.labelText,
      this.onTap,
      this.controller,
      this.hintText,
      this.isRequired = false,
      this.keyboardType,
      this.validatorString,
      this.maxLines = 1,
      this.suffixIcon,
      this.width,
      this.widgetWidth,
      this.onChanged})
      : super(key: key);
  final String? Function(String?)? validatorFunction;
  final bool isEnable;
  final String? labelText;
  final TextEditingController? controller;
  final String? hintText;
  final bool isRequired;
  final dynamic Function()? onTap;
  final dynamic Function(String)? onChanged;
  final TextInputType? keyboardType;
  final String? validatorString;
  final int maxLines;
  final Widget? suffixIcon;
  final double? width;
  final double? widgetWidth;

  @override
  State<LabelWithTextField> createState() => _LabelWithTextFieldState();
}

class _LabelWithTextFieldState extends State<LabelWithTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Constant.paddingMidHalf),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            // width: widget.labelText==Strings.rule?MediaQuery.of(context).size.width / 8:MediaQuery.of(context).size.width / 6,
            width: widget.widgetWidth ?? 185,
            child: CustomFormLabel(
              label: widget.labelText,
              style: Constant.textStyleSize13(context)
                  ?.copyWith(color: Constant.cBlack),
              isRequired: widget.isRequired,
              requiredStyle: Constant.textStyleSize14(context)
                  ?.copyWith(color: Constant.cRed),
            ),
          ),
          // (MediaQuery.of(context).size.width/15).widthBox,
          //Spacer(),
          Expanded(
            child: CustomTextField(
              validatorFunction: widget.validatorFunction ??
                  (val) {
                    if (val!.isEmpty) {
                      return widget.validatorString;
                    }
                    return null;
                  },
              width: widget.width,
              suffixIcon: widget.suffixIcon,
              controller: widget.controller,
              hintText: widget.hintText,
              onTap: widget.onTap,
              onChanged: widget.onChanged,
              type: widget.keyboardType,
              isEnable: widget.isEnable,
              maxLines: widget.maxLines,
            ),
          )
        ],
      ),
    );
  }
}
