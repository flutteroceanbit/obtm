import 'package:flutter/material.dart';
import 'package:oceanbit_timeclock/constant/constant.dart';

class CustomCardView extends StatelessWidget {
  const CustomCardView(
      {Key? key,
      this.backgroundColor = Colors.white,
      this.boxShadow,
      this.borderRadius = Constant.paddingHalf,
      required this.child,
      this.height,
      this.width})
      : super(key: key);
  final Color backgroundColor;
  final List<BoxShadow>? boxShadow;
  final double borderRadius;
  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                  color: Constant.cBlack.withOpacity(0.25),
                  offset: const Offset(0, 0),
                  blurRadius: 6,
                  spreadRadius: 0),
            ],
      ),
      child: child,
    );
  }
}
