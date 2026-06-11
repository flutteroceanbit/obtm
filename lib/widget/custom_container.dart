import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/constant.dart';
import 'dart:math' as math;

class CustomContainer extends StatelessWidget {
  const CustomContainer(
      {Key? key,
      this.rowSegment = 0,
      this.height,
      this.width,
      required this.headerText,
      this.headerTextColor,
      required this.color,
      required this.child,
      this.isNoHeader = false,
      this.boxShadow,
      this.isHeaderInStart = false})
      : super(key: key);
  final double? height;
  final double? width;
  final String headerText;
  final bool isHeaderInStart;
  final Color? headerTextColor;
  final Color color;
  final Widget child;
  final bool isNoHeader;
  final List<BoxShadow>? boxShadow;
  final int rowSegment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Constant.cDashboardCardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: boxShadow ??
              [
                const BoxShadow(
                    spreadRadius: 0,
                    blurRadius: 4,
                    color: Constant.colorSelectedIndicatorShadow,
                    offset: Offset(4, 4)),
                const BoxShadow(
                    spreadRadius: 0,
                    blurRadius: 4,
                    color: Constant.cWhite,
                    offset: Offset(-4, -4))
              ]),
      height: height ?? /* MediaQuery.of(context).size.height/3.45*/ 196.5.h,
      width: width ?? /*MediaQuery.of(context).size.width/4.90*/ 73.3.w,
      // color: color,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Positioned(
                bottom: height != null
                    ? -(MediaQuery.of(context).size.height / 14)
                    : -(MediaQuery.of(context).size.height / 22),
                child: MyArc(
                  diameter: height != null
                      ? MediaQuery.of(context).size.height / 8
                      : MediaQuery.of(context).size.height / 12,
                  color: color,
                )),
            Positioned(
              right: height != null
                  ? -(MediaQuery.of(context).size.height / 16)
                  : -(MediaQuery.of(context).size.height / 24),
              bottom: height != null ? -20 : -10,
              child: RotationTransition(
                  turns: const AlwaysStoppedAnimation(270 / 360),
                  child: MyArc(
                    diameter: height != null
                        ? MediaQuery.of(context).size.height / 8
                        : MediaQuery.of(context).size.height / 12,
                    color: color,
                  )),
            ),
            /* Positioned(bottom:-(MediaQuery.of(context).size.height / 3.5)*0.9*/ /* -210*/ /*,
              right:-(MediaQuery.of(context).size.height / 3.5)*/ /*-210*/ /*,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                ),
                child: RotationTransition(
                  turns: new AlwaysStoppedAnimation(175 / 360),
                  child: Row(mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                    */ /*  Transform.translate(
                        offset: Offset((MediaQuery.of(context).size.height / 3.5),(MediaQuery.of(context).size.height / 3.5)*/ /**/ /*200, 160*/ /**/ /*),
                        child: Container(
                          height: (MediaQuery.of(context).size.height / 3.5)/2.5,
                          width: (MediaQuery.of(context).size.height / 3.5/2.5),
                          decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              shape: BoxShape.circle
                          ),),
                      ),*/ /*
                      Transform.translate(
                        offset: Offset(
                            (MediaQuery.of(context).size.height / 3.5),((MediaQuery.of(context).size.height / 3.5))
                          */ /*20,200*/ /*
                        ),
                        child: Container(
                          height:( MediaQuery.of(context).size.height / 3.5)/2.5,
                          width: (MediaQuery.of(context).size.height / 3.5)/2.5, decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            shape: BoxShape.circle
                        ),),
                      ),
                    ],
                  ),
                ),
              ),
            ),*/
            Column(
              children: [
                /*!isNoHeader ? */ Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.transparent,
                  ),
                  //height:50,
                  /*      width: width ?? MediaQuery
                      .of(context)
                      .size
                      .width,*/
                  padding: EdgeInsets.all(rowSegment == 4
                      ? Constant.paddingHalfHalf
                      : Constant.paddingHalfHalf),
                  // color: Constant.cWhite.withOpacity(0.1),
                  child: isHeaderInStart
                      ? Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Text(headerText,
                                  textAlign: TextAlign.center,
                                  style: /* rowSegment==4?*/
                                      Constant.textStyleSize20(context)?.copyWith(
                                          color: headerTextColor ?? color,
                                          fontWeight: FontWeight
                                              .w600) /*:Constant.textStyleSize15(context)
                            ?.copyWith(color: HeaderTextColor?? color,fontWeight: FontWeight.w500),*/
                                  ),
                            ],
                          ),
                        )
                      : Center(
                          child: Text(headerText,
                              textAlign: TextAlign.center,
                              style: /* rowSegment==4?*/
                                  Constant.textStyleSize20(context)?.copyWith(
                                      color: headerTextColor ?? color,
                                      fontWeight: FontWeight
                                          .w600) /*:Constant.textStyleSize15(context)
                              ?.copyWith(color: HeaderTextColor?? color,fontWeight: FontWeight.w500),*/
                              ),
                        ),
                ),
                /*: const SizedBox.shrink(),*/
                child
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyArc extends StatelessWidget {
  final double diameter;
  final Color color;

  const MyArc({super.key, this.diameter = 200, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(color: color),
      size: Size(diameter, diameter),
    );
  }
}

// This is the Painter class
class MyPainter extends CustomPainter {
  Color color;
  MyPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color.withOpacity(0.1);
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      math.pi,
      math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
