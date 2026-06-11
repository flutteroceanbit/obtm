import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../bloc_logic/department_bloc/department_bloc.dart';
import '../../bloc_logic/department_bloc/department_event.dart';
import '../../bloc_logic/department_bloc/department_state.dart';
import '../../bloc_logic/update_ui_bloc/update_ui_bloc.dart';
import '../../bloc_logic/update_ui_bloc/update_ui_event.dart';
import '../../constant/constant.dart';
import '../../constant/strings.dart';
import '../../utils/logger.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_container_button.dart';
import '../../widget/custom_textfield_with_label.dart';
import '../../widget/new/custom_cardview.dart';
import '../../widget/new/custom_header_container.dart';
import '../dashboard/dashboard.dart';

class DepartmentScreen extends StatefulWidget {
  DepartmentScreen({Key? key, required int sizeTag}) : super(key: key);
  int sizeTag = 1;

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

TextEditingController nameController = TextEditingController();
GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool _autoValidateMode = false;
List departments = [];
int? updateDepartmentId;

class _DepartmentScreenState extends State<DepartmentScreen> {
  @override
  void initState() {
    BlocProvider.of<MyDepartmentBloc>(context)
        .add(GetDepartmentEvent(context: context));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyDepartmentBloc, DepartmentState>(
      listener: (context, state) {
        /// get
        if (state is GetDepartmentLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }

        if (state is GetDepartmentError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is GetDepartmentLoaded) {
          departments.clear();

          departments = List.generate(
              state.data.data.length, (index) => state.data.data[index]);
        }

        /// add

        if (state is AddDepartmentLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is AddDepartmentError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is AddDepartmentLoaded) {
          Navigator.pop(context);
          nameController.clear();
          BlocProvider.of<MyDepartmentBloc>(context)
              .add(GetDepartmentEvent(context: context));
        }

        /// update

        if (state is UpdateDepartmentLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is UpdateDepartmentError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is UpdateDepartmentLoaded) {
          Navigator.pop(context);
          nameController.clear();
          BlocProvider.of<MyDepartmentBloc>(context)
              .add(GetDepartmentEvent(context: context));
        }

        /// delete

        if (state is DeleteDepartmentLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is DeleteDepartmentError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is DeleteDepartmentLoaded) {
          Navigator.pop(context);
          nameController.clear();
          BlocProvider.of<MyDepartmentBloc>(context)
              .add(GetDepartmentEvent(context: context));
        }
      },
      child: CustomHeaderContainer(
        headerWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              Strings.department,
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
        child: Column(
          children: [
            Expanded(
              flex: 11,
              child: SingleChildScrollView(
                child: Column(
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
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
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
                                      Strings.departmentsName,
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
                    departments.isEmpty
                        ? const Center(
                            child: Text(
                              'No Data',
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: departments.length,
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
                                        2: FlexColumnWidth(1),
                                        3: FlexColumnWidth(1),
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
                                                  style:
                                                      Constant.textStyleSize12(
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
                                                  departments[index].name,
                                                  style:
                                                      Constant.textStyleSize12(
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
                                                      nameController.text =
                                                          departments[index]
                                                              .name;
                                                      updateDepartmentId =
                                                          departments[index].id;

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
                                                    child: const CustomCardView(
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal:
                                                              Constant.padding,
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
                                                      updateDepartmentId =
                                                          departments[index].id;
                                                      Logger.println(
                                                          'updateDepartmentId :: $updateDepartmentId');
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
                                                                      updateDepartmentId!,
                                                                      widget
                                                                          .sizeTag)),
                                                            ),
                                                          );
                                                        }),
                                                      );
                                                    },
                                                    child: const CustomCardView(
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal:
                                                              Constant.padding,
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
                                  index == departments.lastIndex
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
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomContainerButton(
                  text: Strings.addDepartments,
                  textStyle: Constant.textStyleSize13(context)!.copyWith(
                    color: Constant.cWhite,
                  ),
                  color: Constant.colorSelectedIndicator,
                  width: 150,
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
                            child: Center(child: customDialog(widget.sizeTag)),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget customDialog(
    int sizeTag, {
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
                          isUpdate
                              ? Strings.updateDepartments
                              : Strings.addDepartments,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Constant.cWhite),
                        ),
                        const Spacer(),
                        GestureDetector(
                            onTap: () {
                              nameController.clear();
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
                      key: _formKey,
                      autovalidateMode: _autoValidateMode
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          LabelWithTextField(
                            labelText: Strings.departmentsName,
                            controller: nameController,
                            validatorString: Strings.departmentEmpty,
                            hintText: Strings.departmentsName,
                            isRequired: true,
                          ),
                          Constant.padding.heightBox,
                          CustomButton(
                            height: 40,
                            width: 120,
                            text: Strings.submit,
                            textStyle:
                                Constant.textStyleSize14(context)?.copyWith(
                              color: Constant.cWhite,
                            ),
                            color: Constant.colorSelectedIndicator,
                            onTap: isUpdate
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<MyDepartmentBloc>(context)
                                          .add(
                                        UpdateDepartment(
                                          context: context,
                                          name: nameController.text,
                                          id: updateDepartmentId!,
                                        ),
                                      );
                                    }
                                  }
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<MyDepartmentBloc>(context)
                                          .add(
                                        AddDepartmentEvent(
                                          context: context,
                                          name: nameController.text,
                                        ),
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
                            'Are you sure to delete this Department type?',
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
                                  BlocProvider.of<MyDepartmentBloc>(context)
                                      .add(
                                    DeleteDepartment(
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
