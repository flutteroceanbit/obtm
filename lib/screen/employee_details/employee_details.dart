import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/employeeCredential/employee_credential_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/employeeCredential/employee_credential_state.dart';
import 'package:oceanbit_timeclock/local_storage/my_local_storage.dart';
import 'package:oceanbit_timeclock/models/get_employee_credential_model.dart';
import 'package:oceanbit_timeclock/models/user_detail_model.dart';
import 'package:oceanbit_timeclock/widget/custom_button.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../bloc_logic/employeeCredential/employee_credential_event.dart';
import '../../constant/constant.dart';
import '../../constant/strings.dart';
import '../../utils/logger.dart';
import '../../widget/custom_drop_down_button.dart';
import '../../widget/custom_form_label.dart';
import '../../widget/custom_textfield_with_label.dart';
import '../dashboard/dashboard.dart';

class EmployeeDetails extends StatefulWidget {
  const EmployeeDetails({Key? key, this.userData}) : super(key: key);
  final UserData? userData;

  @override
  State<EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidateMode = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController emailPasswordController = TextEditingController();
  TextEditingController skypePasswordController = TextEditingController();
  TextEditingController skypeController = TextEditingController();
  CredentialData? credentialData;
  bool? isData = false;

  @override
  void initState() {
    if (widget.userData != null) {
      BlocProvider.of<EmployeeCredentialBloc>(context).add(
        GetEmployeeCredentialEvent(
            context: context, id: widget.userData?.id ?? 0),
      );
    } else {
      BlocProvider.of<EmployeeCredentialBloc>(context).add(
        GetEmployeeCredentialEvent(
            context: context, id: MyLocalStorage().getUser()?.id ?? 0),
      );
    }

    super.initState();
  }

