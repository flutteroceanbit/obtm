import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/screen/admin_screens/employee_screen/widgets/intern_pdf.dart';
import 'package:oceanbit_timeclock/widget/custom_button.dart';
import 'package:oceanbit_timeclock/widget/custom_text_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../bloc_logic/add_update_personal_detail_bloc/add_update_personal_detail_bloc.dart';
import '../../../../constant/constant.dart';
import '../../../../constant/strings.dart';
import '../../../../models/get_employee_info_model.dart';
import '../../../../models/user_list_model.dart';
import '../../../../utils/date_formatter.dart';
import '../../../../utils/logger.dart';
import '../../../../widget/new/custom_datepicker_theme.dart';
import '../../../../widget/new/custom_dropdown.dart';
import 'certificate_pdf.dart';
import 'marksheet_pdf.dart';

class AlertDialogue extends StatelessWidget {
  const AlertDialogue({Key? key, required this.id, required this.isCurrent})
    : super(key: key);
  final int id;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Wrap(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Constant.paddingHalf),
                    color: Constant.cWhite,
                  ),
                  padding: const EdgeInsets.all(Constant.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        isCurrent
                            ? Strings.changeEmployerPast
                            : Strings.changeEmployerCurrent,
                        style: Constant.textStyleSize15(
                          context,
                        )?.copyWith(color: Constant.cBlack),
                      ),
                      Constant.padding.widthBox,
                      Constant.padding.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          !isCurrent
                              ? CustomButton(
                                  width: 200,
                                  height: 30,
                                  text: Strings.currentEmployee,
                                  textStyle: Constant.textStyleSize14(
                                    context,
                                  )?.copyWith(color: Constant.cWhite),
                                  color: Constant.cGreenLight,
                                  onTap: () {
                                    BlocProvider.of<
                                          AddUpdatePersonalDetailBloc
                                        >(context)
                                        .add(
                                          FetchUpdateUserStatusEvent(
                                            '1',
                                            context: context,
                                            id: id,
                                          ),
                                        );
                                  },
                                )
                              : CustomButton(
                                  width: 200,
                                  height: 30,
                                  text: Strings.pastEmployee,
                                  textStyle: Constant.textStyleSize14(
                                    context,
                                  )?.copyWith(color: Constant.cWhite),
                                  color: Constant.cGreenLight,
                                  onTap: () {
                                    BlocProvider.of<
                                          AddUpdatePersonalDetailBloc
                                        >(context)
                                        .add(
                                          FetchUpdateUserStatusEvent(
                                            '0',
                                            context: context,
                                            id: id,
                                          ),
                                        );
                                  },
                                ),
                          Constant.padding.widthBox,
                          CustomButton(
                            width: 200,
                            height: 30,
                            text: Strings.cancel,
                            textStyle: Constant.textStyleSize14(
                              context,
                            )?.copyWith(color: Constant.cWhite),
                            color: Constant.cRed,
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close, color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

Widget certificatePreviewDialog(
  BuildContext context,
  UserModelData certificateData,
  String startDate,
  String endDate,
  String role,
) {
  return Material(
    color: Constant.cBlack.withOpacity(0.2),
    child: Padding(
      padding: EdgeInsets.only(
        right: MediaQuery.of(context).size.width / 8,
        left: MediaQuery.of(context).size.width / 8,
      ),
      child: Center(
        child: StatefulBuilder(
          builder: (context, setState) {
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
                                Strings.certificate,
                                style: Theme.of(context).textTheme.titleLarge!
                                    .copyWith(color: Constant.cWhite),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      Uint8List pdf =
                                          await CertificateExample(
                                            'Certificate',
                                            'pdf_1.dart',
                                            generateCertificate,
                                          ).builder(
                                            CertificateData(
                                              certificateData.firstName!,
                                              certificateData.lastName!,
                                              startDate,
                                              endDate,
                                              role,
                                            ),
                                          );
                                      //downloadPDF(pdf);
                                      final directory = /* Platform.isMacOS
        ?*/
                                          await getDownloadsDirectory(); //FOR ANDROID
                                      // : await getApplicationDocumentsDirectory();
                                      Logger.println(
                                        'external storage path:${directory!.path}',
                                      );
                                      final myPDFPath =
                                          '${directory.path}/${Strings.downloadDirName}';
                                      final myImgDir = Directory(myPDFPath);
                                      if (myImgDir.existsSync() == false) {
                                        myImgDir.create();
                                      }
                                      File file = await File(
                                        "$myPDFPath/Certificate${DateTime.now()}.pdf",
                                      ).writeAsBytes(pdf);

                                      //  var pdfFile=await file.writeAsBytes(pdf);
                                      Logger.println(
                                        'save file path: ${file.path}',
                                      );
                                      /*msgList.add(*/
                                      Constant().show_toast(
                                        file.path,
                                        context,
                                      ) /*)*/;
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
                              bottomRight: Radius.circular(
                                Constant.paddingHalf,
                              ),
                              bottomLeft: Radius.circular(Constant.paddingHalf),
                            ),
                          ),
                          child: Center(
                            child: Theme(
                              data: ThemeData(
                                primaryColor: Constant.colorSelectedIndicator,
                                indicatorColor: Constant.colorSelectedIndicator,
                                useMaterial3: false,
                              ),
                              child: PdfPreview(
                                padding: const EdgeInsets.all(0),
                                previewPageMargin: const EdgeInsets.only(
                                  bottom: Constant.paddingHalfHalf,
                                  top: Constant.paddingHalfHalf,
                                ),
                                useActions: false,
                                maxPageWidth: 700,
                                build: (format) =>
                                    CertificateExample(
                                      'Certificate',
                                      'pdf_1.dart',
                                      generateCertificate,
                                    ).builder(
                                      CertificateData(
                                        certificateData.firstName!,
                                        certificateData.lastName!,
                                        startDate,
                                        endDate,
                                        role,
                                      ),
                                    ),
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
          },
        ),
      ),
    ),
  );
}

Widget internshipOfferLetterPreviewDialog(
  BuildContext context,
  EmployeeInfoData internshipData,
) {
  return Material(
    color: Constant.cBlack.withOpacity(0.2),
    child: Padding(
      padding: EdgeInsets.only(
        right: MediaQuery.of(context).size.width / 8,
        left: MediaQuery.of(context).size.width / 8,
      ),
      child: Center(
        child: StatefulBuilder(
          builder: (context, setState) {
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
                                Strings.internship,
                                style: Theme.of(context).textTheme.titleLarge!
                                    .copyWith(color: Constant.cWhite),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      Uint8List pdf =
                                          await InternshipExample(
                                            'Internship',
                                            'pdf_1.dart',
                                            generateInternshipOfferLetter,
                                          ).builder(
                                            InternshipData(
                                              internshipData.user.firstName,
                                              internshipData.user.lastName,
                                              internshipData.department!.name,
                                            ),
                                          );
                                      //downloadPDF(pdf);
                                      final directory = /* Platform.isMacOS
        ?*/
                                          await getDownloadsDirectory(); //FOR ANDROID
                                      // : await getApplicationDocumentsDirectory();
                                      Logger.println(
                                        'external storage path:${directory!.path}',
                                      );
                                      final myPDFPath =
                                          '${directory.path}/${Strings.downloadDirName}';
                                      final myImgDir = Directory(myPDFPath);
                                      if (myImgDir.existsSync() == false) {
                                        myImgDir.create();
                                      }
                                      File file = await File(
                                        "$myPDFPath/Internship_Offer_Letter_${DateTime.now()}.pdf",
                                      ).writeAsBytes(pdf);

                                      //  var pdfFile=await file.writeAsBytes(pdf);
                                      Logger.println(
                                        'save file path: ${file.path}',
                                      );
                                      /*msgList.add(*/
                                      Constant().show_toast(
                                        file.path,
                                        context,
                                      ) /*)*/;
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
                              bottomRight: Radius.circular(
                                Constant.paddingHalf,
                              ),
                              bottomLeft: Radius.circular(Constant.paddingHalf),
                            ),
                          ),
                          child: Center(
                            child: Theme(
                              data: ThemeData(
                                primaryColor: Constant.colorSelectedIndicator,
                                indicatorColor: Constant.colorSelectedIndicator,
                                useMaterial3: false,
                              ),
                              child: PdfPreview(
                                padding: const EdgeInsets.all(0),
                                previewPageMargin: const EdgeInsets.only(
                                  bottom: Constant.paddingHalfHalf,
                                  top: Constant.paddingHalfHalf,
                                ),
                                useActions: false,
                                maxPageWidth: 700,
                                build: (format) =>
                                    InternshipExample(
                                      'Internship',
                                      'pdf_1.dart',
                                      generateInternshipOfferLetter,
                                    ).builder(
                                      InternshipData(
                                        internshipData.user.firstName,
                                        internshipData.user.lastName,
                                        internshipData.department!.name,
                                      ),
                                    ),
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
          },
        ),
      ),
    ),
  );
}

Widget markSheetPreviewDialog(BuildContext context, String referenceNumber) {
  final nameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final marksController = TextEditingController();
  final technologyController = TextEditingController();
  final companyNameController = TextEditingController();
  final universityNameController = TextEditingController();
  bool isBackground = true;
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  String? selectedGrade;
  String? selectedGender;
  final formKey = GlobalKey<FormState>();

  return Material(
    color: Constant.cBlack.withOpacity(0.2),
    child: Padding(
      padding: EdgeInsets.only(
        right: MediaQuery.of(context).size.width / 8,
        left: MediaQuery.of(context).size.width / 8,
      ),
      child: Center(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Wrap(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Constant.paddingHalf),
                    color: Constant.cWhite,
                  ),
                  child: Column(
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
                                Strings.markSheet,
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
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.7,
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(Constant.padding),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  CustomDropDown(
                                    height: 48,
                                    onChange: (value) {
                                      setState(() {
                                        selectedGender = value;
                                      });
                                    },
                                    selectedValue: selectedGender,
                                    hintText: 'Gender',
                                    list: ['Ms', 'Mr', 'Mrs'],
                                  ),
                                  Constant.paddingHalf.heightBox,
                                  CustomTextField(
                                    controller: nameController,
                                    hintText: 'Name',
                                    type: TextInputType.name,
                                    maxLines: 1,
                                    validator: 'Please enter name',
                                  ),
                                  Constant.paddingHalf.heightBox,
                                  CustomTextField(
                                    controller: fatherNameController,
                                    hintText: 'Father Name',
                                    type: TextInputType.name,
                                    maxLines: 1,
                                    validator: 'Please enter father name',
                                  ),
                                  Constant.paddingHalf.heightBox,
                                  CustomTextField(
                                    controller: marksController,
                                    hintText: 'Marks',
                                    type: TextInputType.number,
                                    maxLines: 1,
                                    validator: 'Please enter marks',
                                  ),
                                  Constant.paddingHalf.heightBox,
                                  CustomTextField(
                                    controller: technologyController,
                                    hintText: 'Technology',
                                    type: TextInputType.text,
                                    maxLines: 1,
                                    validator: 'Please enter technology',
                                  ),
                                  // Constant.paddingHalf.heightBox,
                                  // CustomTextField(
                                  //   controller: companyNameController,
                                  //   hintText: 'Company Name',
                                  //   type: TextInputType.text,
                                  //   maxLines: 1,
                                  //   validator: 'Please enter company name',
                                  // ),
                                  Constant.paddingHalf.heightBox,
                                  CustomTextField(
                                    controller: universityNameController,
                                    hintText: 'University Name',
                                    type: TextInputType.text,
                                    maxLines: 1,
                                    validator: 'Please enter university name',
                                  ),
                                  Constant.paddingHalf.heightBox,
                                  CustomTextField(
                                    isEnable: false,
                                    controller: startDateController,
                                    hintText: 'Start Date',
                                    type: TextInputType.name,
                                    maxLines: 1,
                                    validator: 'Please select start date',
                                    onTap: () async {
                                      startDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(
                                          DateTime.now().year - 5,
                                        ),
                                        lastDate: DateTime(
                                          DateTime.now().year + 1,
                                        ),
                                        builder: (context, child) {
                                          return CustomDatePickerTheme(
                                            child: child!,
                                          );
                                        },
                                      );
                                      if (startDate != null) {
                                        startDateController.text =
                                            DateFormatter.formateDate(
                                              inputFormatter:
                                                  "yyyy-MM-dd 00:00:00.000",
                                              input: startDate.toString(),
                                              outputFormatter: "dd-MM-yyyy",
                                            );
                                        setState(() {});
                                      }
                                    },
                                  ),
                                  Constant.paddingHalf.heightBox,
                                  CustomTextField(
                                    isEnable: false,
                                    controller: endDateController,
                                    hintText: 'End Date',
                                    type: TextInputType.name,
                                    maxLines: 1,
                                    validator: 'Please select end date',
                                    onTap: () async {
                                      endDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(
                                          DateTime.now().year - 5,
                                        ),
                                        lastDate: DateTime(
                                          DateTime.now().year + 1,
                                        ),
                                        builder: (context, child) {
                                          return CustomDatePickerTheme(
                                            child: child!,
                                          );
                                        },
                                      );
                                      if (endDate != null) {
                                        endDateController.text =
                                            DateFormatter.formateDate(
                                              inputFormatter:
                                                  "yyyy-MM-dd 00:00:00.000",
                                              input: endDate.toString(),
                                              outputFormatter: "dd-MM-yyyy",
                                            );
                                        setState(() {});
                                      }
                                    },
                                  ),
                                  Constant.paddingHalf.heightBox,
                                  CustomDropDown(
                                    height: 48,
                                    onChange: (value) {
                                      setState(() {
                                        selectedGrade = value;
                                      });
                                    },
                                    selectedValue: selectedGrade,
                                    hintText: 'Grade',
                                    list: [
                                      'O-Outstanding',
                                      'E-Excellent',
                                      'A+-Very Good',
                                      'B-Good',
                                    ],
                                  ),
                                  Constant.padding.heightBox,
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isBackground,
                                        side: const BorderSide(
                                          color: Colors.black,
                                        ), // border when unchecked
                                        activeColor:
                                            Colors.black, // checked color
                                        checkColor: Colors.white, // tick color
                                        onChanged: (val) {
                                          setState(() {
                                            isBackground = val ?? false;
                                          });
                                        },
                                      ),
                                      const Text(
                                        "Background",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  CustomButton(
                                    height: 40,
                                    width: 120,
                                    text: Strings.submit,
                                    textStyle: Constant.textStyleSize14(
                                      context,
                                    )?.copyWith(color: Constant.cWhite),
                                    color: Constant.colorSelectedIndicator,
                                    onTap: () {
                                      if (formKey.currentState!.validate() &&
                                          selectedGrade != null &&
                                          selectedGender != null) {
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return markSheetPdfPreviewDialog(
                                              context,
                                              MarkSheetData(
                                                nameController.text,
                                                fatherNameController.text,
                                                marksController.text,
                                                technologyController.text,
                                                universityNameController.text,
                                                startDateController.text,
                                                endDateController.text,
                                                selectedGrade!,
                                                selectedGender!,
                                                referenceNumber,
                                                isBackground,
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        Constant().show_toast(
                                          'Please fill all fields',
                                          context,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
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
        ),
      ),
    ),
  );
}

Widget markSheetPdfPreviewDialog(BuildContext context, MarkSheetData data) {
  return Material(
    color: Constant.cBlack.withOpacity(0.2),
    child: Padding(
      padding: EdgeInsets.only(
        right: MediaQuery.of(context).size.width / 8,
        left: MediaQuery.of(context).size.width / 8,
      ),
      child: Center(
        child: StatefulBuilder(
          builder: (context, setState) {
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
                                Strings.markSheet,
                                style: Theme.of(context).textTheme.titleLarge!
                                    .copyWith(color: Constant.cWhite),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      Uint8List pdf = await MarkSheetExample(
                                        'MarkSheet',
                                        'marksheet_pdf.dart',
                                        generateMarkSheet,
                                      ).builder(data);
                                      final directory =
                                          await getDownloadsDirectory();
                                      Logger.println(
                                        'external storage path:${directory!.path}',
                                      );
                                      final myPDFPath =
                                          '${directory.path}/${Strings.downloadDirName}';
                                      final myImgDir = Directory(myPDFPath);
                                      if (myImgDir.existsSync() == false) {
                                        myImgDir.create();
                                      }
                                      File file = await File(
                                        "$myPDFPath/Mark_Sheet_${DateTime.now()}.pdf",
                                      ).writeAsBytes(pdf);
                                      Logger.println(
                                        'save file path: ${file.path}',
                                      );
                                      Constant().show_toast(file.path, context);
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
                              bottomRight: Radius.circular(
                                Constant.paddingHalf,
                              ),
                              bottomLeft: Radius.circular(Constant.paddingHalf),
                            ),
                          ),
                          child: Center(
                            child: Theme(
                              data: ThemeData(
                                primaryColor: Constant.colorSelectedIndicator,
                                indicatorColor: Constant.colorSelectedIndicator,
                                useMaterial3: false,
                              ),
                              child: PdfPreview(
                                padding: const EdgeInsets.all(0),
                                previewPageMargin: const EdgeInsets.only(
                                  bottom: Constant.paddingHalfHalf,
                                  top: Constant.paddingHalfHalf,
                                ),
                                useActions: false,
                                maxPageWidth: 700,
                                build: (format) => MarkSheetExample(
                                  'MarkSheet',
                                  'marksheet_pdf.dart',
                                  generateMarkSheet,
                                ).builder(data),
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
          },
        ),
      ),
    ),
  );
}
