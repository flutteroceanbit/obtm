import 'package:flutter/material.dart';

class CustomFormLabel extends StatelessWidget {
  const CustomFormLabel(
      {Key? key,
      this.label,
      this.isRequired = false,
      this.style,
      this.textAlign = TextAlign.start,
      this.requiredStyle})
      : super(key: key);
  final String? label;
  final bool isRequired;
  final TextStyle? style;
  final TextStyle? requiredStyle;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(
        label!,
        style: style,
        textAlign: textAlign,
        overflow: TextOverflow.fade,
        softWrap: true,
        maxLines: 2,
      ),
      isRequired
          ? Text(
              "*",
              style: requiredStyle,
            )
          : const SizedBox.shrink()
    ]);
  }
}
