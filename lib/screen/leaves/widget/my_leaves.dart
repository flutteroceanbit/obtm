import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/leave_bloc/leave_event.dart';
import 'package:oceanbit_timeclock/models/user_leave_model.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../bloc_logic/leave_bloc/leave_bloc.dart';
import '../../../bloc_logic/leave_bloc/leave_repositories.dart';
import '../../../bloc_logic/leave_bloc/leave_state.dart';
import '../../../constant/constant.dart';
import '../../../constant/strings.dart';
import '../../../local_storage/my_local_storage.dart';
import '../../../utils/logger.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/new/custom_cardview.dart';
import '../../dashboard/dashboard.dart';

class MyLeave extends StatefulWidget {
  const MyLeave({Key? key, this.sizeTag}) : super(key: key);
  final int? sizeTag;

  @override
  State<MyLeave> createState() => _MyLeaveState();
}

List<LeaveBalance?> allLeaveBalances = [];
List allMyLeave = [];

class _MyLeaveState extends State<MyLeave> {
  late final LeaveRepository repository;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    repository = context.read<LeaveRepository>();
    repository.page = 1;
    allMyLeave.clear();
    if (MyLocalStorage().getUser()!.isAdmin) {
      BlocProvider.of<LeaveBloc>(context).add(GetLeaveByUserEvent(
          context: context, userId: MyLocalStorage().getUser()!.id));
      if (!repository.isLoading && !repository.isLastPage) {
        repository.isLoading = true;
      }
    } else {
      BlocProvider.of<LeaveBloc>(context)
          .add(GetUserLeaveEvent(context: context));
      if (!repository.isLoading && !repository.isLastPage) {
        repository.isLoading = true;
      }
    }
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        Logger.println(
            "PaginatedList: onScrollAtLast: isLoading: ${repository.isLoading} ");
        Logger.println(
            "PaginatedList: onScrollAtLast: isLastPage: ${repository.isLastPage} ");
        if (!repository.isLoading && !repository.isLastPage) {
          repository.isLoading = true;
          if (MyLocalStorage().getUser()!.isAdmin) {
            BlocProvider.of<LeaveBloc>(context).add(GetLeaveByUserEvent(
                context: context, userId: MyLocalStorage().getUser()!.id));
          } else {
            BlocProvider.of<LeaveBloc>(context)
                .add(GetUserLeaveEvent(context: context));
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LeaveBloc, LeaveState>(
      listener: (context, state) {
        if (state is GetLeaveByUserLoading ||
            state is AddLeaveLoading ||
            state is DeleteLeaveLoading ||
            state is GetUserLeaveLoading ||
            state is GetLeaveLoading ||
            state is UpdateLeaveLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is GetLeaveByUserError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is GetLeaveByUserLoaded) {
          if (repository.page < 2) {
            allMyLeave.clear();
          }
          allMyLeave.addAll(state.data!.data);
          allLeaveBalances = state.data!.leaveBalances;
          print('leave_balances leave_balances :: ${allLeaveBalances}');
        }

        if (state is GetUserLeaveError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is GetUserLeaveLoaded) {
          if (repository.page < 2) {
            allMyLeave.clear();
          }
          allMyLeave.addAll(state.data!.data);
          allLeaveBalances = state.data!.leaveBalances;
          print('leave_balances leave_balances :: ${allLeaveBalances}');
        }

        if (state is DeleteLeaveError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is DeleteLeaveLoaded) {
          allMyLeave.clear();
          if (MyLocalStorage().getUser()!.isAdmin) {
            BlocProvider.of<LeaveBloc>(context).add(GetLeaveByUserEvent(
                context: context, userId: MyLocalStorage().getUser()!.id!));
            Navigator.pop(context);
          } else {
            BlocProvider.of<LeaveBloc>(context)
                .add(GetUserLeaveEvent(context: context));
            Navigator.pop(context);
          }
        }

        if (state is AddLeaveError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          Constant().show_toast(state.errors, context);
        } else if (state is AddLeaveLoaded) {
          allMyLeave.clear();
          if (MyLocalStorage().getUser()!.isAdmin!) {
            BlocProvider.of<LeaveBloc>(context).add(GetLeaveByUserEvent(
                context: context, userId: MyLocalStorage().getUser()!.id!));
          } else {
            BlocProvider.of<LeaveBloc>(context)
                .add(GetUserLeaveEvent(context: context));
          }
          Navigator.pop(context);
        }
      },
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            allMyLeave.isEmpty
                ? Expanded(
                    child: Center(
                      child: Text(
                        Strings.noData,
                        style: Constant.textStyleSize15(context)?.copyWith(
                          color: Constant.cBlack.withOpacity(0.5),
                        ),
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Constant.cBlack5PerOpacity,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Constant.paddingHalfHalf,
                        vertical: Constant.paddingHalf,
                      ),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(4),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(2),
                          4: FlexColumnWidth(2),
                          5: FlexColumnWidth(1),
                          6: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    Strings.number,
                                    style: Constant.textStyleSize14(context)
                                        ?.copyWith(
                                      color: Constant.cBlack,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Strings.reason,
                                    style: Constant.textStyleSize14(context)
                                        ?.copyWith(
                                      color: Constant.cBlack,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Strings.leaveType,
                                    style: Constant.textStyleSize14(context)
                                        ?.copyWith(
                                      color: Constant.cBlack,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    Strings.startDate,
                                    style: Constant.textStyleSize14(context)
                                        ?.copyWith(
                                      color: Constant.cBlack,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    Strings.endDate,
                                    style: Constant.textStyleSize14(context)
                                        ?.copyWith(
                                      color: Constant.cBlack,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    Strings.status,
                                    style: Constant.textStyleSize14(context)
                                        ?.copyWith(
                                      color: Constant.cBlack,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    Strings.delete,
                                    style: Constant.textStyleSize14(context)
                                        ?.copyWith(color: Constant.cBlack),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
            Expanded(
              flex: 1,
              child: ListView.separated(
                controller: _scrollController,
                itemCount: allMyLeave.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: Constant.paddingHalf),
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(4),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(2),
                        4: FlexColumnWidth(2),
                        5: FlexColumnWidth(1),
                        6: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(
                          children: [
                            Column(
                              children: [
                                Text(
                                  '${index + 1}',
                                  style: Constant.textStyleSize14(context)
                                      ?.copyWith(color: Constant.cBlack),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  allMyLeave[index].reason,
                                  style: Constant.textStyleSize14(context)
                                      ?.copyWith(
                                    color: Constant.cBlack,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  allMyLeave[index].leave.name,
                                  style: Constant.textStyleSize14(context)
                                      ?.copyWith(
                                    color: Constant.cBlack,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  allMyLeave[index].startDate,
                                  style: Constant.textStyleSize14(context)
                                      ?.copyWith(
                                    color: Constant.cBlack,
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  allMyLeave[index].leaveType.value == 1
                                      ? 'First Half Leave'
                                      : allMyLeave[index].leaveType.value == 2
                                          ? 'Second Half Leave'
                                          : allMyLeave[index].endDate,
                                  style: Constant.textStyleSize14(context)
                                      ?.copyWith(
                                    color: Constant.cBlack,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  allMyLeave[index].leaveStatus.name,
                                  style: Constant.textStyleSize14(context)
                                      ?.copyWith(
                                    color: allMyLeave[index]
                                                .leaveStatus
                                                .value ==
                                            -1
                                        ? Constant.cYellowDark
                                        : allMyLeave[index].leaveStatus.value ==
                                                1
                                            ? Constant.cGreenLight
                                            : Constant.cRedLight,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: Constant.paddingHalfHalf),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (allMyLeave[index].leaveStatusValue ==
                                          -1) {
                                        showDialog(
                                          context: context,
                                          builder: ((context) {
                                            return Material(
                                              color: Constant.cBlack
                                                  .withOpacity(0.1),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      8,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      8,
                                                ),
                                                child: Center(
                                                    child: deleteDialog(
                                                        allMyLeave[index].id,
                                                        widget.sizeTag ?? 1)),
                                              ),
                                            );
                                          }),
                                        );
                                      }
                                    },
                                    child: CustomCardView(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: Constant.padding,
                                          vertical: Constant.paddingHalfHalf,
                                        ),
                                        child: Icon(
                                          CupertinoIcons.delete_solid,
                                          size: 18,
                                          color: allMyLeave[index]
                                                      .leaveStatusValue ==
                                                  -1
                                              ? Colors.black
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    color: Constant.cLightGray,
                    height: 1,
                  );
                },
              ),
            ),
            // Expanded(
            //   child: Container(
            //     color: Constant.cLightGray,
            //     height: 1,
            //     width: MediaQuery.of(context).size.width,
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget deleteDialog(
    int id,
    int sizeTag,
  ) {
    return StatefulBuilder(builder: (context, setState) {
      return Wrap(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constant.paddingHalf),
              color: Constant.cWhite,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(Constant.paddingHalf),
                      topLeft: Radius.circular(Constant.paddingHalf),
                    ),
                    color: Constant.colorSelectedIndicator,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Constant.paddingHalf),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Spacer(),
                        Text(
                          Strings.delete,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Constant.cWhite),
                        ),
                        const Spacer(),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              color: Constant.cWhite,
                              size: 20,
                            ))
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(Constant.paddingHalf),
                      bottomLeft: Radius.circular(Constant.paddingHalf),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: Constant.padding,
                      left: Constant.padding,
                      bottom: Constant.padding,
                      right: Constant.padding,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Are you sure to delete this holiday type?',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Constant.cBlack),
                          ),
                          Constant.padding.heightBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomButton(
                                height: 40,
                                width: 120,
                                text: Strings.close,
                                textStyle:
                                    Constant.textStyleSize14(context)?.copyWith(
                                  color: Constant.cWhite,
                                ),
                                color: Constant.colorSelectedIndicator,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Constant.padding4x.widthBox,
                              CustomButton(
                                height: 40,
                                width: 120,
                                text: Strings.delete,
                                textStyle:
                                    Constant.textStyleSize14(context)?.copyWith(
                                  color: Constant.cWhite,
                                ),
                                color: Constant.colorSelectedIndicator,
                                onTap: () {
                                  repository.page = 1;
                                  BlocProvider.of<LeaveBloc>(context).add(
                                      DeleteLeaveEvent(
                                          context: context, id: id.toString()));
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    });
  }
}
