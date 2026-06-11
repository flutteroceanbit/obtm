import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/constant.dart';

class CustomContainerButton extends StatefulWidget {
  const CustomContainerButton(
      {Key? key,
      required this.text,
      required this.color,
      this.width,
      this.height,
      this.textStyle,
      this.onTap})
      : super(key: key);
  final String text;
  final double? height;
  final double? width;
  final Color color;
  final TextStyle? textStyle;
  final void Function()? onTap;

  @override
  State<CustomContainerButton> createState() => _CustomContainerButtonState();
}

class _CustomContainerButtonState extends State<CustomContainerButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? () {},
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(Constant.paddingHalfHalf)),
        height: widget.height ?? 20.h,
        width: widget.width ?? 50.w,
        child: Text(
          widget.text,
          style: widget.textStyle ??
              Constant.textStyleSize13(context)!.copyWith(
                color: Constant.cWhite,
              ),
        ),
      ),
    );
  }
}
