import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/transport_bloc/transport_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/transport_bloc/transport_event.dart';
import 'package:oceanbit_timeclock/bloc_logic/transport_bloc/transport_state.dart';
import 'package:oceanbit_timeclock/models/get_transport_model.dart';
import 'package:oceanbit_timeclock/widget/custom_textfield_with_label.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constant/constant.dart';
import '../../../constant/strings.dart';
import '../../../local_storage/my_local_storage.dart';
import '../../../models/user_detail_model.dart';
import '../../../utils/logger.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/new/custom_dropdown_with_label.dart';
import '../../dashboard/dashboard.dart';

class OtherInformation extends StatefulWidget {
  const OtherInformation({Key? key, this.userData}) : super(key: key);
  final UserData? userData;

  @override
  State<OtherInformation> createState() => _OtherInformationState();
}

class _OtherInformationState extends State<OtherInformation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String? selectedTransport;
  TextEditingController transportNumberController = TextEditingController();
  TextEditingController rcBookController = TextEditingController();
  TextEditingController transportNameController = TextEditingController();
  String? chooseFileError;
  String? fileName;
  String? filePath;
  bool isTransportNameError = false;
  TransportData? transportData;
  PlatformFile? file;

  @override
  void initState() {
    if (widget.userData != null) {
      BlocProvider.of<TransportBloc>(context).add(
        GetTransportEvent(context: context, userId: widget.userData?.id ?? 0),
      );
    } else {
      BlocProvider.of<TransportBloc>(context).add(
        GetTransportEvent(
            context: context, userId: MyLocalStorage().getUser()?.id ?? 0),
      );
    }
    super.initState();
  }

  void getTransportDetails() {
    selectedTransport = transportData!.transportName;
    transportNumberController.text = transportData!.transportNumber;
    filePath = transportData!.rcBook;
    transportNameController.text = transportData!.transportName;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransportBloc, TransportState>(
      listener: (context, state) {
        if (state is GetTransportLoading ||
            state is AddTransportLoading ||
            state is DeleteTransportLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is GetTransportError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          Constant().show_toast(state.errors, context);
        } else if (state is GetTransportLoaded) {
          transportData = state.data?.data;
          getTransportDetails();
        }

        if (state is AddTransportError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is AddTransportLoaded) {
          selectedTransport = null;
          transportNumberController.clear();
          filePath = null;
          if (widget.userData != null) {
            BlocProvider.of<TransportBloc>(context).add(
              GetTransportEvent(
                  context: context, userId: widget.userData?.id ?? 0),
            );
          } else {
            BlocProvider.of<TransportBloc>(context).add(
              GetTransportEvent(
                  context: context,
                  userId: MyLocalStorage().getUser()?.id ?? 0),
            );
          }
          Constant().show_toast('Add Successful', context);
          Logger.println('add successful');
        }
        if (state is DeleteTransportError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is DeleteTransportLoaded) {
          selectedTransport = null;
          transportNumberController.clear();
          filePath = null;
          if (widget.userData != null) {
            BlocProvider.of<TransportBloc>(context).add(
              GetTransportEvent(
                  context: context, userId: widget.userData?.id ?? 0),
            );
          } else {
            BlocProvider.of<TransportBloc>(context).add(
              GetTransportEvent(
                  context: context,
                  userId: MyLocalStorage().getUser()?.id ?? 0),
            );
          }
          transportData = null;
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
                    Padding(
                      padding: const EdgeInsets.all(
                        Constant.paddingHalf,
                      ),
                      child: SizedBox(
                        width: 510,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            transportData != null
                                ? LabelWithTextField(
                                    labelText: Strings.transportName,
                                    hintText: Strings.transportHint,
                                    controller: transportNameController,
                                    isRequired: true,
                                    isEnable: false,
                                    validatorFunction: (val) {
                                      if (val!.isEmpty) {
                                        return Strings.transportNumberEmpty;
                                      } else {
                                        _autoValidate = true;
                                      }
                                      return null;
                                    },
                                  )
                                : LabelWithDropDownButton(
                                    labelText: Strings.transportName,
                                    hintText: Strings.transportHint,
                                    isRequired: true,
                                    list: Strings.transportList,
                                    selectedValue: selectedTransport,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedTransport = value.toString();
                                        if (selectedTransport!
                                            .isNotEmptyAndNotNull) {
                                          isTransportNameError = false;
                                        }
                                      });
                                    },
                                  ),
                            isTransportNameError
                                ? Row(
                                    // mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 185,
                                          top: Constant.padding7,
                                        ),
                                        child: Text(
                                          Strings.transportNameEmpty,
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
                            selectedTransport != 'Other'
                                ? Column(
                                    children: [
                                      LabelWithTextField(
                                        controller: transportNumberController,
                                        labelText: Strings.transportNumber,
                                        hintText: Strings.transportNumberHint,
                                        isRequired: true,
                                        isEnable: transportData != null
                                            ? false
                                            : true,
                                        keyboardType: TextInputType.name,
                                        validatorFunction: (val) {
                                          if (val!.isEmpty) {
                                            return Strings.transportNumberEmpty;
                                          } else {
                                            _autoValidate = true;
                                          }
                                          return null;
                                        },
                                      ),
                                      // Constant.paddingHalf.heightBox,
                                      LabelWithTextField(
                                        isEnable: false,
                                        controller: rcBookController,
                                        labelText: Strings.rcBook,
                                        hintText: Strings.chooseFile,
                                        keyboardType: TextInputType.name,
                                        suffixIcon: GestureDetector(
                                          onTap: transportData != null
                                              ? () {}
                                              : () async {
                                                  FilePickerResult? result =
                                                      await FilePicker.platform
                                                          .pickFiles(
                                                    type: FileType.custom,
                                                    allowedExtensions: [
                                                      'pdf',
                                                      'jpg',
                                                      'png',
                                                    ],
                                                  );

                                                  if (result != null) {
                                                    file = result.files.first;
                                                    filePath = file?.path;
                                                    setState(() {
                                                      chooseFileError = null;
                                                      fileName = file?.name;
                                                      rcBookController.text =
                                                          fileName!;
                                                    });
                                                  } else {
                                                    fileName = null;
                                                    filePath = null;
                                                  }
                                                },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 1),
                                            child: Container(
                                              width: 80,
                                              height: 50,
                                              decoration: const BoxDecoration(
                                                color: Constant
                                                    .colorSelectedIndicator,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  Strings.upload,
                                                  style:
                                                      Constant.textStyleSize15(
                                                              context)
                                                          ?.copyWith(
                                                    color: Constant.cWhite,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Constant.padding.heightBox,
                                      transportData?.rcBook != null
                                          ? Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        '${Strings.transportImageBaseUrl}${transportData?.rcBook}'),
                                                    fit: BoxFit.cover,
                                                  )),
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Constant.padding.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // CustomButton(
              //   color: Constant.colorSelectedIndicator,
              //   height: 35,
              //   width: 130,
              //   text: Strings.delete,
              //   textStyle: Constant.textStyleSize13(context)!
              //       .copyWith(color: Constant.cWhite),
              //   onTap: () {
              //     BlocProvider.of<TransportBloc>(context).add(
              //       DeleteTransportEvent(
              //         context: context,
              //         id: transportData!.id.toString(),
              //       ),
              //     );
              //   },
              // ),
              Constant.padding.widthBox,
              transportData != null
                  ? const SizedBox.shrink()
                  : CustomButton(
                      color: Constant.colorSelectedIndicator,
                      height: 35,
                      width: 130,
                      radius: 5,
                      text: Strings.saveChanges,
                      textStyle: Constant.textStyleSize13(context)!.copyWith(
                        color: Constant.cWhite,
                      ),
                      onTap: () {
                        if (selectedTransport.isEmptyOrNull) {
                          setState(() {
                            isTransportNameError = true;
                          });
                        } else {
                          setState(() {
                            isTransportNameError = false;
                          });
                        }
                        if (_formKey.currentState!.validate()) {
                          Logger.println('''file Path ::: $selectedTransport!,
                      ${transportNumberController.text},
                      $filePath!,
                      $file!,
                      ${widget.userData?.id ?? 0},''');
                          if (file != null) {
                            if (widget.userData != null) {
                              BlocProvider.of<TransportBloc>(context).add(
                                AddTransportEvent(
                                    selectedTransport!,
                                    transportNumberController.text,
                                    filePath!,
                                    file!,
                                    widget.userData?.id ?? 0,
                                    context: context),
                              );
                            } else {
                              BlocProvider.of<TransportBloc>(context).add(
                                AddTransportEvent(
                                    selectedTransport!,
                                    transportNumberController.text,
                                    filePath!,
                                    file!,
                                    MyLocalStorage().getUser()?.id ?? 0,
                                    context: context),
                              );
                            }
                          } else {
                            Constant().show_toast(
                                'Please add transport photo', context);
                          }
                        } else {
                          _autoValidate = true;
                        }
                      },
                    ),
            ],
          ),
        ],
      ),
    );
  }

  /*Widget labelWithTextField(
      {String? Function(String?)? validatorFunction,
        bool isEnable = true,
        String? labelText,
        TextEditingController? controller,
        String? hintText,
        bool isRequired = false,
        TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(top: Constant.paddingMidHalf),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 175,
            child: CustomFormLabel(
              label: labelText,
              style: Constant.textStyleSize13(context)
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
            ),
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
              onChanged:onChanged,
              selectedValue: selectedValue,
              hintText: hintText,
              hintStyle:  (isRequired && _autoValidate)?Constant.textStyleSize13(context)?.copyWith(color:Constant.cRed):
              Constant.textStyleSize13(context)
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
