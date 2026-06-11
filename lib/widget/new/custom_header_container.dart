import 'package:flutter/material.dart';

import '../../constant/constant.dart';

class CustomHeaderContainer extends StatelessWidget {
  const CustomHeaderContainer(
      {Key? key,
      this.headerText,
      this.child,
      this.headerWidget,
      this.headerContainerColor,
      this.isExpand = true,
      this.padding})
      : super(key: key);
  final String? headerText;
  final Widget? headerWidget;
  final Widget? child;
  final Color? headerContainerColor;
  final bool isExpand;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Constant.cWhite,
        boxShadow: [
          BoxShadow(
            color: Constant.cBlack.withOpacity(0.25),
            offset: const Offset(0, 0),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
        borderRadius: BorderRadius.circular(Constant.paddingHalf),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              color: headerContainerColor ?? Constant.colorSelectedIndicator,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Constant.paddingHalf),
                topRight: Radius.circular(Constant.paddingHalf),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(
                Constant.paddingHalf,
              ),
              child: Center(
                child: headerWidget ??
                    Text(
                      headerText ?? '',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Constant.cWhite,
                          ),
                    ),
              ),
            ),
          ),
          isExpand
              ? Expanded(
                  child: Padding(
                    padding: padding ?? const EdgeInsets.all(Constant.padding),
                    child: child ?? Container(),
                  ),
                )
              : Padding(
                  padding: padding ?? const EdgeInsets.all(Constant.padding),
                  child: child ?? Container(),
                ),
        ],
      ),
    );
  }
}
