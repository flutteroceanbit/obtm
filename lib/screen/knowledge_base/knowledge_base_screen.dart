import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/local_storage/my_local_storage.dart';
import 'package:oceanbit_timeclock/widget/custom_button.dart';
import 'package:oceanbit_timeclock/widget/custom_container_button.dart';
import 'package:oceanbit_timeclock/widget/new/custom_header_container.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../bloc_logic/knowledge_bloc/knowledge_bloc.dart';
import '../../bloc_logic/knowledge_bloc/knowledge_event.dart';
import '../../bloc_logic/knowledge_bloc/knowledge_state.dart';
import '../../constant/constant.dart';
import '../../constant/strings.dart';
import '../../models/get_knowledge_model.dart';
import '../../utils/logger.dart';
import '../../widget/custom_drop_down_button.dart';
import '../../widget/custom_form_label.dart';
import '../../widget/custom_textfield_with_label.dart';
import '../../widget/new/custom_cardview.dart';
import '../../widget/new/custom_dropdown_with_label.dart';
import '../dashboard/dashboard.dart';

class KnowledgeBaseScreen extends StatefulWidget {
  const KnowledgeBaseScreen({Key? key, this.sizeTag}) : super(key: key);
  final int? sizeTag;

  @override
  State<KnowledgeBaseScreen> createState() => _KnowledgeBaseScreenState();
}

