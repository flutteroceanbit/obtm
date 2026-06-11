import 'package:flutter/material.dart';
import 'package:oceanbit_timeclock/constant/constant.dart';

class CustomCardWithCornerBubble extends StatelessWidget {
  const CustomCardWithCornerBubble(
      {Key? key,
      this.backgroundColor = Colors.white,
      this.boxShadow,
      required this.color,
      this.borderRadius = Constant.paddingHalf,
      required this.child})
      : super(key: key);
  final Color backgroundColor;
  final List<BoxShadow>? boxShadow;
  final double borderRadius;
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        RotationTransition(
          turns: const AlwaysStoppedAnimation(45 / 360),
          child: Column(
            children: [
              Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1), shape: BoxShape.circle),
              ),
              Transform.translate(
                offset: const Offset(100, 200),
                child: Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.1), shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ),
        Container(
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
        ),
      ],
    );
  }
}
