import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/add_update_contact_detail/add_update_contact_detail_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/add_update_contact_detail/add_update_contact_detail_state.dart';
import 'package:oceanbit_timeclock/widget/custom_textfield_with_label.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../bloc_logic/add_update_contact_detail/add_update_contact_detail_event.dart';
import '../../../bloc_logic/common_repositories/preference_repository.dart';
import '../../../bloc_logic/user_detail_bloc/user_detail_bloc.dart';
import '../../../constant/constant.dart';
import '../../../constant/strings.dart';
import '../../../models/user_detail_model.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_drop_down_button.dart';
import '../../../widget/custom_form_label.dart';
import '../../dashboard/dashboard.dart';

class ContactInfo extends StatefulWidget {
  const ContactInfo({Key? key, this.userData, required this.isEmployee})
      : super(key: key);
  final UserData? userData;
  final bool isEmployee;

  @override
  State<ContactInfo> createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  @override
  void initState() {
    !widget.isEmployee
        ? BlocProvider.of<UserDetailBloc>(context).add(FetchUserDetailEvent(
            context: context,
            id: "${context.read<PreferenceManagerRepository>().user?.id}"))
        : '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddUpdateContactDetailBloc>(
      create: (context) => AddUpdateContactDetailBloc(),
      child: ContactInfoDetail(
          userData: widget.userData, isEmployee: widget.isEmployee),
    );
  }
}

class ContactInfoDetail extends StatefulWidget {
  ContactInfoDetail({Key? key, this.userData, required this.isEmployee})
      : super(key: key);
  UserData? userData;
  bool isEmployee = false;

  @override
  State<ContactInfoDetail> createState() => _ContactInfoDetailState();
}

class _ContactInfoDetailState extends State<ContactInfoDetail> {
  TextEditingController permanentAddressController = TextEditingController();
  TextEditingController correspondAddressController = TextEditingController();
  TextEditingController cityRequiredController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController primaryPhoneNoController = TextEditingController();
  TextEditingController parentContactNoController = TextEditingController();
  TextEditingController email = TextEditingController();
  bool _autoValidate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //MyLoader myLoader = MyLoader();
  UserData? data;

