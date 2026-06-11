import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/add_holiday_type_bloc/add_holiday_type_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/add_holiday_type_bloc/add_holiday_type_event.dart';
import 'package:oceanbit_timeclock/screen/Setting_page/setting_page.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../bloc_logic/add_holiday_type_bloc/add_holiday_type_state.dart';
import '../../bloc_logic/get_holiday_types/get_holiday_bloc.dart';
import '../../bloc_logic/get_holiday_types/get_holiday_event.dart';
import '../../bloc_logic/get_holiday_types/get_holiday_state.dart';
import '../../bloc_logic/update_ui_bloc/update_ui_bloc.dart';
import '../../bloc_logic/update_ui_bloc/update_ui_event.dart';
import '../../constant/constant.dart';
import '../../constant/strings.dart';
import '../../models/holiday_type_model.dart';
import '../../utils/logger.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_container_button.dart';
import '../../widget/custom_form_label.dart';
import '../../widget/custom_textfield_with_label.dart';
import '../../widget/new/custom_cardview.dart';
import '../../widget/new/custom_header_container.dart';
import '../dashboard/dashboard.dart';

class HolidayTypeScreen extends StatefulWidget {
  HolidayTypeScreen({Key? key, required int sizeTag}) : super(key: key);
  int sizeTag = 1;

  @override
  State<HolidayTypeScreen> createState() => _HolidayTypeScreenState();
}