class _KnowledgeBaseScreenState extends State<KnowledgeBaseScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidateMode = false;
  String? selectedLanguage;
  bool isLanguageError = false;
  TextEditingController urlController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<KnowledgeData> allKnowledge = [];

  @override
  void initState() {
    BlocProvider.of<KnowledgeBloc>(context)
        .add(FetchKnowledge(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<KnowledgeBloc, KnowledgeState>(
      listener: (context, state) {
        if (state is GetKnowledgeLoading ||
            state is DeleteKnowledgeLoading ||
            state is UpdateKnowledgeLoading ||
            state is AddKnowledgeLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is GetKnowledgeError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is GetKnowledgeLoaded) {
          allKnowledge.clear();
          allKnowledge = List.generate(
              state.data.data.length, (index) => state.data.data[index]);
        }

        if (state is AddKnowledgeError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          Constant().show_toast(state.errors, context);
        } else if (state is AddKnowledgeLoaded) {
          BlocProvider.of<KnowledgeBloc>(context)
              .add(FetchKnowledge(context: context));
          Navigator.pop(context);
        }
        if (state is UpdateKnowledgeError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          Constant().show_toast(state.errors, context);
        } else if (state is UpdateKnowledgeLoaded) {
          BlocProvider.of<KnowledgeBloc>(context)
              .add(FetchKnowledge(context: context));
          Navigator.pop(context);
        }

        if (state is DeleteKnowledgeError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          // Constant().ShowToast(state.errors, context);
        } else if (state is DeleteKnowledgeLoaded) {
          BlocProvider.of<KnowledgeBloc>(context)
              .add(FetchKnowledge(context: context));
          Navigator.pop(context);
        }
      },
      child: CustomHeaderContainer(
        headerText: Strings.knowledgeBase,
        headerWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Strings.knowledgeBase,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Constant.cWhite),
            ),
            CustomContainerButton(
              width: 40,
              text: Strings.add,
              textStyle: Constant.textStyleSize13(context)!.copyWith(
                color: Constant.cBlack,
              ),
              color: Constant.cWhite,
              onTap: () {
                urlController.clear();
                selectedLanguage = null;
                titleController.clear();
                descriptionController.clear();
                isLanguageError = false;
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
                        child: Center(
                          child: customDialog(context, false),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Constant.cBlack.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                Constant.paddingHalfHalf,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                Constant.paddingHalf,
                              ),
                              child: Table(
                                columnWidths:
                                    MyLocalStorage().getUser()!.isAdmin!
                                        ? const {
                                            0: FlexColumnWidth(0.5),
                                            1: FlexColumnWidth(3),
                                            2: FlexColumnWidth(3),
                                            3: FlexColumnWidth(3),
                                            4: FlexColumnWidth(2),
                                            5: FlexColumnWidth(1),
                                            6: FlexColumnWidth(1),
                                          }
                                        : const {
                                            0: FlexColumnWidth(0.5),
                                            1: FlexColumnWidth(3),
                                            2: FlexColumnWidth(3),
                                            3: FlexColumnWidth(3),
                                            4: FlexColumnWidth(2),
                                            5: FlexColumnWidth(1),
                                          },
                                children: [
                                  TableRow(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            Strings.number,
                                            style: Constant.textStyleSize14(
                                                    context)
                                                ?.copyWith(
                                              color: Constant.cBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            Strings.title,
                                            style: Constant.textStyleSize14(
                                                    context)
                                                ?.copyWith(
                                              color: Constant.cBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            Strings.link,
                                            style: Constant.textStyleSize14(
                                                    context)
                                                ?.copyWith(
                                              color: Constant.cBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            Strings.description,
                                            style: Constant.textStyleSize14(
                                                    context)
                                                ?.copyWith(
                                                    color: Constant.cBlack),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            Strings.language,
                                            style: Constant.textStyleSize14(
                                                    context)
                                                ?.copyWith(
                                                    color: Constant.cBlack),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            Strings.update,
                                            style: Constant.textStyleSize14(
                                                    context)
                                                ?.copyWith(
                                                    color: Constant.cBlack),
                                          ),
                                        ],
                                      ),
                                      MyLocalStorage().getUser()!.isAdmin!
                                          ? Column(children: [
                                              Text(
                                                Strings.delete,
                                                style: Constant.textStyleSize14(
                                                        context)
                                                    ?.copyWith(
                                                        color: Constant.cBlack),
                                              ),
                                            ])
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          allKnowledge.isEmpty
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
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: allKnowledge.length,
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
                                            columnWidths: MyLocalStorage()
                                                    .getUser()!
                                                    .isAdmin!
                                                ? const {
                                                    0: FlexColumnWidth(0.5),
                                                    1: FlexColumnWidth(3),
                                                    2: FlexColumnWidth(3),
                                                    3: FlexColumnWidth(3),
                                                    4: FlexColumnWidth(2),
                                                    5: FlexColumnWidth(1),
                                                    6: FlexColumnWidth(1),
                                                  }
                                                : const {
                                                    0: FlexColumnWidth(0.5),
                                                    1: FlexColumnWidth(3),
                                                    2: FlexColumnWidth(3),
                                                    3: FlexColumnWidth(3),
                                                    4: FlexColumnWidth(2),
                                                    5: FlexColumnWidth(1),
                                                  },
                                            children: [
                                              TableRow(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        '${index + 1}',
                                                        style: Constant
                                                                .textStyleSize13(
                                                                    context)
                                                            ?.copyWith(
                                                          color:
                                                              Constant.cBlack,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        allKnowledge[index]
                                                            .title,
                                                        style: Constant
                                                                .textStyleSize13(
                                                                    context)
                                                            ?.copyWith(
                                                                color: Constant
                                                                    .cBlack),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          Uri url = Uri.parse(
                                                              allKnowledge[
                                                                      index]
                                                                  .link);
                                                          if (await canLaunchUrl(
                                                              url)) {
                                                            await launchUrl(
                                                                url);
                                                          } else {
                                                            msgList.add(Constant()
                                                                .ShowErrorMessage(
                                                                    'could not launch $url',
                                                                    context));
                                                            // Constant().ShowToast(
                                                            //     'could not launch $url',
                                                            //     context,
                                                            // );
                                                            throw 'could not launch $url';
                                                          }
                                                        },
                                                        child: Text(
                                                          allKnowledge[index]
                                                              .link,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: Constant
                                                                  .textStyleSize13(
                                                                      context)
                                                              ?.copyWith(
                                                                  color: Colors
                                                                      .blue),
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        allKnowledge[index]
                                                            .description,
                                                        style: Constant
                                                                .textStyleSize13(
                                                                    context)
                                                            ?.copyWith(
                                                          color:
                                                              Constant.cBlack,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        allKnowledge[index]
                                                            .language,
                                                        style: Constant
                                                                .textStyleSize13(
                                                                    context)
                                                            ?.copyWith(
                                                          color:
                                                              Constant.cBlack,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            vertical: Constant
                                                                .paddingHalfHalf),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            titleController
                                                                    .text =
                                                                allKnowledge[
                                                                        index]
                                                                    .title;
                                                            urlController.text =
                                                                allKnowledge[
                                                                        index]
                                                                    .link;
                                                            selectedLanguage =
                                                                allKnowledge[
                                                                        index]
                                                                    .language;
                                                            descriptionController
                                                                    .text =
                                                                allKnowledge[
                                                                        index]
                                                                    .description;
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  ((context) {
                                                                return Material(
                                                                  color: Constant
                                                                      .cBlack
                                                                      .withOpacity(
                                                                          0.1),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      right: Constant
                                                                          .padding3x,
                                                                      left: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.2,
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child: customDialog(
                                                                          context,
                                                                          true,
                                                                          allKnowledge[index]
                                                                              .id),
                                                                    ),
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
                                                                horizontal:
                                                                    Constant
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
                                                  MyLocalStorage()
                                                          .getUser()!
                                                          .isAdmin!
                                                      ? Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: Constant
                                                                      .paddingHalfHalf),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        ((context) {
                                                                      return Material(
                                                                        color: Constant
                                                                            .cBlack
                                                                            .withOpacity(0.1),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.only(
                                                                            right:
                                                                                MediaQuery.of(context).size.width / 8,
                                                                            left:
                                                                                MediaQuery.of(context).size.width / 8,
                                                                          ),
                                                                          child:
                                                                              Center(child: deleteDialog(allKnowledge[index].id, widget.sizeTag!)),
                                                                        ),
                                                                      );
                                                                    }),
                                                                  );
                                                                },
                                                                child:
                                                                    const CustomCardView(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          Constant
                                                                              .padding,
                                                                      vertical:
                                                                          Constant
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
                                                        )
                                                      : const SizedBox.shrink(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        index == allKnowledge.lastIndex
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget deleteDialog(
    int id,
    int sizeTag,
  ) {
    return StatefulBuilder(builder: (context, setState) {
      return Wrap(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
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
                      top: Constant.padding,
                      left: Constant.padding,
                      bottom: Constant.padding,
                      right: Constant.padding,
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
                            mainAxisSize: MainAxisSize.min,
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
                                  BlocProvider.of<KnowledgeBloc>(context).add(
                                      DeleteKnowledge(
                                          context: context, id: id.toString()));
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

  Widget customDialog(BuildContext context, bool isEdit, [int? id]) {
    return StatefulBuilder(builder: (context, setState) {
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
                          Strings.addLatestKnowledge,
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
                          LabelWithDropDownButton(
                            width: 120,
                            selectedValue: selectedLanguage,
                            isRequired: true,
                            labelText: Strings.language,
                            hintText: Strings.language,
                            onChanged: (value) {
                              setState(() {
                                selectedLanguage = value.toString();
                                if (selectedLanguage.isNotEmptyAndNotNull) {
                                  isLanguageError = false;
                                }
                              });
                            },
                            list: Strings.languageList,
                          ),
                          isLanguageError
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 132,
                                        top: Constant.paddingSmall,
                                      ),
                                      child: Text(
                                        Strings.languageEmpty,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                            ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                          Constant.padding.heightBox,
                          LabelWithTextField(
                            widgetWidth: 120,
                            controller: titleController,
                            labelText: Strings.title,
                            validatorString: Strings.titleEmpty,
                            hintText: Strings.titleHint,
                            isRequired: true,
                          ),
                          Constant.padding.heightBox,
                          LabelWithTextField(
                            widgetWidth: 120,
                            labelText: Strings.link,
                            controller: urlController,
                            validatorString: Strings.linkEmpty,
                            hintText: Strings.linkHint,
                            isRequired: true,
                          ),
                          Constant.padding.heightBox,
                          LabelWithTextField(
                            widgetWidth: 120,
                            labelText: Strings.description,
                            controller: descriptionController,
                            validatorString: Strings.descriptionEmpty,
                            hintText: Strings.descriptionHint,
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
                            onTap: () {
                              if (selectedLanguage.isEmptyOrNull) {
                                setState(() {
                                  isLanguageError = true;
                                });
                              } else {
                                setState(() {
                                  isLanguageError = false;
                                });
                              }
                              if (_formKey.currentState!.validate()) {
                                isEdit
                                    ? BlocProvider.of<KnowledgeBloc>(context)
                                        .add(UpdateKnowledge(
                                            context: context,
                                            link: urlController.text,
                                            language: selectedLanguage!,
                                            title: titleController.text,
                                            desc: descriptionController.text,
                                            id: id!))
                                    : BlocProvider.of<KnowledgeBloc>(context)
                                        .add(AddKnowledgeEvent(
                                            context: context,
                                            link: urlController.text,
                                            language: selectedLanguage!,
                                            title: titleController.text,
                                            desc: descriptionController.text,
                                            userId: MyLocalStorage()
                                                .getUser()!
                                                .id!));
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