  @override
  void initState() {
    addContactDataInController(data: widget.userData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddUpdateContactDetailBloc, AddUpdateContactDetailState>(
          listener: (context, state) {
            if (state is AddUpdateContactDetailLoading) {
              Constant.myLoader.show(context);
            } else {
              Constant.myLoader.hide();
            }
            if (state is AddUpdateContactDetailError) {
              msgList.add(Constant().ShowErrorMessage(state.error, context));
              Constant.myLoader.hide();
              Constant().show_toast(state.error, context);
            } else if (state is AddUpdateContactDetailLoaded) {
              msgList.add(Constant().ShowMessage(
                  state.addUpdateContactDetailModel!.message!, context));
              // Constant().ShowToast(
              //     state.addUpdateContactDetailModel!.message!, context);
              if (widget.isEmployee) {
                BlocProvider.of<UserDetailBloc>(context).add(
                    FetchUserDetailEvent(
                        id: "${widget.userData?.id}", context: context));
              } else {
                BlocProvider.of<UserDetailBloc>(context).add(FetchUserDetailEvent(
                    context: context,
                    id: "${context.read<PreferenceManagerRepository>().user?.id}"));
              }
              Constant().show_toast('AddUpdate successfully', context);
            }
          },
        ),
        BlocListener<UserDetailBloc, UserDetailState>(
            listener: (context, state) {
          if (state is UserDetailLoadingState) {
            Constant.myLoader.show(context);
          } else {
            Constant.myLoader.hide();
          }
          if (state is UserDetailErrorState) {
            msgList.add(Constant().ShowErrorMessage(state.error, context));
            Constant.myLoader.hide();
            // Constant().ShowToast(state.error, context);
          } else if (state is UserDetailLoadedState) {
            data = state.data;
            addContactDataInController(data: data);
          }
        }),
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(
                  Constant.paddingHalf,
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autoValidate
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: SizedBox(
                    width: 510,
                    child: Column(
                      children: [
                        LabelWithTextField(
                          controller: primaryPhoneNoController,
                          labelText: Strings.primaryPhoneNo,
                          hintText: Strings.primaryPhoneNoHint,
                          isRequired: true,
                          isEnable: false,
                          keyboardType: TextInputType.name,
                          validatorFunction: (val) {
                            if (val!.isEmpty) {
                              return Strings.primaryPhoneNoEmpty;
                            } else {
                              _autoValidate = true;
                            }
                            return null;
                          },
                        ),
                        LabelWithTextField(
                          controller: parentContactNoController,
                          labelText: Strings.parentsContactNo,
                          hintText: Strings.parentsContactNoHint,
                          isRequired: true,
                          keyboardType: TextInputType.number,
                          validatorFunction: (val) {
                            if (val!.isEmpty) {
                              return Strings.parentPhoneNoEmpty;
                            } else {
                              _autoValidate = true;
                            }
                            return null;
                          },
                        ),
                        LabelWithTextField(
                          controller: email,
                          labelText: Strings.alternateEmail,
                          hintText: Strings.alternateEmailHint,
                          isRequired: true,
                          keyboardType: TextInputType.number,
                          validatorFunction: (val) {
                            if (val!.isEmpty) {
                              return Strings.alternateEmailEmpty;
                            } else {
                              _autoValidate = true;
                            }
                            return null;
                          },
                        ),
                        LabelWithTextField(
                          controller: permanentAddressController,
                          labelText: Strings.permanentAddress,
                          hintText: Strings.permanentAddressHint,
                          isRequired: true,
                          maxLines: 4,
                          keyboardType: TextInputType.name,
                          validatorFunction: (val) {
                            if (val!.isEmpty) {
                              return Strings.permanentAddressEmpty;
                            } else {
                              _autoValidate = true;
                            }
                            return null;
                          },
                        ),
                        LabelWithTextField(
                          controller: correspondAddressController,
                          labelText: Strings.correspondAddress,
                          hintText: Strings.correspondAddressHint,
                          isRequired: true,
                          maxLines: 4,
                          keyboardType: TextInputType.name,
                          validatorFunction: (val) {
                            if (val!.isEmpty) {
                              return Strings.correspondAddress;
                            } else {
                              _autoValidate = true;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
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
                width: 130,
                radius: 5,
                text: Strings.saveChanges,
                textStyle: Constant.textStyleSize13(context)!
                    .copyWith(color: Constant.cWhite),
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    // Logger.println("Id :::: ${widget.userData!.id ?? 1}");
                    if (widget.isEmployee) {
                      BlocProvider.of<AddUpdateContactDetailBloc>(context).add(
                          FetchAndUpdateContactDetailEvent(
                              context: context,
                              id: widget.userData!.id!,
                              email: email.text,
                              parentsPhone: parentContactNoController.text,
                              correspondenceAddress:
                                  correspondAddressController.text,
                              permanentAddress:
                                  permanentAddressController.text));
                    } else {
                      BlocProvider.of<AddUpdateContactDetailBloc>(context).add(
                          FetchAndUpdateContactDetailEvent(
                              context: context,
                              id: context
                                  .read<PreferenceManagerRepository>()
                                  .user!
                                  .id!,
                              email: email.text,
                              parentsPhone: parentContactNoController.text,
                              correspondenceAddress:
                                  correspondAddressController.text,
                              permanentAddress:
                                  permanentAddressController.text));
                    }
                  } else {
                    setState(() {
                      _autoValidate = true;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget labelWithDropDownButton(
      {String? labelText,
      required String hintText,
      bool isRequired = false,
      required Function(dynamic) onChanged,
      String? validatorText,
      required List<dynamic> list}) {
    return Padding(
      padding: const EdgeInsets.only(top: Constant.paddingMidHalf),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 5,
            child: CustomFormLabel(
              label: labelText,
              style: Constant.textStyleSize12(context)
                  ?.copyWith(color: Constant.cWhite),
              isRequired: isRequired,
              requiredStyle: Constant.textStyleSize14(context)
                  ?.copyWith(color: Constant.cRed),
            ),
          ),
          //Spacer(),
          Expanded(
            child: CustomDropDownButton(
              onChanged: onChanged,
              //selectedValue: selectedValue,
              hintText: (isRequired && _autoValidate)
                  ? Strings.genderEmpty
                  : hintText,
              hintStyle: (isRequired && _autoValidate)
                  ? Constant.textStyleSize12(context)
                      ?.copyWith(color: Constant.cRed)
                  : Constant.textStyleSize12(context)
                      ?.copyWith(color: Constant.cGrayDark.withOpacity(0.8)),
              items: list,
            ),
          )
          /*  (isRequired && _autoValidate)?Text(Strings.genderEmpty,style: Constant.textStyleSize12(context)?.copyWith(color:Constant.cRed),)
              :SizedBox.shrink()*/
        ],
      ),
    );
  }

  addContactDataInController({UserData? data}) {
    primaryPhoneNoController.text =
        data?.phone ?? primaryPhoneNoController.text;
    email.text = data?.contactDetail?.email ?? email.text;
    parentContactNoController.text =
        data?.contactDetail?.parentsPhone ?? parentContactNoController.text;
    permanentAddressController.text = data?.contactDetail?.permanentAddress ??
        permanentAddressController.text;
    correspondAddressController.text =
        data?.contactDetail?.correspondenceAddress ??
            correspondAddressController.text;
  }
}
