import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:oceanbit_timeclock/bloc_logic/reviews_bloc/reviews_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/reviews_bloc/reviews_event.dart';
import 'package:oceanbit_timeclock/bloc_logic/reviews_bloc/reviews_state.dart';
import 'package:oceanbit_timeclock/constant/constant.dart';
import 'package:oceanbit_timeclock/widget/new/custom_header_container.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constant/strings.dart';
import '../../models/review/get_all_employee_review_model.dart';
import '../../utils/date_formatter.dart';
import '../../utils/logger.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/custom_textfield_with_label.dart';
import '../../widget/new/custom_datepicker_theme.dart';
import '../dashboard/dashboard.dart';

class AdminReviewScreen extends StatefulWidget {
  const AdminReviewScreen({Key? key, required this.sizeTag}) : super(key: key);
  final int sizeTag;

  @override
  State<AdminReviewScreen> createState() => _AdminReviewScreenState();
}

class _AdminReviewScreenState extends State<AdminReviewScreen> {
  TextEditingController messageController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  List<AllReviewData> allReview = [];
  bool behavior = false;
  bool socialMedia = false;
  bool taskCompletion = false;

  Future<void> viewVisible() async {
    BlocProvider.of<MyReviewBloc>(
      context,
    ).add(GetReviewEvent(context: context));
  }

