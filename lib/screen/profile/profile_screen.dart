import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/user_detail_bloc/user_detail_bloc.dart';
import 'package:oceanbit_timeclock/models/user_detail_model.dart';
import 'package:oceanbit_timeclock/screen/employee_details/employee_details.dart';
import 'package:oceanbit_timeclock/screen/profile/widgets/contact_info.dart';
import 'package:oceanbit_timeclock/screen/profile/widgets/employee_info.dart';
import 'package:oceanbit_timeclock/screen/profile/widgets/employee_report.dart';
import 'package:oceanbit_timeclock/screen/profile/widgets/other_information.dart';
import 'package:oceanbit_timeclock/screen/profile/widgets/personal_info.dart';
import 'package:oceanbit_timeclock/screen/profile/widgets/previous_employee.dart';
import 'package:oceanbit_timeclock/screen/profile/widgets/salary_account.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../bloc_logic/common_repositories/preference_repository.dart';
import '../../constant/constant.dart';
import '../../constant/strings.dart';
import '../../utils/logger.dart';
import '../../widget/new/custom_header_container.dart';
import '../admin_screens/employee_screen/current_employee.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({
    Key? key,
    required this.menuItem,
    this.isEmployee = false,
    this.userDetail,
    this.isBack,
    this.rowSegment,
    this.sizeTag,
    String subMenuItem = '',
  }) : super(key: key);
  String menuItem = '';
  bool isEmployee;
  UserData? userDetail;
  int? rowSegment;
  int? sizeTag;
  Function(bool)? isBack;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    if (widget.isEmployee && widget.userDetail == null) {
      widget.userDetail = userDataInAdmin;
    }
    Logger.println("Data :::: ${widget.userDetail?.firstName}");
    Logger.println("selected user id :::: ${widget.userDetail?.id}");
    Logger.println("menuItem=${widget.menuItem}");
    if (widget.userDetail == null) {
      BlocProvider.of<UserDetailBloc>(context)
          .add(FetchUserProfileEvent(context: context));
    } else if (context.read<PreferenceManagerRepository>().user!.isAdmin! &&
        widget.userDetail!.id != 0) {
      Logger.println('this is error');
      BlocProvider.of<UserDetailBloc>(context).add(FetchUserDetailEvent(
          id: widget.userDetail!.id.toString(), context: context));
    } else {
      Logger.println('no error is here');
      BlocProvider.of<UserDetailBloc>(context)
          .add(FetchUserProfileEvent(context: context));
    }
    //selectedTabIndex =  0;
    Logger.println("tab size=${TabBarIndicatorSize.tab}");
    Logger.println('user : ${widget.userDetail}');

    super.initState();
  }

  @override
  void dispose() {
    Logger.println('call dispose');
    // if (selectedIndex == 13 || selectedIndex == 14) {
    //   widget.isBack!(false);
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeaderContainer(
      headerWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.menuItem,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Constant.cWhite),
              ),
              Text(
                ' >> Update Profile ${widget.isEmployee ? '(${widget.userDetail?.firstName} ${widget.userDetail?.lastName})' : ''}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Constant.cWhite),
              ),
            ],
          ),
          widget.isBack != null
              ? GestureDetector(
                  onTap: () {
                    widget.isBack!(false);
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    width: 80,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.arrow_back_ios,
                            color: Constant.cBlack,
                            size: 15,
                          ),
                          //Constant.paddingSmall.widthBox,
                          Text('Back',
                              style: Constant.textStyleSize12(context)
                                  ?.copyWith(color: Constant.cBlack)),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Constant.cBlack.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(Constant.paddingHalfHalf)),
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount:
                    context.read<PreferenceManagerRepository>().user?.isAdmin ==
                                true &&
                            widget.isEmployee == true
                        ? Strings.adminTabList.length
                        : Strings.tabList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTabIndex = index;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 0 : Constant.paddingHalf,
                      ),
                      child: Container(
                        // width: MediaQuery
                        //     .of(context)
                        //     .size
                        //     .width*0.12,
                        width: 170,
                        // height: MediaQuery
                        //     .of(context)
                        //     .size
                        //     .height*0.4,
                        decoration: BoxDecoration(
                            color: selectedTabIndex == index
                                ? Constant.colorSelectedIndicator
                                : Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(Constant.paddingHalfHalf),
                            boxShadow: selectedTabIndex == index
                                ? [
                                    const BoxShadow(
                                        blurRadius: 6,
                                        spreadRadius: 0,
                                        color: Constant
                                            .colorSelectedIndicatorShadow,
                                        offset: Offset(4, 4))
                                  ]
                                : []),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: context
                                            .read<PreferenceManagerRepository>()
                                            .user
                                            ?.isAdmin ==
                                        true &&
                                    widget.isEmployee == true
                                ? Text(
                                    Strings.adminTabList[index],
                                    style: Constant.textStyleSize13(context)
                                        ?.copyWith(
                                      color: selectedTabIndex == index
                                          ? Constant.cWhite
                                          : Constant.cBlack,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    Strings.tabList[index],
                                    style: Constant.textStyleSize13(context)
                                        ?.copyWith(
                                      color: selectedTabIndex == index
                                          ? Constant.cWhite
                                          : Constant.cBlack,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Constant.padding.heightBox,
            Expanded(
              flex: 1,
              child: context
                              .read<PreferenceManagerRepository>()
                              .user
                              ?.isAdmin ==
                          true &&
                      widget.isEmployee == true
                  ? Container(
                      // color: Constant.cGrayDark,
                      child: selectedTabIndex == 0
                          ? PersonalInfo(
                              userData: widget.userDetail,
                              isEmployee: widget.isEmployee,
                              rowSegment: widget.rowSegment,
                              isBack: widget.isBack != null ? true : false,
                            )
                          : selectedTabIndex == 1
                              ? EmployeeInfo(
                                  userDetail: widget.userDetail,
                                  isEmployee: widget.isEmployee,
                                  rowSegment: widget.rowSegment,
                                  sizeTag: widget.sizeTag,
                                )
                              : selectedTabIndex == 2
                                  ? ContactInfo(
                                      userData: widget.userDetail,
                                      isEmployee: widget.isEmployee,
                                    )
                                  : selectedTabIndex == 3
                                      ? EmployeeReport(
                                          userData: widget.userDetail,
                                          sizeTag: widget.sizeTag,
                                          rowSegment: widget.rowSegment)
                                      : selectedTabIndex == 4
                                          ? OtherInformation(
                                              userData: widget.userDetail)
                                          : selectedTabIndex == 5
                                              ? PreviousEmployee(
                                                  userData: widget.userDetail,
                                                  isProfile: true,
                                                )
                                              : selectedTabIndex == 6
                                                  ? SalaryAccount(
                                                      userData:
                                                          widget.userDetail,
                                                      isProfile: true,
                                                    )
                                                  : EmployeeDetails(
                                                      userData:
                                                          widget.userDetail,
                                                    ),
                    )
                  : Container(
                      // color: Constant.cGrayDark,
                      child: selectedTabIndex == 0
                          ? PersonalInfo(
                              userData: widget.userDetail,
                              isEmployee: widget.isEmployee,
                              isBack: widget.isBack != null ? true : false,
                              rowSegment: widget.rowSegment,
                            )
                          : selectedTabIndex == 1
                              ? EmployeeInfo(
                                  userDetail: widget.userDetail,
                                  isEmployee: widget.isEmployee,
                                  rowSegment: widget.rowSegment,
                                  sizeTag: widget.sizeTag,
                                )
                              : selectedTabIndex == 2
                                  ? ContactInfo(
                                      userData: widget.userDetail,
                                      isEmployee: widget.isEmployee,
                                    )
                                  : selectedTabIndex == 3
                                      ? OtherInformation(
                                          userData: widget.userDetail)
                                      : selectedTabIndex == 4
                                          ? PreviousEmployee(
                                              userData: widget.userDetail,
                                              isProfile: false,
                                            )
                                          : SalaryAccount(
                                              userData: widget.userDetail),
                    ),
            ),
          ]),
    );
    //   /*return *//*Flexible(
    //     flex: 1,
    //     child:*//* Container(
    //       width: MediaQuery
    //           .of(context)
    //           .size
    //           .width,
    //       color: Constant.cGrayDark,
    //       child: Container(
    //         color: Constant.cWhite.withOpacity(0.2),
    //         child: Column(
    //           children: [
    //             Expanded(
    //               child: Padding(
    //                 padding: const EdgeInsets.all(Constant.paddingHalf),
    //                 child: SizedBox(
    //                   width: MediaQuery.of(context).size.width,
    //                   child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       crossAxisAlignment: CrossAxisAlignment.stretch,
    //                       children: [
    //                         SizedBox(
    //                           height: MediaQuery
    //                               .of(context)
    //                               .size
    //                               .height *0.04,
    //                           child: ListView.builder(
    //                               scrollDirection: Axis.horizontal,
    //                               itemCount: context.read<PreferenceManagerRepository>().user?.isAdmin == true && widget.isEmployee == true ? Strings.adminTabList.length : Strings.tabList.length,
    //                               shrinkWrap: true,
    //                               itemBuilder: (context, index) {
    //                                 return GestureDetector(
    //                                   onTap: () {
    //                                     setState(() {
    //                                       selectedTabIndex = index;
    //                                     });
    //                                   },
    //                                   child: Container(
    //                                       width: MediaQuery
    //                                           .of(context)
    //                                           .size
    //                                           .width*0.12,
    //                                       height: MediaQuery
    //                                           .of(context)
    //                                           .size
    //                                           .height*0.4,
    //                                       color: selectedTabIndex == index
    //                                           ? Constant.cGrayDark
    //                                           : Colors.transparent,
    //                                       child: Center(
    //                                         child: context.read<PreferenceManagerRepository>().user?.isAdmin == true && widget.isEmployee == true? Text(Strings.adminTabList[index],style: Constant.textStyleSize13(
    //                                             context)
    //                                             ?.copyWith(
    //                                             color: Constant.cWhite),
    //                                           textAlign: TextAlign.center,) : Text(Strings.tabList[index],
    //                                           style: Constant.textStyleSize13(
    //                                               context)
    //                                               ?.copyWith(
    //                                               color: Constant.cWhite),
    //                                           textAlign: TextAlign.center,),
    //                                       )),
    //                                 );
    //                               }),
    //                         ),
    //                         Expanded(
    //                           flex: 1,
    //                           child: context.read<PreferenceManagerRepository>().user?.isAdmin == true  && widget.isEmployee == true  ? Container(
    //                             color: Constant.cGrayDark,
    //                             child: selectedTabIndex == 0
    //                                 ? PersonalInfo(userData: widget.userDetail,isEmployee: widget.isEmployee,) : selectedTabIndex == 1 ?
    //                              EmployeeInfo(userDetail: widget.userDetail,isEmployee: widget.isEmployee,) : selectedTabIndex == 2 ?
    //                              ContactInfo(userData: widget.userDetail,isEmployee: widget.isEmployee,) : selectedTabIndex == 3 ?
    //                             EmployeeReport(userData: widget.userDetail,) : selectedTabIndex == 4 ?
    //                              OtherInformation(userData: widget.userDetail) : selectedTabIndex == 5 ?
    //                              PreviousEmployee(userData: widget.userDetail) :
    //                              SalaryAccount(userData: widget.userDetail),
    //                           ) : Container(
    //                             color: Constant.cGrayDark,
    //                             child: selectedTabIndex == 0
    //                                 ? PersonalInfo(userData: widget.userDetail,isEmployee: widget.isEmployee) : selectedTabIndex == 1 ?
    //                             EmployeeInfo(userDetail: widget.userDetail,isEmployee: widget.isEmployee,) : selectedTabIndex == 2 ?
    //                             ContactInfo(userData: widget.userDetail,isEmployee: widget.isEmployee,) : selectedTabIndex == 3 ?
    //                             OtherInformation(userData: widget.userDetail) : selectedTabIndex == 4 ?
    //                             PreviousEmployee(userData: widget.userDetail) :
    //                             SalaryAccount(userData: widget.userDetail),
    //                           ),
    //                         ),
    //                       ]
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //  *//* );
    // }*/
  }
}
