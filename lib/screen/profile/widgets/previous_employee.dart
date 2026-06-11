import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/local_storage/my_local_storage.dart';
import 'package:oceanbit_timeclock/models/get_previous_employer_model.dart';
import 'package:oceanbit_timeclock/widget/custom_textfield_with_label.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../bloc_logic/previous_employer/previous_employer_bloc.dart';
import '../../../bloc_logic/previous_employer/previous_employer_event.dart';
import '../../../bloc_logic/previous_employer/previous_employer_state.dart';
import '../../../constant/constant.dart';
import '../../../constant/strings.dart';
import '../../../models/user_detail_model.dart';
import '../../../utils/logger.dart';
import '../../../widget/custom_button.dart';
import '../../dashboard/dashboard.dart';

class PreviousEmployee extends StatefulWidget {
  const PreviousEmployee({Key? key, this.userData, this.isProfile})
      : super(key: key);
  final UserData? userData;
  final bool? isProfile;

  @override
  State<PreviousEmployee> createState() => _PreviousEmployeeState();
}

class _PreviousEmployeeState extends State<PreviousEmployee> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController companyNameController = TextEditingController();
  TextEditingController profileDesignationController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController companyAddressController = TextEditingController();
  TextEditingController companyMailController = TextEditingController();
  TextEditingController companyWebsiteController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController companyContactNoController = TextEditingController();

  PreviousEmployerData? employeeDetail;
  bool isAccount = false;

  @override
  void initState() {
    Logger.println('userData : ${widget.userData}');
    if (widget.userData != null) {
      BlocProvider.of<PreviousEmployerBloc>(context).add(
        GetPreviousEmployerEvent(
            context: context, id: widget.userData?.id ?? 0),
      );
    } else {
      BlocProvider.of<PreviousEmployerBloc>(context).add(
        GetPreviousEmployerEvent(
            context: context, id: MyLocalStorage().getUser()?.id ?? 0),
      );
    }

    super.initState();
  }

  void getEmployeeDetails() {
    companyNameController.text = employeeDetail!.companyName;
    profileDesignationController.text = employeeDetail!.profileDesignation;
    salaryController.text = employeeDetail!.salaryPerYear.toString();
    companyContactNoController.text = employeeDetail!.companyContactNo;
    companyMailController.text = employeeDetail!.companyMail;
    companyWebsiteController.text = employeeDetail!.companyWebsite;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PreviousEmployerBloc, PreviousEmployerState>(
      listener: (context, state) {
        if (state is GetPreviousEmployerLoading ||
            state is AddPreviousEmployerLoading ||
            state is UpdatePreviousEmployerLoading ||
            state is DeletePreviousEmployerLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is GetPreviousEmployerError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          Constant().show_toast(state.errors, context);
        } else if (state is GetPreviousEmployerLoaded) {
          companyNameController.clear();
          profileDesignationController.clear();
          salaryController.clear();
          companyContactNoController.clear();
          companyMailController.clear();
          companyWebsiteController.clear();
          employeeDetail = state.data?.data;
          getEmployeeDetails();
          isAccount = true;
          Logger.println('isAccount : $isAccount');
        }
        if (state is AddPreviousEmployerError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          Constant().show_toast(state.errors, context);
        } else if (state is AddPreviousEmployerLoaded) {
          if (widget.userData != null) {
            BlocProvider.of<PreviousEmployerBloc>(context).add(
              GetPreviousEmployerEvent(
                  context: context, id: widget.userData?.id ?? 0),
            );
          } else {
            BlocProvider.of<PreviousEmployerBloc>(context).add(
              GetPreviousEmployerEvent(
                  context: context, id: MyLocalStorage().getUser()?.id ?? 0),
            );
          }
          Constant().show_toast('Add Successful', context);
          Logger.println('add successful');
        }
        if (state is UpdatePreviousEmployerError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is UpdatePreviousEmployerLoaded) {
          if (widget.userData != null) {
            BlocProvider.of<PreviousEmployerBloc>(context).add(
              GetPreviousEmployerEvent(
                  context: context, id: widget.userData?.id ?? 0),
            );
          } else {
            BlocProvider.of<PreviousEmployerBloc>(context).add(
              GetPreviousEmployerEvent(
                  context: context, id: MyLocalStorage().getUser()?.id ?? 0),
            );
          }
          Constant().show_toast('Update Successful', context);
          Logger.println('update successful');
        }
        if (state is DeletePreviousEmployerError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is DeletePreviousEmployerLoaded) {
          isAccount = false;
          companyNameController.clear();
          profileDesignationController.clear();
          salaryController.clear();
          companyContactNoController.clear();
          companyMailController.clear();
          companyWebsiteController.clear();
          employeeDetail = null;
          if (widget.userData != null) {
            BlocProvider.of<PreviousEmployerBloc>(context).add(
              GetPreviousEmployerEvent(
                  context: context, id: widget.userData?.id ?? 0),
            );
          } else {
            BlocProvider.of<PreviousEmployerBloc>(context).add(
              GetPreviousEmployerEvent(
                  context: context, id: MyLocalStorage().getUser()?.id ?? 0),
            );
          }
          Constant().show_toast('Delete Successful', context);
          Logger.println('delete successful');
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: 510,
                child: Padding(
                  padding: const EdgeInsets.all(
                    Constant.paddingHalf,
                  ),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _autoValidate
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LabelWithTextField(
                          controller: companyNameController,
                          labelText: Strings.companyName,
                          hintText: Strings.companyNameHint,
                          isRequired: true,
                          keyboardType: TextInputType.name,
                          validatorFunction: (val) {
                            if (val!.isEmpty) {
                              return Strings.companyNameEmpty;
                            } else {
                              _autoValidate = true;
                            }
                            return null;
                          },
                        ),
                        LabelWithTextField(
                          controller: profileDesignationController,
                          labelText: Strings.profileDesignation,
                          hintText: Strings.profileDesignationHint,
                          isRequired: true,
                          keyboardType: TextInputType.name,
                          validatorFunction: (val) {
                            if (val!.isEmpty) {
                              return Strings.profileDesignationEmpty;
                            } else {
                              _autoValidate = true;
                            }
                            return null;
                          },
                        ),
                        LabelWithTextField(
                          controller: salaryController,
                          labelText: Strings.salaryPerYear,
                          hintText: Strings.salaryPerYearHint,
                          isRequired: true,
                          keyboardType: TextInputType.number,
                          validatorFunction: (val) {
                            if (val!.isEmpty) {
                              return Strings.salaryEmpty;
                            } else {
                              _autoValidate = true;
                            }
                            return null;
                          },
                        ),
                        LabelWithTextField(
                          controller: companyMailController,
                          labelText: Strings.companyMail,
                          hintText: Strings.companyMail,
                          isRequired: true,
                          keyboardType: TextInputType.name,
                          validatorFunction: (val) {
                            if (val!.isEmpty) {
                              return Strings.companyMailEmpty;
                            } else {
                              _autoValidate = true;
                            }
                            return null;
                          },
                        ),
                        LabelWithTextField(
                          controller: companyWebsiteController,
                          labelText: Strings.companyWebSite,
                          hintText: Strings.companyWebsiteHint,
                          isRequired: true,
                          keyboardType: TextInputType.url,
                          validatorFunction: (val) {
                            if (val!.isEmpty) {
                              return Strings.companyWebsiteEmpty;
                            } else {
                              _autoValidate = true;
                            }
                            return null;
                          },
                        ),
                        // labelWithTextField(
                        //   controller: addressController,
                        //   labelText: Strings.address,
                        //   hintText: Strings.addressHint,
                        //   isRequired: true,
                        //   keyboardType: TextInputType.name,
                        //   validatorFunction: (val) {
                        //     if (val!.isEmpty) {
                        //       return Strings.salaryEmpty;
                        //     }else{
                        //       _autoValidate = true;
                        //     }
                        //     return null;
                        //   },
                        // ),
                        LabelWithTextField(
                          controller: companyContactNoController,
                          labelText: Strings.companyContactNo,
                          hintText: Strings.companyContactNoHint,
                          isRequired: true,
                          keyboardType: TextInputType.number,
                          validatorFunction: (val) {
                            if (val!.isEmpty) {
                              return Strings.companyContactEmpty;
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
                text: Strings.delete,
                textStyle: Constant.textStyleSize13(context)!
                    .copyWith(color: Constant.cWhite),
                onTap: () {
                  if (widget.userData != null) {
                    BlocProvider.of<PreviousEmployerBloc>(context).add(
                      DeletePreviousEmployerEvent(
                          context: context, id: widget.userData!.id.toString()),
                    );
                  } else {
                    BlocProvider.of<PreviousEmployerBloc>(context).add(
                      DeletePreviousEmployerEvent(
                          context: context,
                          id: MyLocalStorage().getUser()!.id.toString()),
                    );
                  }
                },
              ),
              Constant.padding.widthBox,
              CustomButton(
                color: Constant.colorSelectedIndicator,
                height: 35,
                width: 130,
                radius: 5,
                text: isAccount ? Strings.update : Strings.saveChanges,
                textStyle: Constant.textStyleSize13(context)!
                    .copyWith(color: Constant.cWhite),
                onTap: isAccount
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<PreviousEmployerBloc>(context).add(
                              UpdatePreviousEmployerEvent(
                                  employeeDetail!.id,
                                  employeeDetail!.userId,
                                  companyNameController.text,
                                  profileDesignationController.text,
                                  salaryController.text,
                                  companyMailController.text,
                                  companyWebsiteController.text,
                                  companyContactNoController.text,
                                  context: context));
                        } else {
                          setState(() {
                            _autoValidate = true;
                          });
                        }
                      }
                    : () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.userData?.id != null) {
                            BlocProvider.of<PreviousEmployerBloc>(context).add(
                                AddPreviousEmployerEvent(
                                    widget.userData!.id ?? 1,
                                    companyNameController.text,
                                    profileDesignationController.text,
                                    salaryController.text,
                                    companyMailController.text,
                                    companyWebsiteController.text,
                                    companyContactNoController.text,
                                    context: context));
                          } else {
                            BlocProvider.of<PreviousEmployerBloc>(context).add(
                                AddPreviousEmployerEvent(
                                    MyLocalStorage().getUser()!.id ?? 1,
                                    companyNameController.text,
                                    profileDesignationController.text,
                                    salaryController.text,
                                    companyMailController.text,
                                    companyWebsiteController.text,
                                    companyContactNoController.text,
                                    context: context));
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
}
