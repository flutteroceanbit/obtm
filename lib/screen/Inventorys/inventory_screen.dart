import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oceanbit_timeclock/bloc_logic/Inventory_bloc/inventory_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/Inventory_bloc/inventory_event.dart';
import 'package:oceanbit_timeclock/bloc_logic/Inventory_bloc/inventory_state.dart';
import 'package:oceanbit_timeclock/models/get_inventory_model.dart';
import 'package:oceanbit_timeclock/screen/Inventorys/example_file.dart';
import 'package:oceanbit_timeclock/screen/Inventorys/salary_repository.dart';
import 'package:oceanbit_timeclock/widget/new/custom_header_container.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constant/constant.dart';
import '../../constant/strings.dart';
import '../../utils/date_formatter.dart';
import '../../utils/logger.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_container_button.dart';
import '../../widget/custom_form_label.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/custom_textfield_with_label.dart';
import '../../widget/new/custom_cardview.dart';
import '../../widget/new/custom_datepicker_theme.dart';
import '../dashboard/dashboard.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key, this.sizeTag}) : super(key: key);
  final int? sizeTag;

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<InventoryData> allInventory = [];
  TextEditingController inventoryNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController purchaseDateController = TextEditingController();
  TextEditingController endWarrantyDateController = TextEditingController();
  TextEditingController serialNoController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidateMode = false;
  DateTime? startDate;
  DateTime? endDate;
  GetInventoryModel? getInventoryModel;

  @override
  void initState() {
    BlocProvider.of<InventoryBloc>(context).add(
      GetInventory(context: context),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventoryBloc, InventoryState>(
      listener: (context, state) {
        if (state is GetInventoryByIdLoading ||
            state is AddInventoryLoading ||
            state is UpdateInventoryLoading ||
            state is DeleteInventoryLoading) {
          Constant.myLoader.show(context);
        } else {
          Constant.myLoader.hide();
          setState(() {});
        }
        if (state is GetInventoryByIdError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is GetInventoryLoaded) {
          allInventory.clear();
          getInventoryModel = state.data;
          allInventory = List.generate(
              state.data.data.length, (index) => state.data.data[index]);
        }

        if (state is AddInventoryError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is AddInventoryLoaded) {
          BlocProvider.of<InventoryBloc>(context).add(
            GetInventory(context: context),
          );
          serialNoController.clear();
          inventoryNameController.clear();
          amountController.clear();
          purchaseDateController.clear();
          endWarrantyDateController.clear();
          Navigator.pop(context);
        }

        if (state is UpdateInventoryError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is UpdateInventoryLoaded) {
          BlocProvider.of<InventoryBloc>(context).add(
            GetInventory(context: context),
          );
          serialNoController.clear();
          inventoryNameController.clear();
          amountController.clear();
          purchaseDateController.clear();
          endWarrantyDateController.clear();
          Navigator.pop(context);
        }
        if (state is DeleteInventoryError) {
          msgList.add(Constant().ShowErrorMessage(state.errors, context));
          Constant.myLoader.hide();
          Logger.println('error ${state.errors}');
          //Constant().ShowToast(state.errors, context);
        } else if (state is DeleteInventoryLoaded) {
          BlocProvider.of<InventoryBloc>(context).add(
            GetInventory(context: context),
          );
          Navigator.pop(context);
        }
      },
      child: CustomHeaderContainer(
        headerWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              Strings.inventory,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Constant.cWhite),
            ),
            Row(
              children: [
                CustomContainerButton(
                  text: 'Generate PDF',
                  textStyle: Constant.textStyleSize13(context)!.copyWith(
                    color: Constant.cBlack,
                  ),
                  color: Constant.cWhite,
                  width: 120,
                  onTap: () {
                    setState(() {
                      context.read<InventoryPDFRepository>().inventoryModel =
                          getInventoryModel!;
                    });
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
                            child:
                                Center(child: customPDFPreviewDialog(context)),
                          ),
                        );
                      }),
                    );
                  },
                ),
                Constant.paddingHalfHalf.widthBox,
                CustomContainerButton(
                  text: Strings.addInventory,
                  textStyle: Constant.textStyleSize13(context)!.copyWith(
                    color: Constant.cBlack,
                  ),
                  color: Constant.cWhite,
                  width: 120,
                  onTap: () {
                    inventoryNameController.clear();
                    amountController.clear();
                    purchaseDateController.clear();
                    endWarrantyDateController.clear();
                    serialNoController.clear();
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
                            child: Center(child: customDialog(widget.sizeTag!)),
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
                                  1: FlexColumnWidth(2),
                                  2: FlexColumnWidth(1.5),
                                  3: FlexColumnWidth(1.5),
                                  4: FlexColumnWidth(1),
                                  5: FlexColumnWidth(1),
                                  6: FlexColumnWidth(1),
                                  7: FlexColumnWidth(1),
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
                                            Strings.inventoryName,
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
                                            Strings.amount,
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
                                            Strings.serialNo,
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
                                            Strings.purchaseDate,
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
                                            Strings.endWarrantyDate,
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
                          allInventory.isEmpty
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
                                  itemCount: allInventory.length,
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
                                              1: FlexColumnWidth(2),
                                              2: FlexColumnWidth(1.5),
                                              3: FlexColumnWidth(1.5),
                                              4: FlexColumnWidth(1),
                                              5: FlexColumnWidth(1),
                                              6: FlexColumnWidth(1),
                                              7: FlexColumnWidth(1),
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
                                                        allInventory[index]
                                                            .inventoryName,
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
                                                        allInventory[index]
                                                            .amount,
                                                        style: const TextStyle(
                                                            color: Constant
                                                                .cBlack),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        allInventory[index]
                                                            .serialNo,
                                                        style: const TextStyle(
                                                            color: Constant
                                                                .cBlack),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        date(
                                                            date: allInventory[
                                                                    index]
                                                                .purchaseDate),
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
                                                        allInventory[index]
                                                                    .endWarrantyDate !=
                                                                null
                                                            ? date(
                                                                date: allInventory[
                                                                        index]
                                                                    .endWarrantyDate!)
                                                            : "No Warranty",
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
                                                            serialNoController
                                                                    .text =
                                                                allInventory[
                                                                        index]
                                                                    .serialNo;
                                                            inventoryNameController
                                                                    .text =
                                                                allInventory[
                                                                        index]
                                                                    .inventoryName;
                                                            amountController
                                                                    .text =
                                                                allInventory[
                                                                        index]
                                                                    .amount;
                                                            purchaseDateController
                                                                .text = DateFormat(
                                                                    'dd-MM-yyyy')
                                                                .format(DateFormat(
                                                                        'yyyy-MM-dd')
                                                                    .parse(allInventory[
                                                                            index]
                                                                        .purchaseDate
                                                                        .toString()));
                                                            allInventory[index]
                                                                .purchaseDate
                                                                .toString();
                                                            endWarrantyDateController
                                                                .text = allInventory[
                                                                            index]
                                                                        .endWarrantyDate !=
                                                                    null
                                                                ? DateFormat('dd-MM-yyyy').format(DateFormat(
                                                                        'yyyy-MM-dd')
                                                                    .parse(allInventory[
                                                                            index]
                                                                        .endWarrantyDate
                                                                        .toString()))
                                                                : "No warranty";

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
                                                                                .sizeTag!,
                                                                            isUpdate:
                                                                                true,
                                                                            id: allInventory[index].id)),
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
                                                                            allInventory[index].id,
                                                                            widget.sizeTag!)),
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
                                        index == allInventory.lastIndex
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
                            'Are you sure to delete this Inventory type?',
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
                                  BlocProvider.of<InventoryBloc>(context).add(
                                    DeleteInventory(context: context, id: id),
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

  Widget customPDFPreviewDialog(BuildContext context) {
    return Material(
      color: Constant.cBlack.withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.only(
          right: MediaQuery.of(context).size.width / 8,
          left: MediaQuery.of(context).size.width / 8,
        ),
        child: Center(
          child: StatefulBuilder(builder: (context, setState) {
            return Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.height / 1.5,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Constant.paddingHalf),
                    color: Constant.colorSelectedIndicator,
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                Strings.inventory,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(color: Constant.cWhite),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      Uint8List pdf = await examples[0]
                                          .builder(PdfPageFormat.a4, context);
                                      //downloadPDF(pdf);
                                      final directory = /* Platform.isMacOS
        ?*/
                                          await getDownloadsDirectory(); //FOR ANDROID
                                      // : await getApplicationDocumentsDirectory();
                                      Logger.println(
                                          'external storage path:${directory!.path}');
                                      final myPDFPath =
                                          '${directory.path}/${Strings.downloadDirName}';
                                      final myImgDir = Directory(myPDFPath);
                                      if (myImgDir.existsSync() == false) {
                                        myImgDir.create();
                                      }
                                      File file = await File(
                                              "$myPDFPath/Inventory${DateTime.now()}.pdf")
                                          .writeAsBytes(pdf);

                                      //  var pdfFile=await file.writeAsBytes(pdf);
                                      Logger.println(
                                          'save file path: ${file.path}');
                                      /*msgList.add(*/ Constant()
                                          .show_toast(file.path, context) /*)*/;
                                      //Navigator.pop(context);
                                    },
                                    child: const Icon(
                                      Icons.print,
                                      color: Constant.cWhite,
                                      size: 20,
                                    ),
                                  ),
                                  Constant.padding.widthBox,
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
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.height / 1.5,
                          height: MediaQuery.of(context).size.height - 40,
                          decoration: const BoxDecoration(
                            color: Constant.cWhite,
                            borderRadius: BorderRadius.only(
                              bottomRight:
                                  Radius.circular(Constant.paddingHalf),
                              bottomLeft: Radius.circular(Constant.paddingHalf),
                            ),
                          ),
                          child: Center(
                            child: Theme(
                              data: ThemeData(
                                  //  backgroundColor: Constant.colorPrimary,
                                  primaryColor: Constant.colorSelectedIndicator,
                                  indicatorColor:
                                      Constant.colorSelectedIndicator,
                                  // splashColor: Constant.colorSelectedIndicator,
                                  //platform: Platform.isMacOS?TargetPlatform.macOS:TargetPlatform.windows,
                                  useMaterial3: false),
                              child: PdfPreview(
                                padding: const EdgeInsets.all(0),
                                previewPageMargin: const EdgeInsets.only(
                                    bottom: Constant.paddingHalfHalf,
                                    top: Constant.paddingHalfHalf),
                                useActions: false,
                                //allowSharing: true,
                                //allowPrinting: true,
                                maxPageWidth: 700,
                                build: (format) =>
                                    examples[0].builder(format, context),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget customDialog(
    int sizeTag, {
    isUpdate = false,
    id = 0,
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
                          isUpdate
                              ? Strings.updateInventory
                              : Strings.addInventory,
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
                          Constant.paddingMidDoubleHalf.heightBox,
                          LabelWithTextField(
                            labelText: Strings.inventoryName,
                            controller: inventoryNameController,
                            validatorString: Strings.inventoryEmpty,
                            hintText: Strings.inventoryHint,
                            isRequired: true,
                            maxLines: 1,
                          ),
                          Constant.paddingMidDoubleHalf.heightBox,
                          LabelWithTextField(
                            labelText: Strings.amount,
                            controller: amountController,
                            validatorString: Strings.amountEmpty,
                            hintText: Strings.amountHint,
                            isRequired: true,
                            maxLines: 1,
                          ),
                          Constant.paddingMidDoubleHalf.heightBox,
                          LabelWithTextField(
                            labelText: Strings.serialNo,
                            controller: serialNoController,
                            validatorString: Strings.serialEmpty,
                            hintText: Strings.serialHint,
                            isRequired: true,
                            maxLines: 1,
                          ),
                          Constant.paddingMidDoubleHalf.heightBox,
                          Row(
                            //mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 175,
                                child: CustomFormLabel(
                                  label: Strings.purchaseDate,
                                  style: Constant.textStyleSize13(context)
                                      ?.copyWith(color: Constant.cBlack),
                                  isRequired: true,
                                  requiredStyle:
                                      Constant.textStyleSize14(context)
                                          ?.copyWith(color: Constant.cRed),
                                ),
                              ),
                              Constant.paddingHalf.widthBox,
                              Flexible(
                                flex: 2,
                                child: datePicker(
                                  // labelText: Strings.startDate,
                                  controller: purchaseDateController,
                                  date: startDate,
                                  hintText: Strings.purchaseDateHint,
                                  validatorString: Strings.purchaseDateEmpty,
                                ),
                              ),
                            ],
                          ),
                          Constant.paddingMidDoubleHalf.heightBox,
                          Row(
                            //mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 175,
                                child: CustomFormLabel(
                                  label: Strings.endWarrantyDate,
                                  style: Constant.textStyleSize13(context)
                                      ?.copyWith(color: Constant.cBlack),
                                  isRequired: false,
                                  requiredStyle:
                                      Constant.textStyleSize14(context)
                                          ?.copyWith(color: Constant.cRed),
                                ),
                              ),
                              Constant.paddingHalf.widthBox,
                              Flexible(
                                flex: 2,
                                child: datePicker(
                                  // labelText: Strings.startDate,
                                  controller: endWarrantyDateController,
                                  date: startDate,
                                  hintText: Strings.endWarrantyDateHint,
                                ),
                              ),
                            ],
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
                                      BlocProvider.of<InventoryBloc>(context)
                                          .add(
                                        UpdateInventory(
                                          context: context,
                                          id: id,
                                          inventoryName:
                                              inventoryNameController.text,
                                          amount: amountController.text,
                                          serialNo: serialNoController.text,
                                          purchaseDate: DateFormat('yyyy-MM-dd')
                                              .format(DateFormat('dd-MM-yyyy')
                                                  .parse(purchaseDateController
                                                      .text)),
                                          endWarrantyDate: endWarrantyDateController
                                                          .text !=
                                                      '' &&
                                                  endWarrantyDateController
                                                          .text !=
                                                      "No warranty"
                                              ? DateFormat('yyyy-MM-dd').format(
                                                  DateFormat('dd-MM-yyyy').parse(
                                                      endWarrantyDateController
                                                          .text))
                                              : '',
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        _autoValidateMode = true;
                                      });
                                    }
                                  })
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      BlocProvider.of<InventoryBloc>(context)
                                          .add(
                                        AddInventoryEvent(
                                          context: context,
                                          inventoryName:
                                              inventoryNameController.text,
                                          amount: amountController.text,
                                          serialNo: serialNoController.text,
                                          purchaseDate: DateFormat('yyyy-MM-dd')
                                              .format(DateFormat('dd-MM-yyyy')
                                                  .parse(purchaseDateController
                                                      .text)),
                                          endWarrantyDate: endWarrantyDateController
                                                          .text !=
                                                      '' &&
                                                  endWarrantyDateController
                                                          .text !=
                                                      "No warranty"
                                              ? DateFormat('yyyy-MM-dd').format(
                                                  DateFormat('dd-MM-yyyy').parse(
                                                      endWarrantyDateController
                                                          .text))
                                              : '',
                                        ),
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

  Widget customPDFDialog(int sizeTag) {
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
                          Strings.inventory,
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
                    child: Container(),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget datePicker(
      {DateTime? date,
      TextEditingController? controller,
      String? hintText,
      String? validatorString,
      String? Function(String?)? validatorFunction,
      bool isEnable = true,
      isEndDate = false}) {
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
                  input: controller?.text != ''
                      ? controller?.text
                      : DateTime.now().toString(),
                  outputFormatter: 'yyyy-MM-dd');
              date = await showDatePicker(
                context: context,
                initialDate: isEndDate ? DateTime.parse(start) : DateTime.now(),
                firstDate: isEndDate ? DateTime.parse(start) : DateTime(1900),
                lastDate: DateTime(DateTime.now().year + 10),
                builder: (context, child) {
                  return CustomDatePickerTheme(
                    child: child!,
                  );
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
      validatorFunction: validatorFunction ??
          (val) {
            if (val!.isEmpty) {
              return validatorString;
            }
            return null;
          },
    );
  }

  String date({required DateTime date}) {
    return '${date.day.padLeft(2, '0')}-${date.month.padLeft(2, '0')}-${date.year}';
  }
}
