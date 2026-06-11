import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/screen/Inventorys/inventory_screen.dart';
import 'package:oceanbit_timeclock/screen/admin_screens/employee_screen/admin_salary_screen.dart';
import 'package:provider/provider.dart';
import '../../../bloc_logic/common_repositories/preference_repository.dart';
import '../../../bloc_logic/update_ui_bloc/update_ui_bloc.dart';
import '../../../bloc_logic/update_ui_bloc/update_ui_state.dart';
import '../../../constant/constant.dart';
import '../../../constant/strings.dart';
import '../../../utils/check_network/connectivity_provider.dart';
import '../../../widget/chart_widget.dart';
import '../../../widget/new/custom_header_container.dart';
import '../../../widget/view_today_time_slot_dialog_ui.dart';
import '../../Setting_page/setting_page.dart';
import '../../SystemFaults/widget/systemfaults_screen.dart';
import '../../admin_screens/admin_holiday_screen.dart';
import '../../admin_screens/admin_leave_screen.dart';
import '../../admin_screens/admin_quotes_screen.dart';
import '../../admin_screens/admin_review_screen.dart';
import '../../admin_screens/admin_rules_screen.dart';
import '../../admin_screens/admin_system_fault_screen.dart';
import '../../admin_screens/employee_screen/current_employee.dart';
import '../../admin_screens/employee_screen/past_employee.dart';
import '../../employee_reviews/employee_review_screen.dart';
import '../../holidays/holiday_screen.dart';
import '../../knowledge_base/knowledge_base_screen.dart';
import '../../leaves/widget/leave_screen.dart';
import '../../my_salary/my_salary_screen.dart';
import '../../my_task/my_task_screen.dart';
import '../../ocean_team/ocean_team_screen.dart';
import '../../profile/profile_screen.dart';
import '../../quotes/quotes.dart';
import '../../report_list/report_list_screen.dart';
import '../../rules/rules.dart';
import '../../time/time_screen.dart';
import '../dashboard.dart';
import '../dashboard.dart' as msg_list;
import 'connectionDialog.dart';

class LargeBodyWidget extends StatefulWidget {
  const LargeBodyWidget(
      {Key? key,
      required this.dashboardWidget,
      required this.selectedIndex,
      required this.timerWidget})
      : super(key: key);
  final Widget dashboardWidget;
  final Widget timerWidget;
  final int selectedIndex;

  @override
  State<LargeBodyWidget> createState() => _LargeBodyWidgetState();
}

