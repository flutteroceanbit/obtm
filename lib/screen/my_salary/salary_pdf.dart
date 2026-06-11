import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_to_indian_words/number_to_indian_words.dart';
import 'package:oceanbit_timeclock/screen/my_salary/salary_repository.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../../gen/assets.gen.dart';
import '../../constant/constant.dart';
import '../../constant/strings.dart';
import '../../utils/logger.dart';
import '../profile/widgets/chart_widget/src/utils/app_colors.dart';

File file = File('pdf1.pdf');

Future<Uint8List> generateSalaryInvoice(
  PdfPageFormat pageFormat,
  BuildContext context,
) async {
  final invoice = SalaryInvoiceInfo(
    employeeNumber: '',
    employeeName: '',
    tax: 0,
    baseColor: PdfColors.teal,
    accentColor: PdfColors.blueGrey900,
  );

  return await invoice.buildPdf(pageFormat, context);
}

class SalaryInvoiceInfo {
  SalaryInvoiceInfo({
    //required this.products,
    this.employeeName = 'Dwyane Clerk',
    this.customerAddress =
        '24 Dummy Street Area,Location, Loren Ipsum,570xx59x',
    this.employeeNumber = '0000',
    this.tax = 0,
    this.paymentInfo = '',
    this.baseColor = PdfColors.white,
    this.accentColor = PdfColors.black,
  });

  final String employeeName;
  final String customerAddress;
  final String employeeNumber;
  final double tax;
  final String paymentInfo;
  final PdfColor baseColor;
  final PdfColor accentColor;
  var signature;

  var _logo;
  String taxAmount = '0.0';
  String discountAmount = '0.0';
  double shippingAmount = 0.0;
  // double _grandTotal = 0.0;