  void getCredentialDetails() {
    nameController.text = credentialData!.name;
    emailController.text = credentialData!.email;
    emailPasswordController.text = credentialData!.emailPassword;
    skypeController.text = credentialData!.skypeName;
    skypePasswordController.text = credentialData!.skypePassword;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeCredentialBloc, EmployeeCredentialState>(
      listener: (context, state) {
        if (state is GetEmployeeCredentialLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is GetEmployeeCredentialError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is GetEmployeeCredentialLoaded) {
          credentialData = state.data!.data;
          if (credentialData != null) {
            getCredentialDetails();
          }
          isData = true;
          Logger.println('isAccount : $isData');
        }
        if (state is AddEmployeeCredentialLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is AddEmployeeCredentialError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is AddEmployeeCredentialLoaded) {
          nameController.clear();
          emailController.clear();
          emailPasswordController.clear();
          skypeController.clear();
          skypePasswordController.clear();

          isData = true;

          if (widget.userData != null) {
            BlocProvider.of<EmployeeCredentialBloc>(context).add(
              GetEmployeeCredentialEvent(
                  context: context, id: widget.userData?.id ?? 0),
            );
          } else {
            BlocProvider.of<EmployeeCredentialBloc>(context).add(
              GetEmployeeCredentialEvent(
                  context: context, id: MyLocalStorage().getUser()?.id ?? 0),
            );
          }
          Logger.println('add successful');
        }
        if (state is UpdateEmployeeCredentialLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is UpdateEmployeeCredentialError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is UpdateEmployeeCredentialLoaded) {
          nameController.clear();
          emailController.clear();
          emailPasswordController.clear();
          skypeController.clear();
          skypePasswordController.clear();

          if (widget.userData != null) {
            BlocProvider.of<EmployeeCredentialBloc>(context).add(
              GetEmployeeCredentialEvent(
                  context: context, id: widget.userData?.id ?? 0),
            );
          } else {
            BlocProvider.of<EmployeeCredentialBloc>(context).add(
              GetEmployeeCredentialEvent(
                  context: context, id: MyLocalStorage().getUser()?.id ?? 0),
            );
          }
          Logger.println('update successful');
        }
        if (state is DeleteEmployeeCredentialLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is DeleteEmployeeCredentialError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is DeleteEmployeeCredentialLoaded) {
          nameController.clear();
          emailController.clear();
          emailPasswordController.clear();
          skypeController.clear();
          skypePasswordController.clear();

          isData = false;
          credentialData = null;
          if (widget.userData != null) {
            BlocProvider.of<EmployeeCredentialBloc>(context).add(
              GetEmployeeCredentialEvent(
                  context: context, id: widget.userData?.id ?? 0),
            );
          } else {
            BlocProvider.of<EmployeeCredentialBloc>(context).add(
              GetEmployeeCredentialEvent(
                  context: context, id: MyLocalStorage().getUser()?.id ?? 0),
            );
          }
          Logger.println('delete successful');
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(
                        Constant.paddingHalf,
                      ),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: _autoValidateMode
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        child: SizedBox(
                          width: 510,
                          child: Column(
                            children: [
                              LabelWithTextField(
                                widgetWidth: 120,
                                controller: nameController,
                                labelText: Strings.name,
                                validatorString: Strings.nameEmpty,
                                hintText: Strings.nameHint,
                                isRequired: true,
                              ),
                              Constant.padding.heightBox,
                              LabelWithTextField(
                                widgetWidth: 120,
                                labelText: Strings.email,
                                controller: emailController,
                                validatorString: Strings.emailEmpty,
                                hintText: Strings.emailHint,
                                isRequired: true,
                              ),
                              Constant.padding.heightBox,
                              LabelWithTextField(
                                widgetWidth: 120,
                                labelText: Strings.emailPassword,
                                controller: emailPasswordController,
                                validatorString: Strings.emailPasswordEmpty,
                                hintText: Strings.emailPasswordHint,
                                isRequired: true,
                              ),
                              Constant.padding.heightBox,
                              LabelWithTextField(
                                widgetWidth: 120,
                                labelText: Strings.skype,
                                controller: skypeController,
                                validatorString: Strings.skypeEmpty,
                                hintText: Strings.skypeHint,
                                isRequired: true,
                              ),
                              Constant.padding.heightBox,
                              LabelWithTextField(
                                widgetWidth: 120,
                                labelText: Strings.skypePassword,
                                controller: skypePasswordController,
                                validatorString: Strings.skypePasswordEmpty,
                                hintText: Strings.skypePasswordHint,
                                isRequired: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                    BlocProvider.of<EmployeeCredentialBloc>(context).add(
                      DeleteEmployeeCredentialEvent(
                        context: context,
                        id: widget.userData!.id.toString(),
                      ),
                    );
                  } else {
                    BlocProvider.of<EmployeeCredentialBloc>(context).add(
                      DeleteEmployeeCredentialEvent(
                        context: context,
                        id: MyLocalStorage().getUser()!.id.toString(),
                      ),
                    );
                  }
                },
              ),
              Constant.padding.widthBox,
              CustomButton(
                color: Constant.colorSelectedIndicator,
                height: 35,
                width: 130,
                text: isData == true ? Strings.update : Strings.add,
                textStyle: Constant.textStyleSize13(context)!
                    .copyWith(color: Constant.cWhite),
                onTap: isData == true
                    ? () {
                        if (widget.userData != null) {
                          BlocProvider.of<EmployeeCredentialBloc>(context).add(
                            UpdateEmployeeCredentialEvent(
                                credentialData!.id,
                                widget.userData!.id ?? 1,
                                nameController.text,
                                emailController.text,
                                emailPasswordController.text,
                                skypeController.text,
                                skypePasswordController.text,
                                context: context),
                          );
                        } else {
                          BlocProvider.of<EmployeeCredentialBloc>(context).add(
                            UpdateEmployeeCredentialEvent(
                                credentialData!.id,
                                MyLocalStorage().getUser()!.id ?? 1,
                                nameController.text,
                                emailController.text,
                                emailPasswordController.text,
                                skypeController.text,
                                skypePasswordController.text,
                                context: context),
                          );
                        }
                      }
                    : () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.userData != null) {
                            BlocProvider.of<EmployeeCredentialBloc>(context)
                                .add(
                              AddEmployeeCredentialEvent(
                                  widget.userData!.id ?? 1,
                                  nameController.text,
                                  emailController.text,
                                  emailPasswordController.text,
                                  skypeController.text,
                                  skypePasswordController.text,
                                  context: context),
                            );
                          } else {
                            BlocProvider.of<EmployeeCredentialBloc>(context)
                                .add(
                              AddEmployeeCredentialEvent(
                                  MyLocalStorage().getUser()!.id ?? 1,
                                  nameController.text,
                                  emailController.text,
                                  emailPasswordController.text,
                                  skypeController.text,
                                  skypePasswordController.text,
                                  context: context),
                            );
                          }
                        } else {
                          setState(() {
                            _autoValidateMode = true;
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

  Widget customDialog(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Wrap(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constant.paddingHalf),
              color: Constant.colorSelectedIndicator,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isData == true
                              ? Strings.updateEmployeeDetail
                              : Strings.addEmployeeDetail,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Constant.cWhite),
                        ),
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
                      key: _formKey,
                      autovalidateMode: _autoValidateMode
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          LabelWithTextField(
                            widgetWidth: 120,
                            controller: nameController,
                            labelText: Strings.name,
                            validatorString: Strings.nameEmpty,
                            hintText: Strings.nameHint,
                            isRequired: true,
                          ),
                          Constant.padding.heightBox,
                          LabelWithTextField(
                            widgetWidth: 120,
                            labelText: Strings.email,
                            controller: emailController,
                            validatorString: Strings.emailEmpty,
                            hintText: Strings.emailHint,
                            isRequired: true,
                          ),
                          Constant.padding.heightBox,
                          LabelWithTextField(
                            widgetWidth: 120,
                            labelText: Strings.emailPassword,
                            controller: emailPasswordController,
                            validatorString: Strings.emailPasswordEmpty,
                            hintText: Strings.emailPasswordHint,
                            isRequired: true,
                          ),
                          Constant.padding.heightBox,
                          LabelWithTextField(
                            widgetWidth: 120,
                            labelText: Strings.skype,
                            controller: skypeController,
                            validatorString: Strings.skypeEmpty,
                            hintText: Strings.skypeHint,
                            isRequired: true,
                          ),
                          Constant.padding.heightBox,
                          LabelWithTextField(
                            widgetWidth: 120,
                            labelText: Strings.skypePassword,
                            controller: skypePasswordController,
                            validatorString: Strings.skypePasswordEmpty,
                            hintText: Strings.skypePasswordHint,
                            isRequired: true,
                          ),
                          Constant.padding.heightBox,
                          CustomButton(
                            height: 35,
                            width: 120,
                            color: Constant.colorSelectedIndicator,
                            text: Strings.submit,
                            textStyle: Constant.textStyleSize13(context)
                                ?.copyWith(color: Constant.cWhite),
                            onTap: isData == true
                                ? () {
                                    if (widget.userData != null) {
                                      BlocProvider.of<EmployeeCredentialBloc>(
                                              context)
                                          .add(
                                        UpdateEmployeeCredentialEvent(
                                            credentialData!.id,
                                            widget.userData!.id ?? 1,
                                            nameController.text,
                                            emailController.text,
                                            emailPasswordController.text,
                                            skypeController.text,
                                            skypePasswordController.text,
                                            context: context),
                                      );
                                    } else {
                                      BlocProvider.of<EmployeeCredentialBloc>(
                                              context)
                                          .add(
                                        UpdateEmployeeCredentialEvent(
                                            credentialData!.id,
                                            MyLocalStorage().getUser()!.id ?? 1,
                                            nameController.text,
                                            emailController.text,
                                            emailPasswordController.text,
                                            skypeController.text,
                                            skypePasswordController.text,
                                            context: context),
                                      );
                                    }
                                  }
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      if (widget.userData != null) {
                                        BlocProvider.of<EmployeeCredentialBloc>(
                                                context)
                                            .add(
                                          AddEmployeeCredentialEvent(
                                              widget.userData!.id ?? 1,
                                              nameController.text,
                                              emailController.text,
                                              emailPasswordController.text,
                                              skypeController.text,
                                              skypePasswordController.text,
                                              context: context),
                                        );
                                      } else {
                                        BlocProvider.of<EmployeeCredentialBloc>(
                                                context)
                                            .add(
                                          AddEmployeeCredentialEvent(
                                              MyLocalStorage().getUser()!.id ??
                                                  1,
                                              nameController.text,
                                              emailController.text,
                                              emailPasswordController.text,
                                              skypeController.text,
                                              skypePasswordController.text,
                                              context: context),
                                        );
                                      }
                                    } else {
                                      setState(() {
                                        _autoValidateMode = true;
                                      });
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
    });
  }

  Widget labelWithDropDownButton(
      {String? labelText,
      required BuildContext context,
      required String hintText,
      bool isRequired = false,
      required Function(dynamic) onChanged,
      String? validatorText,
      dynamic selectedValue,
      required List<dynamic> list}) {
    return Padding(
      padding: const EdgeInsets.only(top: Constant.paddingMidHalf),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 120,
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
            child: CustomDropDownButton(
              height: 48,
              onChanged: onChanged,
              selectedValue: selectedValue,
              hintText: hintText,
              hintStyle: (isRequired && _autoValidateMode)
                  ? Constant.textStyleSize11(context)
                      ?.copyWith(color: Constant.cRed)
                  : Constant.textStyleSize13(context)
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
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:oceanbit_timeclock/bloc_logic/employeeCredential/employee_credential_bloc.dart';
// import 'package:oceanbit_timeclock/bloc_logic/employeeCredential/employee_credential_state.dart';
// import 'package:oceanbit_timeclock/local_storage/my_local_storage.dart';
// import 'package:oceanbit_timeclock/models/get_employee_credential_model.dart';
// import 'package:oceanbit_timeclock/models/user_detail_model.dart';
// import 'package:oceanbit_timeclock/widget/custom_button.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// import '../../bloc_logic/employeeCredential/employee_credential_event.dart';
// import '../../constant/constant.dart';
// import '../../constant/strings.dart';
// import '../../widget/custom_drop_down_button.dart';
// import '../../widget/custom_form_label.dart';
// import '../../widget/custom_textfield_with_label.dart';
// import '../dashboard/dashboard.dart';
//
// class EmployeeDetails extends StatefulWidget {
//   EmployeeDetails({Key? key, this.userData}) : super(key: key);
//   UserData? userData;
//
//   @override
//   State<EmployeeDetails> createState() => _EmployeeDetailsState();
// }
//
// class _EmployeeDetailsState extends State<EmployeeDetails> {
//   GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool _autoValidateMode = false;
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController emailPasswordController = TextEditingController();
//   TextEditingController skypePasswordController = TextEditingController();
//   TextEditingController skypeController = TextEditingController();
//   CredentialData? credentialData;
//   bool? isData = false;
//
//   @override
//   void initState() {
//     if (widget.userData != null) {
//       BlocProvider.of<EmployeeCredentialBloc>(context).add(
//         GetEmployeeCredentialEvent(
//             context: context, id: widget.userData?.id ?? 0),
//       );
//     } else {
//       BlocProvider.of<EmployeeCredentialBloc>(context).add(
//         GetEmployeeCredentialEvent(
//             context: context, id: MyLocalStorage().getUser()?.id ?? 0),
//       );
//     }
//
//     super.initState();
//   }
//
//   void getCredentialDetails() {
//     nameController.text = credentialData!.name;
//     emailController.text = credentialData!.email;
//     emailPasswordController.text = credentialData!.emailPassword;
//     skypeController.text = credentialData!.skypeName;
//     skypePasswordController.text = credentialData!.skypePassword;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<EmployeeCredentialBloc, EmployeeCredentialState>(
//       listener: (context, state) {
//         if (state is GetEmployeeCredentialLoading) {
//           Constant.myLoader.show(context);
//         } else {
//           Constant.myLoader.hide();
//           setState(() {});
//         }
//         if (state is GetEmployeeCredentialError) {
//           msgList.add(Constant().ShowErrorMessage(state.errors, context));
//           Constant.myLoader.hide();
//           print('error ${state.errors}');
//           //Constant().ShowToast(state.errors, context);
//         } else if (state is GetEmployeeCredentialLoaded) {
//           credentialData = state.data!.data;
//           if (credentialData != null) {
//             getCredentialDetails();
//           }
//           isData = true;
//
//           print('isAccount : ${isData}');
//         }
//         if (state is AddEmployeeCredentialLoading) {
//           Constant.myLoader.show(context);
//         } else {
//           Constant.myLoader.hide();
//           setState(() {});
//         }
//         if (state is AddEmployeeCredentialError) {
//           msgList.add(Constant().ShowErrorMessage(state.errors, context));
//           Constant.myLoader.hide();
//           print('error ${state.errors}');
//           //Constant().ShowToast(state.errors, context);
//         } else if (state is AddEmployeeCredentialLoaded) {
//           nameController.clear();
//           emailController.clear();
//           emailPasswordController.clear();
//           skypeController.clear();
//           skypePasswordController.clear();
//
//           isData = true;
//
//           if (widget.userData != null) {
//             BlocProvider.of<EmployeeCredentialBloc>(context).add(
//               GetEmployeeCredentialEvent(
//                   context: context, id: widget.userData?.id ?? 0),
//             );
//           } else {
//             BlocProvider.of<EmployeeCredentialBloc>(context).add(
//               GetEmployeeCredentialEvent(
//                   context: context, id: MyLocalStorage().getUser()?.id ?? 0),
//             );
//           }
//           Navigator.pop(context);
//           print('add successful');
//         }
//         if (state is UpdateEmployeeCredentialLoading) {
//           Constant.myLoader.show(context);
//         } else {
//           Constant.myLoader.hide();
//           setState(() {});
//         }
//         if (state is UpdateEmployeeCredentialError) {
//           msgList.add(Constant().ShowErrorMessage(state.errors, context));
//           Constant.myLoader.hide();
//           print('error ${state.errors}');
//           //Constant().ShowToast(state.errors, context);
//         } else if (state is UpdateEmployeeCredentialLoaded) {
//           nameController.clear();
//           emailController.clear();
//           emailPasswordController.clear();
//           skypeController.clear();
//           skypePasswordController.clear();
//           Navigator.of(context).pop();
//
//           if (widget.userData != null) {
//             BlocProvider.of<EmployeeCredentialBloc>(context).add(
//               GetEmployeeCredentialEvent(
//                   context: context, id: widget.userData?.id ?? 0),
//             );
//           } else {
//             BlocProvider.of<EmployeeCredentialBloc>(context).add(
//               GetEmployeeCredentialEvent(
//                   context: context, id: MyLocalStorage().getUser()?.id ?? 0),
//             );
//           }
//           print('update successful');
//         }
//         if (state is DeleteEmployeeCredentialLoading) {
//           Constant.myLoader.show(context);
//         } else {
//           Constant.myLoader.hide();
//           setState(() {});
//         }
//         if (state is DeleteEmployeeCredentialError) {
//           msgList.add(Constant().ShowErrorMessage(state.errors, context));
//           Constant.myLoader.hide();
//           print('error ${state.errors}');
//           //Constant().ShowToast(state.errors, context);
//         } else if (state is DeleteEmployeeCredentialLoaded) {
//           nameController.clear();
//           emailController.clear();
//           emailPasswordController.clear();
//           skypeController.clear();
//           skypePasswordController.clear();
//
//           isData = false;
//           credentialData = null;
//           if (widget.userData != null) {
//             BlocProvider.of<EmployeeCredentialBloc>(context).add(
//               GetEmployeeCredentialEvent(
//                   context: context, id: widget.userData?.id ?? 0),
//             );
//           } else {
//             BlocProvider.of<EmployeeCredentialBloc>(context).add(
//               GetEmployeeCredentialEvent(
//                   context: context, id: MyLocalStorage().getUser()?.id ?? 0),
//             );
//           }
//           print('delete successful');
//         }
//       },
//       child: Column(
//         children: [
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: credentialData != null
//                       ? Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 color: Constant.cBlack.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(
//                                   Constant.paddingHalfHalf,
//                                 ),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(
//                                   Constant.paddingHalf,
//                                 ),
//                                 child: Table(
//                                   columnWidths: const {
//                                     0: FlexColumnWidth(1),
//                                     1: FlexColumnWidth(2),
//                                     2: FlexColumnWidth(3),
//                                     3: FlexColumnWidth(3),
//                                     4: FlexColumnWidth(2),
//                                     5: FlexColumnWidth(3),
//                                   },
//                                   children: [
//                                     TableRow(
//                                       children: [
//                                         Column(
//                                           children: [
//                                             Text(
//                                               Strings.number,
//                                               style: Constant.textStyleSize14(
//                                                       context)
//                                                   ?.copyWith(
//                                                 color: Constant.cBlack,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Column(
//                                           children: [
//                                             Text(
//                                               Strings.name,
//                                               style: Constant.textStyleSize14(
//                                                       context)
//                                                   ?.copyWith(
//                                                 color: Constant.cBlack,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Column(
//                                           children: [
//                                             Text(
//                                               Strings.email,
//                                               style: Constant.textStyleSize14(
//                                                       context)
//                                                   ?.copyWith(
//                                                 color: Constant.cBlack,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Column(
//                                           children: [
//                                             Text(
//                                               Strings.emailPassword,
//                                               style: Constant.textStyleSize14(
//                                                       context)
//                                                   ?.copyWith(
//                                                 color: Constant.cBlack,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Column(
//                                           children: [
//                                             Text(
//                                               Strings.skype,
//                                               style: Constant.textStyleSize14(
//                                                       context)
//                                                   ?.copyWith(
//                                                       color: Constant.cBlack),
//                                             ),
//                                           ],
//                                         ),
//                                         Column(
//                                           children: [
//                                             Text(
//                                               Strings.skypePassword,
//                                               style: Constant.textStyleSize14(
//                                                       context)
//                                                   ?.copyWith(
//                                                       color: Constant.cBlack),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             ListView.separated(
//                                 shrinkWrap: true,
//                                 itemCount: 1,
//                                 separatorBuilder:
//                                     (BuildContext context, int index) {
//                                   return Container(
//                                     height: 1,
//                                     color: Constant.colorGrey,
//                                   );
//                                 },
//                                 itemBuilder: (context, index) {
//                                   return Column(
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.all(
//                                           Constant.paddingHalf,
//                                         ),
//                                         child: Table(
//                                           columnWidths: const {
//                                             0: FlexColumnWidth(1),
//                                             1: FlexColumnWidth(2),
//                                             2: FlexColumnWidth(3),
//                                             3: FlexColumnWidth(3),
//                                             4: FlexColumnWidth(2),
//                                             5: FlexColumnWidth(3),
//                                           },
//                                           children: [
//                                             TableRow(
//                                               children: [
//                                                 Column(
//                                                   children: [
//                                                     Text(
//                                                       '${index + 1}',
//                                                       style: Constant
//                                                               .textStyleSize13(
//                                                                   context)
//                                                           ?.copyWith(
//                                                         color: Constant.cBlack,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Column(
//                                                   children: [
//                                                     Text(
//                                                       credentialData!.name,
//                                                       style: Constant
//                                                               .textStyleSize13(
//                                                                   context)
//                                                           ?.copyWith(
//                                                               color: Constant
//                                                                   .cBlack),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Column(
//                                                   children: [
//                                                     Text(
//                                                       credentialData!.email,
//                                                       style: TextStyle(
//                                                           color:
//                                                               Constant.cBlack),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Column(
//                                                   children: [
//                                                     Text(
//                                                       credentialData!
//                                                           .emailPassword,
//                                                       style: TextStyle(
//                                                           color:
//                                                               Constant.cBlack),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Column(
//                                                   children: [
//                                                     Text(
//                                                       credentialData!.skypeName,
//                                                       style: Constant
//                                                               .textStyleSize13(
//                                                                   context)
//                                                           ?.copyWith(
//                                                         color: Constant.cBlack,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Column(
//                                                   children: [
//                                                     Text(
//                                                       credentialData!
//                                                           .skypePassword,
//                                                       style: Constant
//                                                               .textStyleSize13(
//                                                                   context)
//                                                           ?.copyWith(
//                                                         color: Constant.cBlack,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       index == 2
//                                           ? Container(
//                                               height: 1,
//                                               color: Constant.colorGrey,
//                                             )
//                                           : const SizedBox.shrink(),
//                                     ],
//                                   );
//                                 }),
//                           ],
//                         )
//                       : Center(
//                           child: Text(
//                             'No Data',
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ),
//                 ),
//               ],
//             ),
//           ),
//           Constant.padding.heightBox,
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               CustomButton(
//                 color: Constant.colorSelectedIndicator,
//                 height: 35,
//                 width: 130,
//                 text: Strings.delete,
//                 textStyle: Constant.textStyleSize13(context)!
//                     .copyWith(color: Constant.cWhite),
//                 onTap: () {
//                   if (widget.userData != null) {
//                     BlocProvider.of<EmployeeCredentialBloc>(context).add(
//                       DeleteEmployeeCredentialEvent(
//                         context: context,
//                         id: widget.userData!.id.toString(),
//                       ),
//                     );
//                   } else {
//                     BlocProvider.of<EmployeeCredentialBloc>(context).add(
//                       DeleteEmployeeCredentialEvent(
//                         context: context,
//                         id: MyLocalStorage().getUser()!.id.toString(),
//                       ),
//                     );
//                   }
//                 },
//               ),
//               Constant.padding.widthBox,
//               CustomButton(
//                 color: Constant.colorSelectedIndicator,
//                 height: 35,
//                 width: 130,
//                 text: isData == true ? Strings.update : Strings.add,
//                 textStyle: Constant.textStyleSize13(context)!
//                     .copyWith(color: Constant.cWhite),
//                 onTap: isData == true
//                     ? () {
//                         nameController.text = credentialData!.name;
//                         emailController.text = credentialData!.email;
//                         emailPasswordController.text =
//                             credentialData!.emailPassword;
//                         skypeController.text = credentialData!.skypeName;
//                         skypePasswordController.text =
//                             credentialData!.skypePassword;
//
//                         showDialog(
//                           context: context,
//                           builder: ((context) {
//                             return Material(
//                               color: Constant.cBlack.withOpacity(0.1),
//                               child: Padding(
//                                 padding: EdgeInsets.only(
//                                   right: Constant.padding3x,
//                                   left: MediaQuery.of(context).size.width * 0.2,
//                                 ),
//                                 child: Center(
//                                   child: customDialog(context),
//                                 ),
//                               ),
//                             );
//                           }),
//                         );
//                       }
//                     : () {
//                         nameController.clear();
//                         emailController.clear();
//                         skypeController.clear();
//                         skypePasswordController.clear();
//                         emailPasswordController.clear();
//                         showDialog(
//                           context: context,
//                           builder: ((context) {
//                             return Material(
//                               color: Constant.cBlack.withOpacity(0.1),
//                               child: Padding(
//                                 padding: EdgeInsets.only(
//                                   right: Constant.padding3x,
//                                   left: MediaQuery.of(context).size.width * 0.2,
//                                 ),
//                                 child: Center(
//                                   child: customDialog(context),
//                                 ),
//                               ),
//                             );
//                           }),
//                         );
//                       },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget customDialog(BuildContext context) {
//     return StatefulBuilder(builder: (context, setState) {
//       return Wrap(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(Constant.paddingHalf),
//               color: Constant.colorSelectedIndicator,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(Constant.paddingHalf),
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(Constant.paddingHalf),
//                         topLeft: Radius.circular(Constant.paddingHalf),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           isData == true
//                               ? Strings.updateEmployeeDetail
//                               : Strings.addEmployeeDetail,
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleLarge!
//                               .copyWith(color: Constant.cWhite),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: const Icon(
//                             Icons.close,
//                             color: Constant.cWhite,
//                             size: 20,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Container(
//                   decoration: const BoxDecoration(
//                     color: Constant.cWhite,
//                     borderRadius: BorderRadius.only(
//                       bottomRight: Radius.circular(Constant.paddingHalf),
//                       bottomLeft: Radius.circular(Constant.paddingHalf),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                       top: Constant.padding,
//                       left: Constant.padding,
//                       bottom: Constant.padding,
//                       right: Constant.padding,
//                     ),
//                     child: Form(
//                       key: _formKey,
//                       autovalidateMode: _autoValidateMode
//                           ? AutovalidateMode.onUserInteraction
//                           : AutovalidateMode.disabled,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           LabelWithTextField(
//                             widgetWidth: 120,
//                             controller: nameController,
//                             labelText: Strings.name,
//                             validatorString: Strings.nameEmpty,
//                             hintText: Strings.nameHint,
//                             isRequired: true,
//                           ),
//                           Constant.padding.heightBox,
//                           LabelWithTextField(
//                             widgetWidth: 120,
//                             labelText: Strings.email,
//                             controller: emailController,
//                             validatorString: Strings.emailEmpty,
//                             hintText: Strings.emailHint,
//                             isRequired: true,
//                           ),
//                           Constant.padding.heightBox,
//                           LabelWithTextField(
//                             widgetWidth: 120,
//                             labelText: Strings.emailPassword,
//                             controller: emailPasswordController,
//                             validatorString: Strings.emailPasswordEmpty,
//                             hintText: Strings.emailPasswordHint,
//                             isRequired: true,
//                           ),
//                           Constant.padding.heightBox,
//                           LabelWithTextField(
//                             widgetWidth: 120,
//                             labelText: Strings.skype,
//                             controller: skypeController,
//                             validatorString: Strings.skypeEmpty,
//                             hintText: Strings.skypeHint,
//                             isRequired: true,
//                           ),
//                           Constant.padding.heightBox,
//                           LabelWithTextField(
//                             widgetWidth: 120,
//                             labelText: Strings.skypePassword,
//                             controller: skypePasswordController,
//                             validatorString: Strings.skypePasswordEmpty,
//                             hintText: Strings.skypePasswordHint,
//                             isRequired: true,
//                           ),
//                           Constant.padding.heightBox,
//                           CustomButton(
//                             height: 35,
//                             width: 120,
//                             color: Constant.colorSelectedIndicator,
//                             text: Strings.submit,
//                             textStyle: Constant.textStyleSize13(context)
//                                 ?.copyWith(color: Constant.cWhite),
//                             onTap: isData == true
//                                 ? () {
//                                     if (widget.userData != null) {
//                                       BlocProvider.of<EmployeeCredentialBloc>(
//                                               context)
//                                           .add(
//                                         UpdateEmployeeCredentialEvent(
//                                             credentialData!.id,
//                                             widget.userData!.id ?? 1,
//                                             nameController.text,
//                                             emailController.text,
//                                             emailPasswordController.text,
//                                             skypeController.text,
//                                             skypePasswordController.text,
//                                             context: context),
//                                       );
//                                     } else {
//                                       BlocProvider.of<EmployeeCredentialBloc>(
//                                               context)
//                                           .add(
//                                         UpdateEmployeeCredentialEvent(
//                                             credentialData!.id,
//                                             MyLocalStorage().getUser()!.id ?? 1,
//                                             nameController.text,
//                                             emailController.text,
//                                             emailPasswordController.text,
//                                             skypeController.text,
//                                             skypePasswordController.text,
//                                             context: context),
//                                       );
//                                     }
//                                   }
//                                 : () {
//                                     if (_formKey.currentState!.validate()) {
//                                       if (widget.userData != null) {
//                                         BlocProvider.of<EmployeeCredentialBloc>(
//                                                 context)
//                                             .add(
//                                           AddEmployeeCredentialEvent(
//                                               widget.userData!.id ?? 1,
//                                               nameController.text,
//                                               emailController.text,
//                                               emailPasswordController.text,
//                                               skypeController.text,
//                                               skypePasswordController.text,
//                                               context: context),
//                                         );
//                                       } else {
//                                         BlocProvider.of<EmployeeCredentialBloc>(
//                                                 context)
//                                             .add(
//                                           AddEmployeeCredentialEvent(
//                                               MyLocalStorage().getUser()!.id ??
//                                                   1,
//                                               nameController.text,
//                                               emailController.text,
//                                               emailPasswordController.text,
//                                               skypeController.text,
//                                               skypePasswordController.text,
//                                               context: context),
//                                         );
//                                       }
//                                     } else {
//                                       setState(() {
//                                         _autoValidateMode = true;
//                                       });
//                                     }
//                                   },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       );
//     });
//   }
//
//   Widget labelWithDropDownButton(
//       {String? labelText,
//       required BuildContext context,
//       required String hintText,
//       bool isRequired = false,
//       required Function(dynamic) onChanged,
//       String? validatorText,
//       dynamic selectedValue,
//       required List<dynamic> list}) {
//     return Padding(
//       padding: const EdgeInsets.only(top: Constant.paddingMidHalf),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           SizedBox(
//             width: 120,
//             child: CustomFormLabel(
//               label: labelText,
//               style: Constant.textStyleSize13(context)
//                   ?.copyWith(color: Constant.cBlack),
//               isRequired: isRequired,
//               requiredStyle: Constant.textStyleSize14(context)
//                   ?.copyWith(color: Constant.cRed),
//             ),
//           ),
//           //Spacer(),
//           Expanded(
//             child: CustomDropDownButton(
//               height: 48,
//               onChanged: onChanged,
//               selectedValue: selectedValue,
//               hintText: hintText,
//               hintStyle: (isRequired && _autoValidateMode)
//                   ? Constant.textStyleSize11(context)
//                       ?.copyWith(color: Constant.cRed)
//                   : Constant.textStyleSize13(context)
//                       ?.copyWith(color: Constant.cGrayDark.withOpacity(0.8)),
//               items: list,
//             ),
//           )
//           /*  (isRequired && _autoValidate)?Text(Strings.genderEmpty,style: Constant.textStyleSize12(context)?.copyWith(color:Constant.cRed),)
//               :SizedBox.shrink()*/
//         ],
//       ),
//     );
//   }
// }
