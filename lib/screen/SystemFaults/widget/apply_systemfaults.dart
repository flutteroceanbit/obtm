import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/systemfaults_bloc/systemfaults_event.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../bloc_logic/systemfaults_bloc/systemfaults_bloc.dart';
import '../../../constant/constant.dart';
import '../../../constant/strings.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_form_label.dart';
import '../../../widget/custom_text_field.dart';

class ApplySystemFaults extends StatefulWidget {
  ApplySystemFaults(
      {Key? key,
      this.sizeTag,
      required this.context,
      this.isUpdate = false,
      this.systemType = '',
      this.desc = '',
      this.id = 0})
      : super(key: key);
  int? sizeTag;
  BuildContext context;
  bool isUpdate = false;
  String systemType = '';
  String desc = '';
  int id = 0;

  @override
  State<ApplySystemFaults> createState() => _ApplySystemFaultsState();
}

class _ApplySystemFaultsState extends State<ApplySystemFaults> {
  TextEditingController descController = TextEditingController();
  TextEditingController systemTypeController = TextEditingController();

  @override
  void initState() {
    if (widget.isUpdate) {
      descController.text = widget.desc;
      systemTypeController.text = widget.systemType;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool autoValidate = false;

    return StatefulBuilder(builder: (context, setState) {
      Widget labelWithTextField(
          {String? Function(String?)? validatorFunction,
          bool isEnable = true,
          String? labelText,
          TextEditingController? controller,
          String? hintText,
          bool isRequired = false,
          int maxLines = 1,
          TextInputType? keyboardType}) {
        return Padding(
          padding: const EdgeInsets.only(top: Constant.paddingMidHalf),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: widget.sizeTag == 1 ? 150 : 180,
                child: CustomFormLabel(
                  label: labelText,
                  style: Constant.textStyleSize12(context)
                      ?.copyWith(color: Constant.cBlack),
                  isRequired: isRequired,
                  requiredStyle: Constant.textStyleSize14(context)
                      ?.copyWith(color: Constant.cRed),
                ),
              ),
              Constant.paddingHalf.widthBox,
              Expanded(
                child: CustomTextField(
                  validatorFunction: validatorFunction,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: Constant.paddingMidHalf,
                    horizontal: Constant.paddingHalf,
                  ),
                  textColor: Constant.cFontLight,
                  controller: controller,
                  hintText: hintText,
                  type: keyboardType,
                  maxLines: maxLines,
                  isEnable: isEnable,
                ),
              ),
            ],
          ),
        );
      }

      return Material(
        color: Colors.black.withOpacity(0.2),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.15,
            // vertical: 270,
          ),
          child: Center(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(Constant.paddingHalf),
                        topLeft: Radius.circular(Constant.paddingHalf)),
                    color: Constant.colorSelectedIndicator,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Constant.paddingHalf),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        const Icon(Icons.list_alt_sharp,
                            color: Constant.cWhite),
                        Constant.paddingHalfHalf.widthBox,
                        Text(
                          widget.isUpdate
                              ? Strings.updateFault.toUpperCase()
                              : Strings.applyFault.toUpperCase(),
                          style: Constant.textStyleSize14(context)
                              ?.copyWith(color: Constant.cWhite),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.close,
                            color: Constant.cWhite,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(Constant.paddingHalf),
                        bottomRight: Radius.circular(Constant.paddingHalf)),
                    color: Constant.cWhite,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Constant.paddingMidHalf),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: formKey,
                          autovalidateMode: autoValidate
                              ? AutovalidateMode.onUserInteraction
                              : AutovalidateMode.disabled,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              labelWithTextField(
                                controller: systemTypeController,
                                labelText: Strings.systemType,
                                hintText: Strings.systemTypeHint,
                                maxLines: 1,
                                isRequired: true,
                                keyboardType: TextInputType.name,
                                validatorFunction: (val) {
                                  if (val!.isEmpty) {
                                    return Strings.systemTypeEmpty;
                                  } else {
                                    autoValidate = true;
                                  }
                                  return null;
                                },
                              ),
                              labelWithTextField(
                                controller: descController,
                                labelText: Strings.description,
                                hintText: Strings.descriptionHint,
                                maxLines: 3,
                                isRequired: true,
                                keyboardType: TextInputType.name,
                                validatorFunction: (val) {
                                  if (val!.isEmpty) {
                                    return Strings.descriptionEmpty;
                                  } else {
                                    autoValidate = true;
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        Constant.paddingMidDouble.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                              color: Constant.colorSelectedIndicator,
                              textStyle: Constant.textStyleSize10(context)!
                                  .copyWith(color: Constant.cWhite),
                              height: 40,
                              width: 130,
                              text: widget.isUpdate
                                  ? Strings.update
                                  : Strings.apply,
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  widget.isUpdate
                                      ? BlocProvider.of<SystemFaultBloc>(
                                              context)
                                          .add(UpdateSystemFaultEvent(
                                              widget.id,
                                              systemTypeController.text,
                                              descController.text,
                                              context: context))
                                      : BlocProvider.of<SystemFaultBloc>(
                                              context)
                                          .add(AddSystemFaultEvent(
                                              systemTypeController.text,
                                              descController.text,
                                              context: context));
                                } else {
                                  autoValidate = true;
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
