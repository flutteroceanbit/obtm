import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/constant/constant.dart';
import 'package:oceanbit_timeclock/widget/new/custom_header_container.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../bloc_logic/quote_bloc/quote_bloc.dart';
import '../../bloc_logic/quote_bloc/quote_event.dart';
import '../../bloc_logic/quote_bloc/quote_state.dart';
import '../../constant/strings.dart';
import '../../models/quotes/get_quotes_model.dart';
import '../../utils/logger.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_container_button.dart';
import '../../widget/custom_textfield_with_label.dart';
import '../../widget/new/custom_cardview.dart';
import '../dashboard/dashboard.dart';

class AdminQuotesScreen extends StatefulWidget {
  const AdminQuotesScreen({Key? key, required this.sizeTag}) : super(key: key);
  final int sizeTag;

  @override
  State<AdminQuotesScreen> createState() => _AdminQuotesScreenState();
}

class _AdminQuotesScreenState extends State<AdminQuotesScreen> {
  TextEditingController quoteController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidateMode = false;
  List<QuoteData> allQuotes = [];
  int selectedQuoteId = 0;

  @override
  void initState() {
    BlocProvider.of<MyQuoteBloc>(context).add(GetQuoteEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyQuoteBloc, QuoteState>(
      listener: (context, state) {
        if (state is GetQuoteLoading ||
            state is UpdateQuoteLoading ||
            state is DeleteQuoteLoading ||
            state is AddQuoteLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is GetQuoteError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is GetQuoteLoaded) {
          allQuotes.clear();
          allQuotes = List.generate(
              state.data.data.length, (index) => state.data.data[index]);
          Logger.println("Quote data  2:${state.data.data}");
        }
        if (state is UpdateQuoteError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is UpdateQuoteLoaded) {
          Navigator.pop(context);
          quoteController.clear();
          BlocProvider.of<MyQuoteBloc>(context)
              .add(GetQuoteEvent(context: context));
        }

        if (state is DeleteQuoteError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is DeleteQuoteLoaded) {
          Navigator.pop(context);
          allQuotes.clear();
          BlocProvider.of<MyQuoteBloc>(context)
              .add(GetQuoteEvent(context: context));
        }
        if (state is AddQuoteError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is AddQuoteLoaded) {
          Navigator.pop(context);
          BlocProvider.of<MyQuoteBloc>(context)
              .add(GetQuoteEvent(context: context));
        }
      },
      child: CustomHeaderContainer(
        headerWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              Strings.oceanQuotes,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Constant.cWhite),
            ),
            CustomContainerButton(
              text: Strings.addQuotes,
              textStyle: Constant.textStyleSize13(context)!.copyWith(
                color: Constant.cBlack,
              ),
              color: Constant.cWhite,
              width: 120,
              onTap: () {
                quoteController.clear();
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
                        child: Center(
                            child: customDialog(
                          widget.sizeTag,
                        )),
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
                                columnWidths: const {
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(7),
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
                                            Strings.quoteString,
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
                                            Strings.update,
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
                                            Strings.delete,
                                            style: Constant.textStyleSize14(
                                                    context)
                                                ?.copyWith(
                                                    color: Constant.cBlack),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          allQuotes.isEmpty
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
                                  itemCount: allQuotes.length,
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
                                              0: FlexColumnWidth(1),
                                              1: FlexColumnWidth(7),
                                              2: FlexColumnWidth(1),
                                              3: FlexColumnWidth(1),
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        allQuotes[index].quotes,
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
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            vertical: Constant
                                                                .paddingHalfHalf),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            quoteController
                                                                    .text =
                                                                allQuotes[index]
                                                                    .quotes;

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
                                                                      right: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          8,
                                                                      left: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          8,
                                                                    ),
                                                                    child: Center(
                                                                        child: customDialog(
                                                                            widget
                                                                                .sizeTag,
                                                                            isUpdate:
                                                                                true,
                                                                            id: allQuotes[index].id)),
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
                                                            int updateId =
                                                                allQuotes[index]
                                                                    .id;

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
                                                                      right: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          8,
                                                                      left: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          8,
                                                                    ),
                                                                    child: Center(
                                                                        child: deleteDialog(
                                                                            updateId,
                                                                            widget.sizeTag)),
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
                                        index == allQuotes.lastIndex
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
                            'Are you sure to delete this Quotes type?',
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
                                  BlocProvider.of<MyQuoteBloc>(context).add(
                                    DeleteQuote(
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

  Widget customDialog(
    int sizeTag, {
    isUpdate = false,
    int? id,
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
                          isUpdate ? Strings.updateQuotes : Strings.addQuotes,
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
                            labelText: Strings.quoteString,
                            controller: quoteController,
                            validatorString: Strings.quoteEmpty,
                            hintText: Strings.quoteHint,
                            isRequired: true,
                            maxLines: 1,
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
                                ? (() {
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<MyQuoteBloc>(context).add(
                                        UpdateQuote(
                                            context: context,
                                            id: id!,
                                            quotes: quoteController.text),
                                      );
                                    } else {
                                      setState(() {
                                        _autoValidateMode = true;
                                      });
                                    }
                                  })
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<MyQuoteBloc>(context).add(
                                        AddQuoteEvent(
                                            context: context,
                                            quotes: quoteController.text),
                                      );
                                    } else {
                                      setState(() {
                                        _autoValidateMode = true;
                                      });
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
}
