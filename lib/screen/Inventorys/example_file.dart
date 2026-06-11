import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:oceanbit_timeclock/screen/Inventorys/salary_pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

const examples = <Example>[
  Example(
    'INVOICE1',
    'pdf_1.dart',
    generateInventoryInvoice,
  ),
  /*Example('INVOICE2', 'pdf_2.dart', generateInvoice_2 ),
  Example('INVOICE3', 'pdf_3.dart', generateInvoice_3 ),
  Example('INVOICE4', 'pdf_4.dart', generateInvoice_4 ),
  Example('INVOICE5', 'pdf_5.dart', generateInvoice_5 ),
  Example('INVOICE6', 'pdf_6.dart', generateInvoice_6 )*/
];

typedef LayoutCallbackWithData = Future<Uint8List> Function(
    PdfPageFormat pageFormat, BuildContext context);
typedef OnPdfPreviewActionPressed = void Function(
  BuildContext context,
  LayoutCallback build,
  PdfPageFormat pageFormat,
);
/*class Print{
  const Print(this.index,this.fileName,this.onPressed,this.ActionName,[this.needsData = false]);
  final int index;
  final String fileName;
  final String ActionName;
  final OnPdfPreviewActionPressed onPressed;
  final bool needsData;
}*/

class Example {
  const Example(this.name, this.file, this.builder, [this.needsData = false]);

  final String name;

  final String file;

  final LayoutCallbackWithData builder;

  final bool needsData;
}
