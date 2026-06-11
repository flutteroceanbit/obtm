import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../constant/constant.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({
    Key? key,
    required this.list,
    this.selectedValue,
    this.borderRadius,
    required this.onChange,
    this.backGroundColor = Colors.transparent,
    this.boxShadow,
    this.selectedTextColor = Constant.cGrayDark,
    this.height,
    this.horizontalPadding,
    required this.hintText,
    this.width,
    this.verticalPadding,
  }) : super(key: key);
  final List<String> list;
  final String? selectedValue;
  final double? borderRadius;
  final Function(dynamic) onChange;
  final Color backGroundColor;
  final Color? selectedTextColor;
  final double? height;
  final double? width;
  final String hintText;
  final double? verticalPadding;
  final double? horizontalPadding;
  final List<BoxShadow>? boxShadow;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        height: widget.height ?? 35,
        width: widget.width,
        decoration: BoxDecoration(
          color:
              widget.backGroundColor /*?? ColorName.colorContainerShadowBlue2*/,
          // color: ColorName.colorBlue,
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? Constant.paddingHalf,
          ),
          boxShadow: widget.boxShadow ?? [],
          border: Border.all(color: Constant.cBlack),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            hint: Text(
              widget.hintText,
              style: Constant.textStyleSize13(
                context,
              )?.copyWith(color: Constant.cGrayDark),
            ),
            iconStyleData: IconStyleData(
              icon: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  isMenuOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: widget.selectedTextColor,
                ),
              ),
            ),
            items: widget.list
                .map(
                  (item) => DropdownItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: Constant.textStyleSize13(
                        context,
                      )?.copyWith(color: Constant.cGrayDark),
                    ),
                  ),
                )
                .toList(),
            onMenuStateChange: (val) {
              setState(() {
                isMenuOpen = val;
              });
            },
            dropdownStyleData: DropdownStyleData(offset: const Offset(0, -5)),
            valueListenable: ValueNotifier(widget.selectedValue),
            onChanged: widget.onChange,
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(
                color: Constant.cWhite,
                border: Border.all(color: Constant.colorSelectedIndicator),
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? Constant.paddingHalf,
                ),
              ),
            ),

            // dropdownDecoration: BoxDecoration(
            //   color: Constant.cWhite,
            //   border: Border.all(color: Constant.colorSelectedIndicator),
            //   borderRadius: BorderRadius.circular(
            //     widget.borderRadius ?? Constant.paddingHalf,
            //   ),
            // ),
          ),
        ),
      ),
    );
  }
}
