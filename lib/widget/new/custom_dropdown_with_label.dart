import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constant/constant.dart';
import '../custom_form_label.dart';
import 'custom_dropdown.dart';

class LabelWithDropDownButton extends StatefulWidget {
  LabelWithDropDownButton(
      {this.labelText,
      required this.hintText,
      this.isRequired = false,
      required this.onChanged,
      this.selectedValue,
      this.validatorText,
      required this.list,
      this.width,
      this.isNospace = false,
      Key? key})
      : super(key: key);
  String? labelText;
  String hintText;
  bool isRequired;
  Function(dynamic) onChanged;
  String? validatorText;
  String? selectedValue;
  List<String> list;
  double? width;
  bool isNospace;

  @override
  State<LabelWithDropDownButton> createState() =>
      _LabelWithDropDownButtonState();
}

class _LabelWithDropDownButtonState extends State<LabelWithDropDownButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Constant.paddingMidHalf),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.isNospace
              ? const SizedBox.shrink()
              : SizedBox(
                  width: widget.width ?? 175,
                  child: CustomFormLabel(
                    label: widget.labelText,
                    style: Constant.textStyleSize13(context)
                        ?.copyWith(color: Constant.cBlack),
                    isRequired: widget.isRequired,
                    requiredStyle: Constant.textStyleSize14(context)
                        ?.copyWith(color: Constant.cRed),
                  ),
                ),
          Constant.paddingHalf.widthBox,
          Expanded(
            child: CustomDropDown(
              height: 48,
              list: widget.list,
              hintText: widget.hintText,
              selectedValue: widget.selectedValue,
              onChange: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