  // int selectedColorIndex=-1;
  var emoji;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat, BuildContext ctx) async {
    // Create a PDF document.
    emoji = await PdfGoogleFonts.notoColorEmoji();
    final doc = pw.Document();
    // selectedColorIndex=tableHeaderColorIndex[0];
    // _grandTotal = 0; //context.read<InvoiceRepository>().itemModel.finalAmount;
    _logo = await rootBundle.loadString(Assets.images.dashboardIconSvg.path);
    doc.addPage(
      pw.MultiPage(
        pageTheme: await _buildTheme(
          pageFormat,
          await PdfGoogleFonts.robotoRegular(),
          await PdfGoogleFonts.robotoBold(),
          await PdfGoogleFonts.robotoItalic(),
        ),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          pw.SizedBox(height: Constant.paddingHalf),
          pw.Padding(
            padding: const pw.EdgeInsets.all(Constant.padding),
            child: _tableTitle(context, pageFormat, ctx),
          ),
          pw.SizedBox(height: Constant.paddingHalf),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: Constant.padding,
            ),
            child: _tableContent(context, pageFormat, ctx),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: Constant.padding,
            ),
            child: _tableSubContent(context, pageFormat, ctx),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: Constant.padding,
            ),
            child: _tablePayableContent(context, pageFormat, ctx),
          ),
          pw.SizedBox(height: Constant.paddingDouble),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: Constant.padding,
            ),
            child: _signatureContent(context, pageFormat, ctx),
          ),
          pw.SizedBox(height: Constant.paddingDouble),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: Constant.padding,
            ),
            child: _contentFooter(context, pageFormat, ctx),
          ),
          pw.SizedBox(height: Constant.padding),
        ],
      ),
    );

    // Return the PDF file content
    // await file.writeAsBytes(await doc.save());
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Container(
                color: PdfColor.fromInt(AppColors.mainGridLineColor.value),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Transform.translate(
                      child: pw.SvgImage(svg: _logo, height: 100, width: 100),
                      offset: const PdfPoint(-5, -5),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(Constant.padding),
                      width: 300,
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'Oceanbit Solutions Private Limited',
                            softWrap: true,
                            overflow: pw.TextOverflow.clip,
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(
                                AppColors.contentColorBlack.value,
                              ),
                              fontSize: Constant.textSize12,
                              fontWeight: FontWeight.bold,
                              fontFallback: [emoji],
                              letterSpacing: 2,
                            ),
                          ),
                          pw.SizedBox(height: 10),
                          pw.Text(
                            '424 4th Floor, Shivalik,\nDabholigam Road,\nSurat-395004'
                                .upperCamelCase,
                            softWrap: true,
                            overflow: pw.TextOverflow.clip,
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(
                                AppColors.contentColorBlack.value,
                              ),
                              fontSize: Constant.textSize10,
                              fontWeight: FontWeight.normal,
                              fontFallback: [emoji],
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20),
      ],
    );
  }

  pw.Expanded _buildFooter(pw.Context context) {
    return pw.Expanded(
      child: pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: Constant.padding),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Container(
              height: 30,
              // width: 320,
              child: pw.Row(
                children: [
                  //pw.Icon( pw.IconData(Icons.copyright_outlined.codePoint/*(int.parse("0xe198".toString()))*/)/*,color: PdfColor.fromInt(AppColors.contentColorBlack.value)*/),
                  pw.Text(
                    'Oceanbit Solutions Pvt. Ltd., All Rights Reserved.',
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(
                      color: PdfColor.fromInt(
                        AppColors.contentColorBlack.value,
                      ),
                      fontWeight: FontWeight.normal,
                      fontSize: Constant.textSize10,
                    ),
                  ),
                ],
              ),
            ),
            pw.Text(
              'www.oceanbitsolutions.com',
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(
                color: PdfColor.fromInt(AppColors.contentColorBlack.value),
                fontWeight: FontWeight.normal,
                fontSize: Constant.textSize10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<pw.PageTheme> _buildTheme(
    PdfPageFormat pageFormat,
    pw.Font base,
    pw.Font bold,
    pw.Font italic,
  ) async {
    return pw.PageTheme(
      pageFormat: pageFormat,
      margin: const pw.EdgeInsets.all(0),
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
        icons: await PdfGoogleFonts.materialIcons(),
      ),
    );
  }

  pw.Widget _contentFooter(
    pw.Context context,
    PdfPageFormat pageFormat,
    BuildContext ctx,
  ) {
    return pw.Expanded(
      flex: 1,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Notes:',
            style: pw.TextStyle(
              color: PdfColor.fromInt(Constant.cBlack.value),
              fontSize: Constant.textSize12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.ListView.separated(
            itemCount: Strings.noteDetailList.length,
            itemBuilder: (context, index) {
              return noteDetailWidget(context, index, pageFormat);
            },
            separatorBuilder: (context, index) {
              return pw.SizedBox(height: Constant.paddingHalf);
            },
          ),
        ],
      ),
    );
  }

  pw.Widget noteDetailWidget(
    pw.Context context,
    int index,
    PdfPageFormat pageFormat,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.only(right: 0 /*Constant.paddingSmall*/),
          child: pw.Container(
            width: pageFormat.width / 28,
            child: pw.Text(
              '${index + 1}.',
              textAlign: pw.TextAlign.left,
              style: pw.TextStyle(
                color: PdfColor.fromInt(Constant.cBlack.value),
                fontSize: Constant.textSize12,
                fontWeight: pw.FontWeight.normal,
              ),
            ),
          ),
        ),
        pw.Container(
          width: pageFormat.width - (pageFormat.width / 9),
          child: pw.Text(
            Strings.noteDetailList[index],
            softWrap: true,
            overflow: pw.TextOverflow.clip,
            //maxLines: 3,
            style: pw.TextStyle(
              color: PdfColor.fromInt(Constant.cBlack.value),
              fontSize: Constant.textSize12,
              fontWeight: pw.FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  _tableTitle(pw.Context context, PdfPageFormat pageFormat, BuildContext ctx) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Container(
          //height: 50,
          decoration: pw.BoxDecoration(
            //color: PdfColor.fromInt(Constant.colorGreyTableHeaderBgLight.value),
            border: pw.Border(
              bottom: pw.BorderSide(
                color: PdfColor.fromInt(Constant.cBlack.value),
                width: 1.5,
              ),
            ),
          ),
          child: pw.Text(
            "Salary Slip - ${ctx.read<SalaryPDFRepository>().selectedMonthShort}"
                .toUpperCase(),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColor.fromInt(Constant.cBlack.value),
              fontSize: Constant.textSize15,
              fontWeight: pw.FontWeight.bold,
              // decoration: pw.TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  _tableContent(
    pw.Context context,
    PdfPageFormat pageFormat,
    BuildContext ctx,
  ) {
    List<List<String>> tableContent = [
      ['Employee Code', 'Employee Name', 'Department'],
      [
        ctx.read<SalaryPDFRepository>().employeeCode!,
        ctx.read<SalaryPDFRepository>().userName,
        ctx.read<SalaryPDFRepository>().department,
      ],
    ];
    // Map<int, TableColumnWidth> columnWidths={0:la()};

    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.ListView.separated(
          direction: pw.Axis.vertical,
          itemBuilder: (context, index) {
            return pw.ListView.separated(
              direction: pw.Axis.horizontal,
              itemBuilder: (context, ind) {
                return pw.Container(
                  height: 25,
                  //index==0?25:20,
                  width:
                      (pageFormat.width - (Constant.padding * 2)) -
                      (ind == 1 ? 162 : 475),
                  padding: const pw.EdgeInsets.all(Constant.paddingHalfHalf),
                  color: PdfColor.fromInt(
                    index == 0
                        ? Constant.colorGreyTableHeaderBg.value
                        : Constant.colorSurface.value,
                  ),
                  child: pw.Center(
                    child: pw.Text(
                      tableContent[index][ind],
                      style: pw.TextStyle(
                        color: PdfColor.fromInt(
                          AppColors.contentColorBlack.value,
                        ),
                        //color: PdfColor.fromInt(tableHeaders[0]==Strings.sl&&tableHeaders[1]==Strings.itemDescription?AppColors.colorSecondary.value:AppColors.colorBlack.value),
                        fontSize: 10,
                        fontWeight: index == 0
                            ? pw.FontWeight.bold
                            : pw.FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return pw.Container(
                  color: PdfColor.fromInt(Constant.cWhite.value),
                  width: 1,
                );
              },
              itemCount: tableContent[index].length,
            );
          },
          separatorBuilder: (context, index) {
            return pw.Container(
              color: PdfColor.fromInt(Constant.cWhite.value),
              height: 1,
            );
          },
          itemCount: tableContent.length,
        ),
      ],
    );
  }

  _tablePayableContent(
    pw.Context context,
    PdfPageFormat pageFormat,
    BuildContext ctx,
  ) {
    List<List<String>> tableContent = [
      ['Bank Name', 'Bank A/c No', 'Net Payable'],
      [
        ctx.read<SalaryPDFRepository>().bankName,
        ctx.read<SalaryPDFRepository>().bankACno,
        ctx.read<SalaryPDFRepository>().salaryModel.paidSalary.toString(),
      ],
    ];
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.ListView.separated(
          direction: pw.Axis.vertical,
          itemBuilder: (context, index) {
            return pw.ListView.separated(
              direction: pw.Axis.horizontal,
              itemBuilder: (context, ind) {
                return pw.Container(
                  height: 25,
                  //index==0?25:20,hg
                  width:
                      (pageFormat.width - (Constant.padding * 2)) -
                      (ind == 1
                          ? 295
                          : ind == 0
                          ? 342
                          : 475),
                  padding: const pw.EdgeInsets.all(Constant.paddingHalfHalf),
                  color: PdfColor.fromInt(
                    index == 0
                        ? Constant.colorGreyTableHeaderBg.value
                        : Constant.colorSurface.value,
                  ),
                  child: pw.Center(
                    child: pw.Text(
                      tableContent[index][ind],
                      style: pw.TextStyle(
                        color: PdfColor.fromInt(
                          AppColors.contentColorBlack.value,
                        ),
                        //color: PdfColor.fromInt(tableHeaders[0]==Strings.sl&&tableHeaders[1]==Strings.itemDescription?AppColors.colorSecondary.value:AppColors.colorBlack.value),
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return pw.Container(
                  color: PdfColor.fromInt(Constant.cWhite.value),
                  width: 1,
                );
              },
              itemCount: tableContent[index].length,
            );
          },
          separatorBuilder: (context, index) {
            return pw.Container(
              color: PdfColor.fromInt(Constant.cWhite.value),
              height: 1,
            );
          },
          itemCount: tableContent.length,
        ),
        pw.Container(
          height: 25,
          //index==0?25:20,
          width: (pageFormat.width - (Constant.padding * 2)),
          padding: const pw.EdgeInsets.all(Constant.paddingHalfHalf),
          color: PdfColor.fromInt((Constant.colorGreyTableHeaderBgLight).value),
          child: pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              _getDigitsInWords(
                ctx.read<SalaryPDFRepository>().salaryModel.paidSalary!.toInt(),
              ),
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(
                color: PdfColor.fromInt(AppColors.contentColorBlack.value),
                //color: PdfColor.fromInt(tableHeaders[0]==Strings.sl&&tableHeaders[1]==Strings.itemDescription?AppColors.colorSecondary.value:AppColors.colorBlack.value),
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _tableSubContent(
    pw.Context context,
    PdfPageFormat pageFormat,
    BuildContext ctx,
  ) {
    List<List<String>> tableContent = [
      [
        'Designation',
        'Working\nDays',
        'Present\nDays',
        'Leaves used this month',
        'Month & Year',
      ],
      [
        '${ctx.read<SalaryPDFRepository>().salaryModel.designation}',
        '${ctx.read<SalaryPDFRepository>().salaryModel.workingDays}',
        '${ctx.read<SalaryPDFRepository>().salaryModel.presentDays}',
        'CL\n${ctx.read<SalaryPDFRepository>().salaryModel.casualLeave}',
        'PL\n${ctx.read<SalaryPDFRepository>().salaryModel.provisionalLeave}',
        'SL\n${ctx.read<SalaryPDFRepository>().salaryModel.sickLeave}',
        'LWP\n${ctx.read<SalaryPDFRepository>().salaryModel.leaveWithoutPay}',
        'Penalty\n${ctx.read<SalaryPDFRepository>().salaryModel.penaltyLeave}',
        'Holiday\n${ctx.read<SalaryPDFRepository>().salaryModel.holiday}',
        ctx.read<SalaryPDFRepository>().selectedMonthShort,
      ],
      [
        'Earnings',
        'BS\n${ctx.read<SalaryPDFRepository>().salaryModel.basicSalary}',
        'OT\n${ctx.read<SalaryPDFRepository>().salaryModel.overTime}',
        'Bonus\n${ctx.read<SalaryPDFRepository>().salaryModel.bonus}',
        'HRA\n${ctx.read<SalaryPDFRepository>().salaryModel.hra}',
        'TA\n${ctx.read<SalaryPDFRepository>().salaryModel.ta}',
        '-',
        '-',
        '-',
        'Total Earning\n${ctx.read<SalaryPDFRepository>().salaryModel.basicSalary}',
      ],
      [
        'Deduction',
        'Leave\n${ctx.read<SalaryPDFRepository>().salaryModel.leaves}',
        'TDS\n${ctx.read<SalaryPDFRepository>().salaryModel.tds}',
        'Loan\n${ctx.read<SalaryPDFRepository>().salaryModel.loan}',
        'Others\n${ctx.read<SalaryPDFRepository>().salaryModel.others}',
        'PT\n${ctx.read<SalaryPDFRepository>().salaryModel.professionalTax}',
        '-',
        '-',
        '-',
        'Total Deductions\n${ctx.read<SalaryPDFRepository>().salaryModel.totalDeductionAmt}',
      ],
    ];
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.ListView.separated(
          direction: pw.Axis.vertical,
          itemBuilder: (context, index) {
            return pw.ListView.separated(
              direction: pw.Axis.horizontal,
              itemBuilder: (context, ind) {
                return pw.Container(
                  height: index == 0 ? 30 : 40,
                  //index==0?25:20,
                  width: index == 0
                      ? (pageFormat.width - (Constant.padding * 2)) -
                            (ind == 3
                                ? 293
                                : ind == 1 || ind == 2
                                ? 490
                                : 475)
                      : (pageFormat.width - (Constant.padding * 2)) -
                            ((ind > 2 && ind < 9)
                                ? 512.5
                                : ind == 1 || ind == 2
                                ? 490
                                : 475),
                  padding: pw.EdgeInsets.all(
                    tableContent[index][ind].contains('\n')
                        ? 0
                        : Constant.paddingSmall,
                  ),
                  color: PdfColor.fromInt(
                    index == 0
                        ? Constant.colorGreyTableHeaderBg.value
                        : (index == 2 && ind == 0)
                        ? Constant.colorGreyTableHeaderBgLight.value
                        : Constant.colorSurface.value,
                  ),
                  child: index != 0 && tableContent[index][ind].contains('\n')
                      ? pw.Column(
                          children: [
                            pw.Container(
                              height: 20,
                              width: index == 0
                                  ? (pageFormat.width -
                                            (Constant.padding * 2)) -
                                        (ind == 3
                                            ? 293
                                            : ind == 1 || ind == 2
                                            ? 490
                                            : 475)
                                  : (pageFormat.width -
                                            (Constant.padding * 2)) -
                                        ((ind > 2 && ind < 9)
                                            ? 512.5
                                            : ind == 1 || ind == 2
                                            ? 490
                                            : 475),
                              color: PdfColor.fromInt(
                                Constant.colorGreyTableHeaderBgLight.value,
                              ),
                              child: pw.Center(
                                child: pw.Text(
                                  tableContent[index][ind].split('\n')[0],
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                    color: PdfColor.fromInt(
                                      AppColors.contentColorBlack.value,
                                    ),
                                    //color: PdfColor.fromInt(tableHeaders[0]==Strings.sl&&tableHeaders[1]==Strings.itemDescription?AppColors.colorSecondary.value:AppColors.colorBlack.value),
                                    fontSize: 10,
                                    fontWeight: /*index%2==0?pw.FontWeight.bold:*/
                                        pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            pw.Container(
                              height: 20,
                              width: index == 0
                                  ? (pageFormat.width -
                                            (Constant.padding * 2)) -
                                        (ind == 3
                                            ? 293
                                            : ind == 1 || ind == 2
                                            ? 490
                                            : 475)
                                  : (pageFormat.width -
                                            (Constant.padding * 2)) -
                                        ((ind > 2 && ind < 9)
                                            ? 512.5
                                            : ind == 1 || ind == 2
                                            ? 490
                                            : 475),
                              // color:PdfColor.fromInt(Constant.colorGreyTableHeaderBg.value),
                              child: pw.Center(
                                child: pw.Text(
                                  tableContent[index][ind].split('\n')[1],
                                  textAlign: pw.TextAlign.center,
                                  style: (pw.TextStyle(
                                    color: PdfColor.fromInt(
                                      AppColors.contentColorBlack.value,
                                    ),
                                    //color: PdfColor.fromInt(tableHeaders[0]==Strings.sl&&tableHeaders[1]==Strings.itemDescription?AppColors.colorSecondary.value:AppColors.colorBlack.value),
                                    fontSize: 10,
                                    fontWeight: /*index%2==0?pw.FontWeight.bold:*/
                                        pw.FontWeight.normal,
                                  )),
                                ),
                              ),
                            ),
                          ],
                        )
                      : pw.Center(
                          child: pw.Text(
                            tableContent[index][ind],
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(
                                AppColors.contentColorBlack.value,
                              ),
                              //color: PdfColor.fromInt(tableHeaders[0]==Strings.sl&&tableHeaders[1]==Strings.itemDescription?AppColors.colorSecondary.value:AppColors.colorBlack.value),
                              fontSize: 10,
                              fontWeight: index == 0 || ind == 0
                                  ? pw.FontWeight.bold
                                  : pw.FontWeight.normal,
                            ),
                          ),
                        ),
                );
              },
              separatorBuilder: (context, index) {
                return pw.Container(
                  color: PdfColor.fromInt(Constant.cWhite.value),
                  width: 1,
                );
              },
              itemCount: tableContent[index].length,
            );
          },
          separatorBuilder: (context, index) {
            return pw.Container(
              color: PdfColor.fromInt(Constant.cWhite.value),
              height: 1,
            );
          },
          itemCount: tableContent.length,
        ),
      ],
    );
  }

  String _getDigitsInWords(int digits) {
    String words = '${NumToWords.convertNumberToIndianWords(digits)} only';

    Logger.println('Formatted Number is: $words');
    return words;
  }

  _signatureContent(
    pw.Context context,
    PdfPageFormat pageFormat,
    BuildContext ctx,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Container(
          width:
              (pageFormat.width -
                  (Constant.padding * 2) -
                  Constant.paddingDouble) /
              2,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(Strings.authorizedSignature),
              pw.Container(
                height: 1,
                color: PdfColor.fromInt(Constant.cBlack.value),
                width: (pageFormat.width - (Constant.padding * 2)) / 3.8,
              ),
            ],
          ),
        ),
        pw.Container(
          width:
              (pageFormat.width -
                  (Constant.padding * 2) -
                  Constant.paddingDouble) /
              2,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(Strings.employeeSignature),
              pw.Container(
                height: 1,
                color: PdfColor.fromInt(Constant.cBlack.value),
                width: (pageFormat.width - (Constant.padding * 2)) / 3.8,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
