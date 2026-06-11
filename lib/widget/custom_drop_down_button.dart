import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../constant/constant.dart';

class CustomDropDownButton extends StatefulWidget {
  CustomDropDownButton({
    Key? key,
    required this.hintText,
    this.hintStyle,
    required this.items,
    this.itemTextStyle,
    this.selectedValue,
    this.height = 40,
    required this.onChanged,
  }) : super(key: key);
  String hintText;
  String? selectedValue;
  TextStyle? hintStyle;
  TextStyle? itemTextStyle;
  double height;
  List<dynamic> items = [];

  Function(dynamic) onChanged;

  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  // dynamic selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Constant.paddingHalf),
      height: widget.height,
      /*fromLTRB(
        Constant.paddingHalf,
        Constant.paddingHalfHalf,
        Constant.paddingHalf,
        Constant.paddingHalfHalf,
      ),*/
      decoration: BoxDecoration(
        color: Constant.cWhite,
        borderRadius: BorderRadius.circular(Constant.paddingHalf),
        border: Border.all(color: Constant.cBlack),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          iconStyleData: IconStyleData(
            icon: const Icon(Icons.arrow_drop_down, color: Constant.cGrayDark),
          ),

          hint: Text(
            widget.hintText,
            style: Constant.textStyleSize13(
              context,
            )?.copyWith(color: Constant.cFontLight),
          ),
          items: widget.items
              .map(
                (item) => DropdownItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style:
                        widget.itemTextStyle ??
                        Constant.textStyleSize13(
                          context,
                        )?.copyWith(color: Constant.cGrayDark),
                  ),
                ),
              )
              .toList(),
          valueListenable: ValueNotifier(widget.selectedValue),
          onChanged: widget.onChanged,
          buttonStyleData: ButtonStyleData(
            width: 140,
            decoration: BoxDecoration(
              color: Constant.cWhite,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 12,
          ),
          // buttonWidth: 140,
          // itemHeight: 40,
          // dropdownDecoration: const BoxDecoration(color: Constant.cWhite),
          // dropdownElevation: 12,
        ),
      ),
    );
  }
}
