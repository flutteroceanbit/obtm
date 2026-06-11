import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oceanbit_timeclock/bloc_logic/common_repositories/preference_repository.dart';
import 'package:oceanbit_timeclock/bloc_logic/rules_bloc/rules_event.dart';
import 'package:oceanbit_timeclock/models/rules/get_rules_model.dart';
import 'package:oceanbit_timeclock/widget/custom_button.dart';
import 'package:oceanbit_timeclock/widget/new/custom_header_container.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../bloc_logic/rules_bloc/rules_bloc.dart';
import '../../bloc_logic/rules_bloc/rules_state.dart';
import '../../constant/constant.dart';
import '../../constant/strings.dart';
import '../../utils/logger.dart';
import '../../widget/custom_container_button.dart';
import '../../widget/custom_textfield_with_label.dart';
import '../dashboard/dashboard.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({Key? key}) : super(key: key);

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidateMode = false;
  TextEditingController ruleController = TextEditingController();
  List<RulesData> allRules = [];

  @override
  void initState() {
    BlocProvider.of<RulesBloc>(context).add(
      GetRules(context: context),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RulesBloc, RulesState>(
      listener: (context, state) {
        if (state is GetRulesLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is GetRulesError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is GetRulesLoaded) {
          allRules.clear();
          allRules = List.generate(
              state.data.data.length, (index) => state.data.data[index]);
        }
      },
      child: CustomHeaderContainer(
        // headerText: Strings.oceanRules,
        headerWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Strings.oceanRules,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Constant.cWhite),
            ),
            context.read<PreferenceManagerRepository>().user!.isAdmin!
                ? CustomContainerButton(
                    text: Strings.addRules,
                    textStyle: Constant.textStyleSize13(context)!.copyWith(
                      color: Constant.cBlack,
                    ),
                    color: Constant.cWhite,
                    width: 80,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: ((context) {
                          return Material(
                            color: Constant.cBlack.withOpacity(0.1),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.width / 8,
                                  left: MediaQuery.of(context).size.width / 8),
                              child: Center(
                                child: customDialog(),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  )
                : const SizedBox.shrink()
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: allRules.isEmpty
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
                  : ListView.builder(
                itemCount: allRules.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: Constant.padding),
                    child: Row(
                      children: [
                        bulletPoint(color: Constant.cBlack),
                        Constant.padding.widthBox,
                        Expanded(
                          child: Text(
                            allRules[index].rule,
                            style: Constant.textStyleSize13(context)
                                ?.copyWith(color: Constant.cBlack),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bulletPoint({Color? color}) {
    return Container(
      height: 7,
      width: 7,
      decoration:
          BoxDecoration(color: color ?? Colors.black54, shape: BoxShape.circle),
    );
  }

  Widget customDialog() {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constant.paddingHalf),
            color: Constant.cWhite,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Constant.colorSelectedIndicator,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Constant.paddingHalf),
                    topLeft: Radius.circular(Constant.paddingHalf),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Constant.paddingHalf),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Strings.addRules,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Constant.cWhite),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            color: Constant.cWhite,
                            size: 15.sp,
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
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autoValidateMode
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Constant.paddingHalf.heightBox,
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: Constant.padding,
                              left: Constant.padding,
                              bottom: Constant.padding,
                              right: MediaQuery.of(context).size.width * 0.1),
                          child: LabelWithTextField(
                            labelText: Strings.rule,
                            controller: ruleController,
                            validatorString: Strings.ruleEmpty,
                            hintText: Strings.ruleHint,
                            isRequired: true,
                          ),
                        ),
                      ),
                      Constant.padding.heightBox,
                      CustomButton(
                        height: 40,
                        width: 120,
                        text: Strings.submit,
                        textStyle: Constant.textStyleSize14(context)
                            ?.copyWith(color: Constant.cWhite),
                        color: Constant.colorSelectedIndicator,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              _autoValidateMode = true;
                            });
                          }
                        },
                      ),
                      Constant.paddingHalf.heightBox,
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