class _LargeBodyWidgetState extends State<LargeBodyWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateUiBloc, UpdateUiState>(
      listener: (context, state) {
        if (state is OpenDialogLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is OpenDialogLoaded) {
          showTimeDialog = state.isOpenDialog!;
          setState(() {});
        }
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Column(
            children: [
              widget.timerWidget,
              Expanded(
                child: Padding(
                    padding: EdgeInsets.all(selectedIndex == 0
                        ? Constant.paddingHalf
                        : Constant.paddingMidHalf),
                    child: (widget.selectedIndex == 0)
                        ? widget.dashboardWidget
                        : (widget.selectedIndex == 1)
                            ? const MyTaskScreen()
                            : (widget.selectedIndex == 2)
                                ? const TimeScreen()
                                : (widget.selectedIndex == 3)
                                    ? ProfileScreen(
                                        menuItem: Strings.adminDrawerItem[13],
                                        rowSegment: 2,
                                        sizeTag: 2,
                                      )
                                    : (widget.selectedIndex == 4)
                                        ? context
                                                .read<
                                                    PreferenceManagerRepository>()
                                                .user!
                                                .isAdmin
                                            ? const AdminLeaveScreen(
                                                sizeTag: 2,
                                              )
                                            : const LeaveScreen(
                                                sizeTag: 2,
                                              )
                                        : (widget.selectedIndex == 5)
                                            ? context
                                                    .read<
                                                        PreferenceManagerRepository>()
                                                    .user!
                                                    .isAdmin
                                                ? const AdminHolidayScreen(
                                                    sizeTag: 2)
                                                : const HolidayScreen()
                                            : (widget.selectedIndex == 6)
                                                ? const KnowledgeBaseScreen(
                                                    sizeTag: 2,
                                                  )
                                                : (widget.selectedIndex == 7)
                                                    ? const ReportListScreen(
                                                        rowSegment: 2,
                                                        sizeTag: 2,
                                                      )
                                                    : (widget.selectedIndex ==
                                                            8)
                                                        ? context
                                                                .read<
                                                                    PreferenceManagerRepository>()
                                                                .user!
                                                                .isAdmin
                                                            ? const AdminReviewScreen(
                                                                sizeTag: 2,
                                                              )
                                                            : const EmployeeReviewScreen(
                                                                sizeTag: 2,
                                                              )
                                                        : (widget.selectedIndex ==
                                                                9)
                                                            ? context
                                                                    .read<
                                                                        PreferenceManagerRepository>()
                                                                    .user!
                                                                    .isAdmin
                                                                ? const AdminSystemFaultScreen(
                                                                    sizeTag: 2,
                                                                  )
                                                                : const SystemFaultsScreen(
                                                                    sizeTag: 2,
                                                                  )
                                                            : (widget.selectedIndex ==
                                                                    10)
                                                                ? context
                                                                        .read<
                                                                            PreferenceManagerRepository>()
                                                                        .user!
                                                                        .isAdmin
                                                                    ? const AdminSalaryScreen(
                                                                        sizeTag:
                                                                            1,
                                                                      )
                                                                    : const CustomHeaderContainer(
                                                                        headerText:
                                                                            Strings.salary,
                                                                        child:
                                                                            MySalaryScreen(
                                                                          isEmployee:
                                                                              true,
                                                                        ),
                                                                      )
                                                                : (widget.selectedIndex ==
                                                                        11)
                                                                    ? OceanTeamScreen(
                                                                        sizeTag:
                                                                            2)
                                                                    : (widget.selectedIndex ==
                                                                            12)
                                                                        ? context.read<PreferenceManagerRepository>().user!.isAdmin
                                                                            ? const AdminRulesScreen(
                                                                                sizeTag: 2,
                                                                              )
                                                                            : const RulesScreen()
                                                                        : (widget.selectedIndex == 13)
                                                                            ? context.read<PreferenceManagerRepository>().user!.isAdmin
                                                                                ? const AdminQuotesScreen(
                                                                                    sizeTag: 1,
                                                                                  )
                                                                                : const QuotesScreen()
                                                                            : context.read<PreferenceManagerRepository>().user!.isAdmin
                                                                                ? (widget.selectedIndex == 14)
                                                                                    ? const CurrentEmployee(rowSegment: 2, sizeTag: 2)
                                                                                    : (widget.selectedIndex == 15)
                                                                                        ? const PastEmployee(rowSegment: 2, sizeTag: 2)
                                                                                        : (widget.selectedIndex == 16)
                                                                                            ? const InventoryScreen(
                                                                                                sizeTag: 2,
                                                                                              )
                                                                                            : (widget.selectedIndex == 17)
                                                                                                ? SettingScreen(
                                                                                                    sizeTag: 2,
                                                                                                  )
                                                                                                : Container()
                                                                                : Container()),
              ),
              /*   Transform.translate(
                    offset: Offset(MediaQuery.of(context).size.width,50),
                    child: msgList.length!=0?ListView.builder(shrinkWrap: true,
                        itemCount: msgList.length,
                        itemBuilder: (context,index){
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: Constant.padding),
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              msgList.removeAt(index);
                            });
                          },
                            child: msgList[index]),
                      );
                    }):SizedBox.shrink(),)*/
            ],
          ),
          !(Provider.of<ConnectivityProvider>(context).isOnline)
              ? const ConnectionDialog()
              : const SizedBox.shrink(),
          // kDebugMode
          //     ? msg_list.msgList.isNotEmpty
          //         ? SizedBox(
          //             width: MediaQuery.of(context).size.width / 2,
          //             child: SingleChildScrollView(
          //               child: Column(
          //                 mainAxisAlignment: MainAxisAlignment.end,
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.only(
          //                         top: Constant.padding,
          //                         right: Constant.padding),
          //                     child: Row(
          //                       mainAxisAlignment: MainAxisAlignment.end,
          //                       children: [
          //                         GestureDetector(
          //                             onTap: () {
          //                               setState(() {
          //                                 msg_list.msgList.clear();
          //                               });
          //                             },
          //                             child: CircleAvatar(
          //                               backgroundColor:
          //                                   Constant.cBlack.withOpacity(0.8),
          //                               child: const Icon(
          //                                 Icons.close,
          //                                 color: Constant.cWhite,
          //                                 size: 30,
          //                               ),
          //                             )),
          //                       ],
          //                     ),
          //                   ),
          //                   ListView.builder(
          //                       shrinkWrap: true,
          //                       itemCount: msg_list.msgList.length,
          //                       itemBuilder: (context, index) {
          //                         return Padding(
          //                             padding: const EdgeInsets.symmetric(
          //                                 vertical: 10),
          //                             child: /*GestureDetector(
          //                   onTap: (){
          //                     setState(() {
          //                       msgList.msgList.removeAt(index);
          //                     });
          //                   },
          //                   child:*/
          //                                 msg_list.msgList[index]
          //                             // ),
          //                             );
          //                       }),
          //                 ],
          //               ),
          //             ),
          //           )
          //         : const SizedBox.shrink()
          //     : const SizedBox.shrink(),
          showTimeDialog
              ? TodayTimeSlotsDialog(timeDetail)
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
