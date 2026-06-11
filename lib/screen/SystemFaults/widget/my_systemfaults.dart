import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/systemfaults_bloc/systemfaults_event.dart';
import 'package:oceanbit_timeclock/bloc_logic/systemfaults_bloc/systemfaults_state.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../bloc_logic/systemfaults_bloc/systemfaults_bloc.dart';
import '../../../constant/constant.dart';
import '../../../constant/strings.dart';
import '../../../utils/logger.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/new/custom_cardview.dart';
import '../../dashboard/dashboard.dart';
import 'apply_systemfaults.dart';

class MySystemFaults extends StatefulWidget {
  final int? sizeTag;
  const MySystemFaults({Key? key, this.sizeTag}) : super(key: key);

  @override
  State<MySystemFaults> createState() => _MySystemFaultsState();
}

class _MySystemFaultsState extends State<MySystemFaults> {
  List allFaults = [];

  @override
  void initState() {
    BlocProvider.of<SystemFaultBloc>(context)
        .add(GetSystemFaultEvent(context: context));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SystemFaultBloc, SystemFaultState>(
      listener: (context, state) {
        if (state is GetSystemFaultLoading ||
            state is UpdateSystemFaultLoading ||
            state is AddSystemFaultLoading ||
            state is DeleteSystemFaultLoading ||
            state is GetAdminSystemFaultLoading ||
            state is UpdateAdminSystemFaultLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is GetSystemFaultError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is GetSystemFaultLoaded) {
          allFaults.clear();
          allFaults = List.generate(
              state.data!.data.length, (index) => state.data!.data[index]);
        }

        if (state is DeleteSystemFaultError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is DeleteSystemFaultLoaded) {
          BlocProvider.of<SystemFaultBloc>(context)
              .add(GetSystemFaultEvent(context: context));
          Navigator.pop(context);
        }

        if (state is AddSystemFaultError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          Constant().show_toast(state.errors, context);
        } else if (state is AddSystemFaultLoaded) {
          BlocProvider.of<SystemFaultBloc>(context)
              .add(GetSystemFaultEvent(context: context));

          Navigator.pop(context);
        }
        if (state is UpdateSystemFaultError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          Constant().show_toast(state.errors, context);
        } else if (state is UpdateSystemFaultLoaded) {
          BlocProvider.of<SystemFaultBloc>(context)
              .add(GetSystemFaultEvent(context: context));

          Navigator.pop(context);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
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
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(1),
                    4: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Strings.number,
                              style:
                                  Constant.textStyleSize14(context)?.copyWith(
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
                              Strings.systemType,
                              style:
                                  Constant.textStyleSize14(context)?.copyWith(
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
                              Strings.description,
                              style:
                                  Constant.textStyleSize14(context)?.copyWith(
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
                              style:
                                  Constant.textStyleSize14(context)?.copyWith(
                                color: Constant.cBlack,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              Strings.update,
                              style: Constant.textStyleSize14(context)
                                  ?.copyWith(color: Constant.cBlack),
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
          ),
          allFaults.isEmpty
              ? const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'No Data',
                style: TextStyle(color: Colors.black),
              ),
            ],
          )
              :  ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allFaults.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: Constant.paddingHalf),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(1),
                    4: FlexColumnWidth(1),
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
                              allFaults[index].systemType,
                              style:
                                  Constant.textStyleSize14(context)?.copyWith(
                                color: Constant.cBlack,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              allFaults[index].description,
                              style:
                                  Constant.textStyleSize14(context)?.copyWith(
                                color: Constant.cBlack,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              allFaults[index].status == "0"
                                  ? "Pending"
                                  : allFaults[index].status == "1"
                                      ? "In progress"
                                      : "Solved",
                              style:
                                  Constant.textStyleSize14(context)?.copyWith(
                                color: allFaults[index].status == "0"
                                    ? Constant.cYellowDark
                                    : allFaults[index].status == "1"
                                        ? Constant.cBlue
                                        : Constant.cGreenLight,
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
                                onTap: allFaults[index].status == "2"
                                    ? () {}
                                    : () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return ApplySystemFaults(
                                              sizeTag: widget.sizeTag,
                                              context: context,
                                              isUpdate: true,
                                              desc:
                                                  allFaults[index].description,
                                              systemType:
                                                  allFaults[index].systemType,
                                              id: allFaults[index].id,
                                            );
                                          },
                                        );
                                      },
                                child: CustomCardView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Constant.padding,
                                      vertical: Constant.paddingHalfHalf,
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: allFaults[index].status == "2"
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                ),
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
                                  showDialog(
                                    context: context,
                                    builder: ((context) {
                                      return Material(
                                        color: Constant.cBlack.withOpacity(0.1),
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
                                                  allFaults[index].id,
                                                  widget.sizeTag!)),
                                        ),
                                      );
                                    }),
                                  );
                                },
                                child: const CustomCardView(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Constant.padding,
                                      vertical: Constant.paddingHalfHalf,
                                    ),
                                    child: Icon(
                                      CupertinoIcons.delete_solid,
                                      size: 18,
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
        ],
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
                                  BlocProvider.of<SystemFaultBloc>(context).add(
                                      DeleteSystemFaultEvent(
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