  @override
  void initState() {
    viewVisible();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MyReviewBloc, ReviewState>(
          listener: (context, state) {
            if (state is GetReviewLoading ||
                state is AddReviewLoading ||
                state is DeleteReviewLoading) {
              Constant.myLoader.show(context);
            } else {
              Constant.myLoader.hide();
              setState(() {});
            }
            if (state is GetReviewError) {
              msgList.add(Constant().ShowErrorMessage(state.errors, context));
              Constant.myLoader.hide();
              Logger.println('error ${state.errors}');
              //Constant().ShowToast(state.errors, context);
            } else if (state is GetReviewLoaded) {
              allReview.clear();
              allReview = List.generate(
                state.data.data.length,
                (index) => state.data.data[index],
              );
              Logger.println("holiday data  2:${state.data.data}");
            }
            if (state is AddReviewError) {
              msgList.add(Constant().ShowErrorMessage(state.errors, context));
              Constant.myLoader.hide();
              Logger.println('error ${state.errors}');
              //Constant().ShowToast(state.errors, context);
            } else if (state is AddReviewLoaded) {
              messageController.clear();
              behavior = false;
              socialMedia = false;
              taskCompletion = false;
              Navigator.pop(context);
              viewVisible();
            }
            // if (state is UpdateHolidayLoading) {
            //   Constant.myLoader.show(context);
            // } else {
            //   Constant.myLoader.hide();
            //   setState(() {});
            // }
            // if (state is UpdateHolidayError) {
            //   msgList.add(Constant().ShowErrorMessage(state.errors, context));
            //   Constant.myLoader.hide();
            //   Logger.println('error ${state.errors}');
            //   //Constant().ShowToast(state.errors, context);
            // } else if (state is UpdateHolidayLoaded) {
            //   Navigator.pop(context);
            //   descriptionController.clear();
            //   messageController.clear();
            //   ratingController.clear();
            //   BlocProvider.of<GetHolidayBloc>(context)
            //       .add(FetchHoliday(context: context));
            // }
            if (state is DeleteReviewError) {
              msgList.add(Constant().ShowErrorMessage(state.errors, context));
              Constant.myLoader.hide();
              Logger.println('error ${state.errors}');
              Constant().show_toast(state.errors, context);
            } else if (state is DeleteReviewLoaded) {
              Navigator.pop(context);
              allReview.clear();
              viewVisible();
            }
          },
        ),
      ],
      child: CustomHeaderContainer(
        headerWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              Strings.employeeReview,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Constant.cWhite),
            ),
            // CustomContainerButton(
            //   text: Strings.addEmployeeReview,
            //   textStyle: Constant.textStyleSize13(context)!.copyWith(
            //     color: Constant.cBlack,
            //   ),
            //   color: Constant.cWhite,
            //   width: 180,
            //   onTap: () {
            //     messageController.clear();
            //     ratingController.clear();
            //     showDialog(
            //       context: context,
            //       builder: ((context) {
            //         return Material(
            //           color: Constant.cBlack.withOpacity(0.1),
            //           child: Padding(
            //             padding: EdgeInsets.only(
            //               right: MediaQuery.of(context).size.width / 8,
            //               left: MediaQuery.of(context).size.width / 8,
            //             ),
            //             child: Center(child: customDialog()),
            //           ),
            //         );
            //       }),
            //     );
            //   },
            // ),
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
                                  // 0: FlexColumnWidth(0.5),
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(2),
                                  2: FlexColumnWidth(1),
                                  3: FlexColumnWidth(1),
                                  4: FlexColumnWidth(1),
                                  5: FlexColumnWidth(1.1),
                                  6: FlexColumnWidth(1.1),
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      // Column(
                                      //   children: [
                                      //     Text(
                                      //       Strings.number,
                                      //       style: Constant.textStyleSize14(
                                      //               context)
                                      //           ?.copyWith(
                                      //         color: Constant.cBlack,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      Column(
                                        children: [
                                          Text(
                                            Strings.name,
                                            style: Constant.textStyleSize14(
                                              context,
                                            )?.copyWith(color: Constant.cBlack),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            Strings.task,
                                            style: Constant.textStyleSize14(
                                              context,
                                            )?.copyWith(color: Constant.cBlack),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            Strings.status,
                                            style: Constant.textStyleSize14(
                                              context,
                                            )?.copyWith(color: Constant.cBlack),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            Strings.date,
                                            style: Constant.textStyleSize14(
                                              context,
                                            )?.copyWith(color: Constant.cBlack),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            Strings.totalTime,
                                            style: Constant.textStyleSize14(
                                              context,
                                            )?.copyWith(color: Constant.cBlack),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            Strings.addReview,
                                            style: Constant.textStyleSize14(
                                              context,
                                            )?.copyWith(color: Constant.cBlack),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            Strings.view,
                                            style: Constant.textStyleSize14(
                                              context,
                                            )?.copyWith(color: Constant.cBlack),
                                          ),
                                        ],
                                      ),
                                      // Column(
                                      //   children: [
                                      //     Text(
                                      //       Strings.delete,
                                      //       style: Constant.textStyleSize14(
                                      //               context)
                                      //           ?.copyWith(
                                      //               color: Constant.cBlack),
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: allReview.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                                  return Container(
                                    height: 1,
                                    color: Constant.colorGrey,
                                  );
                                },
                            itemBuilder: (context, index) {
                              double reviewStar = 0;
                              for (int i = 0; i < allReview.length; i++) {
                                reviewStar = 0;
                                if (allReview[index].socialMedia == 1) {
                                  reviewStar++;
                                }
                                if (allReview[index].behavior == 1) {
                                  reviewStar++;
                                }
                                if (allReview[index].taskCompletion == 1) {
                                  reviewStar++;
                                }
                                if (allReview[index].officeArrival == 1) {
                                  reviewStar++;
                                }
                                if (allReview[index].workHours == 1) {
                                  reviewStar++;
                                }
                              }

                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(
                                      Constant.paddingHalf,
                                    ),
                                    child: Table(
                                      columnWidths: const {
                                        // 0: FlexColumnWidth(0.5),
                                        0: FlexColumnWidth(1),
                                        1: FlexColumnWidth(2),
                                        2: FlexColumnWidth(1),
                                        3: FlexColumnWidth(1),
                                        4: FlexColumnWidth(1),
                                        5: FlexColumnWidth(1.1),
                                        6: FlexColumnWidth(1.1),
                                      },
                                      children: [
                                        TableRow(
                                          children: [
                                            // Column(
                                            //   children: [
                                            //     Text(
                                            //       '${index + 1}',
                                            //       style: Constant
                                            //               .textStyleSize13(
                                            //                   context)
                                            //           ?.copyWith(
                                            //         color: Constant.cBlack,
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                            Column(
                                              children: [
                                                Text(
                                                  allReview[index]
                                                      .user
                                                      .firstName
                                                      .toString(),
                                                  style:
                                                      Constant.textStyleSize13(
                                                        context,
                                                      )?.copyWith(
                                                        color: Constant.cBlack,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  allReview[index]
                                                      .dailyReports
                                                      .reportText,
                                                  maxLines: 2,
                                                  style:
                                                      Constant.textStyleSize13(
                                                        context,
                                                      )?.copyWith(
                                                        color: Constant.cBlack,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            // Column(
                                            //   crossAxisAlignment:
                                            //       CrossAxisAlignment.center,
                                            //   children: [
                                            //     commonRadio(
                                            //         value: allReview[index]
                                            //             .officeArrival,
                                            //         text: widget.sizeTag == 1
                                            //             ? 'OA'
                                            //             : 'Office arrival',
                                            //         color: Colors.green),
                                            //     commonRadio(
                                            //         value: allReview[index]
                                            //             .behavior,
                                            //         text: widget.sizeTag == 1
                                            //             ? 'B'
                                            //             : 'Behavior',
                                            //         color: Colors.blue),
                                            //     commonRadio(
                                            //         value: allReview[index]
                                            //             .socialMedia,
                                            //         text: widget.sizeTag == 1
                                            //             ? 'SM'
                                            //             : 'Social Media',
                                            //         color: Colors.red),
                                            //     commonRadio(
                                            //         value: allReview[index]
                                            //             .taskCompletion,
                                            //         text: widget.sizeTag == 1
                                            //             ? 'TC'
                                            //             : 'Task Completion',
                                            //         color: Colors.purple),
                                            //     commonRadio(
                                            //         value: allReview[index]
                                            //             .workHours,
                                            //         text: widget.sizeTag == 1
                                            //             ? 'WH'
                                            //             : 'Work Hours',
                                            //         color: Colors.orange),
                                            //   ],
                                            // ),
                                            Column(
                                              children: [
                                                RatingBar.builder(
                                                  initialRating: reviewStar,
                                                  minRating: 0,
                                                  direction: Axis.horizontal,
                                                  itemCount: 5,
                                                  itemSize: 25,
                                                  itemPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 4.0,
                                                      ),
                                                  itemBuilder:
                                                      (
                                                        context,
                                                        index,
                                                      ) => const Icon(
                                                        Icons.star,
                                                        color: Constant
                                                            .colorSelectedIndicator,
                                                      ),
                                                  ignoreGestures: true,
                                                  onRatingUpdate: (rating) {
                                                    print(rating);
                                                  },
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  '${allReview[index].createdAt.day.padLeft(2, '0')}-${allReview[index].createdAt.month.padLeft(2, '0')}-${allReview[index].createdAt.year.padLeft(2, '0')}',
                                                  style:
                                                      Constant.textStyleSize13(
                                                        context,
                                                      )?.copyWith(
                                                        color: Constant.cBlack,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  allReview[index]
                                                      .dailyReports
                                                      .totalTime,
                                                  style:
                                                      Constant.textStyleSize13(
                                                        context,
                                                      )?.copyWith(
                                                        color: Constant.cBlack,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CustomButton(
                                                  height: 40,
                                                  width: 120,
                                                  padding: EdgeInsets.all(10),
                                                  text: Strings.review,
                                                  textStyle:
                                                      Constant.textStyleSize14(
                                                        context,
                                                      )?.copyWith(
                                                        color: Constant.cWhite,
                                                      ),
                                                  color: Constant
                                                      .colorSelectedIndicator,
                                                  onTap: () {
                                                    behavior =
                                                        allReview[index]
                                                                .behavior ==
                                                            1
                                                        ? true
                                                        : false;
                                                    socialMedia =
                                                        allReview[index]
                                                                .socialMedia ==
                                                            1
                                                        ? true
                                                        : false;
                                                    taskCompletion =
                                                        allReview[index]
                                                                .taskCompletion ==
                                                            1
                                                        ? true
                                                        : false;
                                                    messageController.text =
                                                        allReview[index]
                                                            .remarks ??
                                                        '';
                                                    showDialog(
                                                      context: context,
                                                      builder: ((context) {
                                                        return Material(
                                                          color: Constant.cBlack
                                                              .withOpacity(0.1),
                                                          child: Padding(
                                                            padding: EdgeInsets.only(
                                                              right:
                                                                  MediaQuery.of(
                                                                    context,
                                                                  ).size.width /
                                                                  8,
                                                              left:
                                                                  MediaQuery.of(
                                                                    context,
                                                                  ).size.width /
                                                                  8,
                                                            ),
                                                            child: Center(
                                                              child: customDialog(
                                                                id: allReview[index]
                                                                    .id,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CustomButton(
                                                  height: 40,
                                                  width: 120,
                                                  padding: const EdgeInsets.all(
                                                    10,
                                                  ),
                                                  text: Strings.view,
                                                  textStyle:
                                                      Constant.textStyleSize14(
                                                        context,
                                                      )?.copyWith(
                                                        color: Constant.cWhite,
                                                      ),
                                                  color: Constant
                                                      .colorSelectedIndicator,
                                                  onTap: () {
                                                    behavior =
                                                        allReview[index]
                                                                .behavior ==
                                                            1
                                                        ? true
                                                        : false;
                                                    socialMedia =
                                                        allReview[index]
                                                                .socialMedia ==
                                                            1
                                                        ? true
                                                        : false;
                                                    taskCompletion =
                                                        allReview[index]
                                                                .taskCompletion ==
                                                            1
                                                        ? true
                                                        : false;
                                                    messageController.text =
                                                        allReview[index]
                                                            .remarks ??
                                                        '';
                                                    showDialog(
                                                      context: context,
                                                      builder: ((context) {
                                                        return Material(
                                                          color: Constant.cBlack
                                                              .withOpacity(0.1),
                                                          child: Padding(
                                                            padding: EdgeInsets.only(
                                                              right:
                                                                  MediaQuery.of(
                                                                    context,
                                                                  ).size.width /
                                                                  8,
                                                              left:
                                                                  MediaQuery.of(
                                                                    context,
                                                                  ).size.width /
                                                                  8,
                                                            ),
                                                            child: Center(
                                                              child: customDialog(
                                                                id: allReview[index]
                                                                    .id,
                                                                isView: true,
                                                                review:
                                                                    allReview[index],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  index == allReview.lastIndex
                                      ? Container(
                                          height: 1,
                                          color: Constant.colorGrey,
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              );
                            },
                          ),
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

  Widget commonRadio({
    onChanged,
    required int value,
    required String text,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Radio(
          value: value,
          groupValue: 1,
          fillColor: WidgetStateProperty.all(color),
          onChanged: onChanged ?? (val) {},
        ),
        Constant.padding.widthBox,
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }

  Widget deleteDialog(int id, int sizeTag) {
    return StatefulBuilder(
      builder: (context, setState) {
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
                              'Are you sure to delete this review?',
                              style: Theme.of(context).textTheme.titleMedium!
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
                                  textStyle: Constant.textStyleSize14(
                                    context,
                                  )?.copyWith(color: Constant.cWhite),
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
                                  textStyle: Constant.textStyleSize14(
                                    context,
                                  )?.copyWith(color: Constant.cWhite),
                                  color: Constant.colorSelectedIndicator,
                                  onTap: () {
                                    BlocProvider.of<MyReviewBloc>(context).add(
                                      DeleteReview(
                                        context: context,
                                        id: id.toString(),
                                      ),
                                    );
                                  },
                                ),
                              ],
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

  Widget customDialog({required id, isView = false, AllReviewData? review}) {
    final ScrollController _scrollController = ScrollController();
    TextEditingController controller = TextEditingController();
    if (review != null) {
      controller.text = review.dailyReports.reportText;
    }
    return StatefulBuilder(
      builder: (context, setState) {
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Text(
                            isView
                                ? Strings.employeeReview
                                : Strings.addEmployeeReview,
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(color: Constant.cWhite),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              messageController.clear();
                              behavior = false;
                              socialMedia = false;
                              taskCompletion = false;
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0, top: 10),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: _autoValidate
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(
                                Constant.paddingHalf,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: Constant.paddingMidDoubleHalf,
                                ),
                                child: isView
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Scrollbar(
                                            thumbVisibility: true,
                                            controller: _scrollController,
                                            child: SingleChildScrollView(
                                              controller: _scrollController,
                                              child: LabelWithTextField(
                                                labelText: Strings.task,
                                                isEnable: false,
                                                maxLines: 5,
                                                controller: controller,
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            'Review',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          customCheckBox(
                                            text: 'Office Arrival',
                                            color: Colors.green,
                                            val: review?.officeArrival == 1
                                                ? true
                                                : false,
                                            onTap: () {},
                                          ),
                                          Constant.paddingHalf.heightBox,
                                          customCheckBox(
                                            text: 'Behavior',
                                            color: Colors.blue,
                                            val: behavior,
                                            onTap: () {},
                                          ),
                                          Constant.paddingHalf.heightBox,
                                          customCheckBox(
                                            text: 'Social Media',
                                            color: Colors.red,
                                            val: socialMedia,
                                            onTap: () {},
                                          ),
                                          Constant.paddingHalf.heightBox,
                                          customCheckBox(
                                            text: 'Task Completion',
                                            color: Colors.orange,
                                            val: review?.taskCompletion == 1
                                                ? true
                                                : false,
                                            onTap: () {},
                                          ),
                                          Constant.paddingHalf.heightBox,
                                          customCheckBox(
                                            text: 'Work Hours',
                                            color: Colors.purple,
                                            val: review?.workHours == 1
                                                ? true
                                                : false,
                                            onTap: () {},
                                          ),
                                          Constant.paddingHalf.heightBox,
                                          LabelWithTextField(
                                            labelText: Strings.date,
                                            isEnable: false,
                                            hintText:
                                                '${review?.createdAt.day.padLeft(2, '0')}-${review?.createdAt.month.padLeft(2, '0')}-${review?.createdAt.year.padLeft(2, '0')}',
                                          ),
                                          LabelWithTextField(
                                            labelText: Strings.totalTime,
                                            isEnable: false,
                                            hintText:
                                                '${review?.dailyReports.totalTime}',
                                          ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Review',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          customCheckBox(
                                            text: 'Behavior',
                                            color: Colors.blue,
                                            val: behavior,
                                            onTap: () {
                                              setState(() {
                                                behavior = !behavior;
                                              });
                                            },
                                          ),
                                          Constant.paddingHalf.heightBox,
                                          customCheckBox(
                                            text: 'Social Media',
                                            color: Colors.red,
                                            val: socialMedia,
                                            onTap: () {
                                              setState(() {
                                                socialMedia = !socialMedia;
                                              });
                                            },
                                          ),
                                          Constant.paddingHalf.heightBox,
                                          customCheckBox(
                                            text: 'Task Completion',
                                            color: Colors.purple,
                                            val: taskCompletion,
                                            onTap: () {
                                              setState(() {
                                                taskCompletion =
                                                    !taskCompletion;
                                              });
                                            },
                                          ),
                                          LabelWithTextField(
                                            controller: messageController,
                                            labelText: Strings.remarks,
                                            hintText: Strings.remarksHint,
                                            isRequired: true,
                                            validatorFunction: (val) {
                                              if (val!.isEmpty) {
                                                return Strings.remarks;
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
                            Constant.paddingHalf.heightBox,
                            CustomButton(
                              height: 40,
                              width: 120,
                              text: isView ? Strings.close : Strings.submit,
                              textStyle: Constant.textStyleSize14(
                                context,
                              )?.copyWith(color: Constant.cWhite),
                              color: Constant.colorSelectedIndicator,
                              onTap: isView
                                  ? () {
                                      Navigator.pop(context);
                                    }
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        BlocProvider.of<MyReviewBloc>(
                                          context,
                                        ).add(
                                          AddReviewEvent(
                                            context: context,
                                            remarks: messageController.text,
                                            behavior: behavior ? 1 : 0,
                                            socialMedia: socialMedia ? 1 : 0,
                                            taskCompletion: taskCompletion
                                                ? 1
                                                : 0,
                                            id: id,
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

  Widget customCheckBox({
    required String text,
    required Color color,
    required onTap,
    required val,
  }) {
    return Row(
      children: [
        const SizedBox(width: 185),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: val
                ? Center(
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    ),
                  )
                : null,
          ),
        ),
        Constant.padding.widthBox,
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }

  Widget datePicker({
    DateTime? date,
    TextEditingController? controller,
    String? hintText,
    String? validatorString,
    String? Function(String?)? validatorFunction,
    bool isEnable = true,
    isEndDate = false,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      //type: TextInputType.datetime,
      isEnable: isEnable,
      onChanged: (val) {},
      onTap: isEnable
          ? () async {
              String start = DateFormatter.formateDate(
                inputFormatter: 'dd-MM-yyyy',
                input: messageController.text != ''
                    ? messageController.text
                    : DateTime.now().toString(),
                outputFormatter: 'yyyy-MM-dd',
              );
              date = await showDatePicker(
                context: context,
                initialDate: isEndDate ? DateTime.parse(start) : DateTime.now(),
                firstDate: isEndDate ? DateTime.parse(start) : DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 1),
                builder: (context, child) {
                  return CustomDatePickerTheme(child: child!);
                },
              );
              setState(() {
                controller!.text = DateFormatter.formateDate(
                  inputFormatter: "yyyy-MM-dd 00:00:00.000",
                  input: date.toString(),
                  outputFormatter: "dd-MM-yyyy",
                );
              });
            }
          : () {},
      validatorFunction:
          validatorFunction ??
          (val) {
            if (val!.isEmpty) {
              return validatorString;
            }
            return null;
          },
    );
  }
}

String date({required DateTime date}) {
  return '${date.day.padLeft(2, '0')}-${date.month.padLeft(2, '0')}-${date.year}';
}

// update holiday & holiday type api
// delete holiday & holiday type api
// view holiday & holiday type dialog
