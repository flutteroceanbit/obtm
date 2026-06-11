import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {Key? key,
      this.text,
      this.onTap,
      this.textStyle,
      this.width,
      this.height = 50,
      this.border,
      this.padding = const EdgeInsets.all(0),
      this.color,
      this.focus,
      this.radius = 5,
      this.icon,
      this.isIcon = false,
      this.borderRadius,
      this.mainAxisAlignment,
      this.iconColor = Colors.black})
      : super(key: key);
  final String? text;
  final Function()? onTap;
  final TextStyle? textStyle;
  FocusNode? focus;
  final double? width;
  final Color? color;
  final Color? iconColor;
  final double height;
  double radius;
  BorderRadiusGeometry? borderRadius;
  BoxBorder? border = Border.all();
  EdgeInsetsGeometry? padding;
  final IconData? icon;
  final bool isIcon;
  MainAxisAlignment? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: width ?? double.infinity,
      child: ElevatedButton(
        focusNode: focus,
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.black,
          textStyle: textStyle,
          fixedSize:
              width == null ? Size.fromHeight(height) : Size(width!, height),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(radius),
          ),
        ),
        child: isIcon == true
            ? Center(
                child: Row(
                  mainAxisAlignment:
                      mainAxisAlignment ?? MainAxisAlignment.center,
                  children: [
                    Text(
                      text!,
                      style: textStyle,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                    SizedBox(width: 5.w),
                    Icon(
                      icon,
                      size: 16.h.w,
                      color: iconColor,
                    ),
                  ],
                ),
              )
            : Text(
                text!,
                style: textStyle,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
      ),
    );
  }
}
