import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/update_ui_bloc/update_ui_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/update_ui_bloc/update_ui_state.dart';
import 'package:oceanbit_timeclock/screen/Setting_page/department_screen.dart';
import 'package:oceanbit_timeclock/screen/Setting_page/designation_screen.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../bloc_logic/get_holiday/get_holiday_bloc.dart';
import '../../bloc_logic/get_holiday/get_holiday_event.dart';
import '../../bloc_logic/update_ui_bloc/update_ui_event.dart';
import '../../constant/constant.dart';
import '../../constant/strings.dart';
import '../../models/daily_report_model.dart';
import '../../widget/new/custom_cardview.dart';
import '../../widget/new/custom_header_container.dart';
import 'holiday_type_screen.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key? key, required int sizeTag}) : super(key: key);
  int sizeTag = 1;

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int currentPage = 0;
  bool isMain = true;
  List<String?> allSettingsString = [
    Strings.holidayType,
    Strings.departments,
    Strings.designations,
  ];
  List<IconData?> allSettingsIcon = [
    Icons.holiday_village,
    Icons.account_tree,
    Icons.camera_front_outlined,
  ];

  @override
  void initState() {
    BlocProvider.of<GetHolidayBloc>(context)
        .add(FetchHoliday(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateUiBloc, UpdateUiState>(
      listener: (context, state) {
        if (state is BackLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is BackLoaded) {
          isMain = state.isBack!;
          setState(() {});
        }
      },
      child: isMain
          ? allSettings()
          : currentPage == 1
              ? HolidayTypeScreen(
                  sizeTag: widget.sizeTag,
                )
              : currentPage == 2
                  ? DepartmentScreen(sizeTag: widget.sizeTag)
                  : DesignationScreen(sizeTag: widget.sizeTag),
    );
  }

  Widget allSettings() {
    return CustomHeaderContainer(
      headerText: Strings.setting,
      child: GridView.builder(
        itemCount: 3,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 3 / 1),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                BlocProvider.of<UpdateUiBloc>(context)
                    .add(const BackSetting(false));
                currentPage = index + 1;
              });
            },
            child: CustomCardView(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    allSettingsIcon[index]!,
                    color: Constant.cBlack,
                  ),
                  Constant.padding.widthBox,
                  Text(
                    allSettingsString[index]!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
