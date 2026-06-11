import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_bank_info/get_bank_info_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_bank_info/get_bank_info_event.dart';
import 'package:oceanbit_timeclock/local_storage/my_local_storage.dart';
import 'package:oceanbit_timeclock/widget/custom_textfield_with_label.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../bloc_logic/get_bank_info/get_bank_info_state.dart';
import '../../../constant/constant.dart';
import '../../../constant/strings.dart';
import '../../../models/get_bank_info.dart';
import '../../../models/user_detail_model.dart';
import '../../../utils/logger.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/new/custom_dropdown_with_label.dart';
import '../../dashboard/dashboard.dart';

class SalaryAccount extends StatefulWidget {
  const SalaryAccount({Key? key, this.userData, this.isProfile = false})
      : super(key: key);
  final UserData? userData;
  final bool isProfile;

  @override
  State<SalaryAccount> createState() => _SalaryAccountState();
}

class _SalaryAccountState extends State<SalaryAccount> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController accountTypeController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  String? selectedAccountType;
  bool _autoValidate = false;
  bool isAccountTypeError = false;
  BankInfoData? userBankDetail;
  bool isAccount = false;

  @override
  void initState() {
    if (widget.userData != null) {
      BlocProvider.of<BankInfoBloc>(context).add(
        GetBankInfoEvent(context: context, id: widget.userData?.id ?? 0),
      );
    } else {
      BlocProvider.of<BankInfoBloc>(context).add(
        GetBankInfoEvent(
            context: context, id: MyLocalStorage().getUser()?.id ?? 0),
      );
    }

    super.initState();
  }

  void getUserBankDetails() {
    bankNameController.text = userBankDetail!.bankName;
    branchController.text = userBankDetail!.branch;
    accountNoController.text = userBankDetail!.accountNo;
    accountTypeController.text = userBankDetail!.accountType;
    ifscCodeController.text = userBankDetail!.ifscCode;
    selectedAccountType = userBankDetail!.accountType;
    Logger.println(
        'userBankDetail!.accountType: ${userBankDetail!.accountType}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BankInfoBloc, GetBankInfoState>(
      listener: (context, state) {
        if (state is GetBankInfoLoading ||
            state is AddBankInfoLoading ||
            state is UpdateBankInfoLoading ||
            state is DeleteBankInfoLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is GetBankInfoError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is GetBankInfoLoaded) {
          bankNameController.clear();
          branchController.clear();
          accountNoController.clear();
          accountTypeController.clear();
          ifscCodeController.clear();
          selectedAccountType = null;
          userBankDetail = state.data!.data;
          if (userBankDetail != null) {
            getUserBankDetails();
          }
          isAccount = true;

          Logger.println('isAccount : $isAccount');
        }
        if (state is AddBankInfoError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is AddBankInfoLoaded) {
          if (widget.userData != null) {
            BlocProvider.of<BankInfoBloc>(context).add(
              GetBankInfoEvent(context: context, id: widget.userData?.id ?? 0),
            );
          } else {
            BlocProvider.of<BankInfoBloc>(context).add(
              GetBankInfoEvent(
                  context: context, id: MyLocalStorage().getUser()?.id ?? 0),
            );
          }
          Constant().show_toast('Add Successful', context);
          Logger.println('add successful');
        }
        if (state is UpdateBankInfoError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is UpdateBankInfoLoaded) {
          if (widget.userData != null) {
            BlocProvider.of<BankInfoBloc>(context).add(
              GetBankInfoEvent(context: context, id: widget.userData?.id ?? 0),
            );
          } else {
            BlocProvider.of<BankInfoBloc>(context).add(
              GetBankInfoEvent(
                  context: context, id: MyLocalStorage().getUser()?.id ?? 0),
            );
          }
          Constant().show_toast('Update Successful', context);

          Logger.println('update successful');
        }

        if (state is DeleteBankInfoError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is DeleteBankInfoLoaded) {
          bankNameController.clear();
          branchController.clear();
          accountNoController.clear();
          accountTypeController.clear();
          ifscCodeController.clear();
          selectedAccountType = null;
          isAccount = false;
          userBankDetail = null;
          if (widget.userData != null) {
            BlocProvider.of<BankInfoBloc>(context).add(
              GetBankInfoEvent(context: context, id: widget.userData?.id ?? 0),
            );
          } else {
            BlocProvider.of<BankInfoBloc>(context).add(
              GetBankInfoEvent(
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
              child: Form(
                key: _formKey,
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  children: [
                    Container(
                      color: Constant.cWhite.withOpacity(0.1),
                      // height: 500,
                      child: Padding(
                        padding: const EdgeInsets.all(
                          Constant.paddingHalf,
                        ),
                        child: SizedBox(
                          width: 510,
                          child: Column(
                            children: [
                              LabelWithTextField(
                                controller: bankNameController,
                                labelText: Strings.bankName,
                                hintText: Strings.bankName,
                                isRequired: true,
                                keyboardType: TextInputType.name,
                                validatorFunction: (val) {
                                  if (val!.isEmpty) {
                                    return Strings.enterBankName;
                                  } else {
                                    _autoValidate = true;
                                  }
                                  return null;
                                },
                              ),
                              LabelWithTextField(
                                controller: branchController,
                                labelText: Strings.branch,
                                hintText: Strings.branch,
                                isRequired: true,
                                keyboardType: TextInputType.name,
                                validatorFunction: (val) {
                                  if (val!.isEmpty) {
                                    return Strings.enterBranch;
                                  } else {
                                    _autoValidate = true;
                                  }
                                  return null;
                                },
                              ),
                              LabelWithTextField(
                                controller: accountNoController,
                                labelText: Strings.accountNo,
                                hintText: Strings.accountNo,
                                isRequired: true,
                                keyboardType: TextInputType.name,
                                validatorFunction: (val) {
                                  if (val!.isEmpty) {
                                    return Strings.enterAccountNo;
                                  } else {
                                    _autoValidate = true;
                                  }
                                  return null;
                                },
                              ),
                              LabelWithDropDownButton(
                                labelText: Strings.accountType,
                                hintText: Strings.accountTypeHint,
                                list: Strings.accountTypeList,
                                selectedValue: selectedAccountType,
                                onChanged: (value) {
                                  setState(() {
                                    selectedAccountType = value.toString();
                                    if (selectedAccountType
                                        .isNotEmptyAndNotNull) {
                                      isAccountTypeError = false;
                                    }
                                  });
                                },
                              ),
                              isAccountTypeError
                                  ? Row(
                                      // mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 185,
                                            top: Constant.padding7,
                                          ),
                                          child: Text(
                                            Strings.enterAccountType,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error),
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                              LabelWithTextField(
                                controller: ifscCodeController,
                                labelText: Strings.ifscCode,
                                hintText: Strings.ifscCode,
                                isRequired: true,
                                keyboardType: TextInputType.name,
                                validatorFunction: (val) {
                                  if (val!.isEmpty) {
                                    return Strings.enterIfsc;
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
                    )
                  ],
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
                    BlocProvider.of<BankInfoBloc>(context).add(
                      DeleteBankInfoEvent(
                          context: context, id: widget.userData!.id.toString()),
                    );
                  } else {
                    BlocProvider.of<BankInfoBloc>(context).add(
                      DeleteBankInfoEvent(
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
                text: isAccount ? Strings.update : Strings.saveChanges,
                textStyle: Constant.textStyleSize13(context)!
                    .copyWith(color: Constant.cWhite),
                onTap: isAccount
                    ? () {
                        if (selectedAccountType.isEmptyOrNull) {
                          setState(() {
                            isAccountTypeError = true;
                          });
                        } else {
                          setState(() {
                            isAccountTypeError = false;
                          });
                        }

                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<BankInfoBloc>(context).add(
                            UpdateBankInfoEvent(
                                userBankDetail!.id,
                                userBankDetail!.userId,
                                bankNameController.text,
                                branchController.text,
                                selectedAccountType!,
                                accountNoController.text,
                                ifscCodeController.text,
                                context: context),
                          );
                        } else {
                          setState(() {
                            _autoValidate = true;
                          });
                        }
                      }
                    : () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.userData?.id != null) {
                            BlocProvider.of<BankInfoBloc>(context).add(
                              AddBankInfoEvent(
                                  widget.userData!.id ?? 1,
                                  bankNameController.text,
                                  branchController.text,
                                  selectedAccountType!,
                                  accountNoController.text,
                                  ifscCodeController.text,
                                  context: context),
                            );
                            isAccount = true;
                          } else {
                            BlocProvider.of<BankInfoBloc>(context).add(
                                AddBankInfoEvent(
                                    MyLocalStorage().getUser()!.id ?? 1,
                                    bankNameController.text,
                                    branchController.text,
                                    selectedAccountType!,
                                    accountNoController.text,
                                    ifscCodeController.text,
                                    context: context));
                            isAccount = true;
                          }
                        } else {
                          setState(() {
                            _autoValidate = true;
                          });
                        }
                      },
              ),
            ],
          )
        ],
      ),
    );
  }

  /*Widget labelWithTextField(
      {
        String? Function(String?)? validatorFunction,
        bool isEnable = true,
        String? labelText,
        TextEditingController? controller,
        String? hintText,
        bool isRequired = false,
        int maxLine = 1,
        TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(top: Constant.paddingMidHalf),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width/6.5,
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
            child: CustomTextField(
              validatorFunction: validatorFunction,
              controller: controller,
              hintText: hintText,
              type: keyboardType,
              isEnable: isEnable,
              maxLines: maxLine,
            ),
          )
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
        dynamic selectedValue,
        required List<dynamic> list}) {
    return Padding(
      padding: const EdgeInsets.only(top: Constant.paddingMidHalf),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 175,
            child: CustomFormLabel(
              label: labelText,
              style: Constant.textStyleSize12(context)
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
              onChanged:onChanged,
              selectedValue: selectedValue,
              hintText: hintText,
              hintStyle:  (isRequired && _autoValidate)?Constant.textStyleSize11(context)?.copyWith(color:Constant.cRed):
              Constant.textStyleSize11(context)
                  ?.copyWith(color: Constant.cGrayDark.withOpacity(0.8)),
              items: list,
            ),
          )
          */ /*  (isRequired && _autoValidate)?Text(Strings.genderEmpty,style: Constant.textStyleSize12(context)?.copyWith(color:Constant.cRed),)
              :SizedBox.shrink()*/ /*
        ],
      ),
    );
  }*/
}
