import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/add_update_personal_detail_bloc/add_update_personal_detail_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/change_password_bloc/change_password_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/update_ui_bloc/update_ui_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/update_ui_bloc/update_ui_event.dart';
import 'package:oceanbit_timeclock/bloc_logic/user_detail_bloc/user_detail_bloc.dart';
import 'package:oceanbit_timeclock/constant/api.dart';
import 'package:oceanbit_timeclock/models/user_detail_model.dart';
import 'package:oceanbit_timeclock/widget/custom_textfield_with_label.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../bloc_logic/common_repositories/preference_repository.dart';
import '../../../bloc_logic/user_list_bloc/user_list_bloc.dart';
import '../../../constant/constant.dart';
import '../../../constant/local_key.dart';
import '../../../constant/strings.dart';
import '../../../local_storage/my_local_storage.dart';
import '../../../utils/date_formatter.dart';
import '../../../utils/logger.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_form_label.dart';
import '../../../widget/custom_text_field.dart';
import '../../../widget/new/custom_datepicker_theme.dart';
import '../../../widget/new/custom_dropdown_with_label.dart';
import '../../dashboard/dashboard.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({
    Key? key,
    this.userData,
    this.isEmployee = false,
    this.rowSegment,
    required this.isBack,
  }) : super(key: key);
  final UserData? userData;
  final bool isEmployee;
  final int? rowSegment;
  final bool isBack;

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  String? selectedGender;
  String? selectedEducation;
  String? selectedBloodGroup;
  TextEditingController fNameController = TextEditingController();
  TextEditingController mNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController fileController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController fatherOccupationController = TextEditingController();
  TextEditingController fatherBirthdateController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController aadharNumberController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  final GlobalKey<FormState> _changePasswordFormKey = GlobalKey<FormState>();
  bool _autoValidateMode = false;
  bool _autoValidate = false;
  String? chooseFileError;
  String? fileName;
  String? filePath;
  DateTime? birthDate;
  DateTime? fatherBirthDate;
  bool isGenderError = false;
  int fathersYear = 0;
  UserData? _data;
  PlatformFile? file;
  //MyLoader myLoader = MyLoader();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (context.read<PreferenceManagerRepository>().user!.isAdmin! &&
        widget.userData != null) {
      BlocProvider.of<UserDetailBloc>(context).add(
        FetchUserDetailEvent(context: context, id: "${widget.userData?.id}"),
      );
    } else {
      BlocProvider.of<UserDetailBloc>(
        context,
      ).add(FetchUserProfileEvent(context: context));
    }
    Logger.println("Data::::${widget.userData}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserDetailBloc, UserDetailState>(
          listener: (context, state) {
            if (state is UserProfileLoadingState) {
              Constant.myLoader.show(context);
            } else if (state is UserDetailLoadingState) {
              Constant.myLoader.show(context);
            } else {
              Constant.myLoader.hide();
            }
            if (state is UserProfileLoadedState) {
              _addValueToController(state.data);
              _data = state.data;
            } else if (state is UserDetailLoadedState) {
              _addValueToController(state.data);
              _data = state.data;
              if (!widget.isBack) {
                MyLocalStorage().write(
                  LocalStorageKeys.userData,
                  jsonEncode(state.data),
                );
                BlocProvider.of<UpdateUiBloc>(
                  context,
                ).add(AddUpdateUi(MyLocalStorage().getUser()!));
              }
            } else if (state is UserProfileErrorState) {
              msgList.add(Constant().ShowErrorMessage(state.error, context));
              Constant.myLoader.hide();
              Constant().ShowErrorToast(state.error, context);
            } else if (state is UserDetailErrorState) {
              msgList.add(Constant().ShowErrorMessage(state.error, context));
              Constant.myLoader.hide();
              //  Constant().ShowErrorToast(state.error, context);
            }
          },
        ),
        BlocListener<AddUpdatePersonalDetailBloc, AddUpdatePersonalDetailState>(
          listener: (context, state) {
            if (state is AddUpdatePersonalDetailLoaded) {
              if (context.read<PreferenceManagerRepository>().user?.isAdmin ==
                  true) {
                BlocProvider.of<UserDetailBloc>(context).add(
                  FetchUserDetailEvent(
                    id: state.dataModel!.data!.userId.toString(),
                    context: context,
                  ),
                );
              } else {
                BlocProvider.of<UserDetailBloc>(
                  context,
                ).add(FetchUserProfileEvent(context: context));
              }
              msgList.add(
                Constant().ShowMessage(state.dataModel!.message!, context),
              );
              Constant().show_toast('Add successfully', context);
            } else if (state is UserUpdateLoaded) {
              Logger.println(
                "Gender ::: ${selectedGender![0]} &&&&& ${_data?.personalData?.gender}",
              );
              if ((selectedGender![0] != _data?.personalData?.gender) ||
                  (selectedEducation != _data?.personalData?.education) ||
                  (mNameController.text != _data?.personalData?.middleName) ||
                  (fatherNameController.text !=
                      _data?.personalData?.fatherFullName) ||
                  (fatherOccupationController.text !=
                      _data?.personalData?.fatherOccupation) ||
                  (birthdateController.text != _data?.personalData?.dob) ||
                  (selectedBloodGroup != _data?.personalData?.bloodGroup) ||
                  (aadharNumberController.text !=
                      _data?.personalData?.aadharCard) ||
                  (panNumberController.text != _data?.personalData?.panCard)) {
                BlocProvider.of<AddUpdatePersonalDetailBloc>(context).add(
                  FetchAddUpdatePersonalDetailEvent(
                    context: context,
                    id:
                        widget.userData != null &&
                            context
                                .read<PreferenceManagerRepository>()
                                .user!
                                .isAdmin!
                        ? widget.userData!.id!
                        : context.read<PreferenceManagerRepository>().user!.id!,
                    dob: birthdateController.text,
                    gender: selectedGender!,
                    middleName: mNameController.text,
                    fatherFullName: fatherNameController.text,
                    fatherOccupation: fatherOccupationController.text,
                    bloodGroup: selectedBloodGroup,
                    aadharNumber: aadharNumberController.text,
                    panNumber: panNumberController.text,
                    education: selectedEducation,
                  ),
                );
                BlocProvider.of<UserListBloc>(
                  context,
                ).add(FetchUserListEvent(context: context));
              } else {
                Logger.println(
                  "State id 2 ::: ${_data!.personalData!.userId.toString()}",
                );
                BlocProvider.of<UserDetailBloc>(context).add(
                  FetchUserDetailEvent(
                    id: _data!.personalData!.userId.toString(),
                    context: context,
                  ),
                );
                BlocProvider.of<UserListBloc>(
                  context,
                ).add(FetchUserListEvent(context: context));
              }
              msgList.add(
                Constant().ShowMessage(state.dataModel!.message!, context),
              );
              Constant().show_toast('Update successfully', context);
            } else if (state is UserUpdateError) {
              //  Constant().ShowErrorToast(state.error, context);
              msgList.add(Constant().ShowErrorMessage(state.error, context));
              Constant.myLoader.hide();
            } else if (state is AddUpdatePersonalDetailError) {
              msgList.add(Constant().ShowErrorMessage(state.error, context));
              Constant.myLoader.hide();
              //Constant().ShowErrorToast(state.error, context);
            }
          },
        ),
        BlocListener<ChangePasswordBloc, ChangePasswordState>(
          listener: (context, state) {
            if (state is ChangePasswordLoading) {
              Constant.myLoader.show(context);
            } else {
              Constant.myLoader.hide();
            }
            if (state is ChangePasswordLoaded) {
              Navigator.pop(context);
            } else if (state is ChangePasswordError) {
              msgList.add(Constant().ShowErrorMessage(state.errors, context));
              Constant.myLoader.hide();
              Constant().ShowErrorToast(state.errors, context);
            }
          },
        ),
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(Constant.paddingHalf),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autoValidate
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: ResponsiveGridRow(
                    rowSegments: widget.rowSegment ?? 2,
                    children: [
                      ResponsiveGridCol(
                        lg: 1,
                        xs: 1,
                        md: 1,
                        sm: 1,
                        child: Padding(
                          padding: widget.rowSegment == 2
                              ? const EdgeInsets.only(
                                  right: Constant.paddingMidDoubleHalf,
                                )
                              : EdgeInsets.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LabelWithTextField(
                                controller: fNameController,
                                labelText: Strings.firstName,
                                hintText: Strings.firstNameHint,
                                isRequired: true,
                                isEnable: MyLocalStorage().getUser()!.isAdmin!
                                    ? true
                                    : false,
                                keyboardType: TextInputType.name,
                                validatorFunction: (val) {
                                  if (val!.isEmpty) {
                                    return Strings.firstNameEmpty;
                                  } else {
                                    _autoValidate = true;
                                  }
                                  return null;
                                },
                              ),
                              LabelWithTextField(
                                controller: mNameController,
                                labelText: Strings.middleName,
                                hintText: Strings.middleNameHint,
                                isRequired: false,
                                keyboardType: TextInputType.name,
                              ),
                              LabelWithTextField(
                                controller: lNameController,
                                labelText: Strings.lastName,
                                hintText: Strings.lastNameHint,
                                isRequired: true,
                                isEnable: MyLocalStorage().getUser()!.isAdmin!
                                    ? true
                                    : false,
                                keyboardType: TextInputType.name,
                                validatorFunction: (val) {
                                  if (val!.isEmpty) {
                                    return Strings.lastNameEmpty;
                                  } else {
                                    _autoValidate = true;
                                  }
                                  return null;
                                },
                              ),
                              LabelWithDropDownButton(
                                labelText: Strings.gender,
                                hintText: Strings.genderHint,
                                selectedValue: selectedGender,
                                isRequired: true,
                                list: Strings.genderList,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value.toString();
                                    if (selectedGender.isNotEmptyAndNotNull) {
                                      isGenderError = false;
                                    }
                                  });
                                },
                              ),
                              /*CustomDropDown(
                                  height: 45,
                                  width: 100,
                                  backGroundColor: Colors.blue,
                                  list: Strings.genderList,
                                  selectedValue: selectedGender!,
                                  onChange: (val) {
                                    setState(() {
                                      selectedGender = val;
                                    });
                                  },
                                ),*/
                              isGenderError
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        left: 185,
                                        top: Constant.paddingSmall,
                                      ),
                                      child: Text(
                                        Strings.genderEmpty,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.error,
                                            ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              LabelWithDropDownButton(
                                labelText: Strings.education,
                                hintText: Strings.educationHint,
                                isRequired: false,
                                selectedValue: selectedEducation,
                                list: Strings.educationList,
                                onChanged: (value) {
                                  setState(() {
                                    selectedEducation = value.toString();
                                  });
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: Constant.paddingMidHalf,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 175,
                                          child: CustomFormLabel(
                                            label: Strings.profilePicture,
                                            style: Constant.textStyleSize13(
                                              context,
                                            )?.copyWith(color: Constant.cBlack),
                                            isRequired: false,
                                            requiredStyle:
                                                Constant.textStyleSize14(
                                                  context,
                                                )?.copyWith(
                                                  color: Constant.cRed,
                                                ),
                                          ),
                                        ),
                                        //Spacer(),
                                        Constant.paddingHalf.widthBox,
                                        fileName != null
                                            ? GestureDetector(
                                                onTap:
                                                    MyLocalStorage()
                                                        .getUser()!
                                                        .isAdmin!
                                                    ? () async {
                                                        FilePickerResult?
                                                        result = await FilePicker
                                                            .platform
                                                            .pickFiles(
                                                              type: FileType
                                                                  .custom,
                                                              allowedExtensions:
                                                                  [
                                                                    'pdf',
                                                                    'jpg',
                                                                    'png',
                                                                  ],
                                                            );
                                                        if (result != null) {
                                                          PlatformFile file =
                                                              result
                                                                  .files
                                                                  .first;
                                                          filePath = file.path;
                                                          setState(() {
                                                            chooseFileError =
                                                                null;
                                                            fileName =
                                                                file.name;
                                                            fileController
                                                                    .text =
                                                                fileName!;
                                                          });
                                                        } else {
                                                          fileName = null;
                                                          filePath = null;
                                                        }
                                                      }
                                                    : () {},
                                                child: SizedBox(
                                                  height: 100,
                                                  width: 100,
                                                  child: CircleAvatar(
                                                    foregroundImage: FileImage(
                                                      File(filePath!),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CustomTextField(
                                                      controller:
                                                          fileController,
                                                      hintText:
                                                          Strings.chooseFile,
                                                      type: TextInputType.name,
                                                      isEnable: false,
                                                      onTap:
                                                          MyLocalStorage()
                                                              .getUser()!
                                                              .isAdmin!
                                                          ? () async {
                                                              FilePickerResult?
                                                              result = await FilePicker
                                                                  .platform
                                                                  .pickFiles(
                                                                    type: FileType
                                                                        .custom,
                                                                    allowedExtensions:
                                                                        [
                                                                          'pdf',
                                                                          'jpg',
                                                                          'png',
                                                                        ],
                                                                  );
                                                              if (result !=
                                                                  null) {
                                                                file = result
                                                                    .files
                                                                    .first;
                                                                filePath =
                                                                    file!.path;
                                                                setState(() {
                                                                  chooseFileError =
                                                                      null;
                                                                  fileName =
                                                                      file!
                                                                          .name;
                                                                  fileController
                                                                          .text =
                                                                      fileName!;
                                                                });
                                                              } else {
                                                                fileName = null;
                                                                filePath = null;
                                                              }
                                                            }
                                                          : () {},
                                                    ),
                                                    Constant.padding.heightBox,
                                                    _data?.imageUrl != null
                                                        ? Container(
                                                            height: 100,
                                                            width: 100,
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    10,
                                                                  ),
                                                              image: DecorationImage(
                                                                image: NetworkImage(
                                                                  '${Api.baseurl}${_data?.imageUrl}',
                                                                ),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          )
                                                        : Text(
                                                            Strings
                                                                .profilePictureInfo,
                                                            style:
                                                                Constant.textStyleSize12(
                                                                  context,
                                                                )?.copyWith(
                                                                  color: Constant
                                                                      .cBlack,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                    Constant.padding.heightBox,
                                    fileName != null
                                        ? Text(
                                            Strings.profilePictureInfo,
                                            style:
                                                Constant.textStyleSize12(
                                                  context,
                                                )?.copyWith(
                                                  color: Constant.cBlack,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        lg: 1,
                        xs: 1,
                        md: 1,
                        sm: 1,
                        child: Column(
                          children: [
                            LabelWithTextField(
                              controller: fatherNameController,
                              labelText: Strings.fatherFullName,
                              hintText: Strings.fatherFullNameHint,
                              isRequired: false,
                              keyboardType: TextInputType.name,
                            ),
                            LabelWithTextField(
                              controller: fatherOccupationController,
                              labelText: Strings.fatherOccupation,
                              hintText: Strings.fatherOccupationHint,
                              isRequired: false,
                              keyboardType: TextInputType.name,
                            ),
                            LabelWithTextField(
                              controller: birthdateController,
                              labelText: Strings.birthdate,
                              hintText: 'dd-MM-yyyy',
                              isEnable: false,
                              onTap: () async {
                                birthDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(DateTime.now().year - 1),
                                  lastDate: DateTime.now(),
                                  builder: (context, child) {
                                    return CustomDatePickerTheme(child: child!);
                                  },
                                );
                                birthdateController.text =
                                    DateFormatter.formateDate(
                                      inputFormatter: "yyyy-MM-dd 00:00:00.000",
                                      input: birthDate.toString(),
                                      outputFormatter: "dd-MM-yyyy",
                                    );
                                setState(() {});
                              },
                              validatorFunction: (val) {
                                if (val!.isEmpty) {
                                  return Strings.birthdateEmpty;
                                }
                                return null;
                              },
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       top: Constant.paddingMidHalf),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       SizedBox(
                            //         width: MediaQuery.of(context).size.width / 6,
                            //         child: CustomFormLabel(
                            //           label: Strings.fatherBirthdate,
                            //           style: Constant.textStyleSize12(context)
                            //               ?.copyWith(color: Constant.cWhite),
                            //           isRequired: true,
                            //           requiredStyle:
                            //               Constant.textStyleSize14(context)
                            //                   ?.copyWith(color: Constant.cRed),
                            //         ),
                            //       ),
                            //       //Spacer(),
                            //       Flexible(
                            //         child: Column(
                            //           mainAxisAlignment: MainAxisAlignment.start,
                            //           crossAxisAlignment: CrossAxisAlignment.start,
                            //           mainAxisSize: MainAxisSize.min,
                            //           children: [
                            //             CustomTextField(
                            //               controller: fatherBirthdateController,
                            //               hintText: Strings.fatherBirthdate,
                            //               //type: TextInputType.datetime,
                            //               isEnable: true,
                            //               onTap: () async{
                            //                 fatherBirthDate = await showDatePicker(
                            //                     context: context,
                            //                     initialDate: DateTime.now(),
                            //                     firstDate: DateTime(1900),
                            //                     lastDate: DateTime.now());
                            //                 setState(() {
                            //                   fatherBirthdateController.text =
                            //                       DateFormatter.formateDate(
                            //                         inputFormatter:
                            //                         "yyyy-MM-dd 00:00:00.000",
                            //                         input: fatherBirthDate.toString(),
                            //                         outputFormatter: "dd-MM-yyyy",
                            //                       );
                            //                   fathersYear = DateTime.now().year -
                            //                       fatherBirthDate!.year;
                            //                 });
                            //               },
                            //               validatorFunction: (val) {
                            //                 if (val!.isEmpty) {
                            //                   return Strings.fatherBirthdateEmpty;
                            //                 }
                            //                 return null;
                            //               },
                            //             ),
                            //             Text(
                            //               '$fathersYear ${Strings.yearOld}',
                            //               style: Constant.textStyleSize10(context)
                            //                   ?.copyWith(
                            //                       color: Constant.cWhite,
                            //                       fontWeight: FontWeight.w400),
                            //             )
                            //           ],
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            LabelWithDropDownButton(
                              labelText: Strings.bloodGroup,
                              hintText: Strings.bloodGroupHint,
                              isRequired: false,
                              list: Strings.bloodGroupList,
                              selectedValue: selectedBloodGroup,
                              onChanged: (value) {
                                setState(() {
                                  selectedBloodGroup = value.toString();
                                  Logger.println(
                                    'blood group value==$selectedBloodGroup',
                                  );
                                });
                              },
                            ),
                            LabelWithTextField(
                              controller: aadharNumberController,
                              labelText: Strings.aadharCardNumber,
                              hintText: Strings.aadharCardNumberHint,
                              isRequired: true,
                              keyboardType: TextInputType.number,
                              validatorFunction: (val) {
                                if (val!.isEmpty) {
                                  return Strings.aadharCardNumberEmpty;
                                } else {
                                  _autoValidate = true;
                                }
                                return null;
                              },
                            ),
                            LabelWithTextField(
                              controller: panNumberController,
                              labelText: Strings.pan,
                              hintText: Strings.panNumberHint,
                              isRequired: true,
                              keyboardType: TextInputType.text,
                              validatorFunction: (val) {
                                if (val!.isEmpty) {
                                  return Strings.panNumberEmpty;
                                } else {
                                  _autoValidate = true;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Constant.padding.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(
                color: Constant.colorSelectedIndicator,
                height: 35,
                width: 160,
                text: Strings.changesPassword,
                textStyle: Constant.textStyleSize13(
                  context,
                )!.copyWith(color: Constant.cWhite),
                radius: 5,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: ((context) {
                      return Material(
                        color: Constant.cBlack.withOpacity(0.1),
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: Constant.padding3x,
                            left: MediaQuery.of(context).size.width * 0.2,
                          ),
                          child: Center(child: customDialog(context)),
                        ),
                      );
                    }),
                  );
                },
              ),
              Constant.padding.widthBox,
              CustomButton(
                color: Constant.colorSelectedIndicator,
                height: 35,
                width: 150,
                text: Strings.saveChanges,
                textStyle: Constant.textStyleSize13(
                  context,
                )!.copyWith(color: Constant.cWhite),
                radius: 5,
                onTap: () {
                  if (selectedGender.isEmptyOrNull) {
                    setState(() {
                      isGenderError = true;
                    });
                  } else {
                    setState(() {
                      isGenderError = false;
                    });
                  }
                  if (_formKey.currentState!.validate()) {
                    Logger.println(
                      "Id ::::: ${context.read<PreferenceManagerRepository>().user!.isAdmin! ? widget.userData?.id! : context.read<PreferenceManagerRepository>().user!.id!}",
                    );
                    if (context
                                .read<PreferenceManagerRepository>()
                                .user
                                ?.isAdmin ==
                            true &&
                        ((fNameController.text != _data?.firstName) ||
                            (lNameController.text != _data?.lastName))) {
                      BlocProvider.of<AddUpdatePersonalDetailBloc>(context).add(
                        FetchUpdateUserEvent(
                          context: context,
                          id:
                              widget.userData != null &&
                                  context
                                      .read<PreferenceManagerRepository>()
                                      .user!
                                      .isAdmin!
                              ? widget.userData!.id!
                              : context
                                    .read<PreferenceManagerRepository>()
                                    .user!
                                    .id!,
                          firstName: fNameController.text,
                          lastName: lNameController.text,
                        ),
                      );
                    } else if (context
                                .read<PreferenceManagerRepository>()
                                .user
                                ?.isAdmin ==
                            true &&
                        (filePath != null)) {
                      BlocProvider.of<AddUpdatePersonalDetailBloc>(context).add(
                        FetchUpdateUserWithImageEvent(
                          filePath,
                          file,
                          context: context,
                          id:
                              widget.userData != null &&
                                  context
                                      .read<PreferenceManagerRepository>()
                                      .user!
                                      .isAdmin!
                              ? widget.userData!.id!
                              : context
                                    .read<PreferenceManagerRepository>()
                                    .user!
                                    .id!,
                          firstName: fNameController.text,
                          lastName: lNameController.text,
                        ),
                      );
                    } else {
                      BlocProvider.of<AddUpdatePersonalDetailBloc>(context).add(
                        FetchAddUpdatePersonalDetailEvent(
                          context: context,
                          id:
                              widget.userData != null &&
                                  context
                                      .read<PreferenceManagerRepository>()
                                      .user!
                                      .isAdmin!
                              ? widget.userData!.id!
                              : context
                                    .read<PreferenceManagerRepository>()
                                    .user!
                                    .id!,
                          dob: birthdateController.text,
                          gender: selectedGender!,
                          middleName: mNameController.text,
                          fatherFullName: fatherNameController.text,
                          fatherOccupation: fatherOccupationController.text,
                          bloodGroup: selectedBloodGroup,
                          aadharNumber: aadharNumberController.text,
                          panNumber: panNumberController.text,
                          education: selectedEducation,
                        ),
                      );
                    }
                    //selectedTabIndex = selectedTabIndex + 1;
                  } else {
                    _autoValidate = true;
                  }
                  setState(() {});
                },
              ),
              context.read<PreferenceManagerRepository>().user?.isAdmin ==
                          true &&
                      widget.isEmployee
                  ? Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: CustomButton(
                        color: Constant.colorSelectedIndicator,
                        radius: 5,
                        height: 35,
                        width: 130,
                        text: Strings.back,
                        textStyle: Constant.textStyleSize13(
                          context,
                        )!.copyWith(color: Constant.cWhite),
                        onTap: () {
                          setState(() {
                            BlocProvider.of<UserListBloc>(
                              context,
                            ).add(FetchUserListEvent(context: context));
                          });
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),

      /*  },
),*/
    );
  }

  Widget customDialog(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Wrap(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Constant.paddingHalf),
                color: Constant.colorSelectedIndicator,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Constant.paddingHalf),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(Constant.paddingHalf),
                          topLeft: Radius.circular(Constant.paddingHalf),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Text(
                            Strings.changePassword,
                            style: Theme.of(context).textTheme.titleLarge!
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Constant.cWhite,
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
                        key: _changePasswordFormKey,
                        autovalidateMode: _autoValidateMode
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            LabelWithTextField(
                              widgetWidth: 150,
                              controller: currentPasswordController,
                              labelText: Strings.currentPassword,
                              validatorString: Strings.currentPassword,
                              hintText: Strings.currentPassword,
                              isRequired: true,
                            ),
                            Constant.padding.heightBox,
                            LabelWithTextField(
                              widgetWidth: 150,
                              labelText: Strings.newPassword,
                              controller: newPasswordController,
                              validatorString: Strings.newPassword,
                              hintText: Strings.newPassword,
                              isRequired: true,
                            ),
                            Constant.padding.heightBox,
                            LabelWithTextField(
                              widgetWidth: 150,
                              labelText: Strings.confirmPassword,
                              controller: confirmController,
                              validatorString: Strings.confirmPassword,
                              hintText: Strings.confirmPassword,
                              isRequired: true,
                            ),
                            Constant.padding.heightBox,
                            CustomButton(
                              height: 35,
                              width: 120,
                              color: Constant.colorSelectedIndicator,
                              text: Strings.submit,
                              textStyle: Constant.textStyleSize13(
                                context,
                              )?.copyWith(color: Constant.cWhite),
                              onTap: () {
                                if (_changePasswordFormKey.currentState!
                                    .validate()) {
                                  BlocProvider.of<ChangePasswordBloc>(
                                    context,
                                  ).add(
                                    PasswordEvent(
                                      context: context,
                                      currentPassword:
                                          currentPasswordController.text,
                                      newPassword: newPasswordController.text,
                                      confirmPassword: confirmController.text,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /*Widget labelWithDropDownButton(
      {String? labelText,
      required String hintText,
      bool isRequired = false,
      required Function(dynamic) onChanged,
      String? validatorText,
      String? selectedValue,
      required List<String> list}) {
    return Padding(
      padding: const EdgeInsets.only(top: Constant.paddingMidHalf),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 175,
            child: CustomFormLabel(
              label: labelText,
              style: Constant.textStyleSize13(context)
                  ?.copyWith(color: Constant.cBlack),
              isRequired: isRequired,
              requiredStyle: Constant.textStyleSize14(context)
                  ?.copyWith(color: Constant.cRed),
            ),
          ),
          //Spacer(),
          Expanded(
            child: CustomDropDown(
              height: 48,
              list: list,
              hintText: hintText,
              selectedValue: selectedValue,
              onChange: onChanged
            ),
            */ /*child: CustomDropDownButton(
              height: 48,
              onChanged: onChanged,
              selectedValue: selectedValue,
              hintText: hintText,
              hintStyle: (isRequired && _autoValidate)
                  ? Constant.textStyleSize13(context)
                      ?.copyWith(color: Constant.cRed)
                  : Constant.textStyleSize12(context)
                      ?.copyWith(color: Constant.cGrayDark.withOpacity(0.8)),
              items: list,
            ),*/ /*
          )
          */ /*  (isRequired && _autoValidate)?Text(Strings.genderEmpty,style: Constant.textStyleSize12(context)?.copyWith(color:Constant.cRed),)
              :SizedBox.shrink()*/ /*
        ],
      ),
    );
  }*/

  void _addValueToController(UserData? data) {
    fNameController.text = data?.firstName ?? '';
    lNameController.text = data?.lastName ?? '';
    mNameController.text = data?.personalData?.middleName ?? '';
    selectedGender = data?.personalData?.gender != null
        ? data?.personalData?.gender == 'M'
              ? Strings.genderList[0]
              : Strings.genderList[1]
        : null;
    selectedEducation = data?.personalData?.education;
    selectedBloodGroup = data?.personalData?.bloodGroup;
    birthdateController.text = data?.personalData?.dob ?? '';
    fatherOccupationController.text =
        data?.personalData?.fatherOccupation ?? '';
    fatherNameController.text = data?.personalData?.fatherFullName ?? '';
    aadharNumberController.text = data?.personalData?.aadharCard ?? '';
    panNumberController.text = data?.personalData?.panCard ?? '';
    setState(() {});
  }
}
