import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:number_to_indian_words/number_to_indian_words.dart';
import 'package:oceanbit_timeclock/screen/Inventorys/salary_repository.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../../gen/assets.gen.dart';
import '../../constant/constant.dart';
import '../../constant/strings.dart';
import '../profile/widgets/chart_widget/src/utils/app_colors.dart';

File file = File('pdf1.pdf');

Future<Uint8List> generateInventoryInvoice(
    PdfPageFormat pageFormat, BuildContext context) async {
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
          _tableTitle(context, pageFormat, ctx),
          pw.SizedBox(height: Constant.paddingHalf),
          pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  horizontal: Constant.paddingHalf),
              child: _tableContentHeader(context, pageFormat, ctx)),
          pw.SizedBox(height: Constant.paddingHalf),
          pw.ListView.builder(
            itemBuilder: (context, index) => pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: Constant.paddingHalf),
                child: _tableContent(context, pageFormat, ctx, index)),
            itemCount:
                ctx.read<InventoryPDFRepository>().inventoryModel.data.length,
          ),
          pw.SizedBox(height: Constant.padding3x),
          pw.Padding(
              padding:
                  const pw.EdgeInsets.symmetric(horizontal: Constant.padding),
              child: _signatureContent(context, pageFormat, ctx)),
          pw.SizedBox(height: Constant.paddingDouble),
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
                        child: pw.SvgImage(
                          svg: _logo,
                          height: 100,
                          width: 100,
                        ),
                        offset: const PdfPoint(-5, -5)),
                    pw.Container(
                        padding: const pw.EdgeInsets.all(Constant.padding),
                        width: 300,
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text('Oceanbit Solutions Private Limited',
                                softWrap: true,
                                overflow: pw.TextOverflow.clip,
                                textAlign: pw.TextAlign.right,
                                style: pw.TextStyle(
                                  color: PdfColor.fromInt(
                                      AppColors.contentColorBlack.value),
                                  fontSize: Constant.textSize12,
                                  fontWeight: FontWeight.bold,
                                  fontFallback: [emoji],
                                  letterSpacing: 2,
                                )),
                            pw.SizedBox(height: 10),
                            pw.Text(
                                '424 4th Floor, Shivalik,\nDabholigam Road,\nSurat-395004'
                                    .upperCamelCase,
                                softWrap: true,
                                overflow: pw.TextOverflow.clip,
                                textAlign: pw.TextAlign.right,
                                style: pw.TextStyle(
                                  color: PdfColor.fromInt(
                                      AppColors.contentColorBlack.value),
                                  fontSize: Constant.textSize10,
                                  fontWeight: FontWeight.normal,
                                  fontFallback: [emoji],
                                  letterSpacing: 2,
                                )),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Expanded _buildFooter(pw.Context context) {
    return pw.Expanded(
        child: pw.Padding(
            padding:
                const pw.EdgeInsets.symmetric(horizontal: Constant.padding),
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Container(
                      height: 30,
                      // width: 320,
                      child: pw.Row(children: [
                        //pw.Icon( pw.IconData(Icons.copyright_outlined.codePoint/*(int.parse("0xe198".toString()))*/)/*,color: PdfColor.fromInt(AppColors.contentColorBlack.value)*/),
                        pw.Text(
                          'Oceanbit Solutions Pvt. Ltd., All Rights Reserved.',
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(
                            color: PdfColor.fromInt(
                                AppColors.contentColorBlack.value),
                            fontWeight: FontWeight.normal,
                            fontSize: Constant.textSize10,
                          ),
                        )
                      ])),
                  pw.Text(
                    'www.oceanbitsolutions.com',
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(
                      color:
                          PdfColor.fromInt(AppColors.contentColorBlack.value),
                      fontWeight: FontWeight.normal,
                      fontSize: Constant.textSize10,
                    ),
                  )
                ])));
  }

  Future<pw.PageTheme> _buildTheme(PdfPageFormat pageFormat, pw.Font base,
      pw.Font bold, pw.Font italic) async {
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

  pw.Widget noteDetailWidget(
      pw.Context context, int index, PdfPageFormat pageFormat) {
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Padding(
              padding:
                  const pw.EdgeInsets.only(right: 0 /*Constant.paddingSmall*/),
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
              )),
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
              )),
        ]);
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
                          width: 1.5))),
              child: pw.Text(
                "INVENTORY Slip" /*${ctx.read<InventoryPDFRepository>().selectedMonth}*/
                    .toUpperCase(),
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  color: PdfColor.fromInt(Constant.cBlack.value),
                  fontSize: Constant.textSize15,
                  fontWeight: pw.FontWeight.bold,
                  // decoration: pw.TextDecoration.underline,
                ),
              ))
        ]);
  }

  _tableContentHeader(
      pw.Context context, PdfPageFormat pageFormat, BuildContext ctx) {
    List<List<String>> tableContent = [];
    tableContent.add([
      'No.',
      'Inventory Name',
      'Amount',
      'Serial No.',
      'Purchase',
      'End warranty',
    ]);
    return pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.ListView.separated(
              direction: pw.Axis.vertical,
              itemBuilder: (context, index) {
                return pw.ListView.builder(
                    direction: pw.Axis.horizontal,
                    itemBuilder: (context, ind) {
                      return pw.Container(
                          height: 25,
                          //index==0?25:20,
                          width: ind == 3
                              ? (pageFormat.width - (Constant.padding * 2)) -
                                  (395)
                              : ind == 0
                                  ? (pageFormat.width -
                                          (Constant.padding * 2)) -
                                      (520)
                                  : ind == 4 || ind == 5
                                      ? (pageFormat.width -
                                              (Constant.padding * 2)) -
                                          (485)
                                      : ind == 1
                                          ? (pageFormat.width -
                                                  (Constant.padding * 2)) -
                                              (420)
                                          : (pageFormat.width -
                                                  (Constant.padding * 2)) -
                                              (462),
                          margin: const pw.EdgeInsets.all(1),
                          padding:
                              const pw.EdgeInsets.all(Constant.paddingHalfHalf),
                          color: PdfColor.fromInt(index == 0
                              ? Constant.colorGreyTableHeaderBg.value
                              : Constant.colorSurface.value),
                          child: pw.Center(
                              child: pw.Text(
                            tableContent[index][ind],
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(
                                  AppColors.contentColorBlack.value),
                              //color: PdfColor.fromInt(tableHeaders[0]==Strings.sl&&tableHeaders[1]==Strings.itemDescription?AppColors.colorSecondary.value:AppColors.colorBlack.value),
                              fontSize: 10,
                              fontWeight: index == 0
                                  ? pw.FontWeight.bold
                                  : pw.FontWeight.normal,
                            ),
                          )));
                    },
                    itemCount: tableContent[index].length);
              },
              separatorBuilder: (context, index) {
                return pw.Container(
                    color: PdfColor.fromInt(Constant.cWhite.value), height: 1);
              },
              itemCount: 1),
        ]);
  }

  _tableContent(
      pw.Context context, PdfPageFormat pageFormat, BuildContext ctx, int i) {
    List<List<String>> tableContent = [];
    tableContent.add([
      (i + 1).toString(),
      ctx.read<InventoryPDFRepository>().inventoryModel.data[i].inventoryName,
      ctx.read<InventoryPDFRepository>().inventoryModel.data[i].amount,
      ctx.read<InventoryPDFRepository>().inventoryModel.data[i].serialNo,
      DateFormat('dd-MM-yyyy').format(ctx
          .read<InventoryPDFRepository>()
          .inventoryModel
          .data[i]
          .purchaseDate),
      ctx
                  .read<InventoryPDFRepository>()
                  .inventoryModel
                  .data[i]
                  .endWarrantyDate ==
              null
          ? 'No Warranty'
          : DateFormat('dd-MM-yyyy').format(ctx
              .read<InventoryPDFRepository>()
              .inventoryModel
              .data[i]
              .endWarrantyDate!),
    ]);
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
                          height: 30,
                          //index==0?25:20,
                          width: ind == 3
                              ? (pageFormat.width - (Constant.padding * 2)) -
                                  (395)
                              : ind == 0
                                  ? (pageFormat.width -
                                          (Constant.padding * 2)) -
                                      (520)
                                  : ind == 4 || ind == 5
                                      ? (pageFormat.width -
                                              (Constant.padding * 2)) -
                                          (485)
                                      : ind == 1
                                          ? (pageFormat.width -
                                                  (Constant.padding * 2)) -
                                              (420)
                                          : (pageFormat.width -
                                                  (Constant.padding * 2)) -
                                              (462),
                          margin: const pw.EdgeInsets.all(0.5),
                          padding:
                              const pw.EdgeInsets.all(Constant.paddingHalfHalf),
                          color: PdfColor.fromInt(Constant.colorSurface.value),
                          child: pw.Center(
                              child: pw.Text(
                            tableContent[index][ind],
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(
                                  AppColors.contentColorBlack.value),
                              //color: PdfColor.fromInt(tableHeaders[0]==Strings.sl&&tableHeaders[1]==Strings.itemDescription?AppColors.colorSecondary.value:AppColors.colorBlack.value),
                              fontSize: 10,
                              fontWeight: pw.FontWeight.normal,
                            ),
                          )));
                    },
                    separatorBuilder: (context, index) {
                      return pw.Container(
                          color: PdfColor.fromInt(Constant.cWhite.value),
                          width: 1);
                    },
                    itemCount: tableContent[index].length);
              },
              separatorBuilder: (context, index) {
                return pw.Container(
                    color: PdfColor.fromInt(Constant.cWhite.value), height: 1);
              },
              itemCount: tableContent.length),
        ]);
  }

  _signatureContent(
      pw.Context context, PdfPageFormat pageFormat, BuildContext ctx) {
    return pw
        .Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
      pw.Container(
          width: (pageFormat.width -
                  (Constant.padding * 2) -
                  Constant.paddingDouble) /
              2,
          child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(Strings.directorSignature),
                      pw.Text(Strings.jigneshSapara),
                    ]),
                pw.SizedBox(width: 20),
                pw.Container(
                    height: 1,
                    color: PdfColor.fromInt(Constant.cBlack.value),
                    width: (pageFormat.width - (Constant.padding * 2)) / 3.8)
              ])),
      pw.SizedBox(height: 50),
      pw.Container(
          width: (pageFormat.width -
                  (Constant.padding * 2) -
                  Constant.paddingDouble) /
              2,
          child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(Strings.directorSignature),
                      pw.Text(Strings.milinPatel),
                    ]),
                pw.SizedBox(width: 20),
                pw.Container(
                    height: 1,
                    color: PdfColor.fromInt(Constant.cBlack.value),
                    width: (pageFormat.width - (Constant.padding * 2)) / 3.8)
              ]))
    ]);
  }
}
