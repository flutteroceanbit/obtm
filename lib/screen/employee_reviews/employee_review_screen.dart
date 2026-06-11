import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:oceanbit_timeclock/bloc_logic/reviews_bloc/reviews_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/reviews_bloc/reviews_event.dart';
import 'package:oceanbit_timeclock/bloc_logic/reviews_bloc/reviews_state.dart';
import 'package:oceanbit_timeclock/local_storage/my_local_storage.dart';
import 'package:oceanbit_timeclock/widget/new/custom_header_container.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constant/constant.dart';
import '../../constant/strings.dart';
import '../../models/review/get_all_employee_review_model.dart';
import '../../utils/logger.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_textfield_with_label.dart';
import '../dashboard/dashboard.dart';

class EmployeeReviewScreen extends StatefulWidget {
  final int sizeTag;
  const EmployeeReviewScreen({Key? key, required this.sizeTag})
      : super(key: key);

  @override
  State<EmployeeReviewScreen> createState() => _EmployeeReviewScreenState();
}

class _EmployeeReviewScreenState extends State<EmployeeReviewScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController messageController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  bool _autoValidate = false;
  List<AllReviewData> allReview = [];

  @override
  void initState() {
    BlocProvider.of<MyReviewBloc>(context).add(GetReviewEvent(
        context: context, userId: MyLocalStorage().getUser()?.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MyReviewBloc, ReviewState>(
          listener: (context, state) {
            if (state is GetReviewLoading || state is AddReviewLoading) {
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
                  state.data.data.length, (index) => state.data.data[index]);
              Logger.println("holiday data  2:${state.data.data}");
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
              BlocProvider.of<MyReviewBloc>(context)
                  .add(GetReviewEvent(context: context));
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
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Constant.cWhite),
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
                                  0: FlexColumnWidth(0.5),
                                  1: FlexColumnWidth(2),
                                  2: FlexColumnWidth(1),
                                  3: FlexColumnWidth(1),
                                  4: FlexColumnWidth(1),
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
                                            Strings.task,
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
                                            Strings.status,
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
                                            Strings.date,
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
                                            Strings.totalTime,
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
                                            Strings.view,
                                            style: Constant.textStyleSize14(
                                                    context)
                                                ?.copyWith(
                                              color: Constant.cBlack,
                                            ),
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
                                          0: FlexColumnWidth(0.5),
                                          1: FlexColumnWidth(2),
                                          2: FlexColumnWidth(1),
                                          3: FlexColumnWidth(1),
                                          4: FlexColumnWidth(1),
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
                                                children: [
                                                  RatingBar.builder(
                                                    initialRating: reviewStar,
                                                    minRating: 0,
                                                    direction: Axis.horizontal,
                                                    itemCount: 5,
                                                    itemSize: 25,
                                                    itemPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 4.0),
                                                    itemBuilder:
                                                        (context, index) =>
                                                            const Icon(
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
                                                children: [
                                                  Text(
                                                    allReview[index]
                                                        .dailyReports
                                                        .totalTime,
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
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CustomButton(
                                                    height: 40,
                                                    width: 120,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    text: Strings.view,
                                                    textStyle: Constant
                                                            .textStyleSize14(
                                                                context)
                                                        ?.copyWith(
                                                      color: Constant.cWhite,
                                                    ),
                                                    color: Constant
                                                        .colorSelectedIndicator,
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: ((context) {
                                                          return Material(
                                                            color: Constant
                                                                .cBlack
                                                                .withOpacity(
                                                                    0.1),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                right: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    8,
                                                                left: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    8,
                                                              ),
                                                              child: Center(
                                                                child: customDialog(
                                                                    id: allReview[
                                                                            index]
                                                                        .id,
                                                                    isView:
                                                                        true,
                                                                    review: allReview[
                                                                        index]),
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

  Widget customDialog({required id, isView = false, AllReviewData? review}) {
    final ScrollController _scrollController = ScrollController();
    TextEditingController controller = TextEditingController();
    if (review != null) {
      controller.text = review.dailyReports.reportText;
    }
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Text(
                          isView
                              ? Strings.employeeReview
                              : Strings.addEmployeeReview,
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
                                    right: Constant.paddingMidDoubleHalf),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      style: TextStyle(color: Colors.black),
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
                                      val: review?.behavior == 1 ? true : false,
                                      onTap: () {},
                                    ),
                                    Constant.paddingHalf.heightBox,
                                    customCheckBox(
                                      text: 'Social Media',
                                      color: Colors.red,
                                      val: review?.socialMedia == 1
                                          ? true
                                          : false,
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
                                      val:
                                          review?.workHours == 1 ? true : false,
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
                                )),
                          ),
                          Constant.paddingHalf.heightBox,
                          CustomButton(
                            height: 40,
                            width: 120,
                            text: isView ? Strings.close : Strings.submit,
                            textStyle:
                                Constant.textStyleSize14(context)?.copyWith(
                              color: Constant.cWhite,
                            ),
                            color: Constant.colorSelectedIndicator,
                            onTap: isView
                                ? () {
                                    Navigator.pop(context);
                                  }
                                : () {},
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

  Widget customCheckBox(
      {required String text,
      required Color color,
      required onTap,
      required val}) {
    return Row(
      children: [
        const SizedBox(
          width: 185,
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 2,
              ),
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
        Text(
          text,
          style: TextStyle(color: color),
        ),
      ],
    );
  }

  Widget commonRadio(
      {onChanged,
      required int value,
      required String text,
      required Color color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Radio(
          value: value,
          groupValue: 1,
          fillColor: WidgetStateProperty.all(
            color,
          ),
          onChanged: onChanged ?? (val) {},
        ),
        Constant.padding.widthBox,
        Text(
          text,
          style: TextStyle(color: color),
        ),
      ],
    );
  }
}