class _HolidayTypeScreenState extends State<HolidayTypeScreen> {
  @override
  void initState() {
    BlocProvider.of<GetHolidayTypeBloc>(context)
        .add(FetchHolidayType(context: context));

    super.initState();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool autoValidateMode = false;
  DateTime? startDate;
  DateTime? endDate;
  String holidayType = Strings.holidayTypeList[0];
  bool? isMulti;
  TextEditingController holidayNameController = TextEditingController();
  int? updateHolidayId;
  List<Data> holidays = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddHolidayTypeBloc, AddHolidayTypeState>(
      listener: (context, state) {
        if (state is AddHolidayTypeLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is AddHolidayTypeError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is AddHolidayTypeLoaded) {
          Navigator.pop(context);
          holidayNameController.clear();
          BlocProvider.of<GetHolidayTypeBloc>(context)
              .add(FetchHolidayType(context: context));
        }
      },
      child: CustomHeaderContainer(
        headerWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              Strings.holidayType,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Constant.cWhite,
                  ),
            ),
            CustomContainerButton(
              text: Strings.back,
              textStyle: Constant.textStyleSize13(context)!.copyWith(
                color: Constant.cBlack,
              ),
              color: Constant.cWhite,
              width: 120,
              onTap: () {
                BlocProvider.of<UpdateUiBloc>(context)
                    .add(const BackSetting(true));
              },
            ),
          ],
        ),
        child: BlocListener<GetHolidayTypeBloc, GetHolidayTypeState>(
          listener: (context, state) {
            if (state is GetHolidayTypeLoading ||
                state is UpdateHolidayTypeLoading ||
                state is DeleteHolidayTypeLoading ||
                state is AddHolidayTypeLoading) {
              Constant.myLoader.show(context);
            } else {
              Constant.myLoader.hide();
              setState(() {});
            }

            if (state is GetHolidayTypeError) {
              msgList.add(Constant().ShowErrorMessage(state.errors, context));
              holidays.clear();
              Constant.myLoader.hide();
              Logger.println('error ${state.errors}');
              Constant().show_toast(state.errors, context);
            } else if (state is GetHolidayTypeLoaded) {
              holidays.clear();
              holidays = List.generate(
                  state.data!.data.length, (index) => state.data!.data[index]);
            }
            if (state is UpdateHolidayTypeError) {
              msgList.add(Constant().ShowErrorMessage(state.errors, context));
              Constant.myLoader.hide();
              Logger.println('error ${state.errors}');
              //Constant().ShowToast(state.errors, context);
            } else if (state is UpdateHolidayTypeLoaded) {
              Navigator.pop(context);
              holidayNameController.clear();
              BlocProvider.of<GetHolidayTypeBloc>(context)
                  .add(FetchHolidayType(context: context));
            }
            if (state is DeleteHolidayTypeError) {
              msgList.add(Constant().ShowErrorMessage(state.errors, context));
              Constant.myLoader.hide();
              Logger.println('error ${state.errors}');
              //Constant().ShowToast(state.errors, context);
            } else if (state is DeleteHolidayTypeLoaded) {
              Navigator.pop(context);
              holidayNameController.clear();
              BlocProvider.of<GetHolidayTypeBloc>(context)
                  .add(FetchHolidayType(context: context));
            }
          },
          child: Column(
            children: [
              Expanded(
                flex: 11,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Constant.cBlack.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            Constant.paddingHalfHalf,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(Constant.paddingHalf),
                          child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(0.5),
                              1: FlexColumnWidth(2),
                              2: FlexColumnWidth(2),
                              3: FlexColumnWidth(1),
                              4: FlexColumnWidth(1),
                              5: FlexColumnWidth(1),
                              6: FlexColumnWidth(1),
                            },
                            children: [
                              TableRow(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        Strings.number,
                                        style: Constant.textStyleSize14(context)
                                            ?.copyWith(color: Constant.cBlack),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        Strings.holidayName,
                                        style: Constant.textStyleSize14(context)
                                            ?.copyWith(color: Constant.cBlack),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        Strings.isMulti,
                                        style: Constant.textStyleSize14(context)
                                            ?.copyWith(color: Constant.cBlack),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        Strings.action,
                                        style: Constant.textStyleSize14(context)
                                            ?.copyWith(color: Constant.cBlack),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        Strings.view,
                                        style: Constant.textStyleSize14(context)
                                            ?.copyWith(color: Constant.cBlack),
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
                      holidays.isEmpty
                          ? const Center(
                              child: Text(
                                'No Data',
                                style: TextStyle(color: Colors.black),
                              ),
                            )
                          : ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: holidays.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Container(
                                  height: 1,
                                  color: Constant.colorGrey,
                                );
                              },
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(
                                        Constant.paddingHalf,
                                      ),
                                      child: Table(
                                        columnWidths: const {
                                          0: FlexColumnWidth(0.5),
                                          1: FlexColumnWidth(2),
                                          2: FlexColumnWidth(2),
                                          3: FlexColumnWidth(1),
                                          4: FlexColumnWidth(1),
                                          5: FlexColumnWidth(1),
                                          6: FlexColumnWidth(1),
                                        },
                                        children: [
                                          TableRow(
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${index + 1}',
                                                    style: Constant
                                                            .textStyleSize12(
                                                                context)
                                                        ?.copyWith(
                                                            color: Constant
                                                                .cBlack),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    holidays[index].name,
                                                    style: Constant
                                                            .textStyleSize12(
                                                                context)
                                                        ?.copyWith(
                                                            color: Constant
                                                                .cBlack),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${holidays[index].isMulti}',
                                                    style: Constant
                                                            .textStyleSize12(
                                                                context)
                                                        ?.copyWith(
                                                            color: Constant
                                                                .cBlack),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    Strings.action,
                                                    style: Constant
                                                            .textStyleSize12(
                                                                context)
                                                        ?.copyWith(
                                                            color: Constant
                                                                .cBlack),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: Constant
                                                            .paddingHalfHalf),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        holidayType = holidays[
                                                                        index]
                                                                    .isMulti ==
                                                                0
                                                            ? Strings
                                                                    .holidayTypeList[
                                                                0]
                                                            : Strings
                                                                .holidayTypeList[1];

                                                        holidayNameController
                                                                .text =
                                                            holidays[index]
                                                                .name;

                                                        showDialog(
                                                          context: context,
                                                          builder: ((context) {
                                                            return Material(
                                                              color: Constant
                                                                  .cBlack
                                                                  .withOpacity(
                                                                      0.1),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  right: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      8,
                                                                  left: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      8,
                                                                ),
                                                                child: Center(
                                                                    child: customDialog(
                                                                        widget
                                                                            .sizeTag,
                                                                        isView:
                                                                            true)),
                                                              ),
                                                            );
                                                          }),
                                                        );
                                                      },
                                                      child:
                                                          const CustomCardView(
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: Constant
                                                                .padding,
                                                            vertical: Constant
                                                                .paddingHalfHalf,
                                                          ),
                                                          child: Icon(
                                                            CupertinoIcons
                                                                .eye_fill,
                                                            size: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: Constant
                                                            .paddingHalfHalf),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        holidayType = holidays[
                                                                        index]
                                                                    .isMulti ==
                                                                0
                                                            ? Strings
                                                                    .holidayTypeList[
                                                                0]
                                                            : Strings
                                                                .holidayTypeList[1];

                                                        holidayNameController
                                                                .text =
                                                            holidays[index]
                                                                .name;
                                                        updateHolidayId =
                                                            holidays[index].id;

                                                        showDialog(
                                                          context: context,
                                                          builder: ((context) {
                                                            return Material(
                                                              color: Constant
                                                                  .cBlack
                                                                  .withOpacity(
                                                                      0.1),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  right: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      8,
                                                                  left: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      8,
                                                                ),
                                                                child: Center(
                                                                    child: customDialog(
                                                                        widget
                                                                            .sizeTag,
                                                                        isUpdate:
                                                                            true)),
                                                              ),
                                                            );
                                                          }),
                                                        );
                                                      },
                                                      child:
                                                          const CustomCardView(
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: Constant
                                                                .padding,
                                                            vertical: Constant
                                                                .paddingHalfHalf,
                                                          ),
                                                          child: Icon(
                                                            Icons.edit,
                                                            size: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: Constant
                                                            .paddingHalfHalf),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        updateHolidayId =
                                                            holidays[index].id;
                                                        Logger.println(
                                                            'updateHolidayId :: $updateHolidayId');
                                                        showDialog(
                                                          context: context,
                                                          builder: ((context) {
                                                            return Material(
                                                              color: Constant
                                                                  .cBlack
                                                                  .withOpacity(
                                                                      0.1),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  right: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      8,
                                                                  left: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      8,
                                                                ),
                                                                child: Center(
                                                                    child: deleteDialog(
                                                                        updateHolidayId!,
                                                                        widget
                                                                            .sizeTag)),
                                                              ),
                                                            );
                                                          }),
                                                        );
                                                      },
                                                      child:
                                                          const CustomCardView(
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: Constant
                                                                .padding,
                                                            vertical: Constant
                                                                .paddingHalfHalf,
                                                          ),
                                                          child: Icon(
                                                            CupertinoIcons
                                                                .delete_solid,
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
                                    ),
                                    index == holidays.lastIndex
                                        ? Container(
                                            height: 1,
                                            color: Constant.colorGrey,
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                );
                              }),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomContainerButton(
                    text: Strings.addHolidays,
                    textStyle: Constant.textStyleSize13(context)!.copyWith(
                      color: Constant.cWhite,
                    ),
                    color: Constant.colorSelectedIndicator,
                    width: 120,
                    height: 40,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: ((context) {
                          return Material(
                            color: Constant.cBlack.withOpacity(0.1),
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width / 8,
                                left: MediaQuery.of(context).size.width / 8,
                              ),
                              child:
                                  Center(child: customDialog(widget.sizeTag)),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget customDialog(
    int sizeTag, {
    bool isView = false,
    bool isUpdate = false,
  }) {
    return StatefulBuilder(builder: (context, setState) {
      return Wrap(
        children: [
          Container(
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
                      children: [
                        const Spacer(),
                        Text(
                          isView
                              ? Strings.viewHolidays
                              : isUpdate
                                  ? Strings.updateHolidays
                                  : Strings.addHolidays,
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
                    child: Form(
                      key: formKey,
                      autovalidateMode: autoValidateMode
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: sizeTag == 1 ? 150 : 175,
                                child: CustomFormLabel(
                                  label: Strings.holidayType,
                                  style: Constant.textStyleSize13(context)
                                      ?.copyWith(color: Constant.cBlack),
                                  isRequired: true,
                                  requiredStyle:
                                      Constant.textStyleSize14(context)
                                          ?.copyWith(color: Constant.cRed),
                                ),
                              ),
                              Constant.padding.widthBox,
                              Expanded(
                                child: SizedBox(
                                  height: sizeTag == 1 ? 65 : 30,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: Strings.holidayTypeList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Radio(
                                            value:
                                                Strings.holidayTypeList[index],
                                            groupValue: holidayType,
                                            activeColor: Constant.cBlack,
                                            onChanged: !isView
                                                ? (value) {
                                                    setState(() {
                                                      holidayType =
                                                          value!.toString();
                                                      isMulti = value ==
                                                              Strings
                                                                  .holidayTypeList[0]
                                                          ? false
                                                          : true;
                                                    });
                                                  }
                                                : (value) {},
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap),
                                        Constant.paddingHalfHalf.widthBox,
                                        Text(
                                          Strings.holidayTypeList[index],
                                          style:
                                              Constant.textStyleSize13(context)
                                                  ?.copyWith(
                                                      color: Constant.cBlack),
                                        ),
                                        const SizedBox(
                                          width: Constant.padding,
                                        )
                                        //SizedBox(width: Constant.paddingHalf),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          LabelWithTextField(
                            labelText: Strings.holidayName,
                            controller: holidayNameController,
                            validatorString: Strings.holidayNameEmpty,
                            hintText: Strings.holidayNameHint,
                            isRequired: true,
                            isEnable: isView ? false : true,
                          ),
                          Constant.padding.heightBox,
                          CustomButton(
                            height: 40,
                            width: 120,
                            text: isView ? Strings.close : Strings.submit,
                            textStyle:
                                Constant.textStyleSize14(context)?.copyWith(
                              color: Constant.cWhite,
                            ),
                            color: Constant.colorSelectedIndicator,
                            onTap: isView
                                ? () {
                                    Navigator.pop(context);
                                  }
                                : isUpdate
                                    ? () {
                                        Logger.println('isMulti :: $isMulti');
                                        if (formKey.currentState!.validate()) {
                                          BlocProvider.of<GetHolidayTypeBloc>(
                                                  context)
                                              .add(
                                            UpdateHolidayType(
                                                context: context,
                                                name:
                                                    holidayNameController.text,
                                                isMulti: isMulti ?? false,
                                                id: updateHolidayId.toString()),
                                          );
                                        }
                                      }
                                    : () {
                                        Logger.println('isMulti :: $isMulti');
                                        if (formKey.currentState!.validate()) {
                                          BlocProvider.of<AddHolidayTypeBloc>(
                                                  context)
                                              .add(
                                            AddHolidayTypeForEvent(
                                                context: context,
                                                name:
                                                    holidayNameController.text,
                                                isMulti: isMulti ?? false),
                                          );
                                        }
                                      },
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

  Widget deleteDialog(
    int id,
    int sizeTag,
  ) {
    return StatefulBuilder(builder: (context, setState) {
      return Wrap(
        children: [
          Container(
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
                      top: Constant.paddingDouble,
                      left: Constant.paddingDouble,
                      bottom: Constant.paddingDouble,
                      right: Constant.paddingDouble,
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
                                  BlocProvider.of<GetHolidayTypeBloc>(context)
                                      .add(
                                    DeleteHolidayType(
                                        context: context, id: id.toString()),
                                  );
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
