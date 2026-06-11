import 'package:flutter/material.dart';
import '../../constant/strings.dart';
import '../../widget/new/custom_header_container.dart';

class TimeScreen extends StatelessWidget {
  const TimeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomHeaderContainer(
      headerText: Strings.time,
    );
  }
}
